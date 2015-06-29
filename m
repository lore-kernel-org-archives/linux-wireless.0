Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31058 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbF2Pvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 11:51:54 -0400
Message-ID: <55916984.9050904@qti.qualcomm.com> (sfid-20150629_175158_184675_B16D5631)
Date: Mon, 29 Jun 2015 21:21:32 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 09/10] ath10k: Add support for code swap
References: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com>	<1434610870-5505-10-git-send-email-vthiagar@qti.qualcomm.com> <87egku3gm8.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87egku3gm8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 June 2015 04:51 PM, Kalle Valo wrote:
> Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:
>
>> Code swap is a mechanism to use host memory to store
>> some fw binary code segment. Ath10k host driver allocates
>> and loads the code swap binary into the host memory and
>> configures the target with the host allocated memory
>> information at the address taken from code swap binary.
>> This patch adds code swap support for firmware binary.
>> Code swap binary for firmware bin is available in
>> ATH10K_FW_IE_FW_CODE_SWAP_IMAGE.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>
> [...]
>
>> +static struct ath10k_swap_code_seg_info *
>> +ath10k_swap_code_seg_alloc(struct ath10k *ar, size_t swap_bin_len)
>> +{
>> +	struct ath10k_swap_code_seg_info *seg_info;
>> +	void *virt_addr;
>> +	dma_addr_t paddr;
>> +
>> +	swap_bin_len = roundup(swap_bin_len, 2);
>> +	if (swap_bin_len > ATH10K_SWAP_CODE_SEG_BIN_LEN_MAX) {
>> +		ath10k_err(ar, "refusing code swap bin because it is too big %zd > %d\n",
>> +			   swap_bin_len, ATH10K_SWAP_CODE_SEG_BIN_LEN_MAX);
>
> kbuild found a bug here, I fixed it with the patch below. Please review:
>
> --- a/drivers/net/wireless/ath/ath10k/swap.c
> +++ b/drivers/net/wireless/ath/ath10k/swap.c
> @@ -106,7 +106,7 @@ ath10k_swap_code_seg_alloc(struct ath10k *ar, size_t swap_bin_len)
>
>          swap_bin_len = roundup(swap_bin_len, 2);
>          if (swap_bin_len > ATH10K_SWAP_CODE_SEG_BIN_LEN_MAX) {
> -               ath10k_err(ar, "refusing code swap bin because it is too big %zd > %d\n",
> +               ath10k_err(ar, "refusing code swap bin because it is too big %zu > %d\n",
>                             swap_bin_len, ATH10K_SWAP_CODE_SEG_BIN_LEN_MAX);
>                  return NULL;
>          }

Looks good. Thanks.


Vasanth

