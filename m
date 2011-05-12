Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48575 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab1ELSQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 14:16:15 -0400
Received: by pvg12 with SMTP id 12so810085pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 11:16:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305188063.3461.3.camel@jlt3.sipsolutions.net>
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	<4DC81A61.9080101@candelatech.com>
	<1304959783.12202.7.camel@jlt3.sipsolutions.net>
	<BANLkTinHqMi=sy=sEzQPTz4QEsoucQXYVA@mail.gmail.com>
	<1305132500.17892.1.camel@jlt3.sipsolutions.net>
	<BANLkTikL0iLEWcseFdq572rZcVxVkKg8Hg@mail.gmail.com>
	<1305188063.3461.3.camel@jlt3.sipsolutions.net>
Date: Thu, 12 May 2011 20:08:54 +0200
Message-ID: <BANLkTin2ZxDhZ+aotC=HDz9Fc==tf2gsgQ@mail.gmail.com> (sfid-20110512_201618_855602_DA632549)
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/12 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2011-05-11 at 23:39 +0200, Björn Smedman wrote:
>> 2011/5/11 Johannes Berg <johannes@sipsolutions.net>:
>> > On Wed, 2011-05-11 at 17:58 +0200, Björn Smedman wrote:
>> >> I'm very interested in having multiple AP vifs with different beacon
>> >> intervals. If we're going to just fail anyway in this case can't we do
>> >> that from the drivers instead? I would also prefer that from an
>> >> aesthetic point of view, instead of having broken logic in the drivers
>> >> "protected" by extra verification in cfg80211.
>> >
>> > We can't fail from the drivers, they don't have a failure path.
>>
>> Wouldn't it be best to add a failure path? Based a quick look it seems
>> a little complicated but not unmanageable... Or what do you think?
>
> It's not overly complicated, but I don't like it anyway, that just opens
> the door to the drivers failing all kinds of things and to userspace
> that'll look random.
>
>> Is there anything else where the driver may not support a certain
>> combination of bss configurations? From the top of my head I can think
>> of mac address. That should fail as well depending on HW capability,
>> right? That seems to be another code path but the same problem (no
>> failure path).
>
> That has a failure path, and recently I posted a patch to advertise the
> interface type combinations. I don't think MAC addresses impose any sort
> of restriction.

I think at least some rt2x00 hw may not be able to handle all
combinations of multi-vif MAC addresses.

If I understand correctly ath9k will happily configure the hardware to
ack all BSSIDs if multi-vif MAC addresses are poorly chosen. I don't
know if that's a reason to fail but it wouldn't be good, right?

Another case where cross-vif constraints are difficult to handle is
BSS_CHANGED_ERP_SLOT / BSS_CHANGED_ERP_PREAMBLE. Again, I'm not sure
failing is the right way to handle this but at least ath9k seems
incapable of having separate slot times / preambles for separate
vifs...

> Bottom line is this: We currently don't have a driver that handles this
> correctly. Therefore, the patch is absolutely correct. If somebody
> enhances drivers, they're free to also enhance the checking code, and
> (hopefully) include some advertising of what is possible. Currently,
> however, the best assumption is that it's not possible, and we should
> encode that assumption somewhere in the userspace API.

Sounds reasonable. Thanks for explaining.

/Björn
