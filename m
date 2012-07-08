Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40061 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab2GHTrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 15:47:53 -0400
Message-ID: <4FF9E3E5.6080202@net.t-labs.tu-berlin.de> (sfid-20120708_214756_540025_FE7C9D07)
Date: Sun, 08 Jul 2012 21:47:49 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	brcm80211-dev-list@broadcom.com, pieterpg@broadcom.com,
	gregkh@suse.de, frankyl@broadcom.com, rvossen@broadcom.com,
	brudley@broadcom.com
Subject: Re: [PATCH v2] brcmsmac: restructure info->control.sta handling as
 it is goning to be removed soon.
References: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1340975210.4472.1.camel@jlt3.sipsolutions.net> <4FEDC3F0.1000201@net.t-labs.tu-berlin.de> <20120706193733.GC1879@tuxdriver.com> <4FF9E254.7090203@broadcom.com>
In-Reply-To: <4FF9E254.7090203@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

This patch has the following goal. To implement Transmission Power
Control (TPC) in the mac80211 subsystem, I remove the STA pointer from
the ieee_tx_info structure to gain free mem for TPC annotation and I put
the sta  on the stack to pass it to each driver function in the tx-path.
The broadcom brcmsmac is the only driver where the ieee_tx_info is
somewhat stored and therefore the sta point is not as straight removable
as for the other drivers. This patch resolved that issue.
Please have a look at my recent patch [PATCH] mac80211: Add transmit
power control support (TPC) where I have included this one again with
the full story in the code.

Greetings Thomas

Arend van Spriel schrieb:

> On 07/06/2012 09:37 PM, John W. Linville wrote:
>> On Fri, Jun 29, 2012 at 11:04:16AM -0400, thomas wrote:
>>> Johannes Berg schrieb:
>>>
>>>> On Fri, 2012-06-29 at 05:56 -0700, Thomas Huehn wrote:
>>>>> brcmsmac uses info->control.sta while doing ampdu aggregation. This patch
>>>>> changes the usage of the structure info->control.sta, as it is going to be
>>>>> removed soon from struct ieee80211_tx_info. This patch is a pre-requisit in
>>>>> order to add transmission power control (TPC) to the mac80211 subsystem.
>>>>>
>>>>> Suggested-by: Felix Fietkau <nbd@openwrt.org>
>>>>> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
>>>>> ---
>>>>> Change sequence of overwriting data. Thx to Johannes.
>>>>
>>>>> @@ -665,7 +665,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
>>>>>  			u8 plcp0, plcp3, is40, sgi;
>>>>>  			struct ieee80211_sta *sta;
>>>>>  
>>>>> -			sta = tx_info->control.sta;
>>>>> +			sta = tx_info->rate_driver_data[0];
>>>> Are you sure it actually works now?
>>>
>>> From locking at the code, sta is never used after it gets overridden.
>>> The brcmsmac driver does not use the vif pointer at all. I asked Felix
>>> to double check as I do not have a Broadcom device over here.
>>>
>>> Bye Thomas
>> Any comments on this one from the Broadcom camp?
>>
> 
> Hi John,
> 
> Just applied the patch to have a closer look at the changes, but I am
> missing details on the whole story. I see tx_info->rate_driver_data[0]
> being set in the tx callback and reset to NULL in some other path which
> I believe is only called upon tid or sta removal so it does not make
> sense to me.
> 
> I have pushed the patch to our internal review server as I would like
> some co-workers to have a look. If anyone can provide any more details
> what this patch is trying to solve, please do.
> 
> Gr. AvS
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

