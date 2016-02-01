Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59000 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbcBAHsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 02:48:31 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u117iVLB029266
	for <linux-wireless@vger.kernel.org>; Sun, 31 Jan 2016 23:48:31 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 20sw0hgwr2-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 31 Jan 2016 23:48:31 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Nachiket Kukade <kukaden@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: fix bandwidth display problem
Date: Sun, 31 Jan 2016 23:44:46 -0800
Message-ID: <1454312686-31172-1-git-send-email-akarwar@marvell.com> (sfid-20160201_084908_179916_B22976AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nachiket Kukade <kukaden@marvell.com>

Instead of using HT info from beacon IEs, use HT info from
association response frame to update bandwidth in
cfg80211_get_channel handler.

Signed-off-by: Nachiket Kukade <kukaden@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c  |  4 ++--
 drivers/net/wireless/marvell/mwifiex/fw.h        |  2 +-
 drivers/net/wireless/marvell/mwifiex/join.c      | 15 +++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h      |  2 ++
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  3 +++
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 8461553..f2dce81 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3793,8 +3793,8 @@ static int mwifiex_cfg80211_get_channel(struct wiphy *wiphy,
 		freq = ieee80211_channel_to_frequency(curr_bss->channel, band);
 		chan = ieee80211_get_channel(wiphy, freq);
 
-		if (curr_bss->bcn_ht_oper) {
-			second_chan_offset = curr_bss->bcn_ht_oper->ht_param &
+		if (priv->ht_param_present) {
+			second_chan_offset = priv->assoc_resp_ht_param &
 					IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
 			chan_type = mwifiex_sec_chan_offset_to_chan_type
 							(second_chan_offset);
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 4af9168..c134cf8 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1063,7 +1063,7 @@ struct ieee_types_assoc_rsp {
 	__le16 cap_info_bitmap;
 	__le16 status_code;
 	__le16 a_id;
-	u8 ie_buffer[1];
+	u8 ie_buffer[0];
 } __packed;
 
 struct host_cmd_ds_802_11_associate_rsp {
diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index cc09a81..62211fc 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -644,6 +644,8 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	struct mwifiex_bssdescriptor *bss_desc;
 	bool enable_data = true;
 	u16 cap_info, status_code, aid;
+	const u8 *ie_ptr;
+	struct ieee80211_ht_operation *assoc_resp_ht_oper;
 
 	assoc_rsp = (struct ieee_types_assoc_rsp *) &resp->params;
 
@@ -733,6 +735,19 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 			= ((bss_desc->wmm_ie.qos_info_bitmap &
 				IEEE80211_WMM_IE_AP_QOSINFO_UAPSD) ? 1 : 0);
 
+	/* Store the bandwidth information from assoc response */
+	ie_ptr = cfg80211_find_ie(WLAN_EID_HT_OPERATION, assoc_rsp->ie_buffer,
+				  priv->assoc_rsp_size
+				  - sizeof(struct ieee_types_assoc_rsp));
+	if (ie_ptr) {
+		assoc_resp_ht_oper = (struct ieee80211_ht_operation *)(ie_ptr
+					+ sizeof(struct ieee_types_header));
+		priv->assoc_resp_ht_param = assoc_resp_ht_oper->ht_param;
+		priv->ht_param_present = true;
+	} else {
+		priv->ht_param_present = false;
+	}
+
 	mwifiex_dbg(priv->adapter, INFO,
 		    "info: ASSOC_RESP: curr_pkt_filter is %#x\n",
 		    priv->curr_pkt_filter);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index c755be54c..89a1576 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -674,6 +674,8 @@ struct mwifiex_private {
 	struct mwifiex_ds_mem_rw mem_rw;
 	struct sk_buff_head bypass_txq;
 	struct mwifiex_user_scan_chan hidden_chan[MWIFIEX_USER_SCAN_CHAN_MAX];
+	u8 assoc_resp_ht_param;
+	bool ht_param_present;
 };
 
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index fd8061c..070bce4 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -92,6 +92,9 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	priv->is_data_rate_auto = true;
 	priv->data_rate = 0;
 
+	priv->assoc_resp_ht_param = 0;
+	priv->ht_param_present = false;
+
 	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
 	     GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) && priv->hist_data)
 		mwifiex_hist_data_reset(priv);
-- 
1.8.1.4

