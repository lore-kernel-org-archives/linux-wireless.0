Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4474 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760557Ab3DCKlV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/25] brcmfmac: add firmware-signalling cleanup
 function
Date: Wed, 3 Apr 2013 12:40:33 +0200
Message-ID: <1364985650-11719-9-git-send-email-arend@broadcom.com> (sfid-20130403_124308_100513_B6B3B3A0)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a cleanup function releasing any queued packet buffers in
the mac descriptor entries.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   51 ++++++++++++++++++--
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 542a971..69f460b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -197,6 +197,7 @@ struct brcmf_fws_info {
 	struct brcmf_pub *drvr;
 	struct brcmf_fws_stats stats;
 	struct brcmf_fws_mac_descriptor nodes[BRCMF_FWS_MAC_DESC_TABLE_SIZE];
+	struct brcmf_fws_mac_descriptor other;
 	int fifo_credit[NL80211_NUM_ACS+1+1];
 };
 
@@ -264,6 +265,38 @@ brcmf_fws_mac_descriptor_lookup(struct brcmf_fws_info *fws, u8 *ea)
 	return ERR_PTR(-ENOENT);
 }
 
+static void brcmf_fws_mac_desc_cleanup(struct brcmf_fws_mac_descriptor *entry,
+				       bool (*fn)(struct sk_buff *, void *),
+				       int ifidx)
+{
+	brcmf_dbg(TRACE, "enter: entry=(ea=%pM,ifid=%d), ifidx=%d\n",
+		  entry->ea, entry->interface_id, ifidx);
+	if (entry->occupied && (fn == NULL || (ifidx == entry->interface_id))) {
+		brcmf_dbg(TRACE, "flush delayQ: ifidx=%d, qlen=%d\n",
+			  ifidx, entry->psq.len);
+		/* release packets held in DELAYQ */
+		brcmu_pktq_flush(&entry->psq, true, fn, &ifidx);
+		entry->occupied = !!(entry->psq.len);
+	}
+}
+
+static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
+{
+	int i;
+	struct brcmf_fws_mac_descriptor *table;
+
+	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
+	if (fws == NULL)
+		return;
+
+	/* cleanup individual nodes */
+	table = &fws->nodes[0];
+	for (i = 0; i < ARRAY_SIZE(fws->nodes); i++)
+		brcmf_fws_mac_desc_cleanup(&table[i], NULL, ifidx);
+
+	brcmf_fws_mac_desc_cleanup(&fws->other, NULL, ifidx);
+}
+
 static int brcmf_fws_rssi_indicate(struct brcmf_fws_info *fws, s8 rssi)
 {
 	brcmf_dbg(CTL, "rssi %d\n", rssi);
@@ -394,12 +427,12 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		goto fail;
 	}
 
-	/* set linkage back */
-	drvr->fws->drvr = drvr;
-
 	/* create debugfs file for statistics */
 	brcmf_debugfs_create_fws_stats(drvr, &drvr->fws->stats);
 
+	/* set linkage back */
+	drvr->fws->drvr = drvr;
+
 	/* TODO: remove upon feature delivery */
 	brcmf_err("%s bdcv2 tlv signaling [%x]\n",
 		  drvr->fw_signals ? "enabled" : "disabled", tlv);
@@ -414,9 +447,17 @@ fail:
 
 void brcmf_fws_deinit(struct brcmf_pub *drvr)
 {
-	/* free top structure */
-	kfree(drvr->fws);
+	struct brcmf_fws_info *fws = drvr->fws;
+	ulong flags;
+
+	/* cleanup */
+	brcmf_fws_lock(drvr, flags);
+	brcmf_fws_cleanup(fws, -1);
 	drvr->fws = NULL;
+	brcmf_fws_unlock(drvr, flags);
+
+	/* free top structure */
+	kfree(fws);
 }
 
 int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
-- 
1.7.10.4


