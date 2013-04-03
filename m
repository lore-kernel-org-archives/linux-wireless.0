Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4454 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760471Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/25] brcmfmac: fix handling sk_buff cleanup upon bus
 tx failure
Date: Wed, 3 Apr 2013 12:40:41 +0200
Message-ID: <1364985650-11719-17-git-send-email-arend@broadcom.com> (sfid-20130403_124304_745861_3728A34E)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When firmware-signalling is active the brcmf_txcomplete() does
a free of the sk_buff when transfer to firmware fails in the
bus-specific driver code. However, it should also cleanup the
packet from the hanger. This patch fixes that.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   12 ++++---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   34 ++++++++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |    1 +
 3 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 0299ab6..d37620e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -388,11 +388,13 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 
-	/* await txstatus signal for firmware is active */
-	if (success && brcmf_fws_fc_active(drvr->fws))
-		return;
-
-	brcmf_txfinalize(drvr, txp, success);
+	/* await txstatus signal for firmware if active */
+	if (brcmf_fws_fc_active(drvr->fws)) {
+		if (!success)
+			brcmf_fws_bustxfail(drvr->fws, txp);
+	} else {
+		brcmf_txfinalize(drvr, txp, success);
+	}
 }
 
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 9389bf7..eb63419 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -810,20 +810,12 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 }
 
 static int
-brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
+brcmf_fws_txstatus_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot)
 {
-	u8 flags;
-	u32 status;
-	u32 hslot;
 	int ret;
 	struct sk_buff *skb;
 	struct brcmf_fws_mac_descriptor *entry = NULL;
 
-	status = le32_to_cpu(*(__le32 *)data);
-	flags = brcmf_txstatus_get_field(status, FLAGS);
-	hslot = brcmf_txstatus_get_field(status, HSLOT);
-	fws->stats.txs_indicate++;
-
 	brcmf_dbg(TRACE, "status: flags=0x%X, hslot=%d\n",
 		  flags, hslot);
 
@@ -854,6 +846,20 @@ done:
 	return ret;
 }
 
+static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
+{
+	u32 status;
+	u32 hslot;
+	u8 flags;
+
+	fws->stats.txs_indicate++;
+	status = le32_to_cpu(*(__le32 *)data);
+	flags = brcmf_txstatus_get_field(status, FLAGS);
+	hslot = brcmf_txstatus_get_field(status, HSLOT);
+
+	return brcmf_fws_txstatus_process(fws, flags, hslot);
+}
+
 static int brcmf_fws_dbg_seqnum_check(struct brcmf_fws_info *fws, u8 *data)
 {
 	__le32 timestamp;
@@ -1289,3 +1295,13 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 	brcmf_dbg(TRACE, "enter: mode=%d\n", fws->fcmode);
 	return fws->fcmode != BRCMF_FWS_FCMODE_NONE;
 }
+
+void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
+{
+	ulong flags;
+
+	brcmf_fws_lock(fws->drvr, flags);
+	brcmf_fws_txstatus_process(fws, BRCMF_FWS_TXSTATUS_FW_TOSSED,
+				   brcmf_skb_htod_tag_get_field(skb, HSLOT));
+	brcmf_fws_unlock(fws->drvr, flags);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
index 7778e02..fbe483d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
@@ -28,5 +28,6 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_fws_reset_interface(struct brcmf_if *ifp);
 void brcmf_fws_add_interface(struct brcmf_if *ifp);
 void brcmf_fws_del_interface(struct brcmf_if *ifp);
+void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb);
 
 #endif /* FWSIGNAL_H_ */
-- 
1.7.10.4


