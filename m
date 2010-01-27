Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55219 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab0A0SPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 13:15:00 -0500
Received: by pwi21 with SMTP id 21so3905430pwi.21
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 10:15:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264615477.8619.20.camel@wwguy-ubuntu>
References: <1264511993.25642.9.camel@johannes.local> <43e72e891001271001r2cc39da4ka00a3eef06f6e139@mail.gmail.com>
	<1264615477.8619.20.camel@wwguy-ubuntu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Jan 2010 10:14:40 -0800
Message-ID: <43e72e891001271014j667221bqa11d56f3a68f6099@mail.gmail.com>
Subject: Re: [PATCH] mac80211: wait for beacon before enabling powersave
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"kalle.valo@iki.fi" <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>,
	"buytenh@wantstofly.org" <buytenh@wantstofly.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2010 at 10:04 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> On Wed, 2010-01-27 at 10:01 -0800, Luis R. Rodriguez wrote:
>> On Tue, Jan 26, 2010 at 5:19 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > Because DTIM information is required for powersave
>> > but is only conveyed in beacons, wait for a beacon
>> > before enabling powersave, and change the way the
>> > information is conveyed to the driver accordingly.
>> >
>> > mwl8k doesn't currently seem to implement PS but
>> > requires the DTIM period in a different way; after
>> > talking to Lennert we agreed to just have mwl8k do
>> > the parsing itself in the finalize_join work.
>>
>> Not sure if this is merged yet. If not it might be good to add to the
>> commit log a brief about the impact of the fix for distribution
>> purposes looking to cherry pick some fixes that may cure some issues.
>>
>> The impact of this fix is that the DTIM settings of > 1 would now be
>> respected in the odd situation a beacon would not be received prior to
>> association. Ensuring we use a higher DTIM would mean saving more
>> power as it would mean we can sleep longer.
>>
>> This is not propagated to stable but if it turns out this can enhance
>> power save since DTIM might usually be > 1 and the race may be more
>> common than we expected we may need a respective stable solution.
>>
>
> It will be nice to see a respective solution for stable since this
> impact power save which is very important for certain platform.

Well how about your patch for stable then?

 Luis
