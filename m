Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43819 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab1HaGSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:18:01 -0400
Date: Wed, 31 Aug 2011 11:47:44 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath6kl: read fwlog from firmware ring buffer
Message-ID: <20110831061743.GA1234@vasanth-laptop> (sfid-20110831_081812_041924_C4D941B5)
References: <20110830134432.21543.89808.stgit@localhost6.localdomain6> <20110830134458.21543.74829.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110830134458.21543.74829.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 04:44:58PM +0300, Kalle Valo wrote:
> Firmare sends the logs only when it's internal ring buffer is full. But
> if firmware crashes we need to retrieve the latest logs through diagnose
> window. This is now done everytime the debugfs file is read.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/core.h   |   15 ++++++
>  drivers/net/wireless/ath/ath6kl/debug.c  |    3 +
>  drivers/net/wireless/ath/ath6kl/init.c   |   13 -----
>  drivers/net/wireless/ath/ath6kl/main.c   |   75 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath6kl/target.h |   14 ++++++
>  5 files changed, 107 insertions(+), 13 deletions(-)
> 
> +int ath6kl_read_fwlogs(struct ath6kl *ar)
> +{
> +	struct ath6kl_dbglog_hdr debug_hdr;
> +	struct ath6kl_dbglog_buf debug_buf;
> +	u32 address, length, dropped, firstbuf, debug_hdr_addr;
> +	int ret = 0, loop;
> +	u8 *buf;
> +
> +	buf = kmalloc(ATH6KL_FWLOG_PAYLOAD_SIZE, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	address = TARG_VTOP(ar->target_type,
> +			    ath6kl_get_hi_item_addr(ar,
> +						    HI_ITEM(hi_dbglog_hdr)));
> +
> +	ret = ath6kl_diag_read32(ar, address, &debug_hdr_addr);
> +	if (ret)
> +		goto out;
> +
> +	/* Get the contents of the ring buffer */
> +	if (debug_hdr_addr == 0) {
> +		ath6kl_warn("Invalid address for debug_hdr_addr\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	address = TARG_VTOP(ar->target_type, debug_hdr_addr);
> +	ath6kl_diag_read(ar, address, &debug_hdr, sizeof(debug_hdr));
> +
> +	address = TARG_VTOP(ar->target_type,
> +			    le32_to_cpu(debug_hdr.dbuf_addr));
> +	firstbuf = address;
> +	dropped = le32_to_cpu(debug_hdr.dropped);
> +	ath6kl_diag_read(ar, address, &debug_buf, sizeof(debug_buf));
> +
> +	loop = 100;
> +
> +	do {
> +		address = TARG_VTOP(ar->target_type,
> +				    le32_to_cpu(debug_buf.buffer_addr));
> +		length = le32_to_cpu(debug_buf.length);
> +
> +		if (length != 0 && (le32_to_cpu(debug_buf.length) <=
> +				    le32_to_cpu(debug_buf.bufsize))) {
> +			length = ALIGN(length, 4);
> +
> +			ret = ath6kl_diag_read(ar, address,
> +					       buf, length);
> +			if (ret)
> +				goto out;
> +
> +			ath6kl_debug_fwlog_event(ar, buf, length);
> +		}
> +
> +		address = TARG_VTOP(ar->target_type,
> +				    le32_to_cpu(debug_buf.next));
> +		ath6kl_diag_read(ar, address, &debug_buf, sizeof(debug_buf));

Address passed to ath6kl_diag_read32() and ath6kl_diag_read() does
not seem to be endian safe. This is not just present in your patch,
it has been already there other places as well. I'll fix this up.

Vasanth
