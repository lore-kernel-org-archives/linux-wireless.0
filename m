Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36158 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391251AbeIVCaK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 22:30:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id b11-v6so6476358pfo.3
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2018 13:39:36 -0700 (PDT)
Date: Fri, 21 Sep 2018 13:39:32 -0700
From: Brian Norris <briannorris@chromium.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: download firmware via diag Copy Engine for
 QCA6174 and QCA9377.
Message-ID: <20180921203931.GA236988@ban.mtv.corp.google.com> (sfid-20180921_223939_902634_51DF8FD5)
References: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org>
 <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Aug 30, 2018 at 10:29:42AM +0800, Carl Huang wrote:
> diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
> index 677535b..25ee1c6 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.c
> +++ b/drivers/net/wireless/ath/ath10k/hw.c
...
> +int ath10k_hw_diag_fast_download(struct ath10k *ar,
> +				 u32 address,
> +				 const void *buffer,
> +				 u32 length)
> +{
> +	const u8 *buf = buffer;
> +	bool sgmt_end = false;
> +	u32 base_addr = 0;
> +	u32 base_len = 0;
> +	u32 left = 0;
> +	struct bmi_segmented_file_header *hdr;
> +	struct bmi_segmented_metadata *metadata;
> +	int ret = 0;
> +
> +	if (length < sizeof(*hdr))
> +		return -EINVAL;
> +
> +	/* check firmware header. If it has no correct magic number
> +	 * or it's compressed, returns error.
> +	 */
> +	hdr = (struct bmi_segmented_file_header *)buf;
> +	if (hdr->magic_num != BMI_SGMTFILE_MAGIC_NUM) {
> +		ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +			   "Not a supported firmware, magic_num:0x%x\n",
> +			   hdr->magic_num);
> +		return -EINVAL;
> +	}
> +
> +	if (hdr->file_flags != 0) {
> +		ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +			   "Not a supported firmware, file_flags:0x%x\n",
> +			   hdr->file_flags);
> +		return -EINVAL;
> +	}
> +
> +	metadata = (struct bmi_segmented_metadata *)hdr->data;
> +	left = length - sizeof(*hdr);
> +
> +	while (left > 0) {
> +		base_addr = metadata->addr;
> +		base_len = metadata->length;
> +		buf = metadata->data;
> +		left -= sizeof(*metadata);

You need to ensure 'left >= sizeof(*metadata)' before this block. I can
send a patch.

Brian

> +
> +		switch (base_len) {
> +		case BMI_SGMTFILE_BEGINADDR:
> +			/* base_addr is the start address to run */
> +			ret = ath10k_bmi_set_start(ar, base_addr);
> +			base_len = 0;
> +			break;
> +		case BMI_SGMTFILE_DONE:
> +			/* no more segment */
> +			base_len = 0;
> +			sgmt_end = true;
> +			ret = 0;
> +			break;
> +		case BMI_SGMTFILE_BDDATA:
> +		case BMI_SGMTFILE_EXEC:
> +			ath10k_warn(ar,
> +				    "firmware has unsupported segment:%d\n",
> +				    base_len);
> +			ret = -EINVAL;
> +			break;
> +		default:
> +			if (base_len > left) {
> +				/* sanity check */
> +				ath10k_warn(ar,
> +					    "firmware has invalid segment length, %d > %d\n",
> +					    base_len, left);
> +				ret = -EINVAL;
> +				break;
> +			}
> +
> +			ret = ath10k_hw_diag_segment_download(ar,
> +							      buf,
> +							      base_addr,
> +							      base_len);
> +
> +			if (ret)
> +				ath10k_warn(ar,
> +					    "failed to download firmware via diag interface:%d\n",
> +					    ret);
> +			break;
> +		}
> +
> +		if (ret || sgmt_end)
> +			break;
> +
> +		metadata = (struct bmi_segmented_metadata *)(buf + base_len);
> +		left -= base_len;
> +	}
> +
> +	if (ret == 0)
> +		ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +			   "boot firmware fast diag download successfully.\n");
> +	return ret;
> +}
> +
>  const struct ath10k_hw_ops qca988x_ops = {
>  	.set_coverage_class = ath10k_hw_qca988x_set_coverage_class,
>  };
