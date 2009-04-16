Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:47784 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbZDPAf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 20:35:57 -0400
Date: Thu, 16 Apr 2009 03:36:04 +0300
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Cc: jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org, j@w1.fi
Subject: [PATCH 5/7] ath5k: Enable AP mode
Message-ID: <20090416003604.GE4138@makis> (sfid-20090416_023601_553000_89C69A30)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 After some debuging we were hitting the following bugs so far...

 * Due to huge channel list hostapd couldn't get infos from the driver and couldn't set
 the channel. If we manualy set the channel after hostapd starts (by setting channel to 0 -auto),
 beacons are sent but they wont show up on scan because they are malformed (they have channel = 0
 because hostapd doesn't update the channel info -this is probably a hostapd bug so i'm CCing Jouni)
 and they get dropped. Bob fixed this by only allowing standard channels to be registered
 so now hostapd works as expected.

 * Docs (and HAL source) say that we must write 0 on timer0 when operating on AP mode to start
 TSF increment but this seems to mess with DBA in many cases and beacon queue never gets started.
 We fixed that on the previous patch.

 We have some more things to deal with...

 * For some reason (hw bug or something else) after restarting hostapd a few times, beacon inteval
 seems to change from 100ms to a sec (we get one beacon per sec).

 * We need to set sleep timers on STA mode and enable power saving + support PCF.

 ...but i think it's time we enable AP support "officialy" so that we can get more feedback from
 users. I ran ath5k with the mentioned patches + hostapd 0.6.8 and AP mode worked fine (it had some
 less throughput on my tests than IBSS but it worked).

 Author: Jiri Slaby (Jiri added AP support on ath5k, i'm just setting the flag here)
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6594572..9f080a9 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -520,6 +520,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		    IEEE80211_HW_NOISE_DBM;
 
 	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
