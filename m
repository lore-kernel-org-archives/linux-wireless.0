Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaAVKcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:32:05 -0500
Message-ID: <1390386722.4334.28.camel@jlt4.sipsolutions.net> (sfid-20140122_113215_369177_D15DC93D)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 22 Jan 2014 11:32:02 +0100
In-Reply-To: <CA+BoTQ=7h5beyTa-8fF-7D+3uK8f9K+8-uJP0vG-GWOJiKJERw@mail.gmail.com> (sfid-20140122_112359_586693_C47E9651)
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	 <1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
	 <1390318236.6199.45.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ==WJPJV=t8=_CZAD5qyW3igAtaOcUz9hNCcvUPYH+jdA@mail.gmail.com>
	 <1390381261.4334.12.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmE3TdT=oQbAjzUi5vGo0FA0opz1S9Z6-9UEQ_miSEpXQ@mail.gmail.com>
	 <1390384700.4334.24.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=7h5beyTa-8fF-7D+3uK8f9K+8-uJP0vG-GWOJiKJERw@mail.gmail.com>
	 (sfid-20140122_112359_586693_C47E9651)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 11:23 +0100, Michal Kazior wrote:
> On 22 January 2014 10:58, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-01-22 at 10:40 +0100, Michal Kazior wrote:
> >> > That's true, so maybe you just need to explain this chandef thing
> >> > better? I don't really see the utility (admittedly without actually
> >> > checking carefully in the code where you need it)
> >>
> >> Since you can CSA multiple interfaces you can have different chandefs
> >> for those interfaces. This means you need to know the chandef for the
> >> final channel switch.
> >>
> >> You could probably cache this to local->csa_chandef when processing
> >> the channel switch request itself, but that means you explicitly limit
> >> yourself to single CSA against a given hw/driver.
> >>
> >> At one point I was contemplating having a dedicated structure for
> >> channel switches, and have a list of channel switch structures in
> >> ieee80211_local, but perhaps that's just an overkill.
> >
> > But if we bind all interfaces against a 'pending' chanctx, then that's
> > all implicit in that chanctx calculating/binding, no?
> 
> Correct.
> 
> Hmm. How do you bind a pending chanctx? Does this mean an interface
> can have two channel contexts - the current one, and the pending one?
> 
> I suppose you'd still need to iterate over interfaces (through
> local->interfaces or the [non-existent yet] chanctx->interfaces)
> anyway for validate/sanity check if the final switch is really okay,
> and/or possibly disconnect/stop some interfaces that didn't get a
> chance to request a channel switch (I'm thinking of your STA-CSA-GO
> case).

I'll have to let Luca answer this. :)

johannes

