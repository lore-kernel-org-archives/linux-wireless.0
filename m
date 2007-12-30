Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:42462 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbXL3T1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2007 14:27:06 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2463689fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2007 11:27:05 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Sun, 30 Dec 2007 19:26:45 +0000
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <200712301149.39388.chris2553@googlemail.com> <200712301311.42895.IvDoorn@gmail.com>
In-Reply-To: <200712301311.42895.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712301926.45380.chris2553@googlemail.com> (sfid-20071230_192712_989609_D3F061E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 30 December 2007, Ivo van Doorn wrote:
> On Sunday 30 December 2007, Chris Clayton wrote:
> > On Saturday 29 December 2007, Ivo van Doorn wrote:
> > > On Saturday 29 December 2007, Johannes Berg wrote:
> > > > > Well Ralink doesn't seem to add this padding since this bug
> > > > > appeared, remember all bytes from the DMA was copied to the skb
> > > > > buffer so if there was any padding included it would have been
> > > > > copied as well. ;)
> > > >
> > > > Not necessarily, Broadcom hardware adds the padding in front of the
> > > > 802.11 header so if you'd start copying with the 802.11 header you'd
> > > > run into the same thing. A quick look at the rt2x00pci.c file doesn't
> > > > suggest that there's anything variable about the RX header though so
> > > > I guess that indeed this may be a problem.
> > > >
> > > > > Anyway, I have worked on a fix for the padding and I'll commit it
> > > > > to rt2x00.git first to see if anybody reports any problems with it
> > > > > before sending it to wireless-dev.
> >
> > If it would help, I'd be happy to test your fix, but I'm not a git user,
> > so you would need to post a patch that I could use...
>
> Here is the patch against the latest vanilla kernel,
> the previous piece of code was bugged since the header size check was
> incorrect, but that is fixed in this one.
>

Thanks. You'll be pleased to here that with this patch, the warning has gone 
away and laptop's connection to my wireless network is still fine. I'll be 
using it over the New Year holiday. If anything negative happens I'll let you 
know.

Thanks again.

Chris

> ----
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c
> b/drivers/net/wireless/rt2x00/rt2x00dev.c index ff399f8..4f8a37b 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -386,6 +386,7 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct
> sk_buff *skb, struct ieee80211_rx_status *rx_status =
> &rt2x00dev->rx_status;
>  	struct ieee80211_hw_mode *mode;
>  	struct ieee80211_rate *rate;
> +	unsigned int header_size;
>  	unsigned int i;
>  	int val = 0;
>
> @@ -412,6 +413,26 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct
> sk_buff *skb, }
>  	}
>
> +	/*
> +	 * Properly align the ieee80211 frame and make sure the
> +	 * data behind the ieee80211 header is on a 4 byte boundrary.
> +	 */
> +	header_size = ieee80211_get_hdrlen_from_skb(skb);
> +	if (!header_size) {
> +		/*
> +		 * Frame is too short to contain a valid header,
> +		 * drop the entire frame since it is useless.
> +		 */
> +		kfree_skb(skb);
> +		return;
> +	} else if (header_size % 4 == 0) {
> +		/*
> +		 * Move entire frame 2 bytes to the front.
> +		 */
> +		skb_push(skb, 2);
> +		memmove(skb->data, skb->data + 2, skb->len - 2);
> +	}
> +
>  	rt2x00_update_link_rssi(&rt2x00dev->link, desc->rssi);
>  	rt2x00dev->link.rx_success++;
>  	rx_status->rate = val;



-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
