Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4124 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab3E0TKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:10:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 2/7] brcmfmac: Fix p2p setup when connected to
 ap on 5G.
Date: Mon, 27 May 2013 21:09:54 +0200
Message-ID: <1369681799-3163-3-git-send-email-arend@broadcom.com> (sfid-20130527_211027_896771_E9F8EA7D)
In-Reply-To: <1369681799-3163-1-git-send-email-arend@broadcom.com>
References: <1369681799-3163-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The firmware requires that on p2p setup when net interfaces
are created or updated that they start initially with the same
channel as the channel in use for the current connection
(if any). If none exists take default channel 11.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |   28 ++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index e7a1a47..17275ce 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -47,6 +47,7 @@
 #define IS_P2P_SOCIAL_CHANNEL(channel) ((channel == SOCIAL_CHAN_1) || \
 					 (channel == SOCIAL_CHAN_2) || \
 					 (channel == SOCIAL_CHAN_3))
+#define BRCMF_P2P_TEMP_CHAN	SOCIAL_CHAN_3
 #define SOCIAL_CHAN_CNT		3
 #define AF_PEER_SEARCH_CNT	2
 
@@ -2013,17 +2014,30 @@ static void brcmf_p2p_get_current_chanspec(struct brcmf_p2p_info *p2p,
 					   u16 *chanspec)
 {
 	struct brcmf_if *ifp;
-	struct brcmf_fil_chan_info_le ci;
+	u8 mac_addr[ETH_ALEN];
 	struct brcmu_chan ch;
-	s32 err;
+	struct brcmf_bss_info_le *bi;
+	u8 *buf;
 
 	ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
 
-	ch.chnum = 11;
-
-	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_CHANNEL, &ci, sizeof(ci));
-	if (!err)
-		ch.chnum = le32_to_cpu(ci.hw_channel);
+	if (brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSSID, mac_addr,
+				   ETH_ALEN) == 0) {
+		buf = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
+		if (buf != NULL) {
+			*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
+			if (brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO,
+						   buf, WL_BSS_INFO_MAX) == 0) {
+				bi = (struct brcmf_bss_info_le *)(buf + 4);
+				*chanspec = le16_to_cpu(bi->chanspec);
+				kfree(buf);
+				return;
+			}
+			kfree(buf);
+		}
+	}
+	/* Use default channel for P2P */
+	ch.chnum = BRCMF_P2P_TEMP_CHAN;
 	ch.bw = BRCMU_CHAN_BW_20;
 	p2p->cfg->d11inf.encchspec(&ch);
 	*chanspec = ch.chspec;
-- 
1.7.10.4


