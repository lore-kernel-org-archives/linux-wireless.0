Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab0G0Ryi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:54:38 -0400
Subject: [wt PATCH 3/16] libertas: convert 11D_DOMAIN_INFO to a direct
 command
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:56:05 -0700
Message-ID: <1280260565.19686.16.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c     |  103 +----------------
 drivers/net/wireless/libertas/cmd.c     |  188 ++++++++++++++++++++-----------
 drivers/net/wireless/libertas/cmd.h     |    6 +
 drivers/net/wireless/libertas/cmdresp.c |   51 ---------
 drivers/net/wireless/libertas/decl.h    |    5 -
 drivers/net/wireless/libertas/dev.h     |    3 -
 drivers/net/wireless/libertas/host.h    |   21 +---
 7 files changed, 139 insertions(+), 238 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index e90c560..25f9027 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1979,113 +1979,20 @@ int lbs_cfg_register(struct lbs_private *priv)
 	return ret;
 }
 
-/**
- *  @brief This function sets DOMAIN INFO to FW
- *  @param priv       pointer to struct lbs_private
- *  @return          0; -1
-*/
-static int lbs_11d_set_domain_info(struct lbs_private *priv)
-{
-	int ret;
-
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11D_DOMAIN_INFO,
-			CMD_ACT_SET,
-			CMD_OPTION_WAITFORRSP, 0, NULL);
-	if (ret)
-		lbs_deb_11d("fail to dnld domain info\n");
-
-	return ret;
-}
-
-static void lbs_send_domain_info_cmd_fw(struct wiphy *wiphy,
-					struct regulatory_request *request)
-{
-	u8   no_of_triplet = 0;
-	u8   no_of_parsed_chan = 0;
-	u8   first_channel = 0, next_chan = 0, max_pwr = 0;
-	u8   i, flag = 0;
-	enum ieee80211_band band;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *ch;
-	struct lbs_private *priv = wiphy_priv(wiphy);
-	struct lbs_802_11d_domain_reg *domain_info = &priv->domain_reg;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_CFG80211);
-
-	/* Set country code */
-	domain_info->country_code[0] = request->alpha2[0];
-	domain_info->country_code[1] = request->alpha2[1];
-	domain_info->country_code[2] = ' ';
-
-	for (band = 0; band < IEEE80211_NUM_BANDS ; band++) {
-
-		if (!wiphy->bands[band])
-			continue;
-
-		sband = wiphy->bands[band];
-
-		for (i = 0; i < sband->n_channels ; i++) {
-			ch = &sband->channels[i];
-			if (ch->flags & IEEE80211_CHAN_DISABLED)
-				continue;
-
-			if (!flag) {
-				flag = 1;
-				next_chan = first_channel = (u32) ch->hw_value;
-				max_pwr = ch->max_power;
-				no_of_parsed_chan = 1;
-				continue;
-			}
-
-			if (ch->hw_value == next_chan + 1 &&
-					ch->max_power == max_pwr) {
-				next_chan++;
-				no_of_parsed_chan++;
-			} else {
-				domain_info->triplet[no_of_triplet]
-					.chans.first_channel = first_channel;
-				domain_info->triplet[no_of_triplet]
-					.chans.num_channels = no_of_parsed_chan;
-				domain_info->triplet[no_of_triplet]
-					.chans.max_power = max_pwr;
-				no_of_triplet++;
-				flag = 0;
-			}
-		}
-		if (flag) {
-			domain_info->triplet[no_of_triplet]
-				.chans.first_channel = first_channel;
-			domain_info->triplet[no_of_triplet]
-				.chans.num_channels = no_of_parsed_chan;
-			domain_info->triplet[no_of_triplet]
-				.chans.max_power = max_pwr;
-			no_of_triplet++;
-		}
-	}
-
-	domain_info->no_triplet = no_of_triplet;
-
-	/* Set domain info */
-	ret = lbs_11d_set_domain_info(priv);
-	if (ret)
-		lbs_pr_err("11D: error setting domain info in FW\n");
-
-	lbs_deb_leave(LBS_DEB_CFG80211);
-}
-
 int lbs_reg_notifier(struct wiphy *wiphy,
 		struct regulatory_request *request)
 {
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret;
+
 	lbs_deb_enter_args(LBS_DEB_CFG80211, "cfg80211 regulatory domain "
 			"callback for domain %c%c\n", request->alpha2[0],
 			request->alpha2[1]);
 
-	lbs_send_domain_info_cmd_fw(wiphy, request);
+	ret = lbs_set_11d_domain_info(priv, request, wiphy->bands);
 
 	lbs_deb_leave(LBS_DEB_CFG80211);
-
-	return 0;
+	return ret;
 }
 
 void lbs_scan_deinit(struct lbs_private *priv)
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index e95f80d..2aa362f 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -725,6 +725,129 @@ int lbs_get_rssi(struct lbs_private *priv, s8 *rssi, s8 *nf)
 	return ret;
 }
 
