Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45807 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaFWMc5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 08:32:57 -0400
Message-ID: <1403526767.4418.24.camel@jlt4.sipsolutions.net> (sfid-20140623_143303_524832_41820031)
Subject: Re: [PATCH 2/2] ath10k: make core registering async
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 23 Jun 2014 14:32:47 +0200
In-Reply-To: <CA+BoTQ=fpkOZXVgJt-OWdgSFX1_sO1g1E=J-7NnOb+e6a30FVA@mail.gmail.com> (sfid-20140623_141748_927938_88A91E9A)
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	 <1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	 <1400769683.4174.25.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk=DU=-HzVo-XsQTpCt6CS7aXxQMy5hTyQ7qC56ebBLZQ@mail.gmail.com>
	 <1403524278.4418.19.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=fpkOZXVgJt-OWdgSFX1_sO1g1E=J-7NnOb+e6a30FVA@mail.gmail.com>
	 (sfid-20140623_141748_927938_88A91E9A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-23 at 14:17 +0200, Michal Kazior wrote:

> > Seems like to fix it we just need to get a module reference though? Can
> > a module put() itself though? Hmmm.
> 
> It seems some drivers use module_put(THIS_MODULE) and
> __module_get(THIS_MODULE), e.g. tun/tap driver.

I don't see how this isn't racy in similar ways though?

> But does this bump up the module refcount in such a way that an
> in-progress rmmod will wait/block until the refcount reaches 0?

It should, yes, but you race once you do module_put(), no?

johannes

