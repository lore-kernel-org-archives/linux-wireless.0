Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:40657 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbdFHIGw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 04:06:52 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id 912DC49603F
        for <linux-wireless@vger.kernel.org>; Thu,  8 Jun 2017 10:01:52 +0200 (CEST)
Date: Thu, 8 Jun 2017 10:01:41 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH] cfg80211: Fix grammar issue in error message
Message-ID: <20170608080141.rswb2czupjeblqzq@jirafa.cyrius.com> (sfid-20170608_100655_695544_7F406A35)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix grammar issue in error message about ISO3166.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index cd1d6730eab7..c1ad81f34658 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6767,7 +6767,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 	/* ignore non-ISO3166 country codes */
 	for (i = 0; i < sizeof(req->alpha2); i++)
 		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
-			brcmf_err("not a ISO3166 code (0x%02x 0x%02x)\n",
+			brcmf_err("not an ISO3166 code (0x%02x 0x%02x)\n",
 				  req->alpha2[0], req->alpha2[1]);
 			return;
 		}

-- 
Martin Michlmayr
http://www.cyrius.com/
