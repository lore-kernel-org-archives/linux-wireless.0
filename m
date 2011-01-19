Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab1ASWfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 17:35:13 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so1417828fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 14:35:13 -0800 (PST)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFT 5/8] staging: brcm80211: Remove ETHER_TYPE_BRCM.
Date: Wed, 19 Jan 2011 23:35:29 +0100
Message-Id: <1295476532-21130-6-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1295476532-21130-5-git-send-email-jonas.gorski@gmail.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-2-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-3-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-4-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-5-git-send-email-jonas.gorski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the recently introduced ETH_P_LINK_CTL instead of ETHER_TYPE_BRCM, and
remove the define.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    2 +-
 drivers/staging/brcm80211/include/proto/ethernet.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 87bf42d..71c5203 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1215,7 +1215,7 @@ void dhd_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf,
 		skb_pull(skb, ETH_HLEN);
 
 		/* Process special event packets and then discard them */
-		if (ntoh16(skb->protocol) == ETHER_TYPE_BRCM)
+		if (skb->protocol == htons(ETH_P_LINK_CTL))
 			dhd_wl_host_event(dhd, &ifidx,
 					  skb_mac_header(skb),
 					  &event, &data);
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index bc99842..77deb94 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -21,8 +21,6 @@
 
 #include <packed_section_start.h>
 
-#define	ETHER_TYPE_BRCM		0x886c
-
 BWL_PRE_PACKED_STRUCT struct ether_addr {
 	u8 octet[ETH_ALEN];
 } BWL_POST_PACKED_STRUCT;
-- 
1.5.6.5

