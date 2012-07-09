Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2GIRJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 13:09:36 -0400
Message-ID: <1341853775.4455.53.camel@jlt3.sipsolutions.net> (sfid-20120709_190942_251398_FD5BB0B2)
Subject: Re: [PATCH v2] mac80211: fix invalid band deref building preq IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 19:09:35 +0200
In-Reply-To: <CA+XVXfc0EDA3LxxT2vp=E1An4=Y8egXOgJB9y4s0-Pw2ZjujBg@mail.gmail.com> (sfid-20120709_190508_628734_2FA6799D)
References: <1341853048-12150-1-git-send-email-arik@wizery.com>
	 <1341853186.4455.52.camel@jlt3.sipsolutions.net>
	 <CA+XVXfc0EDA3LxxT2vp=E1An4=Y8egXOgJB9y4s0-Pw2ZjujBg@mail.gmail.com>
	 (sfid-20120709_190508_628734_2FA6799D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 20:04 +0300, Arik Nemtsov wrote:
> On Mon, Jul 9, 2012 at 7:59 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2012-07-09 at 19:57 +0300, Arik Nemtsov wrote:
> >> The function building probe-request IEs does not validate the band is
> >> supported before dereferencing it. This can result in a panic when
> >> all bands are traversed, as done during sched-scan start.
> >>
> >> Warn when this happens and return an empty probe request. Also fix
> >> sched-scan to not waste memory on unsupported bands.
> >>
> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> >> ---
> >> better? :)
> >
> > Yeah I'll apply this :-)
> >
> > I do wonder though why we even bother building probe request IEs for a
> > band if no channels from it are listed in the sched scan request.
> 
> It's a bit complicated to know this, because of how the request is
> structured (have to traverse all the channels etc).
> The memory waste is not so bad anyway I guess.

Yeah but we could just iterate all the channels and build the probe
request IEs for each channel's band unless we did before? Anyway, it
doesn't matter, something for another day maybe :)

johannes

