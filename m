Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2541 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab3DKPKT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 11:10:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 12/15] brcmfmac: obtain iftype for firmware-signal
 descriptor lookup
Date: Thu, 11 Apr 2013 17:08:37 +0200
Message-ID: <1365692918-2980-1-git-send-email-arend@broadcom.com> (sfid-20130411_171043_440174_D78331C6)
In-Reply-To: <1365679740-25679-13-git-send-email-arend@broadcom.com>
References: <1365679740-25679-13-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_fws_find_mac_desc() determines the descriptor
associated with a sk_buff for firmware-signalling. It needs the
interface type to do that. For this a helper function is added in
wl_cfg80211.c.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John

I did it again. It did not compile after resolving a merge conflict
preparing the patch series. This patch fixes that.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c    |   12 +++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    7 +++++++
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h |    1 +
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index b3c608e..19d6952 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -31,8 +31,11 @@
 #include "dhd_dbg.h"
 #include "dhd_bus.h"
 #include "fwil.h"
+#include "fwil_types.h"
 #include "fweh.h"
 #include "fwsignal.h"
+#include "p2p.h"
+#include "wl_cfg80211.h"
 
 /**
  * DOC: Firmware Signalling
@@ -683,7 +686,7 @@ brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, int ifidx, u8 *da)
 	struct brcmf_fws_mac_descriptor *entry = &fws->desc.other;
 	struct brcmf_if *ifp;
 	bool multicast;
-
+	enum nl80211_iftype iftype;
 	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
 
 	multicast = is_multicast_ether_addr(da);
@@ -691,15 +694,18 @@ brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, int ifidx, u8 *da)
 	if (WARN_ON(!ifp))
 		goto done;
 
+	iftype = brcmf_cfg80211_get_iftype(ifp);
+
 	/* Multicast destination and P2P clients get the interface entry.
 	 * STA gets the interface entry if there is no exact match. For
 	 * example, TDLS destinations have their own entry.
 	 */
 	entry = NULL;
-	if (multicast && ifp->fws_desc)
+	if ((multicast || iftype == NL80211_IFTYPE_STATION ||
+	     iftype == NL80211_IFTYPE_P2P_CLIENT) && ifp->fws_desc)
 		entry = ifp->fws_desc;
 
-	if (entry != NULL && multicast)
+	if (entry != NULL && iftype != NL80211_IFTYPE_STATION)
 		goto done;
 
 	entry = brcmf_fws_mac_descriptor_lookup(fws, da);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6c06d0d..3b3eb94 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5237,6 +5237,13 @@ s32 brcmf_cfg80211_down(struct net_device *ndev)
 	return err;
 }
 
+enum nl80211_iftype brcmf_cfg80211_get_iftype(struct brcmf_if *ifp)
+{
+	struct wireless_dev *wdev = &ifp->vif->wdev;
+
+	return wdev->iftype;
+}
+
 u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state)
 {
 	struct brcmf_cfg80211_vif *vif;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 3e474c2..0b9263e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -478,6 +478,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
 s32 brcmf_cfg80211_up(struct net_device *ndev);
 s32 brcmf_cfg80211_down(struct net_device *ndev);
+enum nl80211_iftype brcmf_cfg80211_get_iftype(struct brcmf_if *ifp);
 
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 					   enum nl80211_iftype type,
-- 
1.7.10.4


