Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63322 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab1EKVjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 17:39:12 -0400
Received: by pzk9 with SMTP id 9so428282pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 14:39:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305132500.17892.1.camel@jlt3.sipsolutions.net>
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	<4DC81A61.9080101@candelatech.com>
	<1304959783.12202.7.camel@jlt3.sipsolutions.net>
	<BANLkTinHqMi=sy=sEzQPTz4QEsoucQXYVA@mail.gmail.com>
	<1305132500.17892.1.camel@jlt3.sipsolutions.net>
Date: Wed, 11 May 2011 23:39:11 +0200
Message-ID: <BANLkTikL0iLEWcseFdq572rZcVxVkKg8Hg@mail.gmail.com> (sfid-20110511_233916_023246_42915847)
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/11 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2011-05-11 at 17:58 +0200, Björn Smedman wrote:
>
>> > Yes, in theory that's possible, but apparently no driver actually did
>> > this correctly. Also, it didn't seem like anyone really cares, and we
>> > need to enforce some restrictions because otherwise drivers will end up
>> > doing it wrong, and you'll end up having a beacon interval of 200 while
>> > advertising 150 for example, which will totally throw off powersaving
>> > clients.
>>
>> I'm very interested in having multiple AP vifs with different beacon
>> intervals. If we're going to just fail anyway in this case can't we do
>> that from the drivers instead? I would also prefer that from an
>> aesthetic point of view, instead of having broken logic in the drivers
>> "protected" by extra verification in cfg80211.
>
> We can't fail from the drivers, they don't have a failure path.

Wouldn't it be best to add a failure path? Based a quick look it seems
a little complicated but not unmanageable... Or what do you think?

Is there anything else where the driver may not support a certain
combination of bss configurations? From the top of my head I can think
of mac address. That should fail as well depending on HW capability,
right? That seems to be another code path but the same problem (no
failure path).

/Björn
