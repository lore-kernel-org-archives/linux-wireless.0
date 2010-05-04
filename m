Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab0EDHxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 03:53:01 -0400
Subject: Re: [RFC] mac80211: radiotap vendor data
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Joshua Zhao <Joshua.Zhao@atheros.com>,
	Matt Smith <Matt.Smith@atheros.com>
In-Reply-To: <o2k43e72e891005031516g31c22cdbt3ee5d766e63b3f2c@mail.gmail.com>
References: <1272734031.8461.0.camel@jlt3.sipsolutions.net>
	 <o2k43e72e891005031516g31c22cdbt3ee5d766e63b3f2c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 09:52:56 +0200
Message-ID: <1272959576.3673.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-03 at 15:16 -0700, Luis R. Rodriguez wrote:

> > Note: 11n shouldn't be done there, in case somebody
> > got ideas!!
> 
> Well you mean 802.11n standard stuff, I take it, because there are
> vendor 802.11n specific stuff.

Well most of it should really be standardised :)

> > + * @vendor_radiotap_bitmap: radiotap vendor namespace presence bitmap
> > + * @vendor_radiotap_len: radiotap vendor namespace length
> > + * @vendor_radiotap_align: radiotap vendor namespace alignment. Note
> > + *     that the actual data must be at the start of the SKB data
> > + *     already.
> 
> I see your WARN_ON() on the alignment being set to 0 and set it to 1
> then. Can you clarify a little more on this here. If there is no
> strict alignment requirements why not just treat 0 as 1 then?

Just want people to be aware that they need to think about alignment --
zero being the default value for most things here due to kzalloc would
mean accepting it people wouldn't think about allocations. And most of
the time alignment should be required.

> > @@ -190,11 +218,26 @@ ieee80211_add_rx_radiotap_header(struct
> >        /* IEEE80211_RADIOTAP_RX_FLAGS */
> >        /* ensure 2 byte alignment for the 2 byte field as required */
> >        if ((pos - (u8 *)rthdr) & 1)
> > -               pos++;
> > +               *pos++ = 0;
> 
> Why is this needed though? We already memset(rthdr, 0, rtap_len); above.

Yeah you're probably right, dunno.

> > +       vendor_data = skb_push(skb, 4);
> > +       rx_status.vendor_radiotap_len = 4;
> > +       rx_status.vendor_radiotap_align = 4;
> > +       rx_status.vendor_radiotap_oui[0] = 0xff;
> > +       rx_status.vendor_radiotap_oui[1] = 0xff;
> > +       rx_status.vendor_radiotap_oui[2] = 0xff;
> > +       rx_status.vendor_radiotap_subns = 129;
> > +       rx_status.vendor_radiotap_bitmap = 0x1;
> > +
> > +       *vendor_data++ = 1;
> > +       *vendor_data++ = 2;
> > +       *vendor_data++ = 3;
> > +       *vendor_data++ = 4;
> > +
> 
> Heh nice, now we just need a sample radiotap vendor extension parser example.

http://git.sipsolutions.net/?p=radiotap.git;a=summary
https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=4421

johannes

