Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57512 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3K0KxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 05:53:13 -0500
Received: by mail-wg0-f45.google.com with SMTP id y10so4807400wgg.12
        for <linux-wireless@vger.kernel.org>; Wed, 27 Nov 2013 02:53:12 -0800 (PST)
Date: Wed, 27 Nov 2013 11:52:23 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] mac80211_hwsim: claim CSA support for AP
Message-ID: <20131127105223.GA7446@magnum.frso.rivierawaves.com> (sfid-20131127_115316_927098_6D05AE82)
References: <1385111186-19551-1-git-send-email-karl.beldan@gmail.com>
 <20131122140533.GA24796@magnum.frso.rivierawaves.com>
 <20131123093844.GA3895@magnum.frso.rivierawaves.com>
 <201311261643.22536.sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201311261643.22536.sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 26, 2013 at 04:43:22PM +0100, Simon Wunderlich wrote:
> Hey Karl,
> > Sorry, I was not very clear.
> > What I meant is that, my change for hwsim is not correct because it
> > assumed something like what's above that would prevent beacon_get() to
> > return a beacon when csa is under completion. Instead, it should check
> > for csa completion prior to getting the beacon.
> > 
> > Checking your ath9k change for CSA, I am under the impression this is
> > possible ? : {{{
> > ath9k_channel_switch_beacon()
> > ath9k_beacon_tasklet()
> >         ath9k_csa_is_finished() // ret false
> > ..
> > ath9k_beacon_tasklet()
> >         ath9k_csa_is_finished() // sets sc->csa_vif to NULL, ret true
> >                 ieee80211_csa_finish() // schedules csa work
> > 
> > ath9k_beacon_tasklet()
> >         ath9k_csa_is_finished() // ret false because sc->csa_vif==NULL
> > 
> > csa_finalize_work() // too late
> > }}}
> 
> Yeah, you are right, if the worker is too late ath9k still generates a beacon 
> and will hit a warning that the csa was already finished. Actually that helped 
> quite a lot while developing the feature.
> 
> In practice, I don't think it's that bad - the worker shouldn't take so long 
> too respond, and also it does not hurt to generate/send the beacon one more 
> time on the same channel with count = 0 (or 1). It's useful to get a warning 
> in this case so that the root cause for the delay can be worked on.
> 
I think it's always nice to add a clean-room use of a new stack feature.
I was more expecting a WARN_ON(!vif && vif->csa_active) in the driver
than hitting a "forbidden" path in the stack.
The v4 I sent for hwsim is immune to this race but I'd have expected the
CSA code to handle this (e.g. with a vif->csa_finishing, or by letting
ieee80211_beacon_get* return an ERR_PTR) since many drivers would? have
to do this ATM.

> What do you think? I can change that easily in ath9k otherwise. :)
> 
I have no strong opinion on this, no pb with me keeping it as is, plus
CSA being a recent addition, I doubt new ideas won't chime in.
 
Karl
