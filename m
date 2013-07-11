Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33306 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3GKPLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 11:11:05 -0400
Message-ID: <51DECAFD.8070608@candelatech.com> (sfid-20130711_171108_868303_10CB93A8)
Date: Thu, 11 Jul 2013 08:10:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [WT PATCH 6/6] mac80211: Tell user why beacons fail to parse.
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>  <1372546738-25827-6-git-send-email-greearb@candelatech.com>  (sfid-20130630_005952_096446_C7F6AD26) <1373533184.8201.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1373533184.8201.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2013 01:59 AM, Johannes Berg wrote:
> On Sat, 2013-06-29 at 15:58 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Should help better debug dodgy APs and such.
>
> This isn't a bad idea, but I think instead of storing the message:
>
>> @@ -110,6 +110,7 @@ struct ieee80211_bss {
>>
>>   	/* Keep track of what bits of information we have valid info for. */
>>   	u8 valid_data;
>> +	char corrupt_elems_msg[80];
>
> you should store a "what's bad" type field and the broken IE number or
> so, to reduce memory usage

I thought of this, but the problem is then you cannot tell the details
(for instance the actual lengths when length is bad, the ID that is duplicated, etc).
I figure if we are going to provide the info to the user, we might as well
be specific about it.

>> +				snprintf(elems->parse_err_msg,
>> +					 sizeof(elems->parse_err_msg),
>> +					 "seen id: %i already", id);
>
> Your snprintf() usage is also unsafe.

What is unsafe about it?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

