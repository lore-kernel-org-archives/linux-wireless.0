Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:62435 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018AbZC1VGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 17:06:23 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1932472wff.4
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2009 14:06:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238272957.4217.28.camel@johannes.local>
References: <20090323162834.154525349@sipsolutions.net> <20090323163053.344441542@sipsolutions.net>
	<20090328045529.GF5543@bombadil.infradead.org> <1238262118.4217.13.camel@johannes.local>
	<43e72e890903281218s6b4eeb9eu4a97aa3e87c5a3a6@mail.gmail.com>
	<1238269957.4217.24.camel@johannes.local> <43e72e890903281326j1bba2456j3b82bf3831b614f6@mail.gmail.com>
	<1238272957.4217.28.camel@johannes.local>
Date: Sat, 28 Mar 2009 14:06:06 -0700
Message-ID: <43e72e890903281406w528719b1vda8128255f1ac707@mail.gmail.com> (sfid-20090328_220626_884974_31B8A714)
Subject: Re: [PATCH 7/8] mac80211: fix aggregation to not require queue stop
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 28, 2009 at 1:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-03-28 at 13:26 -0700, Luis R. Rodriguez wrote:

>> >> OK I see that but I am not sure of what's done to the skb in the old
>> >> case if the session is note complete yet, nor now if the session gets
>> >> declined. I can check later, right now I'm feeling lazy.
>> >
>> > Before my patch the skb is still passed to the driver, which would need
>> > to be able to handle it (it == session being stopped). I'm not entirely
>> > sure ath9k handles it properly but I suspect it does.
>>
>> Not sure, this begs the question when you were seeing the received
>> addba response come up first. SInce both iwlagn and ath9k use the irq
>> safe aggregation cb I was suspecting this would happen in general on
>> UP boxen and probably even less likely to happen on ath9k as we don't
>> have to talk to the firmware during the ampdu start action.
>
> No, it can only happen when the remote station is faster to reply than
> the driver.

My point was that if you have the tasklet handled by a separate CPU
the DRV flag would most likely be set by the time the addba response
comes back. On a UP box though you have no option but to wait for wait
for it to be done after we send off the addba request so then it is a
race between the scheduler to schedule the tasklet and the remote
station's speed + the IRQ processing of the received response.

If we would somehow be able to ensure pending BHs complete before we
process the addba response this wouldn't be needed in both places.

Anyway I'm also stating that its likely that the ampdu start action is
slower with iwlagn as interaction with the firmware is required so I
would suspect one can see this behavior more likely on UP iwlagn
boxen.

Where did you see it?

  Luis
