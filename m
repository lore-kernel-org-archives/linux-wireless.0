Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2J2KGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 06:06:15 -0400
Message-ID: <1351505209.10925.30.camel@jlt4.sipsolutions.net> (sfid-20121029_110619_050188_A4AC1B8D)
Subject: Re: [RFC] mac80211: send deauth only with channel context
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Oct 2012 11:06:49 +0100
In-Reply-To: <CAB3XZEeTTAOO1DzPArvaSU-esTFeY7SLAMTkSt5vKD_QScK1vQ@mail.gmail.com> (sfid-20121029_104814_465327_CC7F0297)
References: <1351501949-20169-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEeTTAOO1DzPArvaSU-esTFeY7SLAMTkSt5vKD_QScK1vQ@mail.gmail.com>
	 (sfid-20121029_104814_465327_CC7F0297)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-29 at 11:48 +0200, Eliad Peller wrote:
> On Mon, Oct 29, 2012 at 11:12 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > When userspace asks to deauthenticate and we're just
> > authenticated (or still authenticating) send a deauth
> > frame instead of deleting the auth request.
> >
> why send a deauth if we are not authenticated yet?

Well we could have sent an auth frame already, for example. In fact we
most likely will have, unless we got stuck in probing the AP state.

> >         mutex_lock(&sdata->local->mtx);
> >         ieee80211_recalc_idle(sdata->local);
> >         mutex_unlock(&sdata->local->mtx);
> >
> > + out:
> > +       if (sent_frame)
> > +               __cfg80211_send_deauth(sdata->dev, frame_buf,
> > +                                      IEEE80211_DEAUTH_FRAME_LEN);
> > +
> 
> shouldn't the "out" label be before recalcing the idle state?

Yeah I suppose it should.

johannes

