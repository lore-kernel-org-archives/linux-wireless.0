Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62392 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab0LTQaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 11:30:03 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 08:29:47 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: [PATCH] ath9k: fix aphy / wiphy idle mismatch
Date: Mon, 20 Dec 2010 11:29:59 -0500
Message-ID: <1292862599-26335-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k supports its own set of virtual wiphys, and it uses
the mac80211 idle notifications to know when a device needs
to be idle or not. We recently changed ath9k to force idle
on driver stop() and on resume but forgot to take into account
ath9k's own virtual wiphy idle states. These are used internally
by ath9k to check if the device's radio should be powered down
on each idle call. Without this change its possible that the
device could have been forced off but the virtual wiphy idle
was left on.

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I'm not yet sure if this actually fixes an issue but it
certainly is a proper ammendment to the other idle fix
submitted for stable for suspend/resume.

 drivers/net/wireless/ath/ath9k/main.c |    1 +
 drivers/net/wireless/ath/ath9k/pci.c  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4d64716..1b35175 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1354,6 +1354,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath9k_ps_restore(sc);
 
 	sc->ps_idle = true;
+	ath9k_set_wiphy_idle(aphy, true);
 	ath_radio_disable(sc, hw);
 
 	sc->sc_flags |= SC_OP_INVALID;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 7ca8499..4538283 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -310,6 +310,7 @@ static int ath_pci_resume(struct device *device)
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
 	sc->ps_idle = true;
+	ath9k_set_wiphy_idle(aphy, true);
 	ath_radio_disable(sc, hw);
 
 	return 0;
-- 
1.7.3.2.90.gd4c43

