Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3845 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1IFHwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 03:52:01 -0400
Message-ID: <4E65D11B.3080904@qca.qualcomm.com> (sfid-20110906_095207_407049_0F7603C1)
Date: Tue, 6 Sep 2011 10:51:55 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath6kl: Allow enabling of P2P support
References: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com> <1315233527-6234-5-git-send-email-jouni@qca.qualcomm.com> <4E65C49B.2000201@qca.qualcomm.com> <20110906072138.GA3125@jouni.qca.qualcomm.com>
In-Reply-To: <20110906072138.GA3125@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2011 10:21 AM, Jouni Malinen wrote:
> On Tue, Sep 06, 2011 at 09:58:35AM +0300, Kalle Valo wrote:
>> On 09/05/2011 05:38 PM, Jouni Malinen wrote:
>>> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c +++
>>> b/drivers/net/wireless/ath/ath6kl/cfg80211.c +static unsigned int
>>> ath6kl_p2p; + +module_param(ath6kl_p2p, uint, 0644);
>> 
>> Currently all module parameters are in init.c. It's not the best
>> place and most likely will move to core.c soon, but I still would
>> prefer to have them all in one place. I think moving this to init.c
>> would make sense.
> 
> I started with this in init.c, but that causes checkpatch warnings
> when the variable needs to be accessed as extern in cfg80211.c. Or
> well, I guess I could hide that by defining the extern in a header
> file, but this parameter should not really be used in any other file
> than cfg80211.c to initialize the flag in struct ath6kl. As such, I
> would prefer not to make its visibility any larger that necessary.

I was more thinking that ath6kl_p2p would not be exposed outside init.c,
instead you would set the appropriate conf_flag in ath6kl_core_init() or
similar function. But leave the module_param as it is for now, I will
cleanup the module parameters anyway soon.

> Why would all module parameters need to be defined in the same C
> file?

Just for consistency so that people don't need to grep different locations.

>> Can we combine this if block with the first one?
> 
> Sure, but that would add extra indentation level for the following
> code, so this separate check-if-P2P-is-supported followed by 
> if-P2P-is-supported looks cleaner to me.

Yeah, you are right. My original comment was bogus.

>> If it's ok for you, I'll commit the first three patches and we can
>> talk more about this patch.
> 
> Yes, please do.

Ok, I have applied the first three now.

Kalle
