Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752149AbeEOFEm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 01:04:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: srirrama@codeaurora.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
        <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
        <CAJ-VmonSEuh7Ou=K9Gu-gZ5ikpX9H=nzXe9NssNu1vw8fEk3hg@mail.gmail.com>
        <87h8naqel1.fsf@kamboji.qca.qualcomm.com>
        <CAJ-VmomNrjdEZ+UCH5rmth=2yE9utfM3FUTEy2a0zpq0r44Zig@mail.gmail.com>
Date: Tue, 15 May 2018 08:04:37 +0300
In-Reply-To: <CAJ-VmomNrjdEZ+UCH5rmth=2yE9utfM3FUTEy2a0zpq0r44Zig@mail.gmail.com>
        (Adrian Chadd's message of "Mon, 14 May 2018 14:13:13 -0700")
Message-ID: <87y3gla4re.fsf@codeaurora.org> (sfid-20180515_070551_946585_D690AC54)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

> On Mon, 14 May 2018 at 11:25, Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Adrian Chadd <adrian@freebsd.org> writes:
>
>> > May we have a little more information about how this is supposed to
> work?
>> >
>> > It looks like we're supposed to send the information about the matched
>> > radar pattern back to the firmware for confirmation? What's the intended
>> > behaviour from the firmware? Will the firmware have a hard-coded set of
>> > patterns we have to answer in/by?
>
>> That's really an implementation detail inside the firmware and from
>> ath10k point of view we don't care what checks the firmware has, we just
>> provide all the necessary information. The checks in firmware might even
>> change in later releases.
>
>> > I ask (like Peter, we work together) because we've had to tweak this
>> > behaviour a little to actually pass FCC / ETSI DFS certification. My
>> > general concern is that this'll cause a lot of false detects on boards
> that
>> > haven't had things tweaked for the given board. As far as I'm aware the
> DFS
>> > parameters are still hard-coded into the firmware image so if you have
> to
>> > change those you're SOL without the relevant NDAs - this makes running
> the
>> > open source DFS stuff a little tricksy on vendor boards.
>
>> This shouldn't cause more false detections, the pattern detection from
>> ath.ko is still used as before. The firmware will just disable DFS
>> altogether if it thinks ath10k is not compliant.
>
>
> Heh, well the fun one for production for us is "ok, so what's
> non-compliant" ?
>
> Eg - if it's 1 out of 100 that we don't hit the explicit timing
> requirements because of the rest of the linux kernel (eg someone holds a
> spinlock more than they should) then I'd prefer that we got a notification
> that something happened so we can fix it. Otherwise in the field it'll just
> be "hey, our stuff stopped working" because whatever the firmware
> expectations are aren't being met.
>
> Again, we're OK because we can at least inspect what's going on, but not
> everyone doing ath10k development/deployment will be so lucky :(

Sure, every software change can cause regressions. But the thing is that
this isn't an optional, ath10k has to have this to be able to continue
using DFS channels.

-- 
Kalle Valo
