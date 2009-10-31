Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:48004 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774AbZJaNkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 09:40:45 -0400
Received: by iwn10 with SMTP id 10so2712853iwn.4
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 06:40:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256996211.3555.131.camel@johannes.local>
References: <1256971237.3555.87.camel@johannes.local> <43e72e890910310635q6015cf3bq639426d5c1502454@mail.gmail.com>
	<1256996211.3555.131.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 31 Oct 2009 06:40:30 -0700
Message-ID: <43e72e890910310640p6855a87bk37d3c07697b158d1@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix NULL ptr deref
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Parag Warudkar <parag.lkml@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 31, 2009 at 6:36 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-10-31 at 06:35 -0700, Luis R. Rodriguez wrote:
>> On Fri, Oct 30, 2009 at 11:40 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> >  commit 211a4d12abf86fe0df4cd68fc6327cbb58f56f81
>> >  Author: Johannes Berg <johannes@sipsolutions.net>
>> >  Date:   Tue Oct 20 15:08:53 2009 +0900
>> >
>> >      cfg80211: sme: deauthenticate on assoc failure
>> >
>> > introduced a potential NULL pointer dereference that
>> > some people have been hitting for some reason -- the
>> > params.bssid pointer is not guaranteed to be non-NULL
>> > for what seems to be a race between various ways of
>> > reaching the same thing.
>> >
>> > While I'm trying to analyse the problem more let's
>> > first fix the crash. I think the real fix may be to
>> > avoid doing _anything_ if it ended up being NULL, but
>> > right now I'm not sure yet.
>> >
>> > I think
>> > http://bugzilla.kernel.org/show_bug.cgi?id=14342
>> > might also be this issue.
>> >
>> > Reported-by: Parag Warudkar <parag.lkml@gmail.com>
>> > Tested-by: Parag Warudkar <parag.lkml@gmail.com>
>> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>>
>> Do we know if this will also affect 2.6.32?
>
> I'm pretty sure -- have we got any changes to this code that are not
> in .32?

Not sure, I just wanted to make sure we fix .32 as well, that's all.

  Luis
