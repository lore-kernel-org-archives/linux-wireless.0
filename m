Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751474AbdB0WjN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 17:39:13 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2 3/4] brcmfmac: Do not complain about country code "00"
Date: Mon, 27 Feb 2017 22:45:38 +0100
Message-Id: <20170227214539.16422-3-hdegoede@redhat.com> (sfid-20170227_233917_586211_670E65C2)
In-Reply-To: <20170227214539.16422-1-hdegoede@redhat.com>
References: <20170227214539.16422-1-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The country code gets set to "00" by default at boot, ignore this
rather then logging an error about it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index c54e8b4..c0b7f69 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6705,6 +6705,10 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
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
