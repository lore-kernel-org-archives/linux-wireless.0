Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4302 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966698Ab3DQT0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:15 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/10] brcmfmac: use lock in brcmf_fws_del_interface()
Date: Wed, 17 Apr 2013 21:25:55 +0200
Message-ID: <1366226758-20641-8-git-send-email-arend@broadcom.com> (sfid-20130417_212621_201475_6957B761)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When deleting an interface in firmware-signalling module it will
clear any destination descriptors. To avoid concurrency issues it
should take the lock using brcmf_fws_lock().

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 648f9bd..1cfec56 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1821,14 +1821,17 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 void brcmf_fws_del_interface(struct brcmf_if *ifp)
 {
 	struct brcmf_fws_mac_descriptor *entry = ifp->fws_desc;
+	ulong flags;
 
 	brcmf_dbg(TRACE, "enter: idx=%d\n", ifp->bssidx);
 	if (!entry)
 		return;
 
+	brcmf_fws_lock(ifp->drvr, flags);
 	ifp->fws_desc = NULL;
 	brcmf_fws_clear_mac_descriptor(entry);
 	brcmf_fws_cleanup(ifp->drvr->fws, ifp->ifidx);
+	brcmf_fws_unlock(ifp->drvr, flags);
 }
 
 static void brcmf_fws_dequeue_worker(struct work_struct *worker)
-- 
1.7.10.4