+/**
+ *  @brief Send regulatory and 802.11d domain information to the firmware
+ *
+ *  @param priv		pointer to struct lbs_private
+ *  @param request	cfg80211 regulatory request structure
+ *  @param bands	the device's supported bands and channels
+ *
+ *  @return		0 on success, error code on failure
+*/
+int lbs_set_11d_domain_info(struct lbs_private *priv,
+			    struct regulatory_request *request,
+			    struct ieee80211_supported_band **bands)
+{
+	struct cmd_ds_802_11d_domain_info cmd;
+	struct mrvl_ie_domain_param_set *domain = &cmd.domain;
+	struct ieee80211_country_ie_triplet *t;
+	enum ieee80211_band band;
+	struct ieee80211_channel *ch;
+	u8 num_triplet = 0;
+	u8 num_parsed_chan = 0;
+	u8 first_channel = 0, next_chan = 0, max_pwr = 0;
+	u8 i, flag = 0;
+	size_t triplet_size;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_11D);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+
+	lbs_deb_11d("Setting country code '%c%c'\n",
+		    request->alpha2[0], request->alpha2[1]);
+
+	domain->header.type = cpu_to_le16(TLV_TYPE_DOMAIN);
+
+	/* Set country code */
+	domain->country_code[0] = request->alpha2[0];
+	domain->country_code[1] = request->alpha2[1];
+	domain->country_code[2] = ' ';
+
+	/* Now set up the channel triplets; firmware is somewhat picky here
+	 * and doesn't validate channel numbers and spans; hence it would
+	 * interpret a triplet of (36, 4, 20) as channels 36, 37, 38, 39.  Since
+	 * the last 3 aren't valid channels, the driver is responsible for
+	 * splitting that up into 4 triplet pairs of (36, 1, 20) + (40, 1, 20)
+	 * etc.
+	 */
+	for (band = 0;
+	     (band < IEEE80211_NUM_BANDS) && (num_triplet < MAX_11D_TRIPLETS);
+	     band++) {
+
+		if (!bands[band])
+			continue;
+
+		for (i = 0;
+		     (i < bands[band]->n_channels) && (num_triplet < MAX_11D_TRIPLETS);
+		     i++) {
+			ch = &bands[band]->channels[i];
+			if (ch->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			if (!flag) {
+				flag = 1;
+				next_chan = first_channel = (u32) ch->hw_value;
+				max_pwr = ch->max_power;
+				num_parsed_chan = 1;
+				continue;
+			}
+
+			if ((ch->hw_value == next_chan + 1) &&
+					(ch->max_power == max_pwr)) {
+				/* Consolidate adjacent channels */
+				next_chan++;
+				num_parsed_chan++;
+			} else {
+				/* Add this triplet */
+				lbs_deb_11d("11D triplet (%d, %d, %d)\n",
+					first_channel, num_parsed_chan,
+					max_pwr);
+				t = &domain->triplet[num_triplet];
+				t->chans.first_channel = first_channel;
+				t->chans.num_channels = num_parsed_chan;
+				t->chans.max_power = max_pwr;
+				num_triplet++;
+				flag = 0;
+			}
+		}
+
+		if (flag) {
+			/* Add last triplet */
+			lbs_deb_11d("11D triplet (%d, %d, %d)\n", first_channel,
+				num_parsed_chan, max_pwr);
+			t = &domain->triplet[num_triplet];
+			t->chans.first_channel = first_channel;
+			t->chans.num_channels = num_parsed_chan;
+			t->chans.max_power = max_pwr;
+			num_triplet++;
+		}
+	}
+
+	lbs_deb_11d("# triplets %d\n", num_triplet);
+
+	/* Set command header sizes */
+	triplet_size = num_triplet * sizeof(struct ieee80211_country_ie_triplet);
+	domain->header.len = cpu_to_le16(sizeof(domain->country_code) +
+					triplet_size);
+
+	lbs_deb_hex(LBS_DEB_11D, "802.11D domain param set",
+			(u8 *) &cmd.domain.country_code,
+			le16_to_cpu(domain->header.len));
+
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd.hdr) +
+				   sizeof(cmd.action) +
+				   sizeof(cmd.domain.header) +
+				   sizeof(cmd.domain.country_code) +
+				   triplet_size);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11D_DOMAIN_INFO, &cmd);
+
+	lbs_deb_leave_args(LBS_DEB_11D, "ret %d", ret);
+	return ret;
+}
+
 static int lbs_cmd_reg_access(struct cmd_ds_command *cmdptr,
 			       u8 cmd_action, void *pdata_buf)
 {
@@ -1006,66 +1129,6 @@ void lbs_set_mac_control(struct lbs_private *priv)
 }
 
 /**
- *  @brief This function implements command CMD_802_11D_DOMAIN_INFO
- *  @param priv       pointer to struct lbs_private
- *  @param cmd        pointer to cmd buffer
- *  @param cmdno      cmd ID
- *  @param cmdOption  cmd action
- *  @return           0
-*/
-int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
-				 struct cmd_ds_command *cmd,
-				 u16 cmdoption)
-{
-	struct cmd_ds_802_11d_domain_info *pdomaininfo =
-	    &cmd->params.domaininfo;
-	struct mrvl_ie_domain_param_set *domain = &pdomaininfo->domain;
-	u8 nr_triplet = priv->domain_reg.no_triplet;
-
-	lbs_deb_enter(LBS_DEB_11D);
-
-	lbs_deb_11d("nr_triplet=%x\n", nr_triplet);
-
-	pdomaininfo->action = cpu_to_le16(cmdoption);
-	if (cmdoption == CMD_ACT_GET) {
-		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
-					sizeof(struct cmd_header));
-		lbs_deb_hex(LBS_DEB_11D, "802_11D_DOMAIN_INFO", (u8 *) cmd,
-			le16_to_cpu(cmd->size));
-		goto done;
-	}
-
-	domain->header.type = cpu_to_le16(TLV_TYPE_DOMAIN);
-	memcpy(domain->countrycode, priv->domain_reg.country_code,
-	       sizeof(domain->countrycode));
-
-	domain->header.len = cpu_to_le16(nr_triplet
-				* sizeof(struct ieee80211_country_ie_triplet)
-				+ sizeof(domain->countrycode));
-
-	if (nr_triplet) {
-		memcpy(domain->triplet, priv->domain_reg.triplet,
-				nr_triplet *
-				sizeof(struct ieee80211_country_ie_triplet));
-
-		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
-					     le16_to_cpu(domain->header.len) +
-					     sizeof(struct mrvl_ie_header) +
-					     sizeof(struct cmd_header));
-	} else {
-		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
-					sizeof(struct cmd_header));
-	}
-
-	lbs_deb_hex(LBS_DEB_11D, "802_11D_DOMAIN_INFO", (u8 *) cmd,
-			le16_to_cpu(cmd->size));
-
-done:
-	lbs_deb_enter(LBS_DEB_11D);
-	return 0;
-}
-
-/**
  *  @brief This function prepare the command before send to firmware.
  *
  *  @param priv		A pointer to struct lbs_private structure
@@ -1154,11 +1217,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = 0;
 		goto done;
 
-	case CMD_802_11D_DOMAIN_INFO:
-		cmdptr->command = cpu_to_le16(cmd_no);
-		ret = lbs_cmd_802_11d_domain_info(priv, cmdptr, cmd_action);
-		break;
-
 	case CMD_802_11_TPC_CFG:
 		cmdptr->command = cpu_to_le16(CMD_802_11_TPC_CFG);
 		cmdptr->size =
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index ec41380..2c24c19 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -3,6 +3,8 @@
 #ifndef _LBS_CMD_H_
 #define _LBS_CMD_H_
 
+#include <net/cfg80211.h>
+
 #include "host.h"
 #include "dev.h"
 
@@ -133,4 +135,8 @@ int lbs_set_monitor_mode(struct lbs_private *priv, int enable);
 
 int lbs_get_rssi(struct lbs_private *priv, s8 *snr, s8 *nf);
 
+int lbs_set_11d_domain_info(struct lbs_private *priv,
+			    struct regulatory_request *request,
+			    struct ieee80211_supported_band **bands);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index e51957c..35b8ceb 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -96,53 +96,6 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
 }
-
-/**
- *  @brief This function parses countryinfo from AP and download country info to FW
- *  @param priv    pointer to struct lbs_private
- *  @param resp    pointer to command response buffer
- *  @return        0; -1
- */
-static int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11d_domain_info *domaininfo =
-			&resp->params.domaininforesp;
-	struct mrvl_ie_domain_param_set *domain = &domaininfo->domain;
-	u16 action = le16_to_cpu(domaininfo->action);
-	s16 ret = 0;
-	u8 nr_triplet = 0;
-
-	lbs_deb_enter(LBS_DEB_11D);
-
-	lbs_deb_hex(LBS_DEB_11D, "domain info resp", (u8 *) resp,
-			(int)le16_to_cpu(resp->size));
-
-	nr_triplet = (le16_to_cpu(domain->header.len) - COUNTRY_CODE_LEN) /
-		sizeof(struct ieee80211_country_ie_triplet);
-
-	lbs_deb_11d("domain info resp: nr_triplet %d\n", nr_triplet);
-
-	if (nr_triplet > MRVDRV_MAX_TRIPLET_802_11D) {
-		lbs_deb_11d("invalid number of triplets returned!!\n");
-		return -1;
-	}
-
-	switch (action) {
-	case CMD_ACT_SET:	/*Proc set action */
-		break;
-
-	case CMD_ACT_GET:
-		break;
-	default:
-		lbs_deb_11d("invalid action:%d\n", domaininfo->action);
-		ret = -1;
-		break;
-	}
-
-	lbs_deb_leave_args(LBS_DEB_11D, "ret %d", ret);
-	return ret;
-}
-
 static inline int handle_cmd_response(struct lbs_private *priv,
 				      struct cmd_header *cmd_response)
 {
@@ -172,10 +125,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
-	case CMD_RET(CMD_802_11D_DOMAIN_INFO):
-		ret = lbs_ret_802_11d_domain_info(resp);
-		break;
-
 	case CMD_RET(CMD_802_11_TPC_CFG):
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index ba5438a..1d141fe 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -53,9 +53,4 @@ int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
 
-int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
-		struct cmd_ds_command *cmd, u16 cmdoption);
-
-int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp);
-
 #endif
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 4536d9c..be263ac 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -60,9 +60,6 @@ struct lbs_private {
 	struct dentry *regs_dir;
 	struct dentry *debugfs_regs_files[6];
 
-	/** 11D and domain regulatory data */
-	struct lbs_802_11d_domain_reg domain_reg;
-
 	/* Hardware debugging */
 	u32 mac_offset;
 	u32 bbp_offset;
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 3227288..ad46c36 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -389,30 +389,22 @@ struct lbs_offset_value {
 	u32 value;
 } __attribute__ ((packed));
 
-#define MRVDRV_MAX_TRIPLET_802_11D              83
-
-#define COUNTRY_CODE_LEN                        3
+#define MAX_11D_TRIPLETS	83
 
 struct mrvl_ie_domain_param_set {
 	struct mrvl_ie_header header;
 
-	u8 countrycode[COUNTRY_CODE_LEN];
-	struct ieee80211_country_ie_triplet triplet[1];
+	u8 country_code[3];
+	struct ieee80211_country_ie_triplet triplet[MAX_11D_TRIPLETS];
 } __packed;
 
 struct cmd_ds_802_11d_domain_info {
+	struct cmd_header hdr;
+
 	__le16 action;
 	struct mrvl_ie_domain_param_set domain;
 } __packed;
 
-struct lbs_802_11d_domain_reg {
-	/** Country code*/
-	u8 country_code[COUNTRY_CODE_LEN];
-	/** No. of triplet*/
-	u8 no_triplet;
-	struct ieee80211_country_ie_triplet triplet[MRVDRV_MAX_TRIPLET_802_11D];
-} __packed;
-
 /*
  * Define data structure for CMD_GET_HW_SPEC
  * This structure defines the response for the GET_HW_SPEC command
@@ -973,9 +965,6 @@ struct cmd_ds_command {
 		struct cmd_ds_bbp_reg_access bbpreg;
 		struct cmd_ds_rf_reg_access rfreg;
 
-		struct cmd_ds_802_11d_domain_info domaininfo;
-		struct cmd_ds_802_11d_domain_info domaininforesp;
-
 		struct cmd_ds_802_11_tpc_cfg tpccfg;
 		struct cmd_ds_802_11_afc afc;
 		struct cmd_ds_802_11_led_ctrl ledgpio;
-- 
1.7.1.1


