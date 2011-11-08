Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45180 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1KHUoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 15:44:22 -0500
Message-ID: <4EB994A1.1020808@candelatech.com> (sfid-20111108_214425_621163_3E0606FC)
Date: Tue, 08 Nov 2011 12:44:17 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>  <1320780995-30483-2-git-send-email-greearb@candelatech.com>  (sfid-20111108_203659_989707_E33ECA13) <1320782949.24797.45.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320782949.24797.45.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 12:09 PM, Johannes Berg wrote:
> On Tue, 2011-11-08 at 11:36 -0800, greearb@candelatech.com wrote:
>
>> +			/*
>> +			 * We always need to advert at least MCS0-7, to
>> +			 * be a compliant HT station, for instance
>> +			 */
>> +			if (((i * 8 + q)>= min_rates)&&
>
> This is a little misleading -- why min_rates when the comment says
> MCS0-7?

I let caller determine the min, but comment was to tell why
the min might be set.  In APs, the min supported rates are 16, evidently...not
that this code supports APs at the moment...

When this is about local use instead of advertising, then any minimum
is OK.

Want me to just remove the comment entirely?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

