Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964777Ab1GOKA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 06:00:28 -0400
Subject: Re: [PATCH 5/5] mac80211: mesh beacon includes TIM IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <CAG6hwVN3HED+LZdKN0zpNfjmK9FmBuBWnZ0qe9gYTPPYmCedTg@mail.gmail.com> (sfid-20110714_221703_735281_4D5F9F4B)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-6-git-send-email-thomas@cozybit.com>
	 <20110714062522.GA2534@jm.kir.nu>
	 <CAG6hwVN3HED+LZdKN0zpNfjmK9FmBuBWnZ0qe9gYTPPYmCedTg@mail.gmail.com>
	 (sfid-20110714_221703_735281_4D5F9F4B)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 12:00:23 +0200
Message-ID: <1310724023.4164.22.camel@jlt3.sipsolutions.net> (sfid-20110715_120030_202767_7A4687B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-07-14 at 13:16 -0700, Thomas Pedersen wrote:
> On Wed, Jul 13, 2011 at 11:25 PM, Jouni Malinen <j@w1.fi> wrote:
> > On Wed, Jul 13, 2011 at 04:45:47PM -0700, Thomas Pedersen wrote:
> >> Even though we don't currently implement PS for mesh points, the
> >> standard asks us to include a TIM element in beacons. Include an empty
> >> element for now.
> >
> > Is it allowed to not support PS in this type of case? AP does not have
> > such option..
> >
> 
> You're right, it doesn't look like PS support is optional. The
> standard requires us to respect the PS states of peers. Support for
> this will require some work, but in the meantime, we can include a TIM
> element indicating no frames buffered here, as well as a Mesh Awake
> Window which never expires.
> 
> Otherwise, until we implement proper PS, might it be better not to
> include the TIM IE at all?

Or just not pretend to support the latest mesh draft ...

I don't think PS support can be hard. We have all of it in AP mode
anyway, so you just need to generalise that a bit, maybe refactor like I
said in my other email, and you should be able to get it up & running
pretty quickly?

johannes

