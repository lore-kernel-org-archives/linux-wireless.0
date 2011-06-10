Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61227 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1FJGsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 02:48:01 -0400
Received: by gxk21 with SMTP id 21so1446888gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2011 23:48:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110224200203.GB17412@elie>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
Date: Fri, 10 Jun 2011 14:48:00 +0800
Message-ID: <BANLkTik-DQxb8Ca698BeizRVyB71bWBndQ@mail.gmail.com> (sfid-20110610_084805_989496_24A65D93)
Subject: Re: ath9k causes lockups since kernel 2.6.35
From: Adrian Chadd <adrian@freebsd.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

This patch against the current wireless-testing tree restores bit 6/7
being set for the AR9285.

Tony, would you please test this out and see if this works? This is
against the latest wireless-testing.

Thanks,


Adrian

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index f344cc2..5e4e37f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -384,6 +384,7 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
                        }
                }

+#if 0
                if (AR_SREV_9280(ah) || AR_SREV_9285(ah) || AR_SREV_9287(ah)) {
                        /*
                         * Disable bit 6 and 7 before entering D3 to
@@ -391,6 +392,7 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
                         */
                        val &= ~(AR_WA_BIT6 | AR_WA_BIT7);
                }
+#endif

                if (AR_SREV_9280(ah))
                        val |= AR_WA_BIT22;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h
b/drivers/net/wireless/ath/ath9k/reg.h
index c18ee99..a3c893d 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -704,7 +704,7 @@
 #define AR_WA_ANALOG_SHIFT              (1 << 20)
 #define AR_WA_POR_SHORT                 (1 << 21) /* PCI-E Phy reset control */
 #define AR_WA_BIT22                    (1 << 22)
-#define AR9285_WA_DEFAULT              0x004a050b
+#define AR9285_WA_DEFAULT              0x004a05cb
 #define AR9280_WA_DEFAULT              0x0040073b
 #define AR_WA_DEFAULT                  0x0000073f
