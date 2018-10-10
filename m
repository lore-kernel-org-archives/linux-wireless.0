Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF7DC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 01:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 283202087D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 01:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dj4B4Rv6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 283202087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbeJJIrf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 04:47:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37894 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbeJJIrf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 04:47:35 -0400
Received: by mail-pf1-f193.google.com with SMTP id f29-v6so1758496pff.5
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2018 18:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/jq99VXlr+iyhEPhyN3zeWF3DJyAWRjzxKOwo9tiL5Q=;
        b=dj4B4Rv6GUztwQXrrpwC9KdoAirqHITcrnvF4MXZiFetNa4HC3pbWjMxM2vY1SlEVv
         afIOrBTTKlc10qhhUIe8Zx24ZU43MgiSvGTEx0aVsYIRg3aKy0bizHtrH0znjet5ftcd
         2Q0qOOKdwxO4l2qgnyUN9Sem8FGjRnh4oH3TE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/jq99VXlr+iyhEPhyN3zeWF3DJyAWRjzxKOwo9tiL5Q=;
        b=S7PnWU0Sg/dWxYoGIS78dI/4oM/bdopEE80BSQHyjka3fX2gTJV5u9cR1eXRB7P2m3
         ROP7Mtpq1hRPFzLENPJJlv37hRofM2KAwDzFWUTZ+shvVLPxKM9x4fkzdgGpVf2PzKUh
         oyf+TtTR8KhpliYmrlCJ6ZY2CEOu6HZkLvj4Q66SmocMgSeAxg3CZIoNG4YzFjTJYJDw
         kFBtU3AI5knr9Dw61DcrVKDCk5DW6s+Q4FMUCvHnoPaD7FK78cxutlmmmVgwpaIMFGKa
         Fn0RrgMznsJkHfpOhc03CmRUtK2VOcjEvcXDVs7v6+zttiOLZ0bT+ML04vk4Y1IyBciC
         e4Lg==
X-Gm-Message-State: ABuFfohxYi8BOaeTmPIxSuo9n5sv5KIKVfwvL5cINVFC/gprUFsiDADs
        VXhE76UEDba3OVE1czKMyN8p3g==
X-Google-Smtp-Source: ACcGV60IwKOQWUSIXZunE6pIzh/W3bphd2HtA9cj2IoH2KY4yyAWL1USVJMaifxJWUVfw/NBZK9v1w==
X-Received: by 2002:a65:62d5:: with SMTP id m21-v6mr28333689pgv.243.1539134870761;
        Tue, 09 Oct 2018 18:27:50 -0700 (PDT)
Received: from ban.mtv.corp.google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id h14-v6sm24538440pfn.80.2018.10.09.18.27.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Oct 2018 18:27:49 -0700 (PDT)
Date:   Tue, 9 Oct 2018 18:27:47 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Carl Huang <cjhuang@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: allocate small size dma memory in
 ath10k_pci_diag_write_mem
Message-ID: <20181010012745.GA31172@ban.mtv.corp.google.com>
References: <1538992182-3717-1-git-send-email-cjhuang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538992182-3717-1-git-send-email-cjhuang@codeaurora.org>
User-Agent: Mutt/1.10.1+48 (1f3a9df87d11) (2018-07-22)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Carl,

On Mon, Oct 08, 2018 at 05:49:42PM +0800, Carl Huang wrote:
> ath10k_pci_diag_write_mem may allocate big size of the dma memory
> based on the parameter nbytes. Take firmware diag download as
> example, the biggest size is about 500K. In some systems, the
> allocation is likely to fail because it can't acquire such a large
> contiguous dma memory.
> 
> The fix is to allocate a small size dma memory. In the loop,
> driver copies the data to the allocated dma memory and writes to
> the destination until all the data is written.
> 
> Tested with QCA6174 PCI with
> firmware-6.bin_WLAN.RM.4.4.1-00119-QCARMSWP-1, this also affects
> QCA9377 PCI.
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>

Thanks for the patch! With one small comment, I think this otherwise
looks good, so feel free to add my:

Reviewed-by: Brian Norris <briannorris@chomium.org>

> ---
>  drivers/net/wireless/ath/ath10k/pci.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 873dbb6..1872671 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1071,7 +1071,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
>  	struct ath10k_ce *ce = ath10k_ce_priv(ar);
>  	int ret = 0;
>  	u32 *buf;
> -	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
> +	unsigned int completed_nbytes, alloc_nbytes, remaining_bytes;
>  	struct ath10k_ce_pipe *ce_diag;
>  	void *data_buf = NULL;
>  	u32 ce_data;	/* Host buffer address in CE space */

^^ I don't think this is needed any more.

> @@ -1088,9 +1088,10 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
>  	 *   1) 4-byte alignment
>  	 *   2) Buffer in DMA-able space
>  	 */
> -	orig_nbytes = nbytes;
> +	alloc_nbytes = min_t(unsigned int, nbytes, DIAG_TRANSFER_LIMIT);
> +
>  	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
> -						       orig_nbytes,
> +						       alloc_nbytes,
>  						       &ce_data_base,
>  						       GFP_ATOMIC);
>  	if (!data_buf) {
> @@ -1098,9 +1099,6 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
>  		goto done;
>  	}
>  
> -	/* Copy caller's data to allocated DMA buf */
> -	memcpy(data_buf, data, orig_nbytes);
> -
>  	/*
>  	 * The address supplied by the caller is in the
>  	 * Target CPU virtual address space.
> @@ -1113,12 +1111,15 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
>  	 */
>  	address = ath10k_pci_targ_cpu_to_ce_addr(ar, address);
>  
> -	remaining_bytes = orig_nbytes;
> +	remaining_bytes = nbytes;
>  	ce_data = ce_data_base;

Because you no longer need to increment 'ce_data', you can just pass
'ce_data_base' to ath10k_ce_send_nolock() now.

Regards,
Brian

>  	while (remaining_bytes) {
>  		/* FIXME: check cast */
>  		nbytes = min_t(int, remaining_bytes, DIAG_TRANSFER_LIMIT);
>  
> +		/* Copy caller's data to allocated DMA buf */
> +		memcpy(data_buf, data, nbytes);
> +
>  		/* Set up to receive directly into Target(!) address */
>  		ret = ce_diag->ops->ce_rx_post_buf(ce_diag, &address, address);
>  		if (ret != 0)
> @@ -1171,12 +1172,12 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
>  
>  		remaining_bytes -= nbytes;
>  		address += nbytes;
> -		ce_data += nbytes;
> +		data += nbytes;
>  	}
>  
>  done:
>  	if (data_buf) {
> -		dma_free_coherent(ar->dev, orig_nbytes, data_buf,
> +		dma_free_coherent(ar->dev, alloc_nbytes, data_buf,
>  				  ce_data_base);
>  	}
>  
> -- 
> 2.7.4
> 
