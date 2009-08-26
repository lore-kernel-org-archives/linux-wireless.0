Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n8.bullet.re3.yahoo.com ([68.142.237.93]:24317 "HELO
	n8.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756496AbZHZNdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 09:33:39 -0400
Message-ID: <850984.89698.qm@web23108.mail.ird.yahoo.com>
Date: Wed, 26 Aug 2009 13:33:39 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
To: Hin-Tak Leung <hintak.leung@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1251277063.10667.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 26/8/09, Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2009-08-26 at 03:43 +0100,
> Hin-Tak Leung wrote:
> 
> > The rfkill event hard just goes 1 and 0 whenever I
> slide the switch,
> > regardless of what NM does . e.g. NM set to disable
> networking has no
> > effect on the 1/0 switch (it happens just depending on
> the slide
> > switch and nothing else), and nothing changes when NM
> noticed
> > rfkill'ed if down & decided to if'up and
> reassociate.
> 
> Right, I just wanted to make sure the switch could be
> correctly read
> while the interface is down.
> 
> > Basically the rfkill event state just depends on the
> slide switch,
> > regardless of NM (if it is set to enable wireless
> networking, it just
> > if up the device again; if it is set to disable, it
> just stayed
> > disable & the device stay down, but the event
> state continues to
> > respond to the slide switch).
> 
> Ok. But this isn't making a lot of sense to me, since
> cfg80211 should
> refuse to UP the device when it's rfkilled.
> 
> Or wait ... are you using compat-wireless?

Yes, I am. I mentioned this and did wonder if the _backport/ part in /sys/class is important.

Hin-Tak


      

