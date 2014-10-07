Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37191 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJGNsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 09:48:07 -0400
Message-ID: <5433EF3A.5090504@candelatech.com> (sfid-20141007_154811_467885_11E4EC12)
Date: Tue, 07 Oct 2014 06:48:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] mac-hwsim:  add ethtool stats support.
References: <1411680140-20208-1-git-send-email-greearb@candelatech.com>	 <1411680140-20208-2-git-send-email-greearb@candelatech.com>	 (sfid-20140925_232229_629577_D0F1A28C) <1412671568.1825.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1412671568.1825.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2014 01:46 AM, Johannes Berg wrote:
> On Thu, 2014-09-25 at 14:22 -0700, greearb@candelatech.com wrote:
>
>> +static const char mac80211_hwsim_gstrings_stats[][ETH_GSTRING_LEN] = {
>> +	"tx_pkts_nic",
>> +	"tx_bytes_nic",
>> +	"rx_pkts_nic",
>> +	"rx_bytes_nic",
>> +	"d_tx_dropped",
>> +	"d_tx_failed",
>> +	"d_ps_mode",
>> +	"d_group",
>> +	"d_tx_power",
>
> What's that d_ prefix?

Stats from the driver v/s from the mac80211 stack.  Basically, it
mimics how I did ath9k, ath9k_htc, and ath10k stats (though
not sure ath10k made it upstream yet).

The first 4 match those wifi drivers as well as some Intel wired
NICs.

It doesn't matter a huge amount if you want to change the names,
but it makes user-space stats reporting easier if you would leave
them the same...

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

