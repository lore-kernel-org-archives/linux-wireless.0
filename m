Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23786 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab2BGNdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 08:33:10 -0500
Message-ID: <4F31280F.9000306@qca.qualcomm.com> (sfid-20120207_143314_230428_3662797C)
Date: Tue, 7 Feb 2012 15:33:03 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Check wow state before sending control and data
 pkt
References: <1328536613-17521-1-git-send-email-rmani@qca.qualcomm.com> <4F2FE044.2000106@qca.qualcomm.com> <4F30F980.9010206@qca.qualcomm.com>
In-Reply-To: <4F30F980.9010206@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2012 12:14 PM, Raja Mani wrote:
> On Monday 06 February 2012 07:44 PM, Kalle Valo wrote:
>> On 02/06/2012 03:56 PM, rmani@qca.qualcomm.com wrote:
>>>
>>> +enum ath6kl_wow_state {
>>> +	ATH6KL_WOW_STATE_NONE,
>>> +	ATH6KL_WOW_STATE_SUSPENDING,
>>> +	ATH6KL_WOW_STATE_SUSPENDED,
>>> +};
>>> +
>>>   struct ath6kl {
>>>   	struct device *dev;
>>>   	struct wiphy *wiphy;
>>>
>>>   	enum ath6kl_state state;
>>> +	enum ath6kl_wow_state wow_state;
>>>   	unsigned int testmode;
>>
>> To be honest, adding a new state variable scares me. I don't see how we
>> are able to maintain two different state variables, the end result would
>> be a total mess.
> 
> ath6kl_wow_state is a just sub state of WOW. It roles over only in WOW
> mode. However i understand your point.

It's not just a substate as it's separately checked in txrx.c.

>> I recommend to look at this problem by adding a new state to enum
>> ath6kl_state. That would make it a lot easier to handle all the
>> different states.
> 
> The condition to stop ctrl and data pkt transfer are different.
> Ctrl pkt should be stopped when wow_suspended (after sending
> set_host_sleep_cmd_mode). Data pkt should be dropped before
> the moment we configure set_ip_cmd().

Don't think about dropping packets, instead try to make sure that the
packet flow is _stopped_. Dropping packets should be the last resort,
instead we need to go to the source of the packets. For data packets
this means that we need to stop netdev queues. For control packets we
need to make sure that cfg80211 ops in cfg80211.c don't issue any new
wmi commands. And maybe we should also consider debugfs and wmi events
as they can also issue new wmi commands.

> This where we need a state WOW_SUSPENDING and WOW_SUSPENDED.
> enum ath6kl_state has over all ath6kl suspend state (cut pwr, deep
> sleep,wow). IMHO, mixing WOW sub states there is not good approach.

How is this problem related only to WoW? Doesn't it apply to all suspend
modes?

> If you feel maintaining separate state is not good idea, i could think
> of introducing two new flag WOW_SUSPENDING,  WOW_SUSPENDED in ar->flag.

After a quick thought having a SUSPENDING state makes, but I can't see
the reason for name WOW_SUSPENDING. WOW_SUSPENDED is unclear for me,
what's the difference to ATH6KL_STATE_WOW?

Kalle
