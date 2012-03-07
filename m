Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:35690 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2CGJv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 04:51:56 -0500
Date: Wed, 7 Mar 2012 12:51:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: NFC: Fragment LLCP I frames
Message-ID: <20120307095142.GA24805@elgon.mountain> (sfid-20120307_105159_753731_F6B0C6A8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

I had some questions about the patch e65b0f46edfd: "NFC: Fragment LLCP I
frames" from Mar 5, 2012.

net/nfc/llcp/commands.c
+       while (remaining_len > 0) {
+
+               frag_len = min_t(u16, local->remote_miu, remaining_len);
                                 ^^^

This should be a cast to size_t.  Otherwise for a large value of
remaining_len we'd loop until we hit an allocation failure with
pdu = llcp_allocate_pdu();

 
-       sk = &sock->sk;
-       lock_sock(sk);
+               pr_debug("Fragment %zd bytes remaining %zd",
+                        frag_len, remaining_len);
 
-       nfc_llcp_queue_i_frames(sock);
+               pdu = llcp_allocate_pdu(sock, LLCP_PDU_I,
+                                       frag_len + LLCP_SEQUENCE_SIZE);
+               if (pdu == NULL)
+                       return -ENOMEM;
+
+               skb_put(pdu, LLCP_SEQUENCE_SIZE);
+
+               memcpy(skb_put(pdu, frag_len), msg_ptr, frag_len);
+
+               skb_queue_head(&sock->tx_queue, pdu);
+
+               lock_sock(sk);
+
+               nfc_llcp_queue_i_frames(sock);
+
+               release_sock(sk);
+
+               remaining_len -= frag_len;
+               msg_ptr += len;

Shouldn't this be msg_ptr += frag_len?

+       }

regards,
dan carpenter

