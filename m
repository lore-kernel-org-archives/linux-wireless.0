Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45648 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbcBWNqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 08:46:37 -0500
Message-ID: <56CC62BC.308@candelatech.com> (sfid-20160223_144655_478609_EA6E88E2)
Date: Tue, 23 Feb 2016 05:46:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Let VHT work on 2.4Ghz
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com> <CA+XVXffpNDf0-5a6cPz0aUrrRfHgKQeu09zDt5eSe1K87m__pw@mail.gmail.com>
In-Reply-To: <CA+XVXffpNDf0-5a6cPz0aUrrRfHgKQeu09zDt5eSe1K87m__pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/23/2016 02:47 AM, Arik Nemtsov wrote:
> On Tue, Feb 23, 2016 at 12:42 AM, <greearb@candelatech.com> wrote:
>>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> ath10k supports VHT on 2.4Ghz band.
>> If supplicant and hostapd and radio think
>> VHT should be allowed, then kernel should let them
>> try.
>
> Removing the 80Mhz check entirely is not the right way to go IMO. The
> check is there because there are countries where VHT rates are not
> allowed, even on 20MHz channels. We use the fact these countries have
> no 80MHz-allowed ranges as a crude regulatory hint to disable VHT
> entirely. I'm not sure about the regulatory landscape in these
> countries regarding VHT in 2.4GHz, but please don't break compliance
> for the 5Ghz use-case.

Maybe someone can fix the regulatory logic then?

Add a no-vht flag or whatever?

Any idea which countries this applies to?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
