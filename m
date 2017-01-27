Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:37853 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932700AbdA0M14 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:27:56 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 2/5] brcmfmac: provide a value for struct wowlan_support::max_nd_match_sets
Date: Fri, 27 Jan 2017 12:27:45 +0000
Message-Id: <1485520068-5807-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170127_133124_245986_F8210CA0)
In-Reply-To: <1485520068-5807-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1485520068-5807-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver advertises support for WOWLAN_NETDETECT but did not specify
maximum amount of netdetect match sets. This was no issue due to a bug
in nl80211. As that has been fixed, brcmfmac also needs fixing.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ec1171c..302a78d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6358,6 +6358,8 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy, struct brcmf_if *ifp)
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO)) {
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL_ND)) {
 			brcmf_wowlan_support.flags |= WIPHY_WOWLAN_NET_DETECT;
+			brcmf_wowlan_support.max_nd_match_sets =
+				BRCMF_PNO_MAX_PFN_COUNT;
 			init_waitqueue_head(&cfg->wowl.nd_data_wait);
 		}
 	}
-- 
1.9.1
