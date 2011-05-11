Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33717 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab1EKP6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 11:58:49 -0400
Received: by mail-pw0-f46.google.com with SMTP id 15so305249pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 08:58:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304959783.12202.7.camel@jlt3.sipsolutions.net>
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	<4DC81A61.9080101@candelatech.com>
	<1304959783.12202.7.camel@jlt3.sipsolutions.net>
Date: Wed, 11 May 2011 17:58:48 +0200
Message-ID: <BANLkTinHqMi=sy=sEzQPTz4QEsoucQXYVA@mail.gmail.com> (sfid-20110511_175942_443871_E25E7CD8)
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 9, 2011 at 6:49 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-05-09 at 09:46 -0700, Ben Greear wrote:
>> On 05/09/2011 09:41 AM, Johannes Berg wrote:
>> > From: Johannes Berg<johannes.berg@intel.com>
>> >
>> > Multiple virtual AP interfaces can currently try
>> > to use different beacon intervals, but that just
>> > leads to problems since it won't actually be done
>> > that way by drivers. Return an error in this case
>> > to make sure it won't be done wrong.
>>
>> I think there is no problem with having different beacon
>> intervals, as long as they are all a multiple of
>> the smallest interval and the driver does things properly.
>>
>> I'm not sure ath9k or ath5k currently supports this properly,
>> but there was a patch floating around for a while that did
>> this for ath9k I think...
>
> Yes, in theory that's possible, but apparently no driver actually did
> this correctly. Also, it didn't seem like anyone really cares, and we
> need to enforce some restrictions because otherwise drivers will end up
> doing it wrong, and you'll end up having a beacon interval of 200 while
> advertising 150 for example, which will totally throw off powersaving
> clients.

I'm very interested in having multiple AP vifs with different beacon
intervals. If we're going to just fail anyway in this case can't we do
that from the drivers instead? I would also prefer that from an
aesthetic point of view, instead of having broken logic in the drivers
"protected" by extra verification in cfg80211.

Best regards,

Björn
