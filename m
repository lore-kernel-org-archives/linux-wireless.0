Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44443 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab0LGXNb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:13:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 15:13:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <amod.bodas@atheros.com>,
	<pstew@google.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH v3 2/5] ath9k: fix assumptions for idle calls on suspend/resume
Date: Tue, 7 Dec 2010 15:13:20 -0800
Message-ID: <1291763603-26546-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1291763603-26546-1-git-send-email-lrodriguez@atheros.com>
References: <1291763603-26546-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 will notify drivers when to go idle and ath9k
assumed that it would get further notifications for idle
states after a device stop() config call but as per agreed
semantics the idle state of the radio is left up to driver
after mac80211 issues the stop() callback. The driver is
resposnbile for ensuring the device remains idle after
that even between suspend / resume calls.

This fixes suspend/resume when you issue suspend and resume
twice on ath9k when ath9k_stop() was already called. We need
to put the radio to full sleep in order for resume to work
correctly.

What might seem fishy is we are turning the radio off
after resume. The reason why we do this is because we know
we should not have anything enabled after a mac80211 tells
us to stop(), if we resume and never get a start() we won't
get another stop() by mac80211 so to be safe always bring
the 802.11 device with the radio disabled after resume,
this ensures that if we suspend we already have the radio
disabled and only a start() will ever trigger it on.

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 drivers/net/wireless/ath/ath9k/pci.c  |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index be19b70..669fe6c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1330,8 +1330,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	ath9k_ps_restore(sc);
 
-	/* Finally, put the chip in FULL SLEEP mode */
-	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
+	sc->ps_idle = true;
+	ath_radio_disable(sc, hw);
 
 	sc->sc_flags |= SC_OP_INVALID;
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 747b287..7ca8499 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -309,6 +309,9 @@ static int ath_pci_resume(struct device *device)
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
+	sc->ps_idle = true;
+	ath_radio_disable(sc, hw);
+
 	return 0;
 }
 
-- 
1.7.3.2.90.gd4c43

