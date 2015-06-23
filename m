Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46560 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbbFWFs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 01:48:27 -0400
Message-ID: <5588F319.2060509@qti.qualcomm.com> (sfid-20150623_075100_218327_5385ECB0)
Date: Tue, 23 Jun 2015 11:18:09 +0530
From: rmani <rmani@qti.qualcomm.com>
MIME-Version: 1.0
To: Peter Oh <poh@codeaurora.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] ath10k: configure frag desc memory to target for
 qca99X0
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com> <1434984747-24294-9-git-send-email-rmani@qti.qualcomm.com> <55889D27.9030100@codeaurora.org>
In-Reply-To: <55889D27.9030100@codeaurora.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/23/2015 05:11 AM, Peter Oh wrote:
> Hi Raja,
>
> On 06/22/2015 07:52 AM, Raja Mani wrote:
>> Pre qca99X0 chipsets follows the model where dynamically allocate
>> memory for frag desc on getting new skb for TX. But, this is not
>> going to be the case in qca99X0. It expects frag desc memory to be
>> allocated at boot time and let the driver to reuse allocated memory
>> after every TX completion. So there won't be any dynamic frag memory
>> memory allocation in qca99X0 during data transmission.
>>
>> qca99X0 hardware doesn't need fragment desc address to be programmed
>> in msdu descriptor for every data transaction. It needs to know only
>> starting address of fragment descriptor at the time of the boot.
>> During data transmission, qca99X0 hardware can retrieve corresponding
>> frag addr by adding programmed frag desc base addr + msdu id.
>>
>> Allocate continuous fragment descriptor memory (same size as number of
>> descriptor) at the time of target initialization and configure allocated
>> dma address to the target via HTT_H2T_MSG_TYPE_FRAG_DESC_BANK_CFG.
>>
>> How this is allocated continuous memory is going to be used is not
>> covered in this patch. It just allocates memory and hand over to
>> firmware.
>> If we don't do it at init time, qca99X0 will stall when firmware tries
>> to do TX.
>>
>> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/core.c   |  1 +
>>   drivers/net/wireless/ath/ath10k/core.h   |  6 +++
>>   drivers/net/wireless/ath/ath10k/htt.c    |  4 ++
>>   drivers/net/wireless/ath/ath10k/htt.h    | 11 +++++
>>   drivers/net/wireless/ath/ath10k/htt_tx.c | 76
>> +++++++++++++++++++++++++++++++-
>>   5 files changed, 96 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.c
>> b/drivers/net/wireless/ath/ath10k/core.c
>> index 3c8d5c5..be5f01c 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -111,6 +111,7 @@ static const struct ath10k_hw_params
>> ath10k_hw_params_list[] = {
>>           .patch_load_addr = QCA99X0_HW_2_0_PATCH_LOAD_ADDR,
>>           .uart_pin = 7,
>>           .otp_exe_param = 0x00000700,
>> +        .continuous_frag_desc = true,
>>           .fw = {
>>               .dir = QCA99X0_HW_2_0_FW_DIR,
>>               .fw = QCA99X0_HW_2_0_FW_FILE,
>> diff --git a/drivers/net/wireless/ath/ath10k/core.h
>> b/drivers/net/wireless/ath/ath10k/core.h
>> index f0811d0..2e5c935 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -582,6 +582,12 @@ struct ath10k {
>>            */
>>           bool has_shifted_cc_wraparound;
>> +        /* Some of chip expects fragment descriptor to be
>> continuous
>> +         * memory for any TX operation. Set continuous_frag_desc
>> flag
>> +         * for the hardware which have such requirement.
>> +         */
>> +        bool continuous_frag_desc;
>> +
>>           struct ath10k_hw_params_fw {
>>               const char *dir;
>>               const char *fw;
>> diff --git a/drivers/net/wireless/ath/ath10k/htt.c
>> b/drivers/net/wireless/ath/ath10k/htt.c
>> index 6f71f94..4474c3e 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt.c
>> @@ -249,5 +249,9 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
>>       if (status)
>>           return status;
>> +    status = ath10k_htt_send_frag_desc_bank_cfg(htt);
>> +    if (status)
>> +        return status;
>> +
>>       return ath10k_htt_send_rx_ring_cfg_ll(htt);
>>   }
>> diff --git a/drivers/net/wireless/ath/ath10k/htt.h
>> b/drivers/net/wireless/ath/ath10k/htt.h
>> index 8e64ace..8bdf1e7 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt.h
>> +++ b/drivers/net/wireless/ath/ath10k/htt.h
>> @@ -87,6 +87,11 @@ struct htt_data_tx_desc_frag {
>>       __le32 len;
>>   } __packed;
>> +struct htt_msdu_ext_desc {
>> +    __le32 tso_flag[4];
>> +    struct htt_data_tx_desc_frag frags[6];
>> +};
>> +
>>   enum htt_data_tx_desc_flags0 {
>>       HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT = 1 << 0,
>>       HTT_DATA_TX_DESC_FLAGS0_NO_AGGR         = 1 << 1,
>> @@ -1466,6 +1471,11 @@ struct ath10k_htt {
>>       /* rx_status template */
>>       struct ieee80211_rx_status rx_status;
>> +
>> +    struct {
>> +        dma_addr_t paddr;
>> +        struct htt_msdu_ext_desc *vaddr;
> Defining structure htt_msdu_ext_desc for vaddr instead of void * which
> will be used as base address to get offset address of msdu data could
> lead unexpected address assignment when we manipulate msdu address
> pointer based on vaddr variable.
> For example vaddr variable will be used at ath10k_htt_tx like below to
> have msdu external link descriptor.
> struct htt_msdu_ext_desc *frags_ext;
> frags_ext = htt->frag_desc.vaddr + (sizeof(struct htt_msdu_ext_desc) *
> msdu_id);
> If we assume vaddr is 0xde810000 and msdu_id is 1, we expect frags_ext
> has 0xde810040, but linux memory management system could assign
> 0xde811000 to frags_ext to use continuous memory block for structure
> htt_msdu_ext_desc and it will cause data traffic failure.
> To avoid this scenario, we have to use void * for vaddr.


Here we know the type of memory what for we are allocating, thats why
i kept it as struct htt_msdu_ext_desc *. We can type cast base addr
to u8 * in future and use it in the place where frag_ext is calculated
More over, this patch doesn't cover on how each frag desc memory is
manipulated. For now, let it be type struct htt_msdu_ext_desc *.

--
Raja
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
