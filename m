Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaKKNbx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 08:31:53 -0500
Date: Tue, 11 Nov 2014 14:28:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Mark Asselstine <asselsm@gmail.com>,
	"Antti S. Lankila" <alankila@bel.fi>
Subject: [PATCH v2 3.18] rt2x00: do not align payload on modern H/W
Message-ID: <20141111132846.GA2038@redhat.com> (sfid-20141111_143156_846623_F0D3A8C4)
References: <20141102123846.GB9242@redhat.com>
 <20141111130605.GA2892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141111130605.GA2892@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RT2800 and newer hardware require padding between header and payload if
header length is not multiple of 4.

For historical reasons we also align payload to to 4 bytes boundary, but
such alignment is not needed on modern H/W.

Patch fixes skb_under_panic problems reported from time to time:

https://bugzilla.kernel.org/show_bug.cgi?id=84911
https://bugzilla.kernel.org/show_bug.cgi?id=72471
http://marc.info/?l=linux-wireless&m=139108549530402&w=2
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1087591

Panic happened because we eat 4 bytes of skb headroom on each
(re)transmission when sending frame without the payload and the header
length not being multiple of 4 (i.e. QoS header has 26 bytes). On such
case because paylad_aling=2 is bigger than header_align=0 we increase
header_align by 4 bytes. To prevent that we could change the check to:

	if (payload_length && payload_align > header_align)
		header_align += 4;

but not aligning payload at all is more effective and alignment is not
really needed by H/W (that has been tested on OpenWrt project for few
years now).

Reported-and-tested-by: Antti S. Lankila <alankila@bel.fi>
Debugged-by: Antti S. Lankila <alankila@bel.fi>
Reported-by: Henrik Asp <solenskiner@gmail.com>
Originally-From: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2: update the changelog.

 drivers/net/wireless/rt2x00/rt2x00queue.c | 50 ++++++++-----------------------
 1 file changed, 12 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 5642ccc..22d49d5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -158,55 +158,29 @@ void rt2x00queue_align_frame(struct sk_buff *skb)
 	skb_trim(skb, frame_length);
 }
 
-void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
+/*
+ * H/W needs L2 padding between the header and the paylod if header size
+ * is not 4 bytes aligned.
+ */
+void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int hdr_len)
 {
-	unsigned int payload_length = skb->len - header_length;
-	unsigned int header_align = ALIGN_SIZE(skb, 0);
-	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
-	unsigned int l2pad = payload_length ? L2PAD_SIZE(header_length) : 0;
+	unsigned int l2pad = (skb->len > hdr_len) ? L2PAD_SIZE(hdr_len) : 0;
 
-	/*
-	 * Adjust the header alignment if the payload needs to be moved more
-	 * than the header.
-	 */
-	if (payload_align > header_align)
-		header_align += 4;
-
-	/* There is nothing to do if no alignment is needed */
-	if (!header_align)
+	if (!l2pad)
 		return;
 
-	/* Reserve the amount of space needed in front of the frame */
-	skb_push(skb, header_align);
-
-	/*
-	 * Move the header.
-	 */
-	memmove(skb->data, skb->data + header_align, header_length);
-
-	/* Move the payload, if present and if required */
-	if (payload_length && payload_align)
-		memmove(skb->data + header_length + l2pad,
-			skb->data + header_length + l2pad + payload_align,
-			payload_length);
-
-	/* Trim the skb to the correct size */
-	skb_trim(skb, header_length + l2pad + payload_length);
+	skb_push(skb, l2pad);
+	memmove(skb->data, skb->data + l2pad, hdr_len);
 }
 
-void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
+void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int hdr_len)
 {
-	/*
-	 * L2 padding is only present if the skb contains more than just the
-	 * IEEE 802.11 header.
-	 */
-	unsigned int l2pad = (skb->len > header_length) ?
-				L2PAD_SIZE(header_length) : 0;
+	unsigned int l2pad = (skb->len > hdr_len) ? L2PAD_SIZE(hdr_len) : 0;
 
 	if (!l2pad)
 		return;
 
-	memmove(skb->data + l2pad, skb->data, header_length);
+	memmove(skb->data + l2pad, skb->data, hdr_len);
 	skb_pull(skb, l2pad);
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

