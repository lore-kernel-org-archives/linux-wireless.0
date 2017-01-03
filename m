Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35115 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757925AbdACLD7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 06:03:59 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V4 3/2] brcmfmac: use wiphy_read_of_freq_limits to respect extra limits
Date: Tue,  3 Jan 2017 12:03:40 +0100
Message-Id: <20170103110340.23249-3-zajec5@gmail.com> (sfid-20170103_120405_538517_B63BE491)
In-Reply-To: <20170103110340.23249-1-zajec5@gmail.com>
References: <20170103110340.23249-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

There are some devices (e.g. Netgear R8000 home router) with one chipset
model used for different radios, some of them limited to subbands. NVRAM
entries don't contain any extra info on such limitations and firmware
reports full list of channels to us. We need to store extra limitation
info on DT to support such devices properly.

This patch adds check for channel being disabled with orig_flags which
is how this wiphy helper works.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
This patch should probably go through wireless-driver-next, I'm sending
it just as a proof of concept. It was succesfully tested on SmartRG
SR400ac with BCM43602.

V4: Respect IEEE80211_CHAN_DISABLED in orig_flags
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ccae3bb..f95e316 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5886,6 +5886,9 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 						       band->band);
 		channel[index].hw_value = ch.control_ch_num;
 
+		if (channel->orig_flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
 		/* assuming the chanspecs order is HT20,
 		 * HT40 upper, HT40 lower, and VHT80.
 		 */
@@ -6477,6 +6480,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 			wiphy->bands[NL80211_BAND_5GHZ] = band;
 		}
 	}
+	wiphy_read_of_freq_limits(wiphy);
 	err = brcmf_setup_wiphybands(wiphy);
 	return err;
 }
-- 
2.10.1
