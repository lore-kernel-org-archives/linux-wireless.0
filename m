Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33846 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbdAQWnr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 17:43:47 -0500
Received: by mail-lf0-f68.google.com with SMTP id q89so18009391lfi.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2017 14:43:47 -0800 (PST)
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
Subject: [PATCH] brcmfmac: use wiphy_read_of_freq_limits to respect limits from DT
Date: Tue, 17 Jan 2017 23:35:50 +0100
Message-Id: <20170117223550.12114-1-zajec5@gmail.com> (sfid-20170117_234351_119212_4758F3CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This new helper reads extra frequency limits specified in DT and
disables unavailable chanels. This is useful for devices (like home
routers) with chipsets limited e.g. by board design.

In order to respect info read from DT we simply need to check for
IEEE80211_CHAN_DISABLED bit when constructing channel info.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
This patch requires e691ac2f75b6 ("cfg80211: support ieee80211-freq-limit DT
property") that is currently in net-next.

Kalle: feel free to postpone this until merging net-next one day.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ec1171c..b96fc88 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5886,6 +5886,9 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 			continue;
 		}
 
+		if (channel->orig_flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
 		/* assuming the chanspecs order is HT20,
 		 * HT40 upper, HT40 lower, and VHT80.
 		 */
@@ -6477,6 +6480,9 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 			wiphy->bands[NL80211_BAND_5GHZ] = band;
 		}
 	}
+
+	wiphy_read_of_freq_limits(wiphy);
+
 	return 0;
 }
 
-- 
2.10.1
