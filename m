Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3087 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab2GHTlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 15:41:24 -0400
Message-ID: <4FF9E254.7090203@broadcom.com> (sfid-20120708_214128_611626_6B7E61CD)
Date: Sun, 8 Jul 2012 21:41:08 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: thomas <thomas@net.t-labs.tu-berlin.de>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	brcm80211-dev-list@broadcom.com, pieterpg@broadcom.com,
	gregkh@suse.de, frankyl@broadcom.com, rvossen@broadcom.com,
	brudley@broadcom.com
Subject: Re: [PATCH v2] brcmsmac: restructure info->control.sta handling
 as it is goning to be removed soon.
References: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1340975210.4472.1.camel@jlt3.sipsolutions.net>
 <4FEDC3F0.1000201@net.t-labs.tu-berlin.de>
 <20120706193733.GC1879@tuxdriver.com>
In-Reply-To: <20120706193733.GC1879@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2012 09:37 PM, John W. Linville wrote:
> On Fri, Jun 29, 2012 at 11:04:16AM -0400, thomas wrote:
>> Johannes Berg schrieb:
>>
>>> On Fri, 2012-06-29 at 05:56 -0700, Thomas Huehn wrote:
>>>> brcmsmac uses info->control.sta while doing ampdu aggregation. This patch
>>>> changes the usage of the structure info->control.sta, as it is going to be
>>>> removed soon from struct ieee80211_tx_info. This patch is a pre-requisit in
>>>> order to add transmission power control (TPC) to the mac80211 subsystem.
>>>>
>>>> Suggested-by: Felix Fietkau <nbd@openwrt.org>
>>>> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
>>>> ---
>>>> Change sequence of overwriting data. Thx to Johannes.
>>>
>>>
>>>> @@ -665,7 +665,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
>>>>  			u8 plcp0, plcp3, is40, sgi;
>>>>  			struct ieee80211_sta *sta;
>>>>  
>>>> -			sta = tx_info->control.sta;
>>>> +			sta = tx_info->rate_driver_data[0];
>>>
>>> Are you sure it actually works now?
>>
>>
>> From locking at the code, sta is never used after it gets overridden.
>> The brcmsmac driver does not use the vif pointer at all. I asked Felix
>> to double check as I do not have a Broadcom device over here.
>>
>> Bye Thomas
> 
> Any comments on this one from the Broadcom camp?
> 

Hi John,

Just applied the patch to have a closer look at the changes, but I am
missing details on the whole story. I see tx_info->rate_driver_data[0]
being set in the tx callback and reset to NULL in some other path which
I believe is only called upon tid or sta removal so it does not make
sense to me.

I have pushed the patch to our internal review server as I would like
some co-workers to have a look. If anyone can provide any more details
what this patch is trying to solve, please do.

Gr. AvS

