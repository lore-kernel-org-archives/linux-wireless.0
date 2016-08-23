Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:43398 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757368AbcHWJrh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Aug 2016 05:47:37 -0400
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH v2 1/1] brcmfmac: fix pmksa->bssid usage
Date: Tue, 23 Aug 2016 11:37:17 +0200
Message-Id: <20160823093717.1065-1-nicolas.iooss_linux@m4x.org> (sfid-20160823_114739_968900_B2D4E754)
In-Reply-To: <7fc849f7-c178-d13e-e9cf-d107a9f73c61@m4x.org>
References: <7fc849f7-c178-d13e-e9cf-d107a9f73c61@m4x.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The struct cfg80211_pmksa defines its bssid field as:

    const u8 *bssid;

contrary to struct brcmf_pmksa, which uses:

    u8 bssid[ETH_ALEN];

Therefore in brcmf_cfg80211_del_pmksa(), &pmksa->bssid takes the address
of this field (of type u8**), not the one of its content (which would be
u8*).  Remove the & operator to make brcmf_dbg("%pM") and memcmp()
behave as expected.

This bug have been found using a custom static checker (which checks the
usage of %p... attributes at build time).  It has been introduced in
commit 6c404f34f2bd ("brcmfmac: Cleanup pmksa cache handling code"),
which replaced pmksa->bssid by &pmksa->bssid while refactoring the code,
without modifying struct cfg80211_pmksa definition.

Replace &pmk[i].bssid with pmk[i].bssid too to make the code clearer,
this change does not affect the semantic.

Fixes: 6c404f34f2bd ("brcmfmac: Cleanup pmksa cache handling code")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2628d5e12c64..201a98016142 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3884,11 +3884,11 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", &pmksa->bssid);
+	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", pmksa->bssid);
 
 	npmk = le32_to_cpu(cfg->pmk_list.npmk);
 	for (i = 0; i < npmk; i++)
-		if (!memcmp(&pmksa->bssid, &pmk[i].bssid, ETH_ALEN))
+		if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
 			break;
 
 	if ((npmk > 0) && (i < npmk)) {
-- 
2.9.3
