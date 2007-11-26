Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:62223 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbXKZRZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 12:25:28 -0500
Received: by wa-out-1112.google.com with SMTP id v27so837162wah
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 09:25:28 -0800 (PST)
Message-ID: <1ba2fa240711260925y3e8ab0efg9731af02402c94d9@mail.gmail.com> (sfid-20071126_172533_226981_7B3A747D)
Date: Mon, 26 Nov 2007 19:25:27 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 06/15] mac80211: adding 802.11n essential A-MSDU Rx capability
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net
In-Reply-To: <1196094919.4149.303.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <119608649124-git-send-email-ron.rindjunsky@intel.com>
	 <1196094919.4149.303.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 26, 2007 6:35 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Mon, 2007-11-26 at 16:14 +0200, Ron Rindjunsky wrote:
> > This patch adds the ability to receive and handle A-MSDU frames.
> >
> > Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> Thanks for your patience on this. I have another question that is
> identical in the other code and that we should, if necessary, fix in a
> separate patch to fix both instances of this:
>
>
> > +             payload = frame->data;
> > +             ethertype = (payload[6] << 8) | payload[7];
> > +
> > +             if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
> [...]
> > +             } else {
> > +                     memcpy(skb_push(frame, sizeof(__be16)), &len,
> > +                             sizeof(__be16));
> > +                     memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
> > +                     memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
>
> Here, as well as in the regular data frame handler, we push the length
> of the frame into the ethernet header. Later then, eth_type_trans() will
> load up the skb->protocol field. The thing I'm not entirely sure about
> is this: We can have frames longer than 1536 bytes, but only if the
> length is smaller than 1536 does eth_type_trans() assume that it's a
> length, if we have a frame longer won't it go wrong? I haven't quite
> managed to wrap my head around the rules for wrapping data into an
> 802.11 frame nor in an 802.3 setting so this may be totally incorrect.
>
Just grabbed this from wikipedia
'
values of that field between 0 and 1500 indicated the use of the
original 802.3 Ethernet format with a length field, while values of
1536 decimal (0600 hexadecimal) and greater indicated the use of the
DIX frame format with an EtherType sub-protocol identifier
'
> johannes
>
