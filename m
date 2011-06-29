Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2014 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab1F2Xsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:54 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 076/119] staging: brcm80211: use linux native ethertype
 iso ETH_P_BRCM
Date: Wed, 29 Jun 2011 16:47:40 -0700
Message-ID: <1309391303-22741-77-git-send-email-frankyl@broadcom.com> (sfid-20110630_015114_947518_C7FC2D35)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The linux native ethertype ETH_P_LINK_CTL is matching ETH_P_BRCM so
lets use that definition and get rid of ETH_P_BRCM.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 19e09bd..c3cbda6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -43,8 +43,6 @@
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 
-#define ETH_P_BRCM			0x886c
-
 /* Global ASSERT type flag */
 u32 g_assert_type;
 
@@ -947,7 +945,7 @@ void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *skb,
 		skb_pull(skb, ETH_HLEN);
 
 		/* Process special event packets and then discard them */
-		if (ntohs(skb->protocol) == ETH_P_BRCM)
+		if (ntohs(skb->protocol) == ETH_P_LINK_CTL)
 			brcmf_host_event(dhd, &ifidx,
 					  skb_mac_header(skb),
 					  &event, &data);
-- 
1.7.1


