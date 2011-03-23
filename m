Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39172 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab1CWJvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 05:51:21 -0400
Subject: Re: [RFC 0/9] add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinzRQHq8Zwvua2Zsnz2OjW4_e9L_YAkMxSwnS5j@mail.gmail.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
	 <1300806782.3746.41.camel@jlt3.sipsolutions.net>
	 <AANLkTinzRQHq8Zwvua2Zsnz2OjW4_e9L_YAkMxSwnS5j@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 10:51:15 +0100
Message-ID: <1300873875.3790.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-23 at 11:40 +0200, Eliad Peller wrote:

> > Regardless of how suspend works, the device may need special
> > configuration (e.g. wakeup patterns [1], rekeying information or
> > similar), in our case it even needs special firmware uploaded. Suspend
> > might also only be possible in certain configurations, like being
> > associated with exactly one AP, and not while operating as an AP, for
> > example.
> >
> as Ohad noted, we do need to be able to suspend while operating as AP
> (which is possible as the beaconing is done in the fw), at least with
> our model.
> i can also think of use cases in which it will be useful to have a
> suspended AP also in standard wowlan - like letting the ap go to sleep
> while there are no clients, and waking it up on a directed probe
> request.

Yeah, I was more using that as an example -- our device can't do it at
this point afaik (but I'm not entirely sure).

> > Again, the solution might be a suspend agent that will configure the
> > system in a way that suspend is possible. But how can it tell that
> > suspend will be possible? Between the different possible models, there
> > can be a lot of variety. We can expose those, but what will userspace do
> > with the information? Do we require that it configures the device in a
> > way that it can suspend, or do we do that in the drivers?
> 
> maybe we can add each trigger an additional parameter which describes
> whether this
> trigger is optional (when applicable) or mandatory (which will abort
> the suspend if it can't be configured)?

Yeah that's a good idea, that way userspace can tell what it needs and
wants more specifically than a global flag would be. It will know of
course that it can never configure magic packet when the device doesn't
support that, but when it is supported and the connection drops in the
meantime ...

johannes

