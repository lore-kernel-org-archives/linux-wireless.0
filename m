Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2IDQxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 12:53:52 -0400
Message-ID: <1346777666.3737.38.camel@jlt4.sipsolutions.net> (sfid-20120904_185355_873918_EDCB7DF3)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Date: Tue, 04 Sep 2012 18:54:26 +0200
In-Reply-To: <CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com> (sfid-20120904_184120_528116_7894DA18)
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	 <1346746298.3737.0.camel@jlt4.sipsolutions.net>
	 <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	 <20120904102204.GA2541@w1.fi>
	 <CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
	 <CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
	 <1346758521.3737.28.camel@jlt4.sipsolutions.net>
	 <CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
	 (sfid-20120904_184120_528116_7894DA18)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > I would guess that hardware *decryption* is faulty, maybe only one
> > action frame needs to be correct and so if one of them is nohwcrypt=1 it
> > still works?
> Yes, you are correct. Case 3 is working only accidentally not always
> if the mesh node loaded with nohwcrypt=1 is reboot. So, with following
> case is also not working.
> 
> mesh1: ath5k loaded without nohwcrypt=1 (with
> IEEE80211_KEY_FLAG_SW_MGMT enabled)
> mesh2: ath5k loaded without nohwcrypt=1 (with
> IEEE80211_KEY_FLAG_SW_MGMT enabled)
> 
> Can we conclude that unicast data frames get processed in hardware and
> robust unicast management frames get processed in software for CCMP
> are not working.

I'm sure robust management frames in software *are* working, but
obviously the KEY_FLAG_SW_MGMT only affects transmit, not receive, so
receiving may still be broken.

> By the way, current secured mesh requires the AES CMAC to be enabled.
> But without enabling IEEE80211_HW_MFP_CAPABLE, the key cannot be added
> since this cipher suite is considered not supported. But actually AES
> CMAC can be done in software. Any work around on this?

Well, that's a separate question. Of course we could enable it, but what
would the point be? You don't have CCM for management frames right now,
so CMAC is pretty useless? And if you had CCM for management frames, say
with the things discussed in the p54 thread, then you could just enable
both, right?

johannes

