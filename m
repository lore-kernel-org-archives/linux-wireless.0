Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbXLJR3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:29:41 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 41/48] libertas: TX packet is radiotap iff it comes from rtap_dev
Message-Id: <E1J1kpl-0006nQ-90@shinybook.infradead.org> (sfid-20071210_172950_066135_7651C7C7)
Date: Mon, 10 Dec 2007 10:46:17 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 22:00:55 -0500

Fix one of the barriers to simultaneous radiotap and normal operation --
stop misinterpreting the TX packets on the normal devices. We're also
going to have to clone the incoming skbs and feed them into both
devices, and there seem to be firmware problems with staying associated
too. But this is a reasonable start...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index aefe524..c2881a9 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -105,7 +105,7 @@ int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	p802x_hdr = skb->data;
 	pkt_len = skb->len;
 
-	if (priv->monitormode != LBS_MONITOR_OFF) {
+	if (dev == priv->rtap_net_dev) {
 		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
 		/* set txpd fields from the radiotap header */
-- 
1.5.3.4

