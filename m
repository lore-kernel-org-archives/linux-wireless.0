Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4270 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0LIMwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 07:52:41 -0500
Date: Thu, 9 Dec 2010 07:38:41 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Jonathan Guerin <jonathan@guerin.id.au>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>, nbd@openwrt.org
Subject: Re: ath5k: Weird Retransmission Behaviour
Message-ID: <20101209123841.GA31566@hash.localnet>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com> <201012061714.15863.br1@einfach.org> <AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com> <AANLkTimwprBJpnLM6_Qap1wSVboVJPQecAUgmzAnQhu-@mail.gmail.com> <AANLkTim5hESSHAMYNryUwak=D4tQetZJuDEK41Yq3A+L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTim5hESSHAMYNryUwak=D4tQetZJuDEK41Yq3A+L@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 09, 2010 at 10:21:34AM +0100, Helmut Schaa wrote:
> On Wed, Dec 8, 2010 at 10:53 PM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
> > I only seem to have Minstrel as the only available Rate Control
> > algorithm in my kernel config?
> 
> PID is only selectable on embedded platforms:
> 
> config MAC80211_RC_PID
>         bool "PID controller based rate control algorithm" if EMBEDDED
> 
> Just remove the "if EMBEDDED" from net/mac8011/Kconfig and retry.

For what it's worth, I tested pid and minstrel a while ago with a
modified mac80211_hwsim, and found minstrel to be quite a bit better
at rate adaptation.  So while it may be worth testing out for this
particular use case, minstrel is probably the way to go in general.

-- 
Bob Copeland %% www.bobcopeland.com

