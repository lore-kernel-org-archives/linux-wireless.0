Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43025 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab1CXUsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 16:48:23 -0400
Received: by vxi39 with SMTP id 39so334714vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 13:48:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300999277.3849.1.camel@jlt3.sipsolutions.net>
References: <201103232358.29966.helmut.schaa@googlemail.com>
	<201103241409.03170.helmut.schaa@googlemail.com>
	<1300972793.26265.2.camel@jlt3.sipsolutions.net>
	<201103241457.46343.helmut.schaa@googlemail.com>
	<1300987930.26265.6.camel@jlt3.sipsolutions.net>
	<AANLkTi=mFbtLbQwNX6ZnzW9_xn_CYUBvv98z3-ZT9uf0@mail.gmail.com>
	<1300999201.3849.0.camel@jlt3.sipsolutions.net>
	<1300999277.3849.1.camel@jlt3.sipsolutions.net>
Date: Thu, 24 Mar 2011 22:48:22 +0200
Message-ID: <AANLkTim_EAFQn=3TL8oS=fjDjADsO_S9v0cirQN+=VdY@mail.gmail.com>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 24, 2011 at 22:41, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-03-24 at 21:40 +0100, Johannes Berg wrote:
>> On Thu, 2011-03-24 at 22:38 +0200, Emmanuel Grumbach wrote:
>>
>> > >> STA -> AP  nullfunc PM=1
>> > >> AP -> STA  AMPDU (seqnr 3106 - 3112)
>> > >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> > >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> > >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> > >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> > >> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> > >> ...
>> > >> STA -> AP nullfunc PM=0
>> > >> ...
>> >
>> > Hold on, why do mac80211 send a frame to a sleeping station ?
>> > Am I stupid or is this buggy ?
>>
>> Heh, neither. This happens when the frame is already queued on the
>> hardware queue.
>
> Of course, most (sane) hardware/firmware designs have some way to avoid
> that race by having the device itself note the WAKE->SLEEP transition,
> and the requiring the driver to tell the device about the SLEEP->WAKE
> transition, which enables us to never do this (sending a frame to a
> station that is now asleep).
>

good point. For the same reasons, DELBA Deauth and friends are handled
in FW too...
