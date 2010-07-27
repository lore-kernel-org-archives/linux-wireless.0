Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab0G0Rxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:53:52 -0400
Subject: [wt PATCH 2/16] libertas: clean up RSSI command
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:55:21 -0700
Message-ID: <1280260521.19686.15.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert to a full direct command; previous code rolled a direct
command by hand but left the original indirect command code intact
but disabled.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c     |   37 +---------------------------
 drivers/net/wireless/libertas/cfg.h     |    2 -
 drivers/net/wireless/libertas/cmd.c     |   39 +++++++++++++++++++++++++++---
 drivers/net/wireless/libertas/cmd.h     |    2 +
 drivers/net/wireless/libertas/cmdresp.c |    4 ---
 drivers/net/wireless/libertas/defs.h    |   13 ----------
 drivers/net/wireless/libertas/host.h    |   24 ++++++++----------
 drivers/net/wireless/libertas/main.c    |    7 +----
 8 files changed, 51 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 5110a77..e90c560 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1386,39 +1386,6 @@ static int lbs_cfg_del_key(struct wiphy *wiphy, struct net_device *netdev,
  * Get station
  */
 
-/*
- * Returns the signal or 0 in case of an error.
- */
-
-/* like "struct cmd_ds_802_11_rssi", but with cmd_header. Once we get rid
- * of WEXT, this should go into host.h */
-struct cmd_rssi {
-	struct cmd_header hdr;
-
-	__le16 n_or_snr;
-	__le16 nf;
-	__le16 avg_snr;
-	__le16 avg_nf;
-} __packed;
-
-static int lbs_get_signal(struct lbs_private *priv, s8 *signal, s8 *noise)
-{
-	struct cmd_rssi cmd;
-	int ret;
-
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.n_or_snr = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
-	ret = lbs_cmd_with_response(priv, CMD_802_11_RSSI, &cmd);
-
-	if (ret == 0) {
-		*signal = CAL_RSSI(le16_to_cpu(cmd.n_or_snr),
-				le16_to_cpu(cmd.nf));
-		*noise  = CAL_NF(le16_to_cpu(cmd.nf));
-	}
-	return ret;
-}
-
-
 static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
 			      u8 *mac, struct station_info *sinfo)
 {
@@ -1439,7 +1406,7 @@ static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
 	sinfo->rx_packets = priv->dev->stats.rx_packets;
 
 	/* Get current RSSI */
-	ret = lbs_get_signal(priv, &signal, &noise);
+	ret = lbs_get_rssi(priv, &signal, &noise);
 	if (ret == 0) {
 		sinfo->signal = signal;
 		sinfo->filled |= STATION_INFO_SIGNAL;
@@ -1479,7 +1446,7 @@ static int lbs_get_survey(struct wiphy *wiphy, struct net_device *dev,
 	survey->channel = ieee80211_get_channel(wiphy,
 		ieee80211_channel_to_frequency(priv->channel));
 
-	ret = lbs_get_signal(priv, &signal, &noise);
+	ret = lbs_get_rssi(priv, &signal, &noise);
 	if (ret == 0) {
 		survey->filled = SURVEY_INFO_NOISE_DBM;
 		survey->noise = noise;
diff --git a/drivers/net/wireless/libertas/cfg.h b/drivers/net/wireless/libertas/cfg.h
index 756fb98..e7ba4d8 100644
--- a/drivers/net/wireless/libertas/cfg.h
+++ b/drivers/net/wireless/libertas/cfg.h
@@ -14,8 +14,6 @@ int lbs_reg_notifier(struct wiphy *wiphy,
 		struct regulatory_request *request);
 
 /* All of those are TODOs: */
-#define lbs_cmd_802_11_rssi(priv, cmdptr) (0)
-#define lbs_ret_802_11_rssi(priv, resp) (0)
 #define lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action) (0)
 #define lbs_ret_802_11_bcn_ctrl(priv, resp) (0)
 
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 4454988..e95f80d 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -12,6 +12,8 @@
 #include "cfg.h"
 #include "cmd.h"
 
+#define CAL_NF(nf)		((s32)(-(s32)(nf)))
+#define CAL_RSSI(snr, nf)	((s32)((s32)(snr) + CAL_NF(nf)))
 
 static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
 
@@ -690,6 +692,39 @@ out:
 	return ret;
 }
 
+/**
+ *  @brief Get current RSSI and noise floor
+ *
+ *  @param priv		A pointer to struct lbs_private structure
+ *  @param rssi		On successful return, signal level in mBm
+ *
+ *  @return 	   	The channel on success, error on failure
+ */
+int lbs_get_rssi(struct lbs_private *priv, s8 *rssi, s8 *nf)
+{
+	struct cmd_ds_802_11_rssi cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	BUG_ON(rssi == NULL);
+	BUG_ON(nf == NULL);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	/* Average SNR over last 8 beacons */
+	cmd.n_or_snr = cpu_to_le16(8);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RSSI, &cmd);
+	if (ret == 0) {
+		*nf = CAL_NF(le16_to_cpu(cmd.nf));
+		*rssi = CAL_RSSI(le16_to_cpu(cmd.n_or_snr), le16_to_cpu(cmd.nf));
+	}
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
 static int lbs_cmd_reg_access(struct cmd_ds_command *cmdptr,
 			       u8 cmd_action, void *pdata_buf)
 {
@@ -1106,10 +1141,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_reg_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_RSSI:
-		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
-		break;
-
 	case CMD_802_11_SET_AFC:
 	case CMD_802_11_GET_AFC:
 
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 1b9092f..ec41380 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -131,4 +131,6 @@ int lbs_set_host_sleep(struct lbs_private *priv, int host_sleep);
 
 int lbs_set_monitor_mode(struct lbs_private *priv, int enable);
 
+int lbs_get_rssi(struct lbs_private *priv, s8 *snr, s8 *nf);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index a0d9482..e51957c 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -172,10 +172,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
-	case CMD_RET(CMD_802_11_RSSI):
-		ret = lbs_ret_802_11_rssi(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11D_DOMAIN_INFO):
 		ret = lbs_ret_802_11d_domain_info(resp);
 		break;
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index ea3f10e..da9833f 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -301,19 +301,6 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 #define	BAND_G			(0x02)
 #define ALL_802_11_BANDS	(BAND_B | BAND_G)
 
-/** MACRO DEFINITIONS */
-#define CAL_NF(NF)			((s32)(-(s32)(NF)))
-#define CAL_RSSI(SNR, NF) 		((s32)((s32)(SNR) + CAL_NF(NF)))
-#define SCAN_RSSI(RSSI)			(0x100 - ((u8)(RSSI)))
-
-#define DEFAULT_BCN_AVG_FACTOR		8
-#define DEFAULT_DATA_AVG_FACTOR		8
-#define AVG_SCALE			100
-#define CAL_AVG_SNR_NF(AVG, SNRNF, N)         \
-                        (((AVG) == 0) ? ((u16)(SNRNF) * AVG_SCALE) : \
-                        ((((int)(AVG) * (N -1)) + ((u16)(SNRNF) * \
-                        AVG_SCALE))  / N))
-
 #define MAX_RATES			14
 
 #define	MAX_LEDS			8
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index aeecf58..3227288 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -644,19 +644,19 @@ struct cmd_ds_802_11_rf_channel {
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_rssi {
-	/* weighting factor */
-	__le16 N;
+	struct cmd_header hdr;
 
-	__le16 reserved_0;
-	__le16 reserved_1;
-	__le16 reserved_2;
-} __attribute__ ((packed));
+	/* request:  number of beacons (N) to average the SNR and NF over
+	 * response: SNR of most recent beacon
+	 */
+	__le16 n_or_snr;
 
-struct cmd_ds_802_11_rssi_rsp {
-	__le16 SNR;
-	__le16 noisefloor;
-	__le16 avgSNR;
-	__le16 avgnoisefloor;
+	/* The following fields are only set in the response.
+	 * In the request these are reserved and should be set to 0.
+	 */
+	__le16 nf;       /* most recent beacon noise floor */
+	__le16 avg_snr;  /* average SNR weighted by N from request */
+	__le16 avg_nf;   /* average noise floor weighted by N from request */
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_mac_address {
@@ -969,8 +969,6 @@ struct cmd_ds_command {
 	/* command Body */
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
-		struct cmd_ds_802_11_rssi rssi;
-		struct cmd_ds_802_11_rssi_rsp rssirsp;
 		struct cmd_ds_mac_reg_access macreg;
 		struct cmd_ds_bbp_reg_access bbpreg;
 		struct cmd_ds_rf_reg_access rfreg;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 2a0b590..cfd0af6 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -157,12 +157,7 @@ static void lbs_tx_timeout(struct net_device *dev)
 	   to kick it somehow? */
 	lbs_host_to_card_done(priv);
 
-	/* More often than not, this actually happens because the
-	   firmware has crapped itself -- rather than just a very
-	   busy medium. So send a harmless command, and if/when
-	   _that_ times out, we'll kick it in the head. */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-				     0, 0, NULL);
+	/* FIXME: reset the card */
 
 	lbs_deb_leave(LBS_DEB_TX);
 }
-- 
1.7.1.1


