Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D74C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 18:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63E4320989
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 18:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jBCse8as"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733244AbfA3S50 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 13:57:26 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46617 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732841AbfA3S50 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 13:57:26 -0500
Received: by mail-pl1-f195.google.com with SMTP id t13so216209ply.13
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2019 10:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F9vTkXe2ZcaLkR5VAAHSi2roCZQo+lX1Lb0eNev4vuo=;
        b=jBCse8asB54vee5Fps5w/6TFiH1y8Xl1ynlkNST560AnFlbGrIxDs55mDApGL9Xx46
         LboKewcH/BSdT30ICfRtkhgTU+CjrfTc5MuhsFGfIQz9JC7uOVA/0phLtzvrj4SQ6EhM
         r0FTAu2XG1Px8YAVXkJYoVDdocjsunBSKZat0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F9vTkXe2ZcaLkR5VAAHSi2roCZQo+lX1Lb0eNev4vuo=;
        b=cQBOWGP7sxIn+pO6yoJsdrRX964iXkDXw1EIBIPYdvnPPn03/Hv55bGQ/S2zor7cZM
         HovYkhK+dpgVyFbIA1Rv+2oQMXyOgUI9AZdF19jREYUNHCKvMbGNkOJ7IbIwFyPAFbX4
         ZXefctyewCMoS/Yy9J5C9BC3brQxHR/q9SV8dDo+mcyNCntIxxUNZGwb3SilWwEcM3Of
         AD3Wc0rQZy9VabFe9f/Q1pRQ1eFJkg60X/pOcH0lu19Ci69olEOIeNOaEn5yhTf2jpqe
         T81iNBSycpXv5qbW/2Mmsf1pwQz4tbSCumdOcbXuxw4Tt0xv2pgEOrlUzNPg6m3ZUjCw
         tOZg==
X-Gm-Message-State: AJcUukfJiGnJOQumZz6txQlCMzOcrHI4p8sxzXk8RCblRrpQjONQg+Bg
        oFi21hGSoJ2N3hqF+NnV5vv2Ss2KFYE=
X-Google-Smtp-Source: ALg8bN7my+yuALLOYvdVHgEhXop82ZhEKG0MKN4s7Pe/IfzS1PGaVtXuPPM7BywHFOQw2FUEpmqOtg==
X-Received: by 2002:a17:902:9305:: with SMTP id bc5mr31152635plb.86.1548874644809;
        Wed, 30 Jan 2019 10:57:24 -0800 (PST)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id s9sm2698773pgl.88.2019.01.30.10.57.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 10:57:23 -0800 (PST)
Date:   Wed, 30 Jan 2019 10:57:22 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Set DMA address mask to 35 bit for WCN3990
Message-ID: <20190130185721.GT31919@minitux>
References: <1535992622-5074-1-git-send-email-pillair@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535992622-5074-1-git-send-email-pillair@codeaurora.org>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon 03 Sep 09:37 PDT 2018, Rakesh Pillai wrote:

> WCN3990 is a 37-bit target but can address memory range
> only upto 35 bits. The 36th bit is used to control the
> smmu/iommu translation and the 37th bit is used by the
> internal bus masters to access the wifi subsystem internal
> SRAM. With the DMA mask set to 37i-bit, the host driver
> can get 37-bit dma address, which leads to incorrect
> address access in the target.
> 
> Hence the host driver can used addresses upto 35-bit
> for WCN3990. Fix the dma mask for wcn3990 to 35-bit,
> instead of 37-bit.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>

This solves the problem I'm seeing on my SDM845, where I see a
translation fault on a 32-bit address from the IOMMU, which we
previously mapped the 36 bit version of (my dma-ranges is set to 36
bits).

So:

Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>


However, some of the changes in this patch and the fact that I get a
translation error on the lower 32 bits of the mapped iova, makes me
suspect that while the hardware is capable of 37 bits, the driver only
dealt with the lower 32.  And if that's the case I would like to see
that mentioned in the commit message.

