Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49625 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767745Ab2KONY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 08:24:58 -0500
Received: by mail-qa0-f46.google.com with SMTP id c11so2570066qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2012 05:24:57 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 15 Nov 2012 21:24:57 +0800
Message-ID: <CAPgLHd92hMAagQLtKDJW7nyTmFKUgGz6HE5mis7T=KbLt8VXEQ@mail.gmail.com> (sfid-20121115_142502_013773_8E7F8455)
Subject: [PATCH] rtlwifi: use eth_zero_addr() to assign zero address
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using eth_zero_addr() to assign zero address insetad of
memset() or an inefficient copy from a static array.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/rtlwifi/cam.c  | 2 +-
 drivers/net/wireless/rtlwifi/core.c | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
index 5b4b4d4..4511a39 100644
--- a/drivers/net/wireless/rtlwifi/cam.c
+++ b/drivers/net/wireless/rtlwifi/cam.c
@@ -340,7 +340,7 @@ void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 		if (((bitmap & BIT(0)) == BIT(0)) &&
 		    (memcmp(addr, sta_addr, ETH_ALEN) == 0)) {
 			/* Remove from HW Security CAM */
-			memset(rtlpriv->sec.hwsec_cam_sta_addr[i], 0, ETH_ALEN);
+			eth_zero_addr(rtlpriv->sec.hwsec_cam_sta_addr[i]);
 			rtlpriv->sec.hwsec_cam_bitmap &= ~(BIT(0) << i);
 			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 				 "del CAM entry %d\n", i);

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index a7c0e52..be33aa1 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -962,7 +962,6 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	int err = 0;
 	u8 mac_addr[ETH_ALEN];
 	u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-	u8 zero_addr[ETH_ALEN] = { 0 };
 
 	if (rtlpriv->cfg->mod_params->sw_crypto || rtlpriv->sec.use_sw_sec) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
@@ -1057,7 +1056,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			memcpy(rtlpriv->sec.key_buf[key_idx],
 			       key->key, key->keylen);
 			rtlpriv->sec.key_len[key_idx] = key->keylen;
-			memcpy(mac_addr, zero_addr, ETH_ALEN);
+			eth_zero_addr(mac_addr);
 		} else if (group_key) {	/* group key */
 			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
 				 "set group key\n");
@@ -1108,7 +1107,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		}
 		memset(rtlpriv->sec.key_buf[key_idx], 0, key->keylen);
 		rtlpriv->sec.key_len[key_idx] = 0;
-		memcpy(mac_addr, zero_addr, ETH_ALEN);
+		eth_zero_addr(mac_addr);
 		/*
 		 *mac80211 will delete entrys one by one,
 		 *so don't use rtl_cam_reset_all_entry


