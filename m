Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934411Ab1JELWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 07:22:46 -0400
Subject: Re: [RFC] mac80211: remove per band sta supported rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <20111005111507.GA2184@redhat.com>
References: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>
	 <1317123289.4082.12.camel@jlt3.sipsolutions.net>
	 <20110929150018.GA4554@redhat.com>
	 <1317740824.6741.22.camel@jlt3.sipsolutions.net>
	 <20111005111507.GA2184@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 13:22:42 +0200
Message-ID: <1317813762.4839.7.camel@jlt3.sipsolutions.net> (sfid-20111005_132249_250658_C3E2018D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-05 at 13:15 +0200, Stanislaw Gruszka wrote:

> > Yeah I was going to say ... the main purpose of this these days seems to
> > be catching this tx-on-wrong-band (which should be channel) ...
> 
> There is a old patch from Luis, which add channel to sta_info,
> http://www.spinics.net/lists/linux-wireless/msg56399.html
> I could incorporate it into my sta->supp_rates[BAND] removal patch,
> so we will not loose debuggability, but event extend it.

That seems tricky with CSA, I'm not sure I'd want to go there?
 
> > > 1) started at ieee80211_sta_connection_lost()
> > > https://bugzilla.redhat.com/show_bug.cgi?id=731365#c0
> > > could be fixed by:
> > > ieee80211_set_disassoc(..., false);
> > > ieee80211_send_deauth_disassoc(, false);
> > 
> > Why would this trigger the problem? Can we somehow lose connection while
> > already trying to connect to a new AP?
> 
> Not sure if I understand. I think that change should not influence
> new AP connection. Also if we really loose connection to old AP, not
> sending deauth/disassoc frames does not matter. It can have matter if
> for some reason old AP start to become available again, so we properly
> disassociate. But for such corner case we should rather not care.

True, but I'm not sure I understand how we can even run into the problem
in this scenario. How can we be on a different band when detecting that
the AP went away? No wonder it went away then ... we're on the wrong
band?!

johannes

