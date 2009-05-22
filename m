Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:65411 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZEVAga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 20:36:30 -0400
Received: by pzk7 with SMTP id 7so973116pzk.33
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 17:36:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242951611.5206.9.camel@maxim-laptop>
References: <1241499867.4816.18.camel@maxim-laptop> <1242256104.3241.4.camel@maxim-laptop>
	<43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	<1242256950.3241.13.camel@maxim-laptop> <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
	<1242258469.3241.19.camel@maxim-laptop> <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com>
	<b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com>
	<1242742647.23110.10.camel@ibm172> <1242951611.5206.9.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 21 May 2009 17:36:12 -0700
Message-ID: <43e72e890905211736i3dfaf7d5q78d511eac0fbca1e@mail.gmail.com>
Subject: Re: [BUG] Crda oopses the system
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 5:20 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Tue, 2009-05-19 at 17:17 +0300, Maxim Levitsky wrote:
>> On Thu, 2009-05-14 at 10:20 -0400, Bob Copeland wrote:
>> > On Wed, May 13, 2009 at 8:07 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> > >>
>> > >> I wish I had time to set up, an ath5k in AP mode. There are rumors that
>> > >> it works more or less now, then I could use the same beacon frame to
>> > >> test.
>> > >
>> > > It does and if it doesn't its a bug.
>> >
>> > Just FYI, it's known to have problems if the STA uses power saving --
>> > ath5k never updates the beacon.  I have a patch that should work in the
>> > relevant bugzilla but I haven't been back to retest it (at first I
>> > thought it was causing hangs, but later realized the hangs were due to
>> > other bugs in w-t).
>> >
>>
>
> I was just able to reproduce that bug on latest wireless-testing that I
> belive contains the patches you sent for me to test.

Latest wireless-testing *does* have those patches.

> I reproduced it against ath5k running in AP mode at home.
>
> I finally made the ath5k send beacons (although not much works besides
> this).
>
>
> Note that I noticed that this bug

You can get an oops when trying to associate to your ath5k AP? And its
easily reproducible? What driver to you use as the STA? Can you
provide a trace?

> happens once at boot, if I set NM to
> use system settings,

What does this mean?

> when I try to connect again it doesn't happen. Its
> a race condition after all.

Is the oops not crashing your box? How are you able to try again? What
does trying again mean?

  Luis
