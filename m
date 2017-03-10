Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46018 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932482AbdCJVR1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 16:17:27 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/5] brcmfmac: wrap brcmf_fws_reset_interface into bcdc layer
Date: Fri, 10 Mar 2017 21:17:06 +0000
Message-Id: <1489180626-6722-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170310_221742_694572_87975963)
In-Reply-To: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

Create a new protocol interface function brcmf_proto_reset_if for core
module to notify protocol layer when interface role changes.

Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c  | 7 +++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c  | 3 +--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h | 9 +++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index ae04125..92eafcc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -411,6 +411,12 @@ static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
 	brcmf_fws_del_interface(ifp);
 }
 
+static void
+brcmf_proto_bcdc_reset_if(struct brcmf_if *ifp)
+{
+	brcmf_fws_reset_interface(ifp);
+}
+
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc;
@@ -436,6 +442,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 	drvr->proto->rxreorder = brcmf_proto_bcdc_rxreorder;
 	drvr->proto->add_if = brcmf_proto_bcdc_add_if;
 	drvr->proto->del_if = brcmf_proto_bcdc_del_if;
+	drvr->proto->reset_if = brcmf_proto_bcdc_reset_if;
 	drvr->proto->pd = bcdc;
 
 	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index f63f36f..4eb1e1c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -22,7 +22,6 @@
 #include "core.h"
 #include "debug.h"
 #include "tracepoint.h"
-#include "fwsignal.h"
 #include "fweh.h"
 #include "fwil.h"
 #include "proto.h"
@@ -180,7 +179,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 	}
 
 	if (ifp && ifevent->action == BRCMF_E_IF_CHANGE)
-		brcmf_fws_reset_interface(ifp);
+		brcmf_proto_reset_if(drvr, ifp);
 
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index 2c76c96..3048ed5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -46,6 +46,7 @@ struct brcmf_proto {
 	void (*rxreorder)(struct brcmf_if *ifp, struct sk_buff *skb);
 	void (*add_if)(struct brcmf_if *ifp);
 	void (*del_if)(struct brcmf_if *ifp);
+	void (*reset_if)(struct brcmf_if *ifp);
 	void *pd;
 };
 
@@ -136,4 +137,12 @@ static inline bool brcmf_proto_is_reorder_skb(struct sk_buff *skb)
 	drvr->proto->del_if(ifp);
 }
 
+static inline void
+brcmf_proto_reset_if(struct brcmf_pub *drvr, struct brcmf_if *ifp)
+{
+	if (!drvr->proto->reset_if)
+		return;
+	drvr->proto->reset_if(ifp);
+}
+
 #endif /* BRCMFMAC_PROTO_H */
-- 
1.9.1
