Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:33377 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeCNTEH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 15:04:07 -0400
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH] wireless: brcmfmac: cfg80211: Fix check for ISO3166 code
Date: Wed, 14 Mar 2018 20:02:59 +0100
Message-Id: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com> (sfid-20180314_200410_945840_4EB6427A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "regulatory: add NUL to request alpha2" increases the length of
alpha2 to 3. This causes a regression on brcmfmac, because
brcmf_cfg80211_reg_notifier() expect valid ISO3166 codes in the complete
array. So fix this accordingly.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 74a8302..5ed718d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6805,7 +6805,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 		return;
 
 	/* ignore non-ISO3166 country codes */
-	for (i = 0; i < sizeof(req->alpha2); i++)
+	for (i = 0; i < 2; i++)
 		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
 			brcmf_err("not an ISO3166 code (0x%02x 0x%02x)\n",
 				  req->alpha2[0], req->alpha2[1]);
-- 
2.7.4
