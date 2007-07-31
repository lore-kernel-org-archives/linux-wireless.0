Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48665 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752340AbXGaWLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 18:11:00 -0400
Date: Wed, 1 Aug 2007 00:10:57 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Message-ID: <20070801001057.06c14503@logostar.upir.cz>
In-Reply-To: <200707312337.02137.mb@bu3sch.de>
References: <20070730023128.99E927B409F@zog.reactivated.net>
	<20070730225205.GA17252@deine-taler.de>
	<20070731230043.2cd80e2d@logostar.upir.cz>
	<200707312337.02137.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 31 Jul 2007 23:37:01 +0200, Michael Buesch wrote:
> On Tuesday 31 July 2007 23:00:43 Jiri Benc wrote:
> > It depends on the IEEE80211_HW_MONITOR_DURING_OPER flag in hw.flags. If you
> > set the flag in the driver, then monitor interfaces work in the exactly
> > same way as STA or IBSS interfaces - the add_interface callback is called
> > (with conf.type equal to IEEE80211_IF_TYPE_MNTR) whenever user brings up a
> > monitor interface. You are responsible for switching the card to a monitor
> > mode (e.g. turning off hardware packet filtering).
> 
> I think you don't want to completely turn off packet filtering
> (promisc) if a monitor interface is present. The promisc bit is to be
> honoured seperately.
> The only thing we do in bcm43xx is enable passing of ctl frames (ACKs, etc),
> if we have a monitor interface.

Hm, yes, you're right. I didn't realize that, thanks!

> > As Michael correctly said, don't care about the value, just store it and
> > hand it back to the stack when the stack wants it.
> 
> That might raise the question, if it's required to store if_ids of monitor
> interfaces. I think it's not, as you don't need any mac80211 callback,
> that requires an if_id, for a monitor interface.

Sure. If you don't need to call any callback which requires if_id (and
currently there is no such callback you can call for a monitor interface),
there is no point in storing the value. But it's also no harm.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
