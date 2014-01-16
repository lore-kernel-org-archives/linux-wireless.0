Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39686 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaAPNSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 08:18:10 -0500
Received: by mail-lb0-f182.google.com with SMTP id w7so1411091lbi.13
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 05:18:09 -0800 (PST)
Message-ID: <52D7DC0B.9060206@gmail.com> (sfid-20140116_141815_119299_6C13C02A)
Date: Thu, 16 Jan 2014 14:18:03 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Don't touch split_start when split dump is not
 used
References: <1389877607-3162-1-git-send-email-pontus.fuchs@gmail.com>	 (sfid-20140116_140701_812750_DB719CBA) <1389878160.4345.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1389878160.4345.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-01-16 14:16, Johannes Berg wrote:
> On Thu, 2014-01-16 at 14:06 +0100, Pontus Fuchs wrote:
>> When the netlink skb is exhausted split_start is left set. In the
>> subsequent retry, with a larger buffer, the dump is continued from the
>> failing point instead of from the beginning.
>
>> +static void split_start_inc(struct nl80211_dump_wiphy_state *state)
>> +{
>> +	if (state->split)
>> +		state->split_start++;
>> +}
>
> Wouldn't it be easier to just reset it in this case?

Sure. If you prefer that I can do that instead.

//Pontus

