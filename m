Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52008 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1LWI2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 03:28:00 -0500
Message-ID: <4EF43B85.9050000@qca.qualcomm.com> (sfid-20111223_092825_046627_293525A0)
Date: Fri, 23 Dec 2011 10:27:49 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/6] ath6kl: fix sparse warning on init.c
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>	 <1324406771-7100-2-git-send-email-rodrigue@qca.qualcomm.com>	 <4EF0E4A3.9010306@qca.qualcomm.com> <1324431770.14214.0.camel@joe2Laptop>
In-Reply-To: <1324431770.14214.0.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2011 03:42 AM, Joe Perches wrote:
> On Tue, 2011-12-20 at 21:40 +0200, Kalle Valo wrote:
>> On 12/20/2011 08:46 PM, Luis R. Rodriguez wrote:
>>
>> 	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
>> 		hw = &hw_list[i];
>>
>> 		if (hw->id == ar->version.target_ver)
>> 			break;
>> 	}
>>
>> 	if (i == ARRAY_SIZE(hw_list)) {
>> 		ath6kl_err("Unsupported hardware version: 0x%x\n",
>> 			   ar->version.target_ver);
>> 		return -EINVAL;
>> 	}
>>
>> 	ar->hw = *hw;
>>
>> I always check for both compiler and sparse warnings and I have never
>> seen this. What version of compiler do you have?
> 
> Is the intent here really to allow multiple ids
> in the list and match the last one?

The idea is that there should be just one hw entry per id. But if there
would be multiple entires, the code above would take the first one.

> If not, perhaps this is simpler?
> 
> static int ath6kl_init_hw_params(struct ath6kl *ar)
> {
> 	int i;
> 	const struct ath6kl_hw *hw = hw_list;
> 
> 	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
> 		if (hw->id == ar->version.target_ver) {
> 			ar->hw = *hw;
> 
> 			ath6kl_dbg(ATH6KL_DBG_BOOT,
> 				   "target_ver 0x%x target_type 0x%x dataset_patch 0x%x app_load_addr 0x%x\n",
> 				   ar->version.target_ver, ar->target_type,
> 				   ar->hw.dataset_patch_addr,
> 				   ar->hw.app_load_addr);
> 			ath6kl_dbg(ATH6KL_DBG_BOOT,
> 				   "app_start_override_addr 0x%x board_ext_data_addr 0x%x reserved_ram_size 0x%x\n",
> 				   ar->hw.app_start_override_addr,
> 				   ar->hw.board_ext_data_addr,
> 				   ar->hw.reserved_ram_size);
> 			ath6kl_dbg(ATH6KL_DBG_BOOT,
> 				   "refclk_hz %d uarttx_pin %d\n",
> 				   ar->hw.refclk_hz, ar->hw.uarttx_pin);
> 
> 			return 0;
> 		}
> 		hw++;
> 	}
> 
> 	ath6kl_err("Unsupported hardware version: 0x%x\n",
> 		   ar->version.target_ver);
> 	return -EINVAL;
> }

There's a lot of indentation in that form which I don't like. And I
would prefer to have the "main" (non-error) code path unindented. Easier
to read that way.

> btw: there are missing terminating newlines in the
> existing ath6kl_dbg uses in this routine.

Thanks, I didn't notice that. That needs to be fixed.

Kalle
