Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33603 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933378AbdABQca (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 11:32:30 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V3 3/2] brcmfmac: use wiphy_read_of_freq_limits to get extra limits
Date: Mon,  2 Jan 2017 17:32:09 +0100
Message-Id: <20170102163209.2445-3-zajec5@gmail.com> (sfid-20170102_173243_900024_62837930)
In-Reply-To: <20170102163209.2445-1-zajec5@gmail.com>
References: <20170102163209.2445-1-zajec5@gmail.com>
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

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
This patch should probably go through wireless-driver-next, I'm sending
it just as a proof of concept. It was succesfully tested on SmartRG
SR400ac with BCM43602.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ccae3bb..dab4082 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6825,6 +6825,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		goto priv_out;
 
 	brcmf_dbg(INFO, "Registering custom regulatory\n");
+	wiphy_read_of_freq_limits(wiphy);
 	wiphy->reg_notifier = brcmf_cfg80211_reg_notifier;
 	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
-- 
2.10.1
