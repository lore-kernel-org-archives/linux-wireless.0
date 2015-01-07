Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38627 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbAGN2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:28:43 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so1612324wid.6
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 05:28:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420541023.1966.14.camel@sipsolutions.net>
References: <1419847143-25447-1-git-send-email-arik@wizery.com> <1420541023.1966.14.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 7 Jan 2015 15:28:26 +0200
Message-ID: <CA+XVXfd3nXSm3KZ0-46QUiC4CnCW2O8RXoW9OpXZaiL4u6CVow@mail.gmail.com> (sfid-20150107_142846_474166_463D27AE)
Subject: Re: [PATCH] mac80211: add TDLS supported channels correctly
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2015 at 12:43 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-12-29 at 11:59 +0200, Arik Nemtsov wrote:
>> The function adding the supported channels IE during a TDLS connection had
>> several issues:
>> 1. If the entire subband is usable, the function exitted the loop without
>> adding it
>> 2. The function only checked chandef_usable, ignoring flags like RADAR
>> which would prevent TDLS off-channel communcation.
>> 3. HT20 was explicitly required in the chandef, while not a requirement
>> for TDLS off-channel.
>
>
> That's a strangely formatted commit message ... :)

I thought it's clearer this way. You disagree?

>
>
>> +                     if (cfg80211_reg_can_beacon(sdata->local->hw.wiphy,
>> +                                                 &chandef,
>> +                                                 sdata->wdev.iftype)) {
>>                               ch_cnt++;
>>                               continue;
>
> With some thinking, I can understand it - but that means you need a
> comment here.

Sure.

Arik
