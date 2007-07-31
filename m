Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45697 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761636AbXGaVGR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:06:17 -0400
Date: Tue, 31 Jul 2007 23:06:13 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Message-ID: <20070731230613.6d0a0856@logostar.upir.cz>
In-Reply-To: <200707302223.04696.flamingice@sourmilk.net>
References: <20070730023128.99E927B409F@zog.reactivated.net>
	<20070730225205.GA17252@deine-taler.de>
	<200707310105.55863.mb@bu3sch.de>
	<200707302223.04696.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Jul 2007 22:22:58 -0700, Michael Wu wrote:
> On Monday 30 July 2007 16:05, Michael Buesch wrote:
> > I suggest you look at bcm43xx-mac80211.
> > You will need to introduce refcounting for your monitor interfaces
> > and I _really_ suggest to get rid of the zd_op_open() and zd_op_close()
> > functions. Just include that in add/remove interface. You need
> > to refcount your interfaces anyway.
> >
> Requiring refcounting for monitor interfaces is fairly dumb since mac80211 
> does the exact same refcounting. I haven't bothered to do it in any driver 
> ports yet for this reason. This part of the mac80211 driver api needs to be 
> fixed.

Ouch, I thought we don't bother drivers with more than one monitor
interface at a time. Apparently I forgot to fix that.

> Also, I'm not entirely convinced that eliminating the open/close callbacks is 
> a good idea,

Why?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
