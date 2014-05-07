Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaEGIFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 04:05:30 -0400
Message-ID: <1399449912.5038.7.camel@jlt4.sipsolutions.net> (sfid-20140507_100535_326748_22B7BA73)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 07 May 2014 10:05:12 +0200
In-Reply-To: <CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com> (sfid-20140507_092538_232590_F21EEDE6)
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	 <1399387345.4218.44.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com>
	 (sfid-20140507_092538_232590_F21EEDE6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 09:25 +0200, Michal Kazior wrote:

> > Should csa_active really stay true in the reserved_chanctx case?
> > Wouldn't that leave it beaconing, with potentially suddenly negative
> > (due to underflow) CSA counter, or something?
> 
> Hmm.. I think drivers should check ieee80211_csa_is_complete() before
> calling to ieee80211_beacon_get(). At least that's what ath9k and
> ath10k effectively do now. Hwsim might complain though but this should
> be changed for multi-vif CSA. You may need to wait for other vifs to
> finish CS (the incompat case) so you shouldn't call
> ieee80211_beacon_get() after you get last CSA beacon on a given AP
> vif.

I don't think that works for all drivers - only drivers that actually
generate and tx each beacon - but other drivers just update a template.
We actually have some pending patches to make that work correctly for
the CSA counters, but I'm not really sure what you want to happen in the
case that one is switching while the other hasn't yet? Should it stop
beaconing? Seems like clients would give up the switch then, no?

> Btw. shouldn't csa_active be protected/synchronized between CPUs
> somehow? I think it's possible now to get inconsistencies and hit
> WARN_ONs due to that.

I suppose it should then, I didn't write it :)

johannes

