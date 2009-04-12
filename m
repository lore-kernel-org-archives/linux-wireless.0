Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n23.bullet.mail.mud.yahoo.com ([68.142.206.162]:23629 "HELO
	n23.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754124AbZDLKFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2009 06:05:07 -0400
Date: Sun, 12 Apr 2009 02:57:54 -0700
From: Steven Luo <steven@steven676.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: reset after PCI FATAL/PERR interrupts
Message-ID: <20090412095754.GA2594@steven676.net> (sfid-20090412_120513_480515_AFE70DCE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Steven Luo <steven@steven676.net>

ath9k_hw_getisr() doesn't appear to set anything in the status mask for
PCI FATAL or PERR interrupts (AR_INTR_SYNC_HOST1_FATAL/PERR), which
the open-source HAL seems to do.  This means that the card isn't reset
after these interrupts.

This patch seems to fix a problem where the wireless drops out with an
"ath9k: received PCI FATAL interrupt" in dmesg after some time; the
hardware is an AR5416 in an ASUS WL-500W running 2.6.28.7 (OpenWRT) and
compat-wireless 2009-03-31.

Signed-off-by: Steven Luo <steven@steven676.net>
---

--- a/drivers/net/wireless/ath9k/hw.c	2009-04-09 23:23:35.000000000 -0700
+++ b/drivers/net/wireless/ath9k/hw.c	2009-04-11 23:29:28.000000000 -0700
@@ -3007,6 +3007,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, 
 				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 					"received PCI PERR interrupt\n");
 			}
+			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
 			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,

