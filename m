Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4241 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/12] brcmfmac: remove unnecessary macro usage in
 brcmf_cfg80211_resume()
Date: Mon, 22 Oct 2012 13:55:40 -0700
Message-ID: <1350939341-17687-12-git-send-email-frankyl@broadcom.com> (sfid-20121022_225706_444713_2D278F8C)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The macro wiphy_to_cfg() is a bit redundant as the function already
has a pointer variable to brcmf_cfg80211_info structure.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 82c7c77..62b155e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2997,7 +2997,7 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 	WL_TRACE("Enter\n");
 
 	if (check_vif_up(ifp->vif))
-		brcmf_invoke_iscan(wiphy_to_cfg(wiphy));
+		brcmf_invoke_iscan(cfg);
 
 	WL_TRACE("Exit\n");
 	return 0;
-- 
1.7.9.5


