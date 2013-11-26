Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:34571 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab3KZPnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 10:43:25 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Karl Beldan <karl.beldan@gmail.com>
Subject: Re: [PATCH v3] mac80211_hwsim: claim CSA support for AP
Date: Tue, 26 Nov 2013 16:43:22 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1385111186-19551-1-git-send-email-karl.beldan@gmail.com> <20131122140533.GA24796@magnum.frso.rivierawaves.com> <20131123093844.GA3895@magnum.frso.rivierawaves.com>
In-Reply-To: <20131123093844.GA3895@magnum.frso.rivierawaves.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311261643.22536.sw@simonwunderlich.de> (sfid-20131126_164328_691144_E419BB5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Karl,
> Sorry, I was not very clear.
> What I meant is that, my change for hwsim is not correct because it
> assumed something like what's above that would prevent beacon_get() to
> return a beacon when csa is under completion. Instead, it should check
> for csa completion prior to getting the beacon.
> 
> Checking your ath9k change for CSA, I am under the impression this is
> possible ? : {{{
> ath9k_channel_switch_beacon()
> ath9k_beacon_tasklet()
>         ath9k_csa_is_finished() // ret false
> ..
> ath9k_beacon_tasklet()
>         ath9k_csa_is_finished() // sets sc->csa_vif to NULL, ret true
>                 ieee80211_csa_finish() // schedules csa work
> 
> ath9k_beacon_tasklet()
>         ath9k_csa_is_finished() // ret false because sc->csa_vif==NULL
> 
> csa_finalize_work() // too late
> }}}

Yeah, you are right, if the worker is too late ath9k still generates a beacon 
and will hit a warning that the csa was already finished. Actually that helped 
quite a lot while developing the feature.

In practice, I don't think it's that bad - the worker shouldn't take so long 
too respond, and also it does not hurt to generate/send the beacon one more 
time on the same channel with count = 0 (or 1). It's useful to get a warning 
in this case so that the root cause for the delay can be worked on.

What do you think? I can change that easily in ath9k otherwise. :)

Thanks,
   Simon
