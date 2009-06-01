Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63432 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZFAOFg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 10:05:36 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 07:05:39 -0700
Subject: Re: [PATCH] ath9k: Add sanity check for beacon_int in adhoc/mesh
 case
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Kalle Valo <kalle.valo@iki.fi>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87skikt72k.fsf@litku.valot.fi>
References: <20090528162528.GA8117@jm.kir.nu>
	 <87skikt72k.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Mon, 1 Jun 2009 17:05:35 +0300
Message-ID: <1243865135.1930.2.camel@jm-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-01 at 06:30 -0700, Kalle Valo wrote:
> Jouni Malinen <jouni.malinen@atheros.com> writes:
> 
> > +     /*
> > +      * It looks like mac80211 may end up using beacon interval of zero in
> > +      * some cases (at least for mesh point). Avoid getting into an
> > +      * infinite loop by using a bit safer value instead..
> > +      */
> > +     if (intval == 0)
> > +             intval = 100;
> 
> Maybe a big fat warning here would help with debugging the issue?

If we agree that this should never happen, such a thing could be added.
Though, it would probably be better to place that in mac80211 so that it
would catch the issue with any driver. The beacon_int=0 notification is
not really in any way specific to ath9k; only this workaround for driver
behavior is.

- Jouni


