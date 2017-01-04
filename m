Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36436 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdADR7g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 12:59:36 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V6 4/3] brcmfmac: use wiphy_read_of_freq_limits to respect extra limits
Date: Wed,  4 Jan 2017 18:58:32 +0100
Message-Id: <20170104175832.25996-4-zajec5@gmail.com> (sfid-20170104_190243_666514_5D8FEF05)
In-Reply-To: <20170104175832.25996-1-zajec5@gmail.com>
References: <20170104175832.25996-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

There are some devices (e.g. Netgear R8000 home router) with one chipset
model used for different radios, some of them limited to subbands. NVRAM
entries don't contain any extra info on such limitations and firmware
reports full list of channels to us. We need to store extra limitation
info in DT to support such devices properly.

Now there is a cfg80211 helper for reading such info use it in brcmfmac.
This patch adds check for channel being disabled with orig_flags which
is how this wiphy helper and wiphy_register work.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
This patch should probably go through wireless-driver-next which is why
it got weird number 4/3. I'm sending it just as a proof of concept.
It was succesfully tested on SmartRG SR400ac with BCM43602.

V4: Respect IEEE80211_CHAN_DISABLED in orig_flags
V5: Update commit message
V6: Call wiphy_read_of_freq_limits after brcmf_setup_wiphybands to make it work
    with helper setting "flags" instead of "orig_flags".
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ccae3bb..a008ba5 100644
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
@@ -6478,7 +6481,11 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 		}
 	}
 	err = brcmf_setup_wiphybands(wiphy);
-	return err;
+	if (err)
+		return err;
+	wiphy_read_of_freq_limits(wiphy);
+
+	return 0;
 }
 
 static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
-- 
2.10.1
