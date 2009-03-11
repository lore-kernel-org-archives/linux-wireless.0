Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59678 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbZCKRIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 13:08:21 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 10:08:20 -0700
Date: Wed, 11 Mar 2009 09:07:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v5 1/4] ath9k: implement IO serialization
Message-ID: <20090311160740.GB5669@tesla> (sfid-20090311_180825_146183_9994FEE6)
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com> <1236739953-17701-2-git-send-email-lrodriguez@atheros.com> <1236762611.9658.87.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1236762611.9658.87.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2009 at 02:10:11AM -0700, Johannes Berg wrote:
> On Tue, 2009-03-10 at 22:52 -0400, Luis R. Rodriguez wrote:
> 
> > +	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
> > +		unsigned long flags;
> > +		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
> > +		iowrite32(val, ah->ah_sc->mem + reg_offset);
> > +		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
> > +	} else
> > +		iowrite32(val, ah->ah_sc->mem + reg_offset);
> 
> This is utterly insane. Just make it _always_ do the spinlock, and get
> rid of the hotplug notifier and all that crap.

That is certainly an option as well but we would obviously be incurring
the lock on all reads/writes regardless of what bus you use which is
not necessary. We'll review this and determine whether its worth it.

  Luis
