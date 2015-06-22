Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34554 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbbFVXpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 19:45:11 -0400
Message-ID: <55889D27.9030100@codeaurora.org> (sfid-20150623_014517_944955_8C6CCE91)
Date: Mon, 22 Jun 2015 16:41:27 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Raja Mani <rmani@qti.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 8/8] ath10k: configure frag desc memory to target for
 qca99X0
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com> <1434984747-24294-9-git-send-email-rmani@qti.qualcomm.com>
In-Reply-To: <1434984747-24294-9-git-send-email-rmani@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Raja,

On 06/22/2015 07:52 AM, Raja Mani wrote:
> Pre qca99X0 chipsets follows the model where dynamically allocate
> memory for frag desc on getting new skb for TX. But, this is not
> going to be the case in qca99X0. It expects frag desc memory to be
> allocated at boot time and let the driver to reuse allocated memory
> after every TX completion. So there won't be any dynamic frag memory
> memory allocation in qca99X0 during data transmission.
>
> qca99X0 hardware doesn't need fragment desc address to be programmed
> in msdu descriptor for every data transaction. It needs to know only
> starting address of fragment descriptor at the time of the boot.
> During data transmission, qca99X0 hardware can retrieve corresponding
> frag addr by adding programmed frag desc base addr + msdu id.
>
> Allocate continuous fragment descriptor memory (same size as number of
> descriptor) at the time of target initialization and configure allocated
> dma address to the target via HTT_H2T_MSG_TYPE_FRAG_DESC_BANK_CFG.
>
> How this is allocated continuous memory is going to be used is not
> covered in this patch. It just allocates memory and hand over to firmware.
> If we don't do it at init time, qca99X0 will stall when firmware tries
> to do TX.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/core.c   |  1 +
>   drivers/net/wireless/ath/ath10k/core.h   |  6 +++
>   drivers/net/wireless/ath/ath10k/htt.c    |  4 ++
>   drivers/net/wireless/ath/ath10k/htt.h    | 11 +++++
>   drivers/net/wireless/ath/ath10k/htt_tx.c | 76
> +++++++++++++++++++++++++++++++-
>   5 files changed, 96 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c
> b/drivers/net/wireless/ath/ath10k/core.c
> index 3c8d5c5..be5f01c 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -111,6 +111,7 @@ static const struct ath10k_hw_params
> ath10k_hw_params_list[] = {
>   		.patch_load_addr = QCA99X0_HW_2_0_PATCH_LOAD_ADDR,
>   		.uart_pin = 7,
>   		.otp_exe_param = 0x00000700,
> +		.continuous_frag_desc = true,
>   		.fw = {
>   			.dir = QCA99X0_HW_2_0_FW_DIR,
>   			.fw = QCA99X0_HW_2_0_FW_FILE,
> diff --git a/drivers/net/wireless/ath/ath10k/core.h
> b/drivers/net/wireless/ath/ath10k/core.h
> index f0811d0..2e5c935 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -582,6 +582,12 @@ struct ath10k {
>   		 */
>   		bool has_shifted_cc_wraparound;
>   
> +		/* Some of chip expects fragment descriptor to be
> continuous
> +		 * memory for any TX operation. Set continuous_frag_desc
> flag
> +		 * for the hardware which have such requirement.
> +		 */
> +		bool continuous_frag_desc;
> +
>   		struct ath10k_hw_params_fw {
>   			const char *dir;
>   			const char *fw;
> diff --git a/drivers/net/wireless/ath/ath10k/htt.c
> b/drivers/net/wireless/ath/ath10k/htt.c
> index 6f71f94..4474c3e 100644
> --- a/drivers/net/wireless/ath/ath10k/htt.c
> +++ b/drivers/net/wireless/ath/ath10k/htt.c
> @@ -249,5 +249,9 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
>   	if (status)
>   		return status;
>   
> +	status = ath10k_htt_send_frag_desc_bank_cfg(htt);
> +	if (status)
> +		return status;
> +
>   	return ath10k_htt_send_rx_ring_cfg_ll(htt);
>   }
> diff --git a/drivers/net/wireless/ath/ath10k/htt.h
> b/drivers/net/wireless/ath/ath10k/htt.h
> index 8e64ace..8bdf1e7 100644
> --- a/drivers/net/wireless/ath/ath10k/htt.h
> +++ b/drivers/net/wireless/ath/ath10k/htt.h
> @@ -87,6 +87,11 @@ struct htt_data_tx_desc_frag {
>   	__le32 len;
>   } __packed;
>   
> +struct htt_msdu_ext_desc {
> +	__le32 tso_flag[4];
> +	struct htt_data_tx_desc_frag frags[6];
> +};
> +
>   enum htt_data_tx_desc_flags0 {
>   	HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT = 1 << 0,
>   	HTT_DATA_TX_DESC_FLAGS0_NO_AGGR         = 1 << 1,
> @@ -1466,6 +1471,11 @@ struct ath10k_htt {
>   
>   	/* rx_status template */
>   	struct ieee80211_rx_status rx_status;
> +
> +	struct {
> +		dma_addr_t paddr;
> +		struct htt_msdu_ext_desc *vaddr;
Defining structure htt_msdu_ext_desc for vaddr instead of void * which 
will be used as base address to get offset address of msdu data could 
lead unexpected address assignment when we manipulate msdu address 
pointer based on vaddr variable.
For example vaddr variable will be used at ath10k_htt_tx like below to 
have msdu external link descriptor.
struct htt_msdu_ext_desc *frags_ext;
frags_ext = htt->frag_desc.vaddr + (sizeof(struct htt_msdu_ext_desc) * 
msdu_id);
If we assume vaddr is 0xde810000 and msdu_id is 1, we expect frags_ext 
has 0xde810040, but linux memory management system could assign 
0xde811000 to frags_ext to use continuous memory block for structure 
htt_msdu_ext_desc and it will cause data traffic failure.
To avoid this scenario, we have to use void * for vaddr.
> +	} frag_desc;
>   };
>   
>   #define RX_HTT_HDR_STATUS_LEN 64
> @@ -1533,6 +1543,7 @@ void ath10k_htt_htc_tx_complete(struct ath10k *ar,
> struct sk_buff *skb);
>   void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
>   int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
>   int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64
> cookie);
> +int ath10k_htt_send_frag_desc_bank_cfg(struct ath10k_htt *htt);
>   int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt);
>   int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
>   				u8 max_subfrms_ampdu,
> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c
> b/drivers/net/wireless/ath/ath10k/htt_tx.c
> index a60ef7d..148d5b6 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> @@ -84,6 +84,7 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt,
> u16 msdu_id)
>   int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
>   {
>   	struct ath10k *ar = htt->ar;
> +	int ret, size;
>   
>   	ath10k_dbg(ar, ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
>   		   htt->max_num_pending_tx);
> @@ -94,11 +95,31 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
>   	htt->tx_pool = dma_pool_create("ath10k htt tx pool", htt->ar->dev,
>   				       sizeof(struct ath10k_htt_txbuf), 4,
> 0);
>   	if (!htt->tx_pool) {
> -		idr_destroy(&htt->pending_tx);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto free_idr_pending_tx;
> +	}
> +
> +	if (!ar->hw_params.continuous_frag_desc)
> +		goto skip_frag_desc_alloc;
> +
> +	size = htt->max_num_pending_tx * sizeof(struct htt_msdu_ext_desc);
> +	htt->frag_desc.vaddr = dma_alloc_coherent(ar->dev, size,
> +						  &htt->frag_desc.paddr,
> +						  GFP_DMA);
> +	if (!htt->frag_desc.vaddr) {
> +		ath10k_warn(ar, "failed to alloc fragment desc memory\n");
> +		ret = -ENOMEM;
> +		goto free_tx_pool;
>   	}
>   
> +skip_frag_desc_alloc:
>   	return 0;
> +
> +free_tx_pool:
> +	dma_pool_destroy(htt->tx_pool);
> +free_idr_pending_tx:
> +	idr_destroy(&htt->pending_tx);
> +	return ret;
>   }
>   
>   static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void
> *ctx)
> @@ -121,9 +142,18 @@ static int ath10k_htt_tx_clean_up_pending(int
> msdu_id, void *skb, void *ctx)
>   
>   void ath10k_htt_tx_free(struct ath10k_htt *htt)
>   {
> +	int size;
> +
>   	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending,
> htt->ar);
>   	idr_destroy(&htt->pending_tx);
>   	dma_pool_destroy(htt->tx_pool);
> +
> +	if (htt->frag_desc.vaddr) {
> +		size = htt->max_num_pending_tx *
> +				  sizeof(struct htt_msdu_ext_desc);
> +		dma_free_coherent(htt->ar->dev, size,
> htt->frag_desc.vaddr,
> +				  htt->frag_desc.paddr);
> +	}
>   }
>   
>   void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
> @@ -201,6 +231,48 @@ int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt,
> u8 mask, u64 cookie)
>   	return 0;
>   }
>   
> +int ath10k_htt_send_frag_desc_bank_cfg(struct ath10k_htt *htt)
> +{
> +	struct ath10k *ar = htt->ar;
> +	struct sk_buff *skb;
> +	struct htt_cmd *cmd;
> +	int ret, size;
> +
> +	if (!ar->hw_params.continuous_frag_desc)
> +		return 0;
> +
> +	if (!htt->frag_desc.paddr) {
> +		ath10k_warn(ar, "invalid frag desc memory\n");
> +		return -EINVAL;
> +	}
> +
> +	size = sizeof(cmd->hdr) + sizeof(cmd->frag_desc_bank_cfg);
> +	skb = ath10k_htc_alloc_skb(ar, size);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	skb_put(skb, size);
> +	cmd = (struct htt_cmd *)skb->data;
> +	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_FRAG_DESC_BANK_CFG;
> +	cmd->frag_desc_bank_cfg.info = 0;
> +	cmd->frag_desc_bank_cfg.num_banks = 1;
> +	cmd->frag_desc_bank_cfg.desc_size = sizeof(struct
> htt_msdu_ext_desc);
> +	cmd->frag_desc_bank_cfg.bank_base_addrs[0] =
> +				__cpu_to_le32(htt->frag_desc.paddr);
> +	cmd->frag_desc_bank_cfg.bank_id[0].bank_max_id =
> +				__cpu_to_le16(htt->max_num_pending_tx -
> 1);
> +
> +	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to send frag desc bank cfg
> request: %d\n",
> +			    ret);
> +		dev_kfree_skb_any(skb);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>   int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
>   {
>   	struct ath10k *ar = htt->ar;
Regards,
Peter
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
