Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55569 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab0I2UVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 16:21:33 -0400
Message-ID: <4CA39FCA.6000806@candelatech.com>
Date: Wed, 29 Sep 2010 13:21:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw:  Flush stdout when printing events.
References: <1285720244-26149-1-git-send-email-greearb@candelatech.com> <1285743567.3756.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285743567.3756.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 11:59 PM, Johannes Berg wrote:
> On Tue, 2010-09-28 at 17:30 -0700, greearb@candelatech.com wrote:
>
>> -#define PARSE_BEACON_CHAN(_attr, _chan) do { \
>> -	r = parse_beacon_hint_chan(tb[_attr], \
>> -				&_chan); \
>> -	if (r) \
>> -		return NL_SKIP; \
>> -} while (0)
>> +
>> +#define PARSE_BEACON_CHAN(_attr, _chan) do {		\
>> +		r = parse_beacon_hint_chan(tb[_attr],	\
>> +					&_chan);	\
>> +		if (r) {				\
>> +			fflush(stdout);			\
>> +			return NL_SKIP;			\
>> +		}					\
>> +	} while (0)
>> +
>
> Why does that need fflush() here? We'll eventually finish that line, no?

This returns from the print_event method, so I assume it should
flush.  If it finishes the line, I'm not sure where.

Either way, thanks for taking the other change.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

