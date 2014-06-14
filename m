Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45732 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbaFNN0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:26:43 -0400
Received: by mail-lb0-f173.google.com with SMTP id s7so1925081lbd.32
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:26:42 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: wireless: rtlwifi: rtl8188ee: reg.h:  Cleaning up if statement that always evaluates to false
Date: Sat, 14 Jun 2014 15:27:38 +0200
Message-Id: <1402752458-13836-2-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140614_152716_340111_CDEEE764)
In-Reply-To: <1402752458-13836-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402752458-13836-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found a logical error in an if statement that always evaluates to false.

This has after same discussion resulted in that we add a macro to handle this.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h b/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
index 7af85cf..cd7e7a5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
@@ -411,6 +411,7 @@
 #define	MSR_ADHOC				0x01
 #define	MSR_INFRA				0x02
 #define	MSR_AP					0x03
+#define	MSR_MASK				0x03
 
 #define	RRSR_RSC_OFFSET				21
 #define	RRSR_SHORT_OFFSET			23
-- 
1.7.10.4

