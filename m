Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51102 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:28:07 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 11/11] ath6kl: Remove few unused WMI stuff
Date: Mon, 7 Nov 2011 10:55:47 +0530
Message-ID: <1320643547-3578-12-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062810_058936_379CD2A4)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Removed unused WOW_MAX_FILTER_LISTS macro.

* Removed empty ath6kl_wmi_get_wow_list_event_rx() function.
  List of configured WOW patterns are maintained in CFG layer
  itself. No need to have this function in ath6kl to get
  configured WOW pattern list. It can added later if we need
  it for debugging.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   10 ----------
 drivers/net/wireless/ath/ath6kl/wmi.h |   14 --------------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 3da1fb5..922344d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2576,15 +2576,6 @@ int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 	return ret;
 }
 
-static int ath6kl_wmi_get_wow_list_event_rx(struct wmi *wmi, u8 * datap,
-					    int len)
-{
-	if (len < sizeof(struct wmi_get_wow_list_reply))
-		return -EINVAL;
-
-	return 0;
-}
-
 static int ath6kl_wmi_cmd_send_xtnd(struct wmi *wmi, struct sk_buff *skb,
 				    enum wmix_command_id cmd_id,
 				    enum wmi_sync_flag sync_flag)
@@ -3295,7 +3286,6 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_GET_WOW_LIST_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_GET_WOW_LIST_EVENTID\n");
-		ret = ath6kl_wmi_get_wow_list_event_rx(wmi, datap, len);
 		break;
 	case WMI_GET_PMKID_LIST_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_GET_PMKID_LIST_EVENTID\n");
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index a65eee2..76342d5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1795,7 +1795,6 @@ struct wmi_set_appie_cmd {
 #define WSC_REG_ACTIVE     1
 #define WSC_REG_INACTIVE   0
 
-#define WOW_MAX_FILTER_LISTS	 1
 #define WOW_MAX_FILTERS_PER_LIST 4
 #define WOW_PATTERN_SIZE	 64
 #define WOW_MASK_SIZE		 64
@@ -1866,19 +1865,6 @@ struct wmi_del_wow_pattern_cmd {
 	__le16 filter_id;
 } __packed;
 
-/* WMI_GET_WOW_LIST_CMD reply  */
-struct wmi_get_wow_list_reply {
-	/* number of patterns in reply */
-	u8 num_filters;
-
-	/* this is filter # x of total num_filters */
-	u8 this_filter_num;
-
-	u8 wow_mode;
-	u8 host_mode;
-	struct wow_filter wow_filters[1];
-} __packed;
-
 /* WMI_SET_AKMP_PARAMS_CMD */
 
 struct wmi_pmkid {
-- 
1.7.1

