Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:43976 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdFJKmU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 06:42:20 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id 1F75447B24A
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jun 2017 11:22:54 +0200 (CEST)
Date: Sat, 10 Jun 2017 11:22:47 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH] brcmfmac: iso cfg80211: Fix grammar issue in error message
Message-ID: <20170610092247.2gz6sydytp5pomq6@jirafa.cyrius.com> (sfid-20170610_124236_434526_A09704A7)
References: <20170608080141.rswb2czupjeblqzq@jirafa.cyrius.com>
 <3bf898aa-c890-32ec-aa83-c7a1e7f56729@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3bf898aa-c890-32ec-aa83-c7a1e7f56729@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix grammar issue in error message about ISO3166.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

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