Regards,
Bjorn

> ---
>  drivers/net/wireless/ath/ath10k/ce.c     | 75 ++++++++++++++++++++----
>  drivers/net/wireless/ath/ath10k/ce.h     | 14 +++--
>  drivers/net/wireless/ath/ath10k/htt_tx.c |  2 +-
>  drivers/net/wireless/ath/ath10k/hw.c     | 10 ++--
>  drivers/net/wireless/ath/ath10k/hw.h     |  6 +-
>  drivers/net/wireless/ath/ath10k/snoc.c   |  2 +-
>  6 files changed, 84 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
> index 3b96a43fbda4..7c6733b026e5 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -228,11 +228,31 @@ ath10k_ce_shadow_dest_ring_write_index_set(struct ath10k *ar,
>  }
>  
>  static inline void ath10k_ce_src_ring_base_addr_set(struct ath10k *ar,
> -						    u32 ce_ctrl_addr,
> -						    unsigned int addr)
> +						    u32 ce_id,
> +						    u64 addr)
> +{
> +	struct ath10k_ce *ce = ath10k_ce_priv(ar);
> +	struct ath10k_ce_pipe *ce_state = &ce->ce_states[ce_id];
> +	u32 ce_ctrl_addr = ath10k_ce_base_address(ar, ce_id);
> +	u32 addr_lo = lower_32_bits(addr);
> +
> +	ath10k_ce_write32(ar, ce_ctrl_addr +
> +			  ar->hw_ce_regs->sr_base_addr_lo, addr_lo);
> +
> +	if (ce_state->ops->ce_set_src_ring_base_addr_hi) {
> +		ce_state->ops->ce_set_src_ring_base_addr_hi(ar, ce_ctrl_addr,
> +							    addr);
> +	}
> +}
> +
> +static void ath10k_ce_set_src_ring_base_addr_hi(struct ath10k *ar,
> +						u32 ce_ctrl_addr,
> +						u64 addr)
>  {
> +	u32 addr_hi = upper_32_bits(addr) & CE_DESC_ADDR_HI_MASK;
> +
>  	ath10k_ce_write32(ar, ce_ctrl_addr +
> -			  ar->hw_ce_regs->sr_base_addr, addr);
> +			  ar->hw_ce_regs->sr_base_addr_hi, addr_hi);
>  }
>  
>  static inline void ath10k_ce_src_ring_size_set(struct ath10k *ar,
> @@ -313,11 +333,36 @@ static inline u32 ath10k_ce_dest_ring_read_index_get(struct ath10k *ar,
>  }
>  
>  static inline void ath10k_ce_dest_ring_base_addr_set(struct ath10k *ar,
> -						     u32 ce_ctrl_addr,
> -						     u32 addr)
> +						     u32 ce_id,
> +						     u64 addr)
>  {
> +	struct ath10k_ce *ce = ath10k_ce_priv(ar);
> +	struct ath10k_ce_pipe *ce_state = &ce->ce_states[ce_id];
> +	u32 ce_ctrl_addr = ath10k_ce_base_address(ar, ce_id);
> +	u32 addr_lo = lower_32_bits(addr);
> +
> +	ath10k_ce_write32(ar, ce_ctrl_addr +
> +			  ar->hw_ce_regs->dr_base_addr_lo, addr_lo);
> +
> +	if (ce_state->ops->ce_set_dest_ring_base_addr_hi) {
> +		ce_state->ops->ce_set_dest_ring_base_addr_hi(ar, ce_ctrl_addr,
> +							     addr);
> +	}
> +}
> +
> +static void ath10k_ce_set_dest_ring_base_addr_hi(struct ath10k *ar,
> +						 u32 ce_ctrl_addr,
> +						 u64 addr)
> +{
> +	u32 addr_hi = upper_32_bits(addr) & CE_DESC_ADDR_HI_MASK;
> +	u32 reg_value;
> +
> +	reg_value = ath10k_ce_read32(ar, ce_ctrl_addr +
> +				     ar->hw_ce_regs->dr_base_addr_hi);
> +	reg_value &= ~CE_DESC_ADDR_HI_MASK;
> +	reg_value |= addr_hi;
>  	ath10k_ce_write32(ar, ce_ctrl_addr +
> -			  ar->hw_ce_regs->dr_base_addr, addr);
> +			  ar->hw_ce_regs->dr_base_addr_hi, reg_value);
>  }
>  
>  static inline void ath10k_ce_dest_ring_size_set(struct ath10k *ar,
> @@ -563,7 +608,7 @@ static int _ath10k_ce_send_nolock_64(struct ath10k_ce_pipe *ce_state,
>  
>  	addr = (__le32 *)&sdesc.addr;
>  
> -	flags |= upper_32_bits(buffer) & CE_DESC_FLAGS_GET_MASK;
> +	flags |= upper_32_bits(buffer) & CE_DESC_ADDR_HI_MASK;
>  	addr[0] = __cpu_to_le32(buffer);
>  	addr[1] = __cpu_to_le32(flags);
>  	if (flags & CE_SEND_FLAG_GATHER)
> @@ -731,7 +776,7 @@ static int __ath10k_ce_rx_post_buf_64(struct ath10k_ce_pipe *pipe,
>  		return -ENOSPC;
>  
>  	desc->addr = __cpu_to_le64(paddr);
> -	desc->addr &= __cpu_to_le64(CE_DESC_37BIT_ADDR_MASK);
> +	desc->addr &= __cpu_to_le64(CE_DESC_ADDR_MASK);
>  
>  	desc->nbytes = 0;
>  
> @@ -1336,7 +1381,7 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
>  		ath10k_ce_src_ring_write_index_get(ar, ctrl_addr);
>  	src_ring->write_index &= src_ring->nentries_mask;
>  
> -	ath10k_ce_src_ring_base_addr_set(ar, ctrl_addr,
> +	ath10k_ce_src_ring_base_addr_set(ar, ce_id,
>  					 src_ring->base_addr_ce_space);
>  	ath10k_ce_src_ring_size_set(ar, ctrl_addr, nentries);
>  	ath10k_ce_src_ring_dmax_set(ar, ctrl_addr, attr->src_sz_max);
> @@ -1375,7 +1420,7 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
>  		ath10k_ce_dest_ring_write_index_get(ar, ctrl_addr);
>  	dest_ring->write_index &= dest_ring->nentries_mask;
>  
> -	ath10k_ce_dest_ring_base_addr_set(ar, ctrl_addr,
> +	ath10k_ce_dest_ring_base_addr_set(ar, ce_id,
>  					  dest_ring->base_addr_ce_space);
>  	ath10k_ce_dest_ring_size_set(ar, ctrl_addr, nentries);
>  	ath10k_ce_dest_ring_byte_swap_set(ar, ctrl_addr, 0);
> @@ -1659,7 +1704,7 @@ static void ath10k_ce_deinit_src_ring(struct ath10k *ar, unsigned int ce_id)
>  {
>  	u32 ctrl_addr = ath10k_ce_base_address(ar, ce_id);
>  
> -	ath10k_ce_src_ring_base_addr_set(ar, ctrl_addr, 0);
> +	ath10k_ce_src_ring_base_addr_set(ar, ce_id, 0);
>  	ath10k_ce_src_ring_size_set(ar, ctrl_addr, 0);
>  	ath10k_ce_src_ring_dmax_set(ar, ctrl_addr, 0);
>  	ath10k_ce_src_ring_highmark_set(ar, ctrl_addr, 0);
> @@ -1669,7 +1714,7 @@ static void ath10k_ce_deinit_dest_ring(struct ath10k *ar, unsigned int ce_id)
>  {
>  	u32 ctrl_addr = ath10k_ce_base_address(ar, ce_id);
>  
> -	ath10k_ce_dest_ring_base_addr_set(ar, ctrl_addr, 0);
> +	ath10k_ce_dest_ring_base_addr_set(ar, ce_id, 0);
>  	ath10k_ce_dest_ring_size_set(ar, ctrl_addr, 0);
>  	ath10k_ce_dest_ring_highmark_set(ar, ctrl_addr, 0);
>  }
> @@ -1801,6 +1846,8 @@ static const struct ath10k_ce_ops ce_ops = {
>  	.ce_extract_desc_data = ath10k_ce_extract_desc_data,
>  	.ce_free_pipe = _ath10k_ce_free_pipe,
>  	.ce_send_nolock = _ath10k_ce_send_nolock,
> +	.ce_set_src_ring_base_addr_hi = NULL,
> +	.ce_set_dest_ring_base_addr_hi = NULL,
>  };
>  
>  static const struct ath10k_ce_ops ce_64_ops = {
> @@ -1813,6 +1860,8 @@ static const struct ath10k_ce_ops ce_64_ops = {
>  	.ce_extract_desc_data = ath10k_ce_extract_desc_data_64,
>  	.ce_free_pipe = _ath10k_ce_free_pipe_64,
>  	.ce_send_nolock = _ath10k_ce_send_nolock_64,
> +	.ce_set_src_ring_base_addr_hi = ath10k_ce_set_src_ring_base_addr_hi,
> +	.ce_set_dest_ring_base_addr_hi = ath10k_ce_set_dest_ring_base_addr_hi,
>  };
>  
>  static void ath10k_ce_set_ops(struct ath10k *ar,
> @@ -1908,7 +1957,7 @@ void ath10k_ce_alloc_rri(struct ath10k *ar)
>  			  lower_32_bits(ce->paddr_rri));
>  	ath10k_ce_write32(ar, ar->hw_ce_regs->ce_rri_high,
>  			  (upper_32_bits(ce->paddr_rri) &
> -			  CE_DESC_FLAGS_GET_MASK));
> +			  CE_DESC_ADDR_HI_MASK));
>  
>  	for (i = 0; i < CE_COUNT; i++) {
>  		ctrl1_regs = ar->hw_ce_regs->ctrl1_regs->addr;
> diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
> index dbeffaef6024..677b852bfaa2 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.h
> +++ b/drivers/net/wireless/ath/ath10k/ce.h
> @@ -39,8 +39,8 @@ struct ath10k_ce_pipe;
>  #define CE_DESC_FLAGS_BYTE_SWAP      (1 << 1)
>  #define CE_WCN3990_DESC_FLAGS_GATHER BIT(31)
>  
> -#define CE_DESC_FLAGS_GET_MASK		GENMASK(4, 0)
> -#define CE_DESC_37BIT_ADDR_MASK		GENMASK_ULL(37, 0)
> +#define CE_DESC_ADDR_MASK		GENMASK_ULL(34, 0)
> +#define CE_DESC_ADDR_HI_MASK		GENMASK(4, 0)
>  
>  /* Following desc flags are used in QCA99X0 */
>  #define CE_DESC_FLAGS_HOST_INT_DIS	(1 << 2)
> @@ -104,7 +104,7 @@ struct ath10k_ce_ring {
>  	/* Host address space */
>  	void *base_addr_owner_space_unaligned;
>  	/* CE address space */
> -	u32 base_addr_ce_space_unaligned;
> +	dma_addr_t base_addr_ce_space_unaligned;
>  
>  	/*
>  	 * Actual start of descriptors.
> @@ -115,7 +115,7 @@ struct ath10k_ce_ring {
>  	void *base_addr_owner_space;
>  
>  	/* CE address space */
> -	u32 base_addr_ce_space;
> +	dma_addr_t base_addr_ce_space;
>  
>  	char *shadow_base_unaligned;
>  	struct ce_desc *shadow_base;
> @@ -331,6 +331,12 @@ struct ath10k_ce_ops {
>  			      void *per_transfer_context,
>  			      dma_addr_t buffer, u32 nbytes,
>  			      u32 transfer_id, u32 flags);
> +	void (*ce_set_src_ring_base_addr_hi)(struct ath10k *ar,
> +					     u32 ce_ctrl_addr,
> +					     u64 addr);
> +	void (*ce_set_dest_ring_base_addr_hi)(struct ath10k *ar,
> +					      u32 ce_ctrl_addr,
> +					      u64 addr);
>  };
>  
>  static inline u32 ath10k_ce_base_address(struct ath10k *ar, unsigned int ce_id)
> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
> index 5d8b97a0ccaa..0dcfb8fe8cdd 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> @@ -1359,7 +1359,7 @@ static int ath10k_htt_tx_64(struct ath10k_htt *htt,
>  	u16 msdu_id, flags1 = 0;
>  	u16 freq = 0;
>  	dma_addr_t frags_paddr = 0;
> -	u32 txbuf_paddr;
> +	dma_addr_t txbuf_paddr;
>  	struct htt_msdu_ext_desc_64 *ext_desc = NULL;
>  	struct htt_msdu_ext_desc_64 *ext_desc_t = NULL;
>  
> diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
> index 989bd9172b77..aedd631a61cf 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.c
> +++ b/drivers/net/wireless/ath/ath10k/hw.c
> @@ -317,9 +317,11 @@ static struct ath10k_hw_ce_ctrl1_upd wcn3990_ctrl1_upd = {
>  };
>  
>  const struct ath10k_hw_ce_regs wcn3990_ce_regs = {
> -	.sr_base_addr		= 0x00000000,
> +	.sr_base_addr_lo	= 0x00000000,
> +	.sr_base_addr_hi	= 0x00000004,
>  	.sr_size_addr		= 0x00000008,
> -	.dr_base_addr		= 0x0000000c,
> +	.dr_base_addr_lo	= 0x0000000c,
> +	.dr_base_addr_hi	= 0x00000010,
>  	.dr_size_addr		= 0x00000014,
>  	.misc_ie_addr		= 0x00000034,
>  	.sr_wr_index_addr	= 0x0000003c,
> @@ -464,9 +466,9 @@ static struct ath10k_hw_ce_dst_src_wm_regs qcax_wm_dst_ring = {
>  };
>  
>  const struct ath10k_hw_ce_regs qcax_ce_regs = {
> -	.sr_base_addr		= 0x00000000,
> +	.sr_base_addr_lo	= 0x00000000,
>  	.sr_size_addr		= 0x00000004,
> -	.dr_base_addr		= 0x00000008,
> +	.dr_base_addr_lo	= 0x00000008,
>  	.dr_size_addr		= 0x0000000c,
>  	.ce_cmd_addr		= 0x00000018,
>  	.misc_ie_addr		= 0x00000034,
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index 13e885f046d5..8f513d798a0e 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -343,9 +343,11 @@ struct ath10k_hw_ce_ctrl1_upd {
>  };
>  
>  struct ath10k_hw_ce_regs {
> -	u32 sr_base_addr;
> +	u32 sr_base_addr_lo;
> +	u32 sr_base_addr_hi;
>  	u32 sr_size_addr;
> -	u32 dr_base_addr;
> +	u32 dr_base_addr_lo;
> +	u32 dr_base_addr_hi;
>  	u32 dr_size_addr;
>  	u32 ce_cmd_addr;
>  	u32 misc_ie_addr;
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index 865916223d91..4ce1c5c5575e 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -65,7 +65,7 @@ static void ath10k_snoc_htt_htc_rx_cb(struct ath10k_ce_pipe *ce_state);
>  
>  static const struct ath10k_snoc_drv_priv drv_priv = {
>  	.hw_rev = ATH10K_HW_WCN3990,
> -	.dma_mask = DMA_BIT_MASK(37),
> +	.dma_mask = DMA_BIT_MASK(35),
>  	.msa_size = 0x100000,
>  };
>  
> -- 
> 2.17.1
> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
