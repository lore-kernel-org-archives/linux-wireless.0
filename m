Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:23860 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYKFOl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:41:58 -0500
Received: by wf-out-1314.google.com with SMTP id 27so710058wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 06:41:57 -0800 (PST)
Message-ID: <1ba2fa240811060641xe70c29cgf4e8dbf36b29636@mail.gmail.com> (sfid-20081106_154201_339863_02DFA75F)
Date: Thu, 6 Nov 2008 16:41:57 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFT] iwlagn: remove pointless TX frame check
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225974603.3619.219.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223547733.22490.43.camel@johannes.berg>
	 <1ba2fa240810091308r167b9147p46f74421329a55c1@mail.gmail.com>
	 <1223630089.3930.71.camel@johannes.berg>
	 <1224794532.6002.73.camel@johannes.berg>
	 <1225974603.3619.219.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 6, 2008 at 2:30 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-10-23 at 22:42 +0200, Johannes Berg wrote:
>> On Fri, 2008-10-10 at 11:14 +0200, Johannes Berg wrote:
>>
>> > > NACK, the completion of association of mac80211 and iwlagn isn't fully
>> > > synchronized so there is still
>> > > a race.
>> >
>> > Can we fix that?
>>
>> Ping? Any idea _where_ the two can get desynchronized?
>
> Ping again. I like verifiable reasons for a "NACK".

I'm working on it right now. Practically instead of association check
what will  remain is check if everything is station is properly
configured. Meaning stations is configured in the set in the firmware
and rate scale is also set.
This will cover all modes. Need to implement sta_notify handler and
move some code from rate scaling to the driver.
There will be never full synchronization between mac80211 and the
driver about internal station state but the check might be very
simplified.

Thanks
Tomas
