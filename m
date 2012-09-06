Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24706 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab2IFQRl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 12:17:41 -0400
Message-ID: <5048CCA7.4010604@linux.intel.com> (sfid-20120906_181744_613116_38F932C5)
Date: Thu, 06 Sep 2012 18:17:43 +0200
From: Eric Lapuyade <eric.lapuyade@linux.intel.com>
MIME-Version: 1.0
To: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
CC: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	sameo@linux.intel.com, eric.lapuyade@intel.com
Subject: Re: [linux-nfc] [PATCH 2/2] NFC: Correct outgoing frame before requeueing
References: <1346926937-4968-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <1346926937-4968-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
In-Reply-To: <1346926937-4968-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2012 12:22 PM, Waldemar Rymarkiewicz wrote:
> Purge data added by lower layers (len and crc) in the head and tail of the frame
> during initial send. Now, the frame is correct to be resent.
> 
> Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
> ---
>  net/nfc/hci/shdlc.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
> index 8a5f034..30e353e 100644
> --- a/net/nfc/hci/shdlc.c
> +++ b/net/nfc/hci/shdlc.c
> @@ -241,8 +241,9 @@ static void nfc_shdlc_requeue_ack_pending(struct nfc_shdlc *shdlc)
>  	pr_debug("ns reset to %d\n", shdlc->dnr);
>  
>  	while ((skb = skb_dequeue_tail(&shdlc->ack_pending_q))) {
> -		skb_pull(skb, 2);	/* remove len+control */
> -		skb_trim(skb, skb->len - 2);	/* remove crc */
> +		/* remove client head + shdlc control field */
> +		skb_pull(skb, shdlc->client_headroom + 1);
> +		skb_trim(skb, skb->len - shdlc->client_tailroom);
>  		skb_queue_head(&shdlc->send_q, skb);
>  	}
>  	shdlc->ns = shdlc->dnr;
> 

Hi Waldemar,

This patch would work for PN544, but it makes the assumption that the
driver will always insert/append exactly client_headroom/client_tailroom
bytes when xmit is called. This is not specified nor enforced so it may
be a little dangerous.

To correct that, we can :
- either specify that the driver xmit MUST NOT modify skb. We then let
it remove those len and crc before returning from xmit. This is the most
logical since only the driver really knows what it's doing.
- or specify that the driver head/tailroom request MUST BE the exact
number of bytes added to the skb by xmit.

Samuel, what do you think?

Eric


