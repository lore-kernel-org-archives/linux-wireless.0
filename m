Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45993 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbaFWOLQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 10:11:16 -0400
Message-ID: <1403532659.4418.30.camel@jlt4.sipsolutions.net> (sfid-20140623_161119_529008_D0B6C488)
Subject: Re: [PATCH 2/2] ath10k: make core registering async
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 23 Jun 2014 16:10:59 +0200
In-Reply-To: <CA+BoTQnvRgfObtvJcVj3np6LSRSHr_2uEfqRpOw59fuy88xnYQ@mail.gmail.com> (sfid-20140623_145946_117384_07F493F0)
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	 <1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	 <1400769683.4174.25.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk=DU=-HzVo-XsQTpCt6CS7aXxQMy5hTyQ7qC56ebBLZQ@mail.gmail.com>
	 <1403524278.4418.19.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=fpkOZXVgJt-OWdgSFX1_sO1g1E=J-7NnOb+e6a30FVA@mail.gmail.com>
	 <1403526767.4418.24.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnvRgfObtvJcVj3np6LSRSHr_2uEfqRpOw59fuy88xnYQ@mail.gmail.com>
	 (sfid-20140623_145946_117384_07F493F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-23 at 14:59 +0200, Michal Kazior wrote:
> >> But does this bump up the module refcount in such a way that an
> >> in-progress rmmod will wait/block until the refcount reaches 0?
> >
> > It should, yes, but you race once you do module_put(), no?
> 
> It's still racy, I agree.
> 
> I don't see how device_release_driver() can be made work synchronously
> at all. It should, however, be perfectly fine if this was an async
> request to release a device/driver, right?

Yeah, but the work struct would have to live somewhere that can't be
unloaded, or can more safely wait for it...

I guess we could also have a list of these in the modules and
synchronize on them in module_exit()?

johannes

