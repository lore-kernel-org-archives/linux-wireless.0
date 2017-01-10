Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpoutz26.laposte.net ([194.117.213.101]:47807 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1765331AbdAJJze (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 04:55:34 -0500
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout014 (Postfix) with ESMTP id D1760121273
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2017 10:55:31 +0100 (CET)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout014 (Postfix) with ESMTP id C3B13121373
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2017 10:55:31 +0100 (CET)
Received: from lpn-prd-vrin002 (lpn-prd-vrin002.prosodie [10.128.63.3])
        by lpn-prd-vrout014 (Postfix) with ESMTP id BF1C8121273
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2017 10:55:31 +0100 (CET)
Received: from lpn-prd-vrin002 (localhost [127.0.0.1])
        by lpn-prd-vrin002 (Postfix) with ESMTP id AADF35BF602
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2017 10:55:31 +0100 (CET)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Joe Perches <joe@perches.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH next] rtlwifi: rtl8192de: fix missing curly braces
Date: Tue, 10 Jan 2017 10:55:21 +0100
Message-Id: <20170110095521.4410-1-vincent.stehle@laposte.net> (sfid-20170110_105549_380038_7E7A6AFC)
In-Reply-To: <20161215182310.13713-15-Larry.Finger@lwfinger.net>
References: <20161215182310.13713-15-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restore some curly braces that have been removed in commit c93ac39da006457f
("rtlwifi: Remove some redundant code") while removing redundant messages
and extraneous braces.

This fixes the following smatch warning:

  drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c:326 rtl92d_download_fw() warn: curly braces intended?

...and the following coccinelle warning:

  drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c:325:2-38: code aligned with following code on line 326

Fixes: c93ac39da006457f ("rtlwifi: Remove some redundant code")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Joe Perches <joe@perches.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---


Hi,

I saw that in Linux next-20170110.

Best regards,

Vincent.


 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
index aa1e51c871df..bcde4da4e593 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
@@ -321,9 +321,10 @@ int rtl92d_download_fw(struct ieee80211_hw *hw)
 	value &= (~BIT(5));
 	rtl_write_byte(rtlpriv, 0x1f, value);
 	spin_unlock_irqrestore(&globalmutex_for_fwdownload, flags);
-	if (err)
+	if (err) {
 		pr_err("fw is not ready to run!\n");
 		goto exit;
+	}
 exit:
 	err = _rtl92d_fw_init(hw);
 	return err;
-- 
2.11.0
