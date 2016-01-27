Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47403 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935414AbcA0Vr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 16:47:27 -0500
Message-ID: <56A93A4A.8050509@codeaurora.org> (sfid-20160127_224735_273951_D7C0BC48)
Date: Wed, 27 Jan 2016 13:44:42 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>,
	Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath10k: add abstraction layer for vdev subtype
References: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com> <1453920957-9908-5-git-send-email-poh@qca.qualcomm.com> <56A91645.9040602@candelatech.com>
In-Reply-To: <56A91645.9040602@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 01/27/2016 11:11 AM, Ben Greear wrote:
> On 01/27/2016 10:55 AM, Peter Oh wrote:
>> Abstraction layer for vdev subtype is added to solve
>> subtype mismatch and to give flexible compatibility
>> among different firmware revisions.
>>
>> For instance, 10.2 and 10.4 firmware has different
>> definition of their vdev subtypes for Mesh.
>> 10.4 defined subtype 6 for 802.11s Mesh while 10.2 uses 5.
>> Hence use the abstraction API to get right subtype to use.
>>
>> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/mac.c     | 15 ++++---
>>   drivers/net/wireless/ath/ath10k/wmi-ops.h | 11 +++++
>>   drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 +
>>   drivers/net/wireless/ath/ath10k/wmi.c     | 70
> +++++++++++++++++++++++++++++++
>> drivers/net/wireless/ath/ath10k/wmi.h     | 42 ++++++++++++++++---
>>   5 files changed, 128 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
> b/drivers/net/wireless/ath/ath10k/mac.c
>> index 2940b00..c9a39ab 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -4345,25 +4345,29 @@ static int ath10k_add_interface(struct
> ieee80211_hw *hw,
>>              bit, ar->free_vdev_map);
>>
>>       arvif->vdev_id = bit;
>> -    arvif->vdev_subtype = WMI_VDEV_SUBTYPE_NONE;
>> +    arvif->vdev_subtype =
>> +        ath10k_wmi_get_vdev_subtype(ar, WMI_VDEV_SUBTYPE_NONE);
>>
>>       switch (vif->type) {
>>       case NL80211_IFTYPE_P2P_DEVICE:
>>           arvif->vdev_type = WMI_VDEV_TYPE_STA;
>> -        arvif->vdev_subtype = WMI_VDEV_SUBTYPE_P2P_DEVICE;
>> +        arvif->vdev_subtype = ath10k_wmi_get_vdev_subtype
>> +                    (ar, WMI_VDEV_SUBTYPE_P2P_DEVICE);
>
> Would it maybe be simpler code to just assign these types to the ar 
> struct
> at
> firmware init time.  And then do something like:
>
> arvif->vdev_subtype = ar->p2p_subtype;
Maintaining a variable per subtype doesn't look good since a variable 
can cover subtypes.
>
> Or even maybe:
>
> arvif->vdev_subtype = ar->subtype_for_viftype[vif->type];
if you take a look the abstraction layer, there is different index 
indicating the same subtype.
In that case, your suggestion also needs to maintaining different array 
per FW version which is the same amount of work as this patch.
>
> I'm not sure how much it matters, but in general I find the 
> abstraction in
> ath10k makes it hard to read through the code.
It cannot help avoiding use it since ath10k supports different chipsets 
and firmware IMO.
>
> Thanks,
> Ben
>

