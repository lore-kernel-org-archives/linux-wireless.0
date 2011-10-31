Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18713 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:52:41 -0400
Message-ID: <4EAE6FDE.4060105@qca.qualcomm.com> (sfid-20111031_105245_546439_FA6DDF53)
Date: Mon, 31 Oct 2011 15:22:30 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/7] ath6kl: Add wmi functions to add/delete wow patterns
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> <1319539047-8756-2-git-send-email-rmani@qca.qualcomm.com> <4EAA9BE2.7050808@qca.qualcomm.com>
In-Reply-To: <4EAA9BE2.7050808@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 October 2011 05:41 PM, Kalle Valo wrote:
> On 10/25/2011 01:37 PM, rmani@qca.qualcomm.com wrote:
>> From: Raja Mani<rmani@qca.qualcomm.com>
>>
>> Signed-off-by: Raja Mani<rmani@qca.qualcomm.com>
>
> Try to avoid empty commit logs. You could just say that these commands
> will be used by the following patch if nothing else.
>
>> +int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi,
>> +				   struct wmi_add_wow_pattern_cmd *add_wow_cmd,
>> +				   u8 *pattern, u8 *mask)
>> +{
>
> Don't use a struct as the parameter, instead add individual parameters.
> So something like this:
>
> int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi,
> 	u8 id, u8 size, 8 offset,				
> 	u8 *pattern, u8 *mask)
>
> This is easier for the caller and you get to handle the endian in the
> callee which simplifies the code.

Agree.. I'll take care in V2.
>
>> +	size = sizeof(*cmd) +
>> +		((2 * add_wow_cmd->filter_size) * sizeof(u8));
>
> This can fit into line. And sizeof(u8) really doesn't make any sense.
>
> And is this correct? The struct is defined like this:
>
> +struct wmi_add_wow_pattern_cmd {
> +	u8 filter_list_id;
> +	u8 filter_size;
> +	u8 filter_offset;
> +	u8 filter[1];
> +} __packed;
>
> So there's one extra byte for the filter and above you include also that
> byte. But if the sctruct is defined like this the extra byte is not
> included:
>
> +struct wmi_add_wow_pattern_cmd {
> +	u8 filter_list_id;
> +	u8 filter_size;
> +	u8 filter_offset;
> +	u8 filter[0];
> +} __packed;
>

Good catch.. I'll correct it.

>> +int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi,
>> +				   struct wmi_del_wow_pattern_cmd *del_wow_cmd)
>
> Same here as earlier, don't use the struct as a parameter.

Okay..

>
> Kalle
