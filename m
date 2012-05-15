Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:48273 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501Ab2EOJAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 05:00:51 -0400
Date: Tue, 15 May 2012 12:00:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] brcm80211: brcmu_pkt_buf_free_skb() should handle NULL
Message-ID: <20120515090027.GG30265@elgon.mountain> (sfid-20120515_110056_180179_168FF4BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is potentially called with NULL pointers, for example, look at
brcmf_c_prec_enq().  Since it's a free() function, probably people
expect it to handle NULL pointers.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index b45ab34..3e6405e 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -43,6 +43,8 @@ EXPORT_SYMBOL(brcmu_pkt_buf_get_skb);
 /* Free the driver packet. Free the tag if present */
 void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
 {
+	if (!skb)
+		return;
 	WARN_ON(skb->next);
 	if (skb->destructor)
 		/* cannot kfree_skb() on hard IRQ (net/core/skbuff.c) if
