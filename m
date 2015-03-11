Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57536 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbbCKWGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 18:06:19 -0400
Message-ID: <5500BC5A.9040809@candelatech.com> (sfid-20150311_230622_086449_4F7FFDFA)
Date: Wed, 11 Mar 2015 15:06:18 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211-hwsim and tx-rates.
References: <5500AEAB.8010605@candelatech.com> <5500B417.9070307@broadcom.com>
In-Reply-To: <5500B417.9070307@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2015 02:31 PM, Arend van Spriel wrote:
> On 03/11/15 22:07, Ben Greear wrote:
>> When using the user-space transport, the netlink frame sent to user-space
>> has a rate index and retry count, and nothing else.  Is there a
>> reliable way to know in user-space what index maps to what actual rate?
> 
> Not sure what you are exactly looking for, but maybe the function cfg80211_calculate_bitrate() in net/wireless/util.c may provide you some answers.

Well, that would be useful in the kernel, but in user-space w/hardware sim,
as far as I can tell we only have this rate info:

/**
 * struct hwsim_tx_rate - rate selection/status
 *
 * @idx: rate index to attempt to send with
 * @count: number of tries in this rate before going to the next rate
 *
 * A value of -1 for @idx indicates an invalid rate and, if used
 * in an array of retry rates, that no more rates should be tried.
 *
 * When used for transmit status reporting, the driver should
 * always report the rate and number of retries used.
 *
 */
struct hwsim_tx_rate {
	s8 idx;
	u8 count;
} __packed;


I don't see a good way to tie that idx to an actual rate (which involves
flags, nss, mcs values, etc).

Maybe I should also just send the info I care about, which is a 'bps' rate,
channel-width indication, SGI, etc as separate netlink attributes....


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

