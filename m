Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56964
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843AbXIKUzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 16:55:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Date: Tue, 11 Sep 2007 22:52:44 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
References: <1188875058.13078.428.camel@debian.sh.intel.com> <1189506221.6161.9.camel@johannes.berg> <1ba2fa240709111037u1d48ef25ndf9583ee7dd7635e@mail.gmail.com>
In-Reply-To: <1ba2fa240709111037u1d48ef25ndf9583ee7dd7635e@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200709112252.45020.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 September 2007 19:37:40 Tomas Winkler wrote:
> On 9/11/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2007-09-10 at 17:20 +0300, Tomas Winkler wrote:
> >
> > > It is my best intention yet first we need native interface which make
> > > in turn problems in eb tables. So it is a long shot.
> >
> > Ok. We've managed long enough without it so I guess we can wait :)
> >
> > > I wouldn't appreciate this at all. 11n is major feature of our NIC.
> > > Major obstacle in finally pushing 11n is constant  code base change of
> > > iwlwifi. This is already 4th  code base. The latest was because the
> > > driver didn't look nice enough, what an engineering   reason! In the
> > > bottom line we are hunting our own tail for wrong reasons
> >
> > Well, I believe that there are bad layering violations in your current
> > driver, namely looking at the packets mac80211 sends, doing 11N
> > manipulations and everything in the driver and duplicating the sta_info
> > stuff because mac80211 happens to be missing a few hooks. If you think
> > those are "wrong reasons" that's fine with me.
> 
> There is no doubt that what you currently see is ugly, we reworked the
> code and added these few hooks the problem is that they don't apply
> anymore  to recent code, since I'm stabilizing basic flows after each
> code base in the middle of development.
> I know I'm not 'release often' complained but I really test the code
> that I'm publishing, it takes time.
> I prefer to have stable driver and fix it step by step then releasing
> 30 patches that nobody have time to consume and review in addition it
> just kills the functionality. Don't know maybe I'm too old for Linux
> :)

Well, if you post the patches to get included into wireless-dev,
people will start testing them. So they test them im parallel
with you (you will do your testing of course as well).
Of course you do some basic testing before releasing the patches,
such as "does it compile" or "does the card basically still work".
But with this you get _more_ review and testing. That's the whole
point of "release early and often".
Testing early-released patches is SMP, while testing alone is UP. ;)

> > Personally, I'm just raising these points and marking them down as
> > "against merging as-is". If others don't care about them, that's ok with
> > me.
> >
> After all it is functional driver. It gets ~60Mps in TCP even more.

Well, lots of other functional stuff was rejected, because it was
simply ugly and a maintanance hell. (I'm not saying that your driver
is such a thing. I didn't look at it, yet).

-- 
Greetings Michael.
