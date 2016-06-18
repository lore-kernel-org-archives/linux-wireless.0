Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39321 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbcFRXga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2016 19:36:30 -0400
Date: Sun, 19 Jun 2016 01:36:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com,
	linux-wireless@vger.kernel.org
Subject: Re: N900, wl1251: wifi is now slow, even with powersave off
Message-ID: <20160618233627.GA10225@amd> (sfid-20160619_013702_805249_BA393BA8)
References: <20160618155946.GA16792@amd>
 <20160618225554.GA27771@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160618225554.GA27771@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 2016-06-19 00:55:54, Pavel Machek wrote:
> Hi!
> 
> > Ping to N900:
> > 
> > 64 bytes from maemo (10.0.0.8): icmp_seq=187 ttl=64 time=124 ms
> > rtt min/avg/max/mdev = 4.382/101.866/453.145/42.395 ms
> > root@duo:/data/pavel#
> > 
> > Now on n900:
> > 
> > pavel@n900:/my/tui/ofone$ sudo iw dev wlan0 set power_save off
> > pavel@n900:/my/tui/ofone$
> > 
> > That should bring ping back to < 2 msec range, but nothing changes:
> > 
> > root@duo:/data/pavel# ping maemo
> > PING maemo (10.0.0.8) 56(84) bytes of data.
> > 64 bytes from maemo (10.0.0.8): icmp_seq=1 ttl=64 time=78.5 ms
> > rtt min/avg/max/mdev = 18.298/68.025/118.223/30.756 ms
> > root@duo:/data/pavel#
> > 
> > Any ideas what is going on there?
> 
> v4.4: works ok, rtt min/avg/max/mdev = 2.111/2.243/2.524/0.150 ms
> v4.5-rc0: can't get wifi to work.
v4.5: slow as described.
> v4.6: slow as described.
> v4.7-rc3: slow as described.

Hmm. If wifi is truly broken in -rc0, I'm looking for some fun bisect
:-(.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
