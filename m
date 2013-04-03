Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4490 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760594Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/25] brcmfmac: perform filtered firmware-signalling
 cleanup upon DEL_IF
Date: Wed, 3 Apr 2013 12:40:36 +0200
Message-ID: <1364985650-11719-12-git-send-email-arend@broadcom.com> (sfid-20130403_124138_098534_BDDC9479)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an interface is deleted make sure to cleanup all packet
buffers related to that interface.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index eba5106..b123a80 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -354,21 +354,31 @@ static void brcmf_fws_mac_desc_cleanup(struct brcmf_fws_mac_descriptor *entry,
 	}
 }
 
+static bool brcmf_fws_ifidx_match(struct sk_buff *skb, void *arg)
+{
+	u32 ifidx = brcmf_skb_if_flags_get_field(skb, INDEX);
+	return ifidx == *(int *)arg;
+}
+
 static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 {
 	int i;
 	struct brcmf_fws_mac_descriptor *table;
+	bool (*matchfn)(struct sk_buff *, void *) = NULL;
 
 	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
 	if (fws == NULL)
 		return;
 
+	if (ifidx != -1)
+		matchfn = brcmf_fws_ifidx_match;
+
 	/* cleanup individual nodes */
 	table = &fws->nodes[0];
 	for (i = 0; i < ARRAY_SIZE(fws->nodes); i++)
-		brcmf_fws_mac_desc_cleanup(&table[i], NULL, ifidx);
+		brcmf_fws_mac_desc_cleanup(&table[i], matchfn, ifidx);
 
-	brcmf_fws_mac_desc_cleanup(&fws->other, NULL, ifidx);
+	brcmf_fws_mac_desc_cleanup(&fws->other, matchfn, ifidx);
 }
 
 static int brcmf_fws_rssi_indicate(struct brcmf_fws_info *fws, s8 rssi)
@@ -678,5 +688,6 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 
 	ifp->fws_desc = NULL;
 	brcmf_fws_clear_mac_descriptor(entry);
+	brcmf_fws_cleanup(ifp->drvr->fws, ifp->ifidx);
 	kfree(entry);
 }
-- 
1.7.10.4


