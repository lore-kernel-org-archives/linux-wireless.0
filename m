Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4991 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbZD3T4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 15:56:45 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [PATCH 5/9] ath5k: Enable AP mode
Date: Thu, 30 Apr 2009 15:55:48 -0400
Message-Id: <1241121352-6064-6-git-send-email-me@bobcopeland.com>
In-Reply-To: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
References: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jiri Slaby <jirislaby@gmail.com>

After some debuging we were hitting the following bugs so far...

 * Due to huge channel list hostapd couldn't get infos from the driver
 and couldn't set the channel. If we manualy set the channel after
 hostapd starts (by setting channel to 0 -auto), beacons are sent
 but they wont show up on scan because they are malformed (they have
 channel = 0 because hostapd doesn't update the channel info -this is
 probably a hostapd bug so i'm CCing Jouni) and they get dropped. Bob
 fixed this by only allowing standard channels to be registered so
 now hostapd works as expected.

 * Docs (and HAL source) say that we must write 0 on timer0 when
 operating on AP mode to start TSF increment but this seems to
 mess with DBA in many cases and beacon queue never gets started.
 We fixed that on the previous patch.

 We have some more things to deal with...

 * For some reason (hw bug or something else) after restarting hostapd
 a few times, beacon inteval seems to change from 100ms to a sec
 (we get one beacon per sec).

 * We need to set sleep timers on STA mode and enable power saving +
 support PCF.

 ...but i think it's time we enable AP support "officialy" so that
 we can get more feedback from users. I ran ath5k with the mentioned
 patches + hostapd 0.6.8 and AP mode worked fine (it had some less
 throughput on my tests than IBSS but it worked).

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
 Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b48ff7d..912ffc5 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -516,6 +516,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		    IEEE80211_HW_NOISE_DBM;
 
 	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
-- 
1.6.0.6


