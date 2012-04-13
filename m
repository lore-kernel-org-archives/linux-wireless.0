Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34106 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934921Ab2DMKQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 06:16:17 -0400
Date: Fri, 13 Apr 2012 13:16:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: eric.lapuyade@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: NFC: HCI support
Message-ID: <20120413101609.GA10315@elgon.mountain> (sfid-20120413_121625_413937_7AE46514)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Eric Lapuyade,

This is a semi-automatic email about new static checker warnings.

The patch 8b8d2e08bf0d: "NFC: HCI support" from Apr 10, 2012, leads 
to the following Smatch complaint:

net/nfc/hci/core.c:815 nfc_hci_recv_frame()
	 error: we previously assumed 'hcp_skb' could be null (see line 790)

net/nfc/hci/core.c
   789						     msg_len, GFP_KERNEL);
   790			if (hcp_skb == NULL) {
                            ^^^^^^^^^^^^^^^
New check.

   791				/* TODO ELa: cannot deliver HCP message. How to
   792				 * propagate error up?
   793				 */

If we can't allocate memory here, shouldn't we just drop the packet and
return?  The other layers can handle dropped packets.

   794			}
   795	
   796			*skb_put(hcp_skb, NFC_HCI_HCP_PACKET_HEADER_LEN) = pipe;
   797	
   798			skb_queue_walk(&hdev->rx_hcp_frags, frag_skb) {
   799				msg_len = frag_skb->len - NFC_HCI_HCP_PACKET_HEADER_LEN;
   800				memcpy(skb_put(hcp_skb, msg_len),
   801				       frag_skb->data + NFC_HCI_HCP_PACKET_HEADER_LEN,
   802				       msg_len);
   803			}
   804	
   805			skb_queue_purge(&hdev->rx_hcp_frags);
   806		} else {
   807			packet->header &= NFC_HCI_FRAGMENT;
   808			hcp_skb = skb;
   809		}
   810	
   811		/* if this is a response, dispatch immediately to
   812		 * unblock waiting cmd context. Otherwise, enqueue to dispatch
   813		 * in separate context where handler can also execute command.
   814		 */
   815		packet = (struct hcp_packet *)hcp_skb->data;
                                              ^^^^^^^^^^^^^
New dereference.

   816		type = HCP_MSG_GET_TYPE(packet->message.header);
   817		if (type == NFC_HCI_HCP_RESPONSE) {

regards,
dan carpenter

