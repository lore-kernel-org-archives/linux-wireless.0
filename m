Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:57568 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaFUVCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 17:02:45 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so5116044wes.41
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jun 2014 14:02:44 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	Peter Wu <lekensteyn@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: wireless: rtlwifi: rtl8192de: hw.c:  Cleaning up if statement that always evaluates to false
Date: Sat, 21 Jun 2014 23:03:42 +0200
Message-Id: <1403384623-9737-2-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140621_230302_496820_3A3BD53A)
In-Reply-To: <1403384623-9737-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403384623-9737-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found a logical error in an if statement that always evaluates to false.

This has after same discussion resulted in that we add a macro to handle this.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index 2b08671..280c3da 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1128,7 +1128,7 @@ static int _rtl92de_set_media_status(struct ieee80211_hw *hw,
 	}
 	rtl_write_byte(rtlpriv, REG_CR + 2, bt_msr);
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
-	if ((bt_msr & 0xfc) == MSR_AP)
+	if ((bt_msr & MSR_MASK) == MSR_AP)
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
 	else
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/reg.h b/drivers/net/wireless/rtlwifi/rtl8192de/reg.h
index 7f29b8d..315a298 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/reg.h
@@ -369,6 +369,7 @@
 #define	MSR_ADHOC			0x01
 #define	MSR_INFRA			0x02
 #define	MSR_AP				0x03
+#define	MSR_MASK			0x03
 
 /* 6. Adaptive Control Registers  (Offset: 0x0160 - 0x01CF) */
 /* ----------------------------------------------------- */
-- 
1.7.10.4

