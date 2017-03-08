Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753634AbdCHOBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 09:01:03 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v3 2/3] brcmfmac: Do not complain about country code "00"
Date: Wed,  8 Mar 2017 14:50:16 +0100
Message-Id: <20170308135017.29867-2-hdegoede@redhat.com> (sfid-20170308_150136_077354_960C2CDE)
In-Reply-To: <20170308135017.29867-1-hdegoede@redhat.com>
References: <20170308135017.29867-1-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The country code gets set to "00" by default at boot, ignore this
rather then logging an error about it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Changes in v3:
-Add Arend's Acked-by
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 944b83c..7765ad0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6736,6 +6736,10 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 	s32 err;
 	int i;
 
+	/* The country code gets set to "00" by default at boot, ignore */
+	if (req->alpha2[0] == '0' && req->alpha2[1] == '0')
+		return;
+
 	/* ignore non-ISO3166 country codes */
 	for (i = 0; i < sizeof(req->alpha2); i++)
 		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
-- 
2.9.3
