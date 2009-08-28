Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:53345 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZH1K22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:28:28 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 09/10] rndis_wlan: disable IWEVPMKIDCAND wireless event
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:28:30 +0300
Message-ID: <20090828102830.15684.65092.stgit@fate.lan>
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 01cd341..512000b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2821,14 +2821,16 @@ static void rndis_wlan_pmkid_cand_list_indication(struct usbnet *usbdev,
 		return;
 
 	for (i = 0; i < le32_to_cpu(cand_list->num_candidates); i++) {
-		struct iw_pmkid_cand pcand;
-		union iwreq_data wrqu;
 		struct ndis_80211_pmkid_candidate *cand =
 						&cand_list->candidate_list[i];
 
 		devdbg(usbdev, "cand[%i]: flags: 0x%08x, bssid: %pM",
 				i, le32_to_cpu(cand->flags), cand->bssid);
 
+#if 0
+		struct iw_pmkid_cand pcand;
+		union iwreq_data wrqu;
+
 		memset(&pcand, 0, sizeof(pcand));
 		if (le32_to_cpu(cand->flags) & 0x01)
 			pcand.flags |= IW_PMKID_CAND_PREAUTH;
@@ -2839,6 +2841,7 @@ static void rndis_wlan_pmkid_cand_list_indication(struct usbnet *usbdev,
 		wrqu.data.length = sizeof(pcand);
 		wireless_send_event(usbdev->net, IWEVPMKIDCAND, &wrqu,
 								(u8 *)&pcand);
+#endif
 	}
 }
 

