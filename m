Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36452 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751447AbdINSRz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 14:17:55 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8192ee: Fix memory leak when loading firmware
Date: Thu, 14 Sep 2017 13:17:44 -0500
Message-Id: <20170914181744.8216-1-Larry.Finger@lwfinger.net> (sfid-20170914_201805_882043_52FA21CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In routine rtl92ee_set_fw_rsvdpagepkt(), the driver allocates an skb, but
never calls rtl_cmd_send_packet(), which will free the buffer. All other
rtlwifi drivers perform this operation correctly.

This problem has been in the driver since it was included in the kernel.
Fortunately, each firmware load only leaks 4 buffers, which likely
explains why it has not previously been detected.

Cc: Stable <stable@vger.kernel.org> # 3.18+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 7eae27f8e173..f9563ae301ad 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -682,7 +682,7 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct sk_buff *skb = NULL;
-
+	bool rtstatus;
 	u32 totalpacketlen;
 	u8 u1rsvdpageloc[5] = { 0 };
 	bool b_dlok = false;
@@ -768,7 +768,9 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 	skb = dev_alloc_skb(totalpacketlen);
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
-	b_dlok = true;
+	rtstatus = rtl_cmd_send_packet(hw, skb);
+	if (rtstatus)
+		b_dlok = true;
 
 	if (b_dlok) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD ,
-- 
2.12.3
