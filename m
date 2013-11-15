Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:39607 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3KOQ3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 11:29:16 -0500
Received: by mail-la0-f42.google.com with SMTP id ec20so2965654lab.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 08:29:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131114152146.GA30653@garbanzo.do-not-panic.com>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-2-git-send-email-mcgrof@do-not-panic.com>
 <1384377637.28806.14.camel@jlt4.sipsolutions.net> <20131114140505.GA19070@garbanzo.do-not-panic.com>
 <1384437774.13941.25.camel@jlt4.sipsolutions.net> <20131114151159.GA29954@garbanzo.do-not-panic.com>
 <1384441523.13941.35.camel@jlt4.sipsolutions.net> <20131114152146.GA30653@garbanzo.do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 15 Nov 2013 17:28:55 +0100
Message-ID: <CAB=NE6Uz8u6tUe7m=ZQdCo20mVM0Bp9NkMVwk1gx4zNBSQDeug@mail.gmail.com> (sfid-20131115_172920_026232_78ADB13D)
Subject: Re: [RFC 1/5] cfg80211: pass the wdev on the country IE regulatory hint
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>, sunitb <sunitb@qca.qualcomm.com>,
	rsunki <rsunki@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 4:21 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Thu, Nov 14, 2013 at 04:05:23PM +0100, Johannes Berg wrote:
>> On Thu, 2013-11-14 at 07:12 -0800, Luis R. Rodriguez wrote:
>>
>> > > But that's kinda unsafe. Might also be worth just making it a
>> > > void* to avoid people trying to use it.
>> >
>> > OK. I can see the cookie in theory race against the allocator
>> > releasing and creating a new wdev and it magically being
>> > the same pointer, but chances are really low of that.
>>
>> Hmm, good point, maybe it'd be better to clean it up on netdev
>> unregistration.
>
> Ah, the block notifier?

Actually that would be good to remove stale unprocessed reguatory
hints too :D gonna go for that.

  Luis
