Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.solarflare.com ([216.237.3.220]:52519 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1EPUPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 16:15:16 -0400
Subject: Re: several packets in a single buffer in Rx
From: Ben Hutchings <bhutchings@solarflare.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	=?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>, guy.cohen@intel.com
In-Reply-To: <BANLkTimvCVcQX-7teQgG7EQV9eeLgG3JnQ@mail.gmail.com>
References: <BANLkTimkgtQL1A2A3iAP-UYK2KdDvPmY3Q@mail.gmail.com>
	 <BANLkTinb3kaK7_b=47AL+Mb6Zmt9twEM9g@mail.gmail.com>
	 <BANLkTi=aBLPX7OMKi=sMhT81x-2f6Ci6sQ@mail.gmail.com>
	 <BANLkTi=xJbL-26Hzg0Pp5zKPUi35bV6VmA@mail.gmail.com>
	 <BANLkTin_stn+7Ja3hbuaOgtrEVJEoT9Lhw@mail.gmail.com>
	 <BANLkTimvCVcQX-7teQgG7EQV9eeLgG3JnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 21:15:12 +0100
Message-ID: <1305576912.2885.32.camel@bwh-desktop> (sfid-20110516_221525_742035_53B0F53B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-16 at 23:04 +0300, Tomas Winkler wrote:
> 2011/5/16 Emmanuel Grumbach <egrumbach@gmail.com>:
> > 2011/5/16 Michał Mirosław <mirqus@gmail.com>:
> >> W dniu 16 maja 2011 14:59 użytkownik Emmanuel Grumbach
> >> <egrumbach@gmail.com> napisał:
> >>> 2011/5/16 Michał Mirosław <mirqus@gmail.com>:
> >>>> 2011/5/16 Emmanuel Grumbach <egrumbach@gmail.com>:
> >>>>> I would like to be able to deliver the same page several times to the
> >>>>> stack without having the stack consume it before the last time I
> >>>>> deliver it.
> >>>>> Of course I would like to avoid cloning it.
> >>>>
> >>>> Just do get_page() on the page having another packet in it before
> >>>> passing skb up.
> >>>>
> >>>
> >>> I can see the path:
> >>> __kfree_skb -> skb_release_all -> skb_release_data -> put_page
> >>> put_page will free the page iff the _count variable reaches 0. Of course,
> >>> _count is incremented by get_page.
> >>>
> >>> I will give it try.
> >>>
> >>> I understand that this will work regardless the order given to
> >>> alloc_pages right ?
> >>
> >> Yes. Remember that if you put a lot of packets in a big-order page
> >> then the memory will be freed only after all packets are freed.
> >
> > Sure. Thanks for the help.
> 
> How it is ensured that skb manipulation won't corrupt another packet
> on the same page?

Fragments attached to an skb are always treated as read-only.  The
headers will be copied into the skb's header buffer and may be modified
there.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

