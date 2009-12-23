Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49868 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbZLWCjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 21:39:22 -0500
Received: by iwn1 with SMTP id 1so4865799iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 18:39:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19249.32300.243423.92179@gargle.gargle.HOWL>
References: <20091222022355.GA32508@bombadil.infradead.org>
	<19248.19829.293087.367661@gargle.gargle.HOWL> <20091222155005.GA4385@tux>
	<20091222162055.GC4385@tux> <20091222165528.GE4385@tux> <19249.32300.243423.92179@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Dec 2009 18:39:01 -0800
Message-ID: <43e72e890912221839y48e3228l6f422a3771a71c92@mail.gmail.com>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 6:19 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> (Trimming CC List)
>
> Luis Rodriguez wrote:
>> > Here's the new log with 0x601, with a few pm-suspend successes above.
>
> The only issue here is a call to wakeup the chip comes
> after the ->stop() callback. And that happens here:
>
>> > [  271.448580] Freezing user space processes ... (elapsed 0.00 seconds) done.
>> > [  271.450215] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
>> > [  271.450296] PM: Entering mem sleep
>> > [  271.450321] Suspending console(s) (use no_console_suspend to debug)
>> > [  271.456054] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
>> > [  271.456073] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
>> > [  271.456112] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
>> > [  271.456141] ath9k: Detach Interface
>> > [  271.456161] ath9k: NETWORK SLEEP -> AWAKE
>> > [  271.458525] ath9k: AWAKE -> NETWORK SLEEP
>> > [  271.458533] ath9k: NETWORK SLEEP -> FULL-SLEEP
>> > [  271.458544] ath9k:
>> > [  271.458547] ath9k: Driver halt
>> > [  271.458552] FULL-SLEEP -> AWAKE
>
> The actual issue then lies in the callsite, probably mac80211 - having stopped
> the driver (during suspend), any notifications/calls to the driver are invalid.
>
> But strange that I am not able to reproduce this.

I wasn't able to reproduce at home, only at work in a busy
environment, but can't say I tested that much at home.

> What distribution are you using ? Also, the version of NM ?

I'm on Ubuntu 9.10, I'm not using NM though, I'm running
wpa_supplicant manually. To reproduce I had to force wpa_supplicant to
remain connected. wpa_supplicant does this if not interrupted. NM will
instead deauth and disassoc you prior to suspend.

Have you tried using wpa_supplicant alone?

  Luis
