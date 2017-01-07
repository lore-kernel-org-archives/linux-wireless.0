Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34476 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933323AbdAGUgZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 15:36:25 -0500
Received: by mail-lf0-f67.google.com with SMTP id q89so2540569lfi.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2017 12:36:25 -0800 (PST)
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
Subject: [PATCH 1/2] brcmfmac: don't preset all channels as disabled
Date: Sat,  7 Jan 2017 21:36:04 +0100
Message-Id: <20170107203605.24866-1-zajec5@gmail.com> (sfid-20170107_213633_798794_69EE0D2A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

During init we take care of regulatory stuff by disabling all
unavailable channels (see brcmf_construct_chaninfo) so this predisabling
them is not really required (and this patch won't change any behavior).
It will on the other hand allow more detailed runtime control over
channels which is the main reason for this change.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 895404c..45ee5b6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -138,7 +138,6 @@ static struct ieee80211_rate __wl_rates[] = {
 	.band			= NL80211_BAND_2GHZ,		\
 	.center_freq		= (_freq),			\
 	.hw_value		= (_channel),			\
-	.flags			= IEEE80211_CHAN_DISABLED,	\
 	.max_antenna_gain	= 0,				\
 	.max_power		= 30,				\
 }
@@ -147,7 +146,6 @@ static struct ieee80211_rate __wl_rates[] = {
 	.band			= NL80211_BAND_5GHZ,		\
 	.center_freq		= 5000 + (5 * (_channel)),	\
 	.hw_value		= (_channel),			\
-	.flags			= IEEE80211_CHAN_DISABLED,	\
 	.max_antenna_gain	= 0,				\
 	.max_power		= 30,				\
 }
-- 
2.10.1
