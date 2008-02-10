Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYBKMWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 07:22:09 -0500
Subject: [PATCH v2] mac80211: give burst time in txop rather than 0.1msec
	units
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 10 Feb 2008 16:49:38 +0100
Message-Id: <1202658578.11481.4.camel@johannes.berg> (sfid-20080211_122218_015513_F6A3C320)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes mac80211 to pass the burst time to conf_tx in txop
units rather than 0.1msec units. 0.1msec units are only required
by atheros hardware (according to current driver support), all
other drivers do other calculations or require the txop value.
Therefore, it results in fewer calculations and more precision
if we just pass the txop value through to the driver.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Michael Buesch <mb@bu3sch.de>
---
Michael (Wu), the p54 driver has some values that differ from
the 802.11 spec, is that intentional?

Changes since v1:
 * Fix p54 +1 that was for integer division only, thanks goes to
   Tomas for pointing that out.
 * CC linux-wireless

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 drivers/net/wireless/p54common.c            |   21 +++++++++++++--------
 include/net/mac80211.h                      |   12 ++++++------
 net/mac80211/ieee80211_sta.c                |   11 ++++++-----
 5 files changed, 27 insertions(+), 21 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-02-08 13:30:12.772100640 +0100
+++ everything/include/net/mac80211.h	2008-02-10 16:37:59.495454318 +0100
@@ -89,19 +89,19 @@ struct ieee80211_ht_bss_info {
  * struct ieee80211_tx_queue_params - transmit queue configuration
  *
  * The information provided in this structure is required for QoS
- * transmit queue configuration.
+ * transmit queue configuration. Cf. IEEE 802.11 7.3.2.29.
  *
  * @aifs: arbitration interface space [0..255, -1: use default]
  * @cw_min: minimum contention window [will be a value of the form
  *	2^n-1 in the range 1..1023; 0: use default]
  * @cw_max: maximum contention window [like @cw_min]
- * @burst_time: maximum burst time in units of 0.1ms, 0 meaning disabled
+ * @txop: maximum burst time in units of 32 usecs, 0 meaning disabled
  */
 struct ieee80211_tx_queue_params {
-	int aifs;
-	int cw_min;
-	int cw_max;
-	int burst_time;
+	s16 aifs;
+	u16 cw_min;
+	u16 cw_max;
+	u16 txop;
 };
 
 /**
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-08 13:29:50.532014160 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-10 16:37:58.465453667 +0100
@@ -297,12 +297,13 @@ static void ieee80211_sta_wmm_params(str
 		params.aifs = pos[0] & 0x0f;
 		params.cw_max = ecw2cw((pos[1] & 0xf0) >> 4);
 		params.cw_min = ecw2cw(pos[1] & 0x0f);
-		/* TXOP is in units of 32 usec; burst_time in 0.1 ms */
-		params.burst_time = (pos[2] | (pos[3] << 8)) * 32 / 100;
+		params.txop = pos[2] | (pos[3] << 8);
+#ifdef CONFIG_MAC80211_DEBUG
 		printk(KERN_DEBUG "%s: WMM queue=%d aci=%d acm=%d aifs=%d "
-		       "cWmin=%d cWmax=%d burst=%d\n",
+		       "cWmin=%d cWmax=%d txop=%d\n",
 		       dev->name, queue, aci, acm, params.aifs, params.cw_min,
-		       params.cw_max, params.burst_time);
+		       params.cw_max, params.txop);
+#endif
 		/* TODO: handle ACM (block TX, fallback to next lowest allowed
 		 * AC for now) */
 		if (local->ops->conf_tx(local_to_hw(local), queue, &params)) {
@@ -3229,7 +3230,7 @@ int ieee80211_sta_set_ssid(struct net_de
 			qparam.cw_min = 15;
 
 		qparam.cw_max = 1023;
-		qparam.burst_time = 0;
+		qparam.txop = 0;
 
 		for (i = IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
 			local->ops->conf_tx(local_to_hw(local),
--- everything.orig/drivers/net/wireless/p54common.c	2008-02-08 13:37:00.462002333 +0100
+++ everything/drivers/net/wireless/p54common.c	2008-02-10 16:45:36.095452637 +0100
@@ -759,13 +759,12 @@ static int p54_set_leds(struct ieee80211
 	return 0;
 }
 
-#define P54_SET_QUEUE(queue, ai_fs, cw_min, cw_max, burst)	\
+#define P54_SET_QUEUE(queue, ai_fs, cw_min, cw_max, _txop)	\
 do {	 							\
 	queue.aifs = cpu_to_le16(ai_fs);			\
 	queue.cwmin = cpu_to_le16(cw_min);			\
 	queue.cwmax = cpu_to_le16(cw_max);			\
-	queue.txop = (burst == 0) ? 				\
-		0 : cpu_to_le16((burst * 100) / 32 + 1);	\
+	queue.txop = cpu_to_le16(_txop);			\
 } while(0)
 
 static void p54_init_vdcf(struct ieee80211_hw *dev)
@@ -783,10 +782,16 @@ static void p54_init_vdcf(struct ieee802
 
 	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
 
-	P54_SET_QUEUE(vdcf->queue[0], 0x0002, 0x0003, 0x0007, 0x000f);
-	P54_SET_QUEUE(vdcf->queue[1], 0x0002, 0x0007, 0x000f, 0x001e);
-	P54_SET_QUEUE(vdcf->queue[2], 0x0002, 0x000f, 0x03ff, 0x0014);
-	P54_SET_QUEUE(vdcf->queue[3], 0x0007, 0x000f, 0x03ff, 0x0000);
+	/*
+	 * FIXME: The default values in the spec (IEEE 802.11
+	 *	  7.3.2.19 Table 37) are 47, 94, 0, 0, why use
+	 *	  47, 94, 63, 0 here? Also, the default AIFS
+	 *	  values (second parameter) are 2, 2, 3, 7...
+	 */
+	P54_SET_QUEUE(vdcf->queue[0], 0x0002, 0x0003, 0x0007, 47);
+	P54_SET_QUEUE(vdcf->queue[1], 0x0002, 0x0007, 0x000f, 94);
+	P54_SET_QUEUE(vdcf->queue[2], 0x0002, 0x000f, 0x03ff, 63);
+	P54_SET_QUEUE(vdcf->queue[3], 0x0007, 0x000f, 0x03ff, 0);
 }
 
 static void p54_set_vdcf(struct ieee80211_hw *dev)
@@ -939,7 +944,7 @@ static int p54_conf_tx(struct ieee80211_
 
 	if ((params) && !((queue < 0) || (queue > 4))) {
 		P54_SET_QUEUE(vdcf->queue[queue], params->aifs,
-			params->cw_min, params->cw_max, params->burst_time);
+			params->cw_min, params->cw_max, params->txop);
 	} else
 		return -EINVAL;
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-02-08 13:40:35.832004394 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-02-10 16:38:01.385488064 +0100
@@ -7437,7 +7437,7 @@ static int iwl3945_mac_conf_tx(struct ie
 	priv->qos_data.def_qos_parm.ac[q].cw_max = cpu_to_le16(params->cw_max);
 	priv->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
 	priv->qos_data.def_qos_parm.ac[q].edca_txop =
-			cpu_to_le16((params->burst_time * 100));
+			cpu_to_le16((params->txop * 32));
 
 	priv->qos_data.def_qos_parm.ac[q].reserved1 = 0;
 	priv->qos_data.qos_active = 1;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-02-08 13:39:39.672042426 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-02-10 16:38:01.445458387 +0100
@@ -7915,7 +7915,7 @@ static int iwl4965_mac_conf_tx(struct ie
 	priv->qos_data.def_qos_parm.ac[q].cw_max = cpu_to_le16(params->cw_max);
 	priv->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
 	priv->qos_data.def_qos_parm.ac[q].edca_txop =
-			cpu_to_le16((params->burst_time * 100));
+			cpu_to_le16((params->txop * 32));
 
 	priv->qos_data.def_qos_parm.ac[q].reserved1 = 0;
 	priv->qos_data.qos_active = 1;


