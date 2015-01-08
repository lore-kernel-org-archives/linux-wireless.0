Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39810 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbbAHHsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 02:48:22 -0500
Message-ID: <1420703288.2029.4.camel@sipsolutions.net> (sfid-20150108_084825_102331_66D5C3CC)
Subject: Re: [PATCHv4] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>
Date: Thu, 08 Jan 2015 08:48:08 +0100
In-Reply-To: <CAA2SeN+KZqXcBpOuW=J_vyznOn03NceuH8RDdmcB30-7-9xyQw@mail.gmail.com> (sfid-20150107_153952_445561_A5BF7DBF)
References: <1420566070-25336-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1420639929.3407.18.camel@sipsolutions.net>
	 <CAA2SeN+KZqXcBpOuW=J_vyznOn03NceuH8RDdmcB30-7-9xyQw@mail.gmail.com>
	 (sfid-20150107_153952_445561_A5BF7DBF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-07 at 15:39 +0100, Lorenzo Bianconi wrote:

> > Does it really make sense to ask the driver to do "automatic"? After
> > all, there are other limits in mac80211 (like 11h from the AP and
> > regulatory) that need to be considered. So perhaps if userspace says
> > "automatic", the driver should still see only "limited"?
> >
> 
> IMHO "automatic" means lower driver has to take into account just
> channel/regulatory constraints (that is ath9k behavior), since the
> user/mac80211 does not cap TX power, whereas "limited" means the
> user/mac80211 has set a limit for emitted power, so that configuration
> has to be taken into account. 

Well, mac80211 always gives you a max TX power value though - and if
it's only the maximum regulatory permitted on that channel. So there's
always a valid upper bound - unlike the userspace API where "automatic"
means that you have no idea of an upper bound. Inside the kernel you
always have an upper bound, so "automatic" doesn't make that much sense?

johannes

