Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33354 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbbLNWfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 17:35:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH 8/8] rtlwifi: rtl8192cu: Add missing parameter setup
Date: Mon, 14 Dec 2015 16:34:38 -0600
Message-Id: <1450132478-2386-9-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151214_233528_883414_816A3D0B)
In-Reply-To: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver fails to copy the module parameter for software encryption
to the locations used by the main code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index fd4a535..7c6f7f0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -65,6 +65,8 @@ static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->dm.disable_framebursting = false;
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	rtlpriv->cfg->mod_params->sw_crypto =
+		rtlpriv->cfg->mod_params->sw_crypto;
 
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x4000);
-- 
2.1.4

