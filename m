Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4988 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759149Ab3E2QjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:39:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 11/16] brcmfmac: Find correct MAC descriptor in
 case of TDLS.
Date: Wed, 29 May 2013 18:39:01 +0200
Message-ID: <1369845546-31950-12-git-send-email-arend@broadcom.com> (sfid-20130529_183935_671093_96586B94)
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

In case of TDLS find the correct MAC descriptor for fw signalling
data. In case of TDLS each destination gets its own entry. This
was not handled correctly for P2P client.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index a7db11b..1b0538d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -681,26 +681,21 @@ brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, struct brcmf_if *ifp,
 {
 	struct brcmf_fws_mac_descriptor *entry = &fws->desc.other;
 	bool multicast;
-	enum nl80211_iftype iftype;
 
 	multicast = is_multicast_ether_addr(da);
-	iftype = brcmf_cfg80211_get_iftype(ifp);
 
-	/* Multicast destination and P2P clients get the interface entry.
-	 * STA gets the interface entry if there is no exact match. For
-	 * example, TDLS destinations have their own entry.
+	/* Multicast destination, STA and P2P clients get the interface entry.
+	 * STA/GC gets the Mac Entry for TDLS destinations, TDLS destinations
+	 * have their own entry.
 	 */
-	entry = NULL;
-	if ((multicast || iftype == NL80211_IFTYPE_STATION ||
-	     iftype == NL80211_IFTYPE_P2P_CLIENT) && ifp->fws_desc)
+	if (multicast && ifp->fws_desc) {
 		entry = ifp->fws_desc;
-
-	if (entry != NULL && iftype != NL80211_IFTYPE_STATION)
 		goto done;
+	}
 
 	entry = brcmf_fws_mac_descriptor_lookup(fws, da);
 	if (IS_ERR(entry))
-		entry = &fws->desc.other;
+		entry = ifp->fws_desc;
 
 done:
 	return entry;
-- 
1.7.10.4


