Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:48301 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaFWWKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 18:10:52 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so7850020wes.36
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 15:10:51 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Ben Hutchings <ben@decadent.org.uk>,
	Peter Wu <peter@lekensteyn.nl>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHv3 6/6] drivers/staging/rtl8821ae: replace magic number by macro
Date: Tue, 24 Jun 2014 00:11:51 +0200
Message-Id: <1403561511-8117-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140624_001110_864886_D66B3235)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For consistency with other drivers, replace a magic number by a macro.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Reviewed-by: Peter Wu <peter@lekensteyn.nl>
---
 drivers/staging/rtl8821ae/rtl8821ae/hw.c  |    2 +-
 drivers/staging/rtl8821ae/rtl8821ae/reg.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hw.c b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
index 1b8583b..1aa1661 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hw.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
@@ -1623,7 +1623,7 @@ static int _rtl8821ae_set_media_status(struct ieee80211_hw *hw,
 
 	rtl_write_byte(rtlpriv, (MSR), bt_msr);
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
-	if ((bt_msr & ~0xfc) == MSR_AP)
+	if ((bt_msr & MSR_MASK) == MSR_AP)
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
 	else
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
diff --git a/drivers/staging/rtl8821ae/rtl8821ae/reg.h b/drivers/staging/rtl8821ae/rtl8821ae/reg.h
index beffb42..4cb3ca9 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/reg.h
+++ b/drivers/staging/rtl8821ae/rtl8821ae/reg.h
@@ -431,6 +431,7 @@
 #define	MSR_ADHOC					0x01
 #define	MSR_INFRA					0x02
 #define	MSR_AP						0x03
+#define	MSR_MASK					0x03
 
 #define	RRSR_RSC_OFFSET				21
 #define	RRSR_SHORT_OFFSET			23
-- 
1.7.10.4

