Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4465 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760498Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/25] brcmfmac: add flow-control mode to firmware
 signalling
Date: Wed, 3 Apr 2013 12:40:39 +0200
Message-ID: <1364985650-11719-15-git-send-email-arend@broadcom.com> (sfid-20130403_124132_058538_40655DD7)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upcoming patches will add firmware signalled flow control. Prepare
by adding the mode, which defaults to disable it. The mode can be
queried by brcmf_fws_fc_active() and set by a module parameter.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 ++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   23 +++++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   26 +++++++++++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |    1 +
 4 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index af307c1..ef5e3a9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -623,5 +623,7 @@ extern void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 extern u32 brcmf_get_chip_info(struct brcmf_if *ifp);
+extern void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp,
+			     bool success);
 
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 3ba9e104..05c8840 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -363,21 +363,20 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 	}
 }
 
-void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
+void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp,
+		      bool success)
 {
-	u8 ifidx;
+	struct brcmf_if *ifp;
 	struct ethhdr *eh;
+	u8 ifidx;
 	u16 type;
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pub *drvr = bus_if->drvr;
-	struct brcmf_if *ifp;
 	int res;
 
 	res = brcmf_proto_hdrpull(drvr, false, &ifidx, txp);
 
 	ifp = drvr->iflist[ifidx];
 	if (!ifp)
-		goto done;
+		return;
 
 	if (res == 0) {
 		eh = (struct ethhdr *)(txp->data);
@@ -391,8 +390,18 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 	}
 	if (!success)
 		ifp->stats.tx_errors++;
+}
 
-done:
+void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+
+	/* await txstatus signal for firmware is active */
+	if (success && brcmf_fws_fc_active(drvr->fws))
+		return;
+
+	brcmf_txfinalize(drvr, txp, success);
 	brcmu_pkt_buf_free_skb(txp);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 2afd850..cb1414d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 #include <linux/types.h>
+#include <linux/module.h>
 #include <linux/if_ether.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
@@ -124,10 +125,6 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 #define BRCMF_FWS_STATE_OPEN				1
 #define BRCMF_FWS_STATE_CLOSE				2
 
-#define BRCMF_FWS_FCMODE_NONE				0
-#define BRCMF_FWS_FCMODE_IMPLIED_CREDIT			1
-#define BRCMF_FWS_FCMODE_EXPLICIT_CREDIT		2
-
 #define BRCMF_FWS_MAC_DESC_TABLE_SIZE			32
 #define BRCMF_FWS_MAX_IFNUM				16
 #define BRCMF_FWS_MAC_DESC_ID_INVALID			0xff
@@ -245,6 +242,12 @@ struct brcmf_skbuff_cb {
 			BRCMF_SKB_HTOD_TAG_ ## field ## _MASK, \
 			BRCMF_SKB_HTOD_TAG_ ## field ## _SHIFT)
 
+enum brcmf_fws_fcmode {
+	BRCMF_FWS_FCMODE_NONE,
+	BRCMF_FWS_FCMODE_IMPLIED_CREDIT,
+	BRCMF_FWS_FCMODE_EXPLICIT_CREDIT
+};
+
 /**
  * struct brcmf_fws_mac_descriptor - firmware signalling data per node/interface
  *
@@ -328,9 +331,14 @@ struct brcmf_fws_info {
 	struct brcmf_fws_hanger hanger;
 	struct brcmf_fws_mac_descriptor nodes[BRCMF_FWS_MAC_DESC_TABLE_SIZE];
 	struct brcmf_fws_mac_descriptor other;
+	enum brcmf_fws_fcmode fcmode;
 	int fifo_credit[NL80211_NUM_ACS+1+1];
 };
 
+static int fcmode;
+module_param(fcmode, int, S_IRUSR);
+MODULE_PARM_DESC(fcmode, "mode of firmware signalled flow control");
+
 /**
  * brcmf_fws_get_tlv_len() - returns defined length for given tlv id.
  */
@@ -745,6 +753,7 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 
 	/* set linkage back */
 	drvr->fws->drvr = drvr;
+	drvr->fws->fcmode = fcmode;
 
 	/* TODO: remove upon feature delivery */
 	brcmf_err("%s bdcv2 tlv signaling [%x]\n",
@@ -920,3 +929,12 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 	brcmf_fws_cleanup(ifp->drvr->fws, ifp->ifidx);
 	kfree(entry);
 }
+
+bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
+{
+	if (!fws)
+		return false;
+
+	brcmf_dbg(TRACE, "enter: mode=%d\n", fws->fcmode);
+	return fws->fcmode != BRCMF_FWS_FCMODE_NONE;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
index 38a75e4..1566f4d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
@@ -20,6 +20,7 @@
 
 int brcmf_fws_init(struct brcmf_pub *drvr);
 void brcmf_fws_deinit(struct brcmf_pub *drvr);
+bool brcmf_fws_fc_active(struct brcmf_fws_info *fws);
 int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		      struct sk_buff *skb);
 
-- 
1.7.10.4


