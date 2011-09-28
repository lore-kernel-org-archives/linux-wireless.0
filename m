Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab1I1HK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 03:10:58 -0400
Subject: Re: [RFC 04/15] mac80211: split PS buffers into ACs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB=NE6Wi1EJtyW=4kCNTgdhjzzgTMT3N7xhgKu+AWd9cphcD5Q@mail.gmail.com> (sfid-20110927_225152_449291_118F1AA2)
References: <20110922154726.521122680@sipsolutions.net>
	 <20110922154849.648785480@sipsolutions.net>
	 <CAB=NE6Wi1EJtyW=4kCNTgdhjzzgTMT3N7xhgKu+AWd9cphcD5Q@mail.gmail.com>
	 (sfid-20110927_225152_449291_118F1AA2)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 09:10:55 +0200
Message-ID: <1317193855.3986.4.camel@jlt3.sipsolutions.net> (sfid-20110928_091101_937344_83C176EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-27 at 13:51 -0700, Luis R. Rodriguez wrote:

> > +       /*
> > +        * If all ACs are delivery-enabled then we should build
> > +        * the TIM bit for all ACs anyway; if only some are then
> > +        * we ignore those and build the TIM bit using only the
> > +        * non-enabled ones.
> > +        */
> 
> As per the documentation uapsd_queues is the "bitmap of queues
> configured for uapsd". As I read this we are ignoring setting the TIM
> for the STA if an AC queue was marked as uapsd-enabled but had
> buffered frames for it, so we'd only set the TIM if we had at least
> one AC queue that did not have uapsd enabled and had buffered frames
> pending. Is that accurate?

Almost.

First of all, we need to differentiate between delivery- and
trigger-enabled, which currently we don't. Since this only happens with
TSPEC, we're not worried about that right now, but it's good to keep it
in mind. So right now, the uapsd_queues bitmap marks those that are both
trigger- and delivery-enabled.

Now, to the TIM bit: when *all* ACs are delivery-enabled, the TIM bit
will be set from all ACs. This is the case you missed. When only some of
the ACs are delivery-enabled, the delivery-enabled ACs are ignored for
purposes of setting the TIM bit. This is what you described.

This is described in 11.2.1.5 (IIRC).

johannes

