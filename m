Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34825 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941883AbdAGUg1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 15:36:27 -0500
Received: by mail-lf0-f67.google.com with SMTP id v186so2475951lfa.2
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2017 12:36:27 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/2] brcmfmac: setup wiphy bands after registering it first
Date: Sat,  7 Jan 2017 21:36:05 +0100
Message-Id: <20170107203605.24866-2-zajec5@gmail.com> (sfid-20170107_213635_310503_E733B236)
In-Reply-To: <20170107203605.24866-1-zajec5@gmail.com>
References: <20170107203605.24866-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

During bands setup we disable all channels that firmware doesn't support
in the current regulatory setup. If we do this before wiphy_register
it will result in copying set flags (including IEEE80211_CHAN_DISABLED)
to the orig_flags which is supposed to be persistent. We don't want this
as regulatory change may result in enabling some channels. We shouldn't
mess with orig_flags then (by changing them or ignoring them) so it's
better to just take care of their proper values.

This patch cleanups code a bit (by taking orig_flags more seriously) and
allows further improvements like disabling really unavailable channels.
We will need that e.g. if some frequencies should be disabled for good
due to hardware setup (design).

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 45ee5b6..729bf33 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6477,8 +6477,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 			wiphy->bands[NL80211_BAND_5GHZ] = band;
 		}
 	}
-	err = brcmf_setup_wiphybands(wiphy);
-	return err;
+	return 0;
 }
 
 static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
@@ -6843,6 +6842,12 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		goto priv_out;
 	}
 
+	err = brcmf_setup_wiphybands(wiphy);
+	if (err) {
+		brcmf_err("Setting wiphy bands failed (%d)\n", err);
+		goto wiphy_unreg_out;
+	}
+
 	/* If cfg80211 didn't disable 40MHz HT CAP in wiphy_register(),
 	 * setup 40MHz in 2GHz band and enable OBSS scanning.
 	 */
-- 
2.10.1
