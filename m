Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37934 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609Ab0KGRUm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 12:20:42 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Nov 2010 17:20:37 +0000
Message-ID: <1289150437.2816.73.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 2/5] Staging: brcmfmac: Fix MAC header lookup on 64-bit
 architectures
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix direct use of sk_buff::mac_header which is an offset rather
than a pointer on 64-bit architectures.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Compile-tested only.  This should be 2.6.37 material.

Ben.

 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index e535787..4218f87 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1190,7 +1190,7 @@ void dhd_rx_frame(dhd_pub_t *dhdp, int ifidx, void *pktbuf, int numpkt)
 		/* Process special event packets and then discard them */
 		if (ntoh16(skb->protocol) == ETHER_TYPE_BRCM)
 			dhd_wl_host_event(dhd, &ifidx,
-					  skb->mac_header,
+					  skb_mac_header(skb),
 					  &event, &data);
 
 		ASSERT(ifidx < DHD_MAX_IFS && dhd->iflist[ifidx]);
-- 
1.7.2.3



