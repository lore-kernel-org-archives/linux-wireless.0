Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0H0Sn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:43:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Amod Bodas <Amod.Bodas@atheros.com>
Subject: [PATCH] ath9k: fix drop of multicast / broadcast data during scan
Date: Fri, 27 Aug 2010 14:43:26 -0400
Message-Id: <1282934606-4169-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211's scan implementation puts the burden of processing the DTIM
count on drivers to accurately disallow scanning during certain wait
constraints. ath9k was allowing to change channel while a few of these
wait constraints were still in effect causing some drop of buffered
broadcast and multicast traffic. Fix this by checking for the wait
constraints prior to switching channels.

This is tested against a Cisco E3000 AP configued with a DTIM Interval of 2
and beacon interval of 1000. Then setup ath9k to receive multicast
traffic:

  user@ath9k-RX-box $ iperf -s -u -B 224.0.55.55 -i 1

On the transmit multicast box connected to the same AP:

  user@ath9k-TX-box $ while true ; do iperf -c 224.0.55.55 \
	-u -T 32 -t 3 -i 1 -b 10M -t 1000; sleep 2 ; done

Without this patch we would otherwise loose that data. You can verify we run into
this by enabling the ATH_DBG_PS (0x800) when loading ath9k.

Cc: stable@kernel.org
Cc: Amod Bodas <Amod.Bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

With other types of tests my AP just ends up dying so this is as
far as I could test it. For example setting the DTIM interval to a
max 255 beacon interval to a max of 65535 I poo out my AP in no time
when sending broadcast / multicast traffic. In fact even Ethernet
dies out immediately.

 drivers/net/wireless/ath/ath9k/main.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1165f90..3b0cd19 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1511,6 +1511,22 @@ void ath9k_enable_ps(struct ath_softc *sc)
 	}
 }
 
+static bool ath9k_can_change_channel(struct ath_softc *sc)
+{
+	u32 wait_for = PS_WAIT_FOR_BEACON |
+		       PS_WAIT_FOR_CAB |
+		       PS_WAIT_FOR_PSPOLL_DATA |
+		       PS_WAIT_FOR_TX_ACK;
+
+	if (sc->ps_flags & wait_for) {
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_PS,
+			  "Cannot change channel due to a wait constraint\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath_wiphy *aphy = hw->priv;
@@ -1605,6 +1621,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
 
+		if (!ath9k_can_change_channel(sc))
+			goto skip_chan_change;
+
 		aphy->chan_idx = pos;
 		aphy->chan_is_ht = conf_is_ht(conf);
 		if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
-- 
1.7.0.4

