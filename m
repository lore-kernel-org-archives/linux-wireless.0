Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38468 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbeIVGoz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 02:44:55 -0400
Received: by mail-pl1-f193.google.com with SMTP id u11-v6so6646486plq.5
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2018 17:53:31 -0700 (PDT)
Date: Fri, 21 Sep 2018 17:53:27 -0700
From: Brian Norris <briannorris@chromium.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: download firmware via diag Copy Engine for
 QCA6174 and QCA9377.
Message-ID: <20180922005325.GA47003@ban.mtv.corp.google.com> (sfid-20180922_025557_643068_3E602B6C)
References: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org>
 <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again!

One last (?) comment:

On Thu, Aug 30, 2018 at 10:29:42AM +0800, Carl Huang wrote:

> diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
> index 677535b..25ee1c6 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.c
> +++ b/drivers/net/wireless/ath/ath10k/hw.c

> @@ -918,6 +919,190 @@ static int ath10k_hw_qca6174_enable_pll_clock(struct ath10k *ar)

> +static int ath10k_hw_diag_segment_download(struct ath10k *ar,
> +					   const void *buffer,
> +					   u32 address,
> +					   u32 length)
> +{
> +	if (address >= DRAM_BASE_ADDRESS + REGION_ACCESS_SIZE_LIMIT)
> +		/* Needs to change MSB for memory write */
> +		return ath10k_hw_diag_segment_msb_download(ar, buffer,
> +							   address, length);
> +	else
> +		return ath10k_hif_diag_write(ar, address, buffer, length);
> +}
> +
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
> +
> +		switch (base_len) {
...
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

This 'base_len' is determined by the firmware blob and in common cases
is over 500K. The PCI implementation currently tries to
dma_alloc_coherent() a bounce buffer for this. Many systems can't
acquire that large of contiguous DMA memory reliably, so this is isn't
very effective. Can we improve the strategy here? Do you lose a lot of
speed if you do this in smaller (a few pages?) chunks instead?

Brian

> +
> +			if (ret)
> +				ath10k_warn(ar,
> +					    "failed to download firmware via diag interface:%d\n",
> +					    ret);
> +			break;
...
