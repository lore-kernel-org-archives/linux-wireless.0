Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:34458 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbbHSWQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 18:16:54 -0400
Received: by laba3 with SMTP id a3so11800845lab.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 15:16:52 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: check all combinations when setting wiphy's addresses
Date: Thu, 20 Aug 2015 00:16:42 +0200
Message-Id: <1440022602-6943-1-git-send-email-zajec5@gmail.com> (sfid-20150820_001658_159971_61C3CE07)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom is working on better reflection of interface combinations. With
upcoming patches we may have 1st combination supporting less interfaces
than others.
To don't run out of addresses check all combinations to find the one
with the greatest max_interfaces value.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
I believe this patch should be applied before:
brcmfmac: correct interface combination info
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index ffe5260..c85e2db 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -5786,7 +5786,9 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy)
 static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	const struct ieee80211_iface_combination *combo;
 	struct ieee80211_supported_band *band;
+	u16 max_interfaces = 0;
 	__le32 bandlist[3];
 	u32 n_bands;
 	int err, i;
@@ -5799,8 +5801,13 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	if (err)
 		return err;
 
-	for (i = 0; i < wiphy->iface_combinations->max_interfaces &&
-	     i < ARRAY_SIZE(drvr->addresses); i++) {
+	for (i = 0, combo = wiphy->iface_combinations;
+	     i < wiphy->n_iface_combinations; i++, combo++) {
+		max_interfaces = max(max_interfaces, combo->max_interfaces);
+	}
+
+	for (i = 0; i < max_interfaces && i < ARRAY_SIZE(drvr->addresses);
+	     i++) {
 		u8 *addr = drvr->addresses[i].addr;
 
 		memcpy(addr, drvr->mac, ETH_ALEN);
-- 
1.8.4.5

