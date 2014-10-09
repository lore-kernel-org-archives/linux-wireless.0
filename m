Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65053 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaJIOpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 10:45:52 -0400
Received: by mail-wi0-f177.google.com with SMTP id fb4so2035647wid.4
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 07:45:51 -0700 (PDT)
Date: Thu, 9 Oct 2014 16:45:48 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211/trivial: fix typo in starting baserate for
 rts_cts_rate_idx
Message-ID: <20141009144548.GD20644@magnum.frso.rivierawaves.com> (sfid-20141009_164557_229286_3D756572)
References: <1412690018-18429-1-git-send-email-karl.beldan@gmail.com>
 <1412845586.1828.27.camel@jlt4.sipsolutions.net>
 <20141009140636.GC20644@magnum.frso.rivierawaves.com>
 <1412864103.1828.48.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1412864103.1828.48.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 09, 2014 at 04:15:03PM +0200, Johannes Berg wrote:
> On Thu, 2014-10-09 at 16:06 +0200, Karl Beldan wrote:
> > On Thu, Oct 09, 2014 at 11:06:26AM +0200, Johannes Berg wrote:
> > > On Tue, 2014-10-07 at 15:53 +0200, Karl Beldan wrote:
> > > > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > > 
> > > Is that really trivial? It seems to have some impact on the code, but I
> > > can't right now say exactly what the impact is. Can you describe it and
> > > say whether I should add it to mac80211 or mac80211-next? For "trivial"
> > > I'd probably say mac80211-next, but this might be more important than
> > > that?
> > > 
> > The typo is clearly showing but the faulty behavior clearly demands more
> > detail indeed.
> > 
> > It affects non-(V)HT rates and can lead to selecting an rts_cts rate
> > that is not a basic rate or way superior to the reference rate (ATM
> > rates[0] used for the 1st attempt of the protected frame data).
> > E.g, assuming the drivers register growing (bitrate) sorted
> > ieee80211_rate tables, having :
> > - rates[0].idx == d'2 and basic_rates == b'10100
> > will select rts_cts idx b'10011 & ~d'(BIT(2)-1), i.e. 1, likewise
> > - rates[0].idx == d'2 and basic_rates == b'10001 
> > will select rts_cts idx b'10000
> > The first is not a basic rate and the second is > rates[0].
> > 
> > I hope it clarifies things enough.
> 
> Well, I'm still not sure which tree I should put it in, I guess?
> 

All I can say is that nor this faulty behavior nor the correspond fix
are likely to cause a crash (we always tx registered rates).
 
Karl
