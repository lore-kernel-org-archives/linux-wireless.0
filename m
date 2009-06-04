Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47088 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbZFDVka (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 17:40:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Georgy Berdyshev <codingmaster@gmail.com>
Subject: Re: mac80211 : fix unaligned rx skb
Date: Thu, 4 Jun 2009 23:40:23 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	matthieu castet <castet.matthieu@free.fr>,
	linux-wireless@vger.kernel.org
References: <4A282B92.70609@free.fr> <43e72e890906041353y98a3a13s2b8d60328a9c0c6d@mail.gmail.com> <ee8eb53d0906041416q52812277x7061070d1d9a683c@mail.gmail.com>
In-Reply-To: <ee8eb53d0906041416q52812277x7061070d1d9a683c@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200906042340.23997.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 04 June 2009 23:16:13 Georgy Berdyshev wrote:
> Hi,
> 
> that's the inline version:
> -------
> mac80211 is checking is the skb is aligned on 32 bit boundary.
> But it is checking against ethernet header, whereas Linux expect IP
> header aligned.
> And ethernet ether size is 6*2+2=14, so aligning ethernet header make
> IP header unaligned.
> 
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 9776f73..0845fb3 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1397,7 +1397,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
>  		 * mac80211. That also explains the __skb_push()
>  		 * below.
>  		 */
> -		align = (unsigned long)skb->data & 3;
> +		align = ((unsigned long)(skb->data + sizeof(struct ethhdr))) & 3;
>  		if (align) {
>  			if (WARN_ON(skb_headroom(skb) < 3)) {
>  				dev_kfree_skb(skb);

Uhm, can you give a more verbose explanation? Without that I'd say this patch is plain wrong.
What the hell does struct ethhdr have to do with wireless?
This is not ethernet. It's 802.11. There is no such thing as an ethernet header in a 802.11 packet.

-- 
Greetings, Michael.
