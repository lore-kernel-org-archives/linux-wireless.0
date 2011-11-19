Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:58651 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1KSLEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 06:04:24 -0500
Subject: [PATCH 4/5] rndis_wlan: add reporting of PMKSA candidate events
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 19 Nov 2011 13:04:21 +0200
Message-ID: <20111119110421.11950.8383.stgit@localhost6.localdomain6> (sfid-20111119_120433_002166_8384A5ED)
In-Reply-To: <20111119110405.11950.91713.stgit@localhost6.localdomain6>
References: <20111119110405.11950.91713.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert old WEXT reporting to use new cfg80211_pmksa_candidate_notify().

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 08c85af..56514d9 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -244,6 +244,10 @@ enum ndis_80211_power_mode {
 	NDIS_80211_POWER_MODE_FAST_PSP,
 };
 
+enum ndis_80211_pmkid_cand_list_flag_bits {
+	NDIS_80211_PMKID_CAND_PREAUTH = cpu_to_le32(1 << 0)
+};
+
 struct ndis_80211_auth_request {
 	__le32 length;
 	u8 bssid[6];
@@ -3022,25 +3026,13 @@ static void rndis_wlan_pmkid_cand_list_indication(struct usbnet *usbdev,
 	for (i = 0; i < le32_to_cpu(cand_list->num_candidates); i++) {
 		struct ndis_80211_pmkid_candidate *cand =
 						&cand_list->candidate_list[i];
+		bool preauth = !!(cand->flags & NDIS_80211_PMKID_CAND_PREAUTH);
 
-		netdev_dbg(usbdev->net, "cand[%i]: flags: 0x%08x, bssid: %pM\n",
-			   i, le32_to_cpu(cand->flags), cand->bssid);
-
-#if 0
-		struct iw_pmkid_cand pcand;
-		union iwreq_data wrqu;
+		netdev_dbg(usbdev->net, "cand[%i]: flags: 0x%08x, preauth: %d, bssid: %pM\n",
+			   i, le32_to_cpu(cand->flags), preauth, cand->bssid);
 
-		memset(&pcand, 0, sizeof(pcand));
-		if (le32_to_cpu(cand->flags) & 0x01)
-			pcand.flags |= IW_PMKID_CAND_PREAUTH;
-		pcand.index = i;
-		memcpy(pcand.bssid.sa_data, cand->bssid, ETH_ALEN);
-
-		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.length = sizeof(pcand);
-		wireless_send_event(usbdev->net, IWEVPMKIDCAND, &wrqu,
-								(u8 *)&pcand);
-#endif
+		cfg80211_pmksa_candidate_notify(usbdev->net, i, cand->bssid,
+						preauth, GFP_ATOMIC);
 	}
 }
 

