Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38836 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZHNJWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 05:22:23 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFT] ar9170: check mpdu len on single mpdu before processing
Date: Fri, 14 Aug 2009 11:21:29 +0200
Cc: linux-wireless@vger.kernel.org,
	Stephen Chen <Stephen.Chen@atheros.com>
References: <1250214676-10608-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250214676-10608-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200908141121.29762.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 August 2009 03:51:16 Luis R. Rodriguez wrote:
> When ar9170 recieves a single MPDU in RX stream mode
> we set the header and tail pointers for processing
> but we never check if the MPDU will actually have
> it given by the length passed. Should we have run into
> this we would be chowing down on memory which may
> not be ours.
> 
> Cc: Stephen Chen <Stephen.Chen@atheros.com>
> Cc: Christian Lamparter <chunkeey@web.de>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> I won't be able to test this for a bit, was reviewing
> RX stream support and noticed this.
> 
> BTW Chris, Stephen points out we *can* use packet mode for
> RX with Otus devices.
I know... The otus driver talks about how to set the stream modes.
But then you make the firmware cry, it wants to control the all the
USB settings by itself.

> I haven't yet checked if ar9170 supports
> it but I think that's what the Windows driver uses.
(Well, you basically answered this already in the other post...)
But here's some more: The windows driver also utilize txstream
since XP/Vista can feed whole _aggregates_ 
(well, not the aggregate you might think, just a bundle of frames) 
directly into the _tx routines.

> It seems RX stream mode is used to reduce the number of
> interrupt and can help on some platforms.
> The down side to RX stream mode seems to be that it
> "may introduce buffer copy as a side effect",
> not sure what that is though, Stephen, can you clarify?
well, seems like you're struck by the same thought I had when
I looked at it: But c'mon: even for low-cost systems the memory
bandwidth easily exceeds the USB 2.0 bandwidth by orders of magnitudes.

And another upside is that we don't have to alloc 16k frames - that's 
(order 3 I think) all the time.

It may sounds a bit strange, but as you know ar9170 supports 8k msdu.
So we have to be ready to receive them. 
Now it's pretty straight forward, this would be a very wasteful behavior.
Since A-MSDU aren't used much and normally the frames are between
1 and 2k... 

so yes, that rxstream is not so bad after all!
(Also, it makes refilling much easier since the original skb is not consumed,
 we will never run out of rx buffers when the memory is too fragmented)

>  drivers/net/wireless/ath/ar9170/main.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> index ea8c941..75c317d 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -1040,9 +1040,27 @@ static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
>  
>  	case AR9170_RX_STATUS_MPDU_SINGLE:
>  		/* single mpdu - has plcp (head) and phy status (tail) */
> +
> +		if (unlikely(mpdu_len < sizeof(struct ar9170_rx_head))) {
> +			if (ar9170_nag_limiter(ar))
> +				printk(KERN_ERR "%s: rx'd single mpdu "
> +				       "with no header.\n",
> +				       wiphy_name(ar->hw->wiphy));
> +			return;
> +		}
> +
>  		head = (void *) buf;
>  
>  		mpdu_len -= sizeof(struct ar9170_rx_head);
> +
> +		if (unlikely(mpdu_len < sizeof(struct ar9170_rx_phystatus))) {
> +			if (ar9170_nag_limiter(ar))
> +				printk(KERN_ERR "%s: rx'd single mpdu"
> +				       "with no tail.\n",
> +				       wiphy_name(ar->hw->wiphy));
> +			return ;
> +		}
> +
>  		mpdu_len -= sizeof(struct ar9170_rx_phystatus);
>  
>  		buf += sizeof(struct ar9170_rx_head);
> 

naaa, not necessary...  there is more than your eyes can see :)
---
        case AR9170_RX_STATUS_MPDU_SINGLE:
                /* single mpdu - has plcp (head) and phy status (tail) */
                head = (void *) buf;
		[...]
                mpdu_len -= sizeof(struct ar9170_rx_head);
                mpdu_len -= sizeof(struct ar9170_rx_phystatus);
		[...]
        default:
                BUG_ON(1);
                break;
        }

        if (unlikely(mpdu_len < FCS_LEN))
                return ;
---
of course frames that only have FCS_LEN octets are a most likely
_damaged_ in some way... but we don't know, so we pass it on to
the stack to decide, maybe the user has a running monitor...

Regards,
	Chr
