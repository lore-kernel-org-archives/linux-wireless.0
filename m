Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:36315 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbdA3UwV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 15:52:21 -0500
Received: by mail-ot0-f194.google.com with SMTP id 36so39678383otx.3
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2017 12:52:21 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Jurij Smakov <jurij@wooyd.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V2] rtlwifi: rtl8192ce: Fix loading of incorrect firmware
Date: Mon, 30 Jan 2017 14:52:18 -0600
Message-Id: <20170130205218.25288-1-Larry.Finger@lwfinger.net> (sfid-20170130_215224_703207_2A189773)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jurij Smakov <jurij@wooyd.org>

In commit cf4747d7535a ("rtlwifi: Fix regression caused by commit
d86e64768859, an error in the edit results in the wrong firmware
being loaded for some models of the RTL8188/8192CE. In this condition,
the connection suffered from high ping latency, slow transfer rates,
 and required higher signal strengths to work at all

See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=853073,
https://bugzilla.opensuse.org/show_bug.cgi?id=1017471, and
https://github.com/lwfinger/rtlwifi_new/issues/203 for descriptions
of the problems. This patch fixes all of those problems.

Fixes: cf4747d7535a ("rtlwifi: Fix regression caused by commit d86e64768859")
Signed-off-by: Jurij Smakov <jurij@wooyd.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> # 4.9+
---
V2 - answer the comments of Kalle
---
Kalle,

This patch should be pushed upstream as soon as possible. Note that it
does not cause a kernel panic. It does, however, reduce the reliability
of the wireless connection.

Larry
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
index b875a72..9a94e45 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
@@ -96,7 +96,7 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	char *fw_name = "rtlwifi/rtl8192cfwU.bin";
+	char *fw_name;
 
 	rtl8192ce_bt_reg_init(hw);
 
@@ -167,8 +167,13 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	}
 
 	/* request fw */
-	if (IS_81XXC_VENDOR_UMC_B_CUT(rtlhal->version))
+	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
+	    !IS_92C_SERIAL(rtlhal->version))
+		fw_name = "rtlwifi/rtl8192cfwU.bin";
+	else if (IS_81XXC_VENDOR_UMC_B_CUT(rtlhal->version))
 		fw_name = "rtlwifi/rtl8192cfwU_B.bin";
+	else
+		fw_name = "rtlwifi/rtl8192cfw.bin";
 
 	rtlpriv->max_fw_size = 0x4000;
 	pr_info("Using firmware %s\n", fw_name);
-- 
2.10.2
