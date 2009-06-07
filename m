Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55756 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbZFGJ0h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 05:26:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: mac80211 : fix unaligned rx skb
Date: Sun, 7 Jun 2009 11:26:22 +0200
Cc: Georgy Berdyshev <codingmaster@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4A282B92.70609@free.fr> <4A28B3D0.4070201@free.fr> <4A2B8760.10001@free.fr>
In-Reply-To: <4A2B8760.10001@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906071126.22323.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 June 2009 11:24:48 matthieu castet wrote:
> matthieu castet wrote:
> > Michael Buesch wrote:
> >> On Thursday 04 June 2009 23:16:13 Georgy Berdyshev wrote:
> >>> Hi,
> >>>
> >>> that's the inline version:
> >>> -------
> >>> mac80211 is checking is the skb is aligned on 32 bit boundary.
> >>> But it is checking against ethernet header, whereas Linux expect IP
> >>> header aligned.
> >>> And ethernet ether size is 6*2+2=14, so aligning ethernet header make
> >>> IP header unaligned.
> >>>
> >>> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> >>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> >>> index 9776f73..0845fb3 100644
> >>> --- a/net/mac80211/rx.c
> >>> +++ b/net/mac80211/rx.c
> >>> @@ -1397,7 +1397,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data 
> >>> *rx)
> >>>           * mac80211. That also explains the __skb_push()
> >>>           * below.
> >>>           */
> >>> -        align = (unsigned long)skb->data & 3;
> >>> +        align = ((unsigned long)(skb->data + sizeof(struct ethhdr))) 
> >>> & 3;
> >>>          if (align) {
> >>>              if (WARN_ON(skb_headroom(skb) < 3)) {
> >>>                  dev_kfree_skb(skb);
> >>
> >> Uhm, can you give a more verbose explanation? Without that I'd say 
> >> this patch is plain wrong.
> >> What the hell does struct ethhdr have to do with wireless?
> >  > This is not ethernet. It's 802.11. There is no such thing as an
> >  > ethernet header in a 802.11 packet.
> >  >
> > Where are in ieee80211_deliver_skb that is called after 
> > ieee80211_data_to_8023. So it is not 802.11.
> > 
> Do you want more explanation ?

No reply always means "ok" on this list ;)

-- 
Greetings, Michael.
