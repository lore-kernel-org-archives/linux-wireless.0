Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:44339 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYHGQpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 12:45:40 -0400
Received: by rv-out-0506.google.com with SMTP id k40so565443rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2008 09:45:39 -0700 (PDT)
Message-ID: <1ba2fa240808070945u961bdb5tb19eefe27a144729@mail.gmail.com> (sfid-20080807_184543_751985_F3C875C9)
Date: Thu, 7 Aug 2008 19:45:39 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fill start-sequence-number for BA session start
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1218090814.23048.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1218051926.23048.65.camel@johannes.berg>
	 <1ba2fa240808061542k7fd3e0dat61df0ee77710e463@mail.gmail.com>
	 <1218090814.23048.86.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 7, 2008 at 9:33 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-08-07 at 01:42 +0300, Tomas Winkler wrote:
>> On Wed, Aug 6, 2008 at 10:45 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > Otherwise, drivers are required to keep track of the sequence numbers
>> > themselves, and they really shouldn't be since we already do it for
>> > them. I'll fix the race once we figure out how this code should work
>> > at all, it's currently disabled.
>> >
>> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>>
>> Finally I know why nothing works in iwlwifi. This is most crucial
>> point of correct driver behavior.
>> There is direct  mapping between hw queue indexes and sequence numbers....
>> This is bad.
>
> Eh, this particular patch has nothing to do with iwlwifi at all because
> iwlwifi overrides all sequence numbers anyway.

I'm not referring to this patch but to expected behavior that was broken.
Second I'm not sure mac should keep track of sequence numbers. In
theory driver can drop packets in processing
and this may confuse sequence progress. I've already wrote about it...

Tomas
