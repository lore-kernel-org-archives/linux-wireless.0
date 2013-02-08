Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1533 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760065Ab3BHO4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/27] brcmfmac: fix compiler warning on printf format
Date: Fri, 8 Feb 2013 15:53:39 +0100
Message-ID: <1360335242-12608-5-git-send-email-arend@broadcom.com> (sfid-20130208_163814_749865_EA1FC7DE)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 64-bit target a warning was given when using %d to print
sizeof() value:

  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.o
brcm80211/brcmfmac/wl_cfg80211.c: In function 'brcmf_alloc_vif':
brcm80211/brcmfmac/wl_cfg80211.c:3884:2: error: format '%d' expects
argument of type 'int', but argument 3 has type 'long unsigned int'
[-Werror=format]

Fixed using %zu instead.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6ab6397..6cd47e2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3997,7 +3997,7 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 	if (cfg->vif_cnt == BRCMF_IFACE_MAX_CNT)
 		return ERR_PTR(-ENOSPC);
 
-	brcmf_dbg(TRACE, "allocating virtual interface (size=%d)\n",
+	brcmf_dbg(TRACE, "allocating virtual interface (size=%zu)\n",
 		  sizeof(*vif));
 	vif = kzalloc(sizeof(*vif), GFP_KERNEL);
 	if (!vif)
-- 
1.7.10.4


