Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA463C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8B26222B6
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="tSCnjvHx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394354AbfBNMoN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:44:13 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48248 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389280AbfBNMoM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:44:12 -0500
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id E882294A0E;
        Thu, 14 Feb 2019 04:44:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com E882294A0E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1550148250;
        bh=9DaOzjAZjiiGc3tPCFueaj6obFmuE0MMS1WW/eLIo9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSCnjvHxHvT3ezVjLVbjxEarIk3PaxWFqJtbVjPwXj+/yn7ith4ac2/eMt4UKrFBb
         7S6c5a6HfDcRlTZJvWLbQjlCS8XfbAmMU5OCVlO1cDbzvRy5DLD7e+t9rIH9kqJqlC
         q5eOUHUSJSzbRCj3OUpa9J0R3xxx+5ovzIMlqVp0=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 447CB81EBF;
        Thu, 14 Feb 2019 04:44:11 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 35BBDB02AED; Thu, 14 Feb 2019 13:44:08 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/6] brcmfmac: add subtype check for event handling in data path
Date:   Thu, 14 Feb 2019 13:43:48 +0100
Message-Id: <1550148232-4309-3-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For USB there is no separate channel being used to pass events
from firmware to the host driver and as such are passed over the
data path. In order to detect mock event messages an additional
check is needed on event subtype. This check is added conditionally
using unlikely() keyword.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c  |  5 +++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h  | 16 ++++++++++++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c    |  2 +-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index e772c08..a368ba6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -519,7 +519,8 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_event)
 	} else {
 		/* Process special event packets */
 		if (handle_event)
-			brcmf_fweh_process_skb(ifp->drvr, skb);
+			brcmf_fweh_process_skb(ifp->drvr, skb,
+					       BCMILCP_SUBTYPE_VENDOR_LONG);
 
 		brcmf_netif_rx(ifp, skb);
 	}
@@ -536,7 +537,7 @@ void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
 	if (brcmf_rx_hdrpull(drvr, skb, &ifp))
 		return;
 
-	brcmf_fweh_process_skb(ifp->drvr, skb);
+	brcmf_fweh_process_skb(ifp->drvr, skb, 0);
 	brcmu_pkt_buf_free_skb(skb);
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
index 31f3e8e..7027243 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
@@ -211,7 +211,7 @@ enum brcmf_fweh_event_code {
  */
 #define BRCM_OUI				"\x00\x10\x18"
 #define BCMILCP_BCM_SUBTYPE_EVENT		1
-
+#define BCMILCP_SUBTYPE_VENDOR_LONG		32769
 
 /**
  * struct brcm_ethhdr - broadcom specific ether header.
@@ -334,10 +334,10 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 void brcmf_fweh_p2pdev_setup(struct brcmf_if *ifp, bool ongoing);
 
 static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
-					  struct sk_buff *skb)
+					  struct sk_buff *skb, u16 stype)
 {
 	struct brcmf_event *event_packet;
-	u16 usr_stype;
+	u16 subtype, usr_stype;
 
 	/* only process events when protocol matches */
 	if (skb->protocol != cpu_to_be16(ETH_P_LINK_CTL))
@@ -346,8 +346,16 @@ static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
 	if ((skb->len + ETH_HLEN) < sizeof(*event_packet))
 		return;
 
-	/* check for BRCM oui match */
 	event_packet = (struct brcmf_event *)skb_mac_header(skb);
+
+	/* check subtype if needed */
+	if (unlikely(stype)) {
+		subtype = get_unaligned_be16(&event_packet->hdr.subtype);
+		if (subtype != stype)
+			return;
+	}
+
+	/* check for BRCM oui match */
 	if (memcmp(BRCM_OUI, &event_packet->hdr.oui[0],
 		   sizeof(event_packet->hdr.oui)))
 		return;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 4e8397a..ee922b0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1116,7 +1116,7 @@ static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	skb->protocol = eth_type_trans(skb, ifp->ndev);
 
-	brcmf_fweh_process_skb(ifp->drvr, skb);
+	brcmf_fweh_process_skb(ifp->drvr, skb, 0);
 
 exit:
 	brcmu_pkt_buf_free_skb(skb);
-- 
1.9.1

