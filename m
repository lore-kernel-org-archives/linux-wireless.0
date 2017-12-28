Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34530 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753516AbdL1MnO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 07:43:14 -0500
Received: by mail-lf0-f67.google.com with SMTP id y78so39521718lfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 04:43:13 -0800 (PST)
Subject: Re: [RFC v3 03/11] ath10k: per target configurablity of various items
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
 <20170917194013.8658-4-erik.stromdahl@gmail.com>
 <87wp1eaiz0.fsf@kamboji.qca.qualcomm.com>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <c34f5c79-61a9-28b2-439c-f02045d06299@gmail.com> (sfid-20171228_134338_254859_DCB0829D)
Date: Thu, 28 Dec 2017 13:43:10 +0100
MIME-Version: 1.0
In-Reply-To: <87wp1eaiz0.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2017-12-22 16:19, Kalle Valo wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
> 
>> Added ability to set bus type and configure the max number of
>> peers in the ath10k_hw_params struct.
>>
>> With this functionality it is possible to have a different
>> hw configuration depending on bus type for the same radio
>> chipset.
>>
>> E.g. SDIO and USB devices using the same chipset as PCIe
>> devices will potentially use different board files and perhaps
>> other configuration parameters.
>>
>> One such parameter is the max number of peers.
>> Instead of using a default value (suitable for PCIe devices)
>> derived from the WMI op version, a per target value can be
>> used instead.
>>
>> This is needed by the QCA9377 USB device in order to prevent
>> the target fw to crash after HTT RX ring cfg is issued.
>>
>> Apparently, the QCA9377 HL device does not seem to handle the
>> same amount of peers as the LL devices.
>>
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> 
> I was a bit torn about this, I definitely see the need for this but on
> the other hand it creates duplicate data (for example two entries for
> QCA9377 chip). I guess this is the right approach, at least I cannot
> come up anything better.
> 
> But this patch should be split into two:
> 
> 1) add bus field to struct ath10k_hw_params
> 
> 2) add max_num_peers field to struct ath10k_hw_params
> 
> And it seems 2) is already implemented in commit 9f2992fea580 ("ath10k:
> wmi: get wmi init parameter values from hw params"), so hopefully we
> only need 1) anymore.
> 

Before commit 9f2992fea580a48135591873e5e3ac7e01444207,
TARGET_TLV_NUM_PEERS was used both in the WMI TLV init command
and as the value of *max_num_peers* in *struct ath10k* (ar->max_num_peers).

commit 9f2992fea580a48135591873e5e3ac7e01444207 does not set
*ar->max_num_peers* to the value of *ar->hw_param->num_peers*.

Is this correct?

As I see it, there is a possible mismatch between what is written
to the device in the WMI init message and the value of *ar->max_num_peers*.

Do we still need *max_num_peers* in *struct ath10k* now that we have the
*num_peers* member in *struct ath10k_hw_params*?

I am currently rewriting my HL patches and I was thinking about adding
a separate patch related to this.

>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -1663,9 +1663,19 @@ static int ath10k_init_hw_params(struct ath10k *ar)
>>   	for (i = 0; i < ARRAY_SIZE(ath10k_hw_params_list); i++) {
>>   		hw_params = &ath10k_hw_params_list[i];
>>   
>> -		if (hw_params->id == ar->target_version &&
>> -		    hw_params->dev_id == ar->dev_id)
>> -			break;
>> +		if (ar->is_high_latency) {
>> +			/* High latency devices will use different fw depending
>> +			 * on if it is a USB or SDIO device.
>> +			 */
>> +			if (hw_params->bus == ar->hif.bus &&
>> +			    hw_params->id == ar->target_version &&
>> +			    hw_params->dev_id == ar->dev_id)
>> +				break;
>> +		} else {
>> +			if (hw_params->id == ar->target_version &&
>> +			    hw_params->dev_id == ar->dev_id)
>> +				break;
>> +		}
> 
> I don't like the is_high_latency test here at all. The bus field should
> be checked with all entries, not just high latency ones. And because of
> this even most of the hw_param bus field entries were not initialised.
> 
> So only thing to do is to initialise the bus field for all the entries
> and the ugly test here can be removed. Just remember that QCA4019 uses
> AHB, I think all the rest is PCI. Or do we have AHB devices supported?

I noticed that there has been introduced a new bus type (SNOC).
Do you know which devices are SNOC devices?
Btw, what the heck is SNOC anyway?

> 
>> @@ -550,6 +557,18 @@ struct ath10k_hw_params {
>>   	 */
>>   	int vht160_mcs_rx_highest;
>>   	int vht160_mcs_tx_highest;
>> +
>> +	/* max_num_peers can be used to override the setting derived from
>> +	 * the WMI op version. If this value is non-zero, it will always
>> +	 * be used instead of the default value derived from the WMI op
>> +	 * version.
>> +	 */
>> +	int max_num_peers;
>> +
>> +	/* Specifies whether or not the device is a high latency device */
>> +	bool is_high_latency;
>> +
>> +	enum ath10k_bus bus;
>>   };
> 
> Please move the bus field between dev_id and name fields. It's so
> important that it should not be in the end.
> 
