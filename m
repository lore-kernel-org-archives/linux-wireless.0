Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50386 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0KPPqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 10:46:15 -0500
Received: by eye27 with SMTP id 27so356909eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 07:46:14 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make skb->data two-byte alignment
Date: Tue, 16 Nov 2010 16:45:14 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	"RA-Jay Hung" <jay_hung@ralinktech.com>
References: <201011131908.15595.IvDoorn@gmail.com> <201011131912.55384.IvDoorn@gmail.com> <201011131913.55169.IvDoorn@gmail.com>
In-Reply-To: <201011131913.55169.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011161645.15018.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag 13 November 2010 schrieb Ivo van Doorn:
> From: RA-Jay Hung <Jay_Hung@ralinktech.com>
> 
> When send out skb data to mac80211, orignal code will cause mac80211
> unaligned access, so modify code to make mac80211 can natural access.

And this introduces the same panic again :(

The problem is the following:

We don't pass the skb in the same state back to mac80211 as we got it.

When inserting the l2pad we're moving the header and thus reduce headroom.
This patch modifies the bahavior during l2pad removal to not move the header
back into its old position but instead moves the payload. Thus the skb keeps
the reduced headroom. If this skb gets requeued into rt2x00 (which can happen
when the frame wasn't acked and the according STA is known to e in powersave
mode) the header and payload get aligned again further reducing headroom which
results in a too small headroom for the TXWI and thus a skb_under_panic.

Helmut

> Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index dc54317..a3d79c7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -204,8 +204,10 @@ void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
>  	if (!l2pad)
>  		return;
>  
> -	memmove(skb->data + l2pad, skb->data, header_length);
> -	skb_pull(skb, l2pad);
> +	memmove(skb->data + header_length, skb->data + header_length + l2pad,
> +				skb->len - header_length - l2pad);
> +
> +	skb_trim(skb, skb->len - l2pad);
>  }
>  
>  static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
> 

