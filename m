Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:46156 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752320Ab1LUBlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 20:41:49 -0500
Message-ID: <1324431708.11292.13.camel@joe2Laptop> (sfid-20111221_024153_031713_9ED803DA)
Subject: Re: [PATCH 1/6] ath6kl: fix sparse warning on init.c
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 20 Dec 2011 17:41:48 -0800
In-Reply-To: <4EF0E4A3.9010306@qca.qualcomm.com>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1324406771-7100-2-git-send-email-rodrigue@qca.qualcomm.com>
	 <4EF0E4A3.9010306@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-20 at 21:40 +0200, Kalle Valo wrote:
> On 12/20/2011 08:46 PM, Luis R. Rodriguez wrote:
> > From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> > This fixes this sparse warning:
> >   CC [M]  drivers/net/wireless/ath/ath6kl/init.o
> > drivers/net/wireless/ath/ath6kl/init.c: In function ‘ath6kl_init_hw_params’:
> > drivers/net/wireless/ath/ath6kl/init.c:1377:26: warning: ‘hw’ may be used uninitialized in this function
> That's a compiler warning.
[]
> I can't see how hw can be uninitialised here (looking at the version in
> ath6kl.git). I copy the full code here:
> static int ath6kl_init_hw_params(struct ath6kl *ar)
> {
> 	const struct ath6kl_hw *hw;
> 	int i;
> 
> 	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
> 		hw = &hw_list[i];
> 
> 		if (hw->id == ar->version.target_ver)
> 			break;
> 	}
> 
> 	if (i == ARRAY_SIZE(hw_list)) {
> 		ath6kl_err("Unsupported hardware version: 0x%x\n",
> 			   ar->version.target_ver);
> 		return -EINVAL;
> 	}
> 
> 	ar->hw = *hw;
> 
> I always check for both compiler and sparse warnings and I have never
> seen this. What version of compiler do you have?

Is the intent here really to allow multiple ids
in the list and match the last one?

If not, perhaps something like this is simpler?

static int ath6kl_init_hw_params(struct ath6kl *ar)
{
	int i;
	const struct ath6kl_hw *hw = hw_list;

	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
		if (hw->id == ar->version.target_ver) {
			ar->hw = *hw;

			ath6kl_dbg(ATH6KL_DBG_BOOT,
				   "target_ver 0x%x target_type 0x%x dataset_patch 0x%x app_load_addr 0x%x\n",
				   ar->version.target_ver, ar->target_type,
				   ar->hw.dataset_patch_addr,
				   ar->hw.app_load_addr);
			ath6kl_dbg(ATH6KL_DBG_BOOT,
				   "app_start_override_addr 0x%x board_ext_data_addr 0x%x reserved_ram_size 0x%x\n",
				   ar->hw.app_start_override_addr,
				   ar->hw.board_ext_data_addr,
				   ar->hw.reserved_ram_size);
			ath6kl_dbg(ATH6KL_DBG_BOOT,
				   "refclk_hz %d uarttx_pin %d\n",
				   ar->hw.refclk_hz, ar->hw.uarttx_pin);

			return 0;
		}
		hw++;
	}

	ath6kl_err("Unsupported hardware version: 0x%x\n",
		   ar->version.target_ver);
	return -EINVAL;
}

btw: there are missing terminating newlines in the
current ath6kl_dbg uses in this routine.

