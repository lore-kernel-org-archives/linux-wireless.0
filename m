Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40841 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab2DPOOW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 10:14:22 -0400
Message-ID: <4F8C29ED.6020701@linux.intel.com> (sfid-20120416_161449_509009_834D8FB7)
Date: Mon, 16 Apr 2012 16:17:17 +0200
From: Eric Lapuyade <eric.lapuyade@linux.intel.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: eric.lapuyade@intel.com, linux-wireless@vger.kernel.org
Subject: Re: NFC: HCI support
References: <20120413101609.GA10315@elgon.mountain>
In-Reply-To: <20120413101609.GA10315@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thank you for the report. Please see below my explanations.

Regards,

Eric

On 13/04/2012 12:16, Dan Carpenter wrote:
> Hello Eric Lapuyade,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 8b8d2e08bf0d: "NFC: HCI support" from Apr 10, 2012, leads
> to the following Smatch complaint:
>
> net/nfc/hci/core.c:815 nfc_hci_recv_frame()
> 	 error: we previously assumed 'hcp_skb' could be null (see line 790)
>
> net/nfc/hci/core.c
>     789						     msg_len, GFP_KERNEL);
>     790			if (hcp_skb == NULL) {
>                              ^^^^^^^^^^^^^^^
> New check.
>
>     791				/* TODO ELa: cannot deliver HCP message. How to
>     792				 * propagate error up?
>     793				 */
>
> If we can't allocate memory here, shouldn't we just drop the packet and
> return?  The other layers can handle dropped packets.

Actually, the higher level to which this frame is destined cannot handle lost packets. In the current case, the frame can contain a response to an outgoing command, or an event or a command from the chipset.
In case of the response, the upper layer would complete command execution with a timeout error. So basically it would work except the command would complete with an incorrect error indication which could be a problem if you try to understand why the chip didn't answer your command.
In case of an event, that could be a tag_discovered event for example. Events MUST be delivered, otherwise it would appear to the user like if the tag wasn't detected at all, with no indication that something failed.
In case of an incoming command, it would be no problem, the remote would timeout on our response.

I will soon commit a new patch to purge the fragment list and return. This will remove the checker errors. I'll leave the TODO until we have designed a way for upper layer to be notified.

>
>     794			}
>     795	
>     796			*skb_put(hcp_skb, NFC_HCI_HCP_PACKET_HEADER_LEN) = pipe;
>     797	
>     798			skb_queue_walk(&hdev->rx_hcp_frags, frag_skb) {
>     799				msg_len = frag_skb->len - NFC_HCI_HCP_PACKET_HEADER_LEN;
>     800				memcpy(skb_put(hcp_skb, msg_len),
>     801				       frag_skb->data + NFC_HCI_HCP_PACKET_HEADER_LEN,
>     802				       msg_len);
>     803			}
>     804	
>     805			skb_queue_purge(&hdev->rx_hcp_frags);
>     806		} else {
>     807			packet->header&= NFC_HCI_FRAGMENT;
>     808			hcp_skb = skb;
>     809		}
>     810	
>     811		/* if this is a response, dispatch immediately to
>     812		 * unblock waiting cmd context. Otherwise, enqueue to dispatch
>     813		 * in separate context where handler can also execute command.
>     814		 */
>     815		packet = (struct hcp_packet *)hcp_skb->data;
>                                                ^^^^^^^^^^^^^
> New dereference.
>
>     816		type = HCP_MSG_GET_TYPE(packet->message.header);
>     817		if (type == NFC_HCI_HCP_RESPONSE) {
>
> regards,
> dan carpenter
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
