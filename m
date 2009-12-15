Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59119 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbZLOWH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 17:07:57 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 14:07:57 -0800
Date: Tue, 15 Dec 2009 14:07:56 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?utf-8?B?THVrw6HFoQ==?= Turek <8an@praha12.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Implement mac80211 callback
 set_coverage_class
Message-ID: <20091215220756.GD2067@tux>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
 <1260899813-17585-6-git-send-email-8an@praha12.net>
 <20091215185016.GB2123@tux>
 <200912152235.01490.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <200912152235.01490.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 01:35:01PM -0800, Lukáš Turek wrote:
> On 15.12.2009 19:50 you wrote:
> > Can you move this last line setting the sc->ah->ah_coverage_class
> > to ath5k_hw_set_coverage_class() instead?
> ath5k_hw_set_coverage_class() is also called after interface reset:
> ath5k_hw_set_coverage_class(ah, ah->ah_coverage_class);
> 
> So it would be quite strange if it set the value again...
> But I see your point, and don't see a better solution.

What I meant was not for you to pass the ah->ah_coverage_class to
ath5k_hw_set_coverage_class() but instead to pass the value obtained
from mac80211 and let ath5k_hw_set_coverage_class() itself set it on
ah.

> > Also -- if an ath_hw_set_coverage_class(common, coverage_class) can be
> > defined on drivers/net/wireless/ath/hw.c along with:
> >
> > ath_hw_set_slot_time(common, slot_time),
> > ath_hw_set_ack_timeout(common, ack_timeout);
> > ath_hw_set_cts_timeout(common, cts_timeout);
>
> Unfortunately the functions are really hardware specific, they write a 
> register that even differs between chip versions, and also depend on chip 
> clock rate.

Thanks for checking, I just wanted to elaborate as to how we can share code
and to because of that it seems like a good idea to remain consistant and
treat settings ah-> variables in hw code alone.

The less we muck with ah-> settings on base.c for ath5k the more well kept
and separated the actual hw code is. This really will only serve purpose
to later merge mow hw code between ath9k/ath5k. How much we end up sharing
remains to be seen, I don't mind the current split we have but if we do
see something obviously common it makes sense to just stuff it in when we
get a chance to ath.

> It would be possible to move ath_hw_set_coverage_class() to ath to share the 
> calculation, but that would require exporting six functions from the modules.
> 
> > Wonder if ar9170 can support setting these too.
>
> It seems it supports setting slot time, but I don't see a register with ACK 
> timeout, which is required too.

Thanks for checking, I was lazy, and just curious. Reason for asking was if
it could use at least caching the coverage class a hardware parameter we
can stuff it into ath_common just as we do with the bssid_mask and stuff.
Even if its just shared between ath5k and ath9k its still worth stashing it
there if both will use it.

Since tuning cts timeout, ack timouet and slot time may not be an operation
which we do that often it would still not be so bad to just stuff a generic
helper for ath5k/ath9k into ath which will handle the different hw revisions
itself.

  Luis
