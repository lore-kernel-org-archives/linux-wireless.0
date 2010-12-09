Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f177.google.com ([209.85.216.177]:45824 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab0LIOef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:34:35 -0500
Received: by qyk27 with SMTP id 27so2109073qyk.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 06:34:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101209123841.GA31566@hash.localnet>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
 <201012061714.15863.br1@einfach.org> <AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com>
 <AANLkTimwprBJpnLM6_Qap1wSVboVJPQecAUgmzAnQhu-@mail.gmail.com>
 <AANLkTim5hESSHAMYNryUwak=D4tQetZJuDEK41Yq3A+L@mail.gmail.com> <20101209123841.GA31566@hash.localnet>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Fri, 10 Dec 2010 00:34:19 +1000
Message-ID: <AANLkTinmsG9NhiiigOrFZQUS+pdDaHSvxpN7JnjdUXs=@mail.gmail.com>
Subject: Re: ath5k: Weird Retransmission Behaviour
To: Bob Copeland <me@bobcopeland.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 9, 2010 at 10:38 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Thu, Dec 09, 2010 at 10:21:34AM +0100, Helmut Schaa wrote:
>> On Wed, Dec 8, 2010 at 10:53 PM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
>> > I only seem to have Minstrel as the only available Rate Control
>> > algorithm in my kernel config?
>>
>> PID is only selectable on embedded platforms:
>>
>> config MAC80211_RC_PID
>>         bool "PID controller based rate control algorithm" if EMBEDDED
>>
>> Just remove the "if EMBEDDED" from net/mac8011/Kconfig and retry.
>
> For what it's worth, I tested pid and minstrel a while ago with a
> modified mac80211_hwsim, and found minstrel to be quite a bit better
> at rate adaptation.  So while it may be worth testing out for this
> particular use case, minstrel is probably the way to go in general.

So, while I say this with no idea how to do it, might it be worth
fixing Minstrel so that it adheres to mac80211's maximum retry values?

Cheers,

Jonathan
>
> --
> Bob Copeland %% www.bobcopeland.com
>
>
