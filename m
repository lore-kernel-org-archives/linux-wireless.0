Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51692 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3ARGPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 01:15:54 -0500
Received: by mail-wg0-f43.google.com with SMTP id e12so762166wge.22
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2013 22:15:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D140B0437@SC-VEXCH1.marvell.com>
References: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com>
 <1358248982.4648.1.camel@jlt4.sipsolutions.net> <CABPxzYJciFXV=S7BGWT_V-M8U9ydpiBT8RSJJn35oHQy+zh3aQ@mail.gmail.com>
 <CAJ-Vmon_m1bH_OTL7XitXwRvqPK2+Q-V7E=rcBdGw7Gkj58LJQ@mail.gmail.com>
 <1358378606.15012.63.camel@jlt4.sipsolutions.net> <CABPxzY+2qNLxoySMou+PzqzfhK4ZOVfcP08BwZGx0J2Bz3Sd1Q@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430D140B0437@SC-VEXCH1.marvell.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 18 Jan 2013 11:45:33 +0530
Message-ID: <CABPxzYLkL9HrLU=D_HANmKxx3Nb5o7tYXvdKwWOCzZHgQo=tDA@mail.gmail.com> (sfid-20130118_071558_273336_059E85CA)
Subject: Re: Tx AMSDU Support
To: Bing Zhao <bzhao@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Adrian Chadd <adrian@freebsd.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks a lot Bing. Its very helpful, will do that.

On Fri, Jan 18, 2013 at 12:59 AM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Krishna,
>
>> Ok...will try with the below ones..Marvell definitely has support for AMSDU Tx.
>
> mwifiex driver uses AMPDU aggregation by default. Please apply the following change to disable AMPDU so that AMSDU can be chosen for aggregation. Also increase the Tx buffer size to 4K to allow AMSDU aggregation for two 1500-byte packets. Or, you can use 8K to aggregate more packets for your tests.
>
> ---
> diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
> index e00b806..97ef459 100644
> --- a/drivers/net/wireless/mwifiex/init.c
> +++ b/drivers/net/wireless/mwifiex/init.c
> @@ -317,9 +317,9 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
>
>         adapter->pm_wakeup_fw_try = false;
>
> -       adapter->max_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
> -       adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
> -       adapter->curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
> +       adapter->max_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
> +       adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
> +       adapter->curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
>
>         adapter->is_hs_configured = false;
>         adapter->hs_cfg.conditions = cpu_to_le32(HOST_SLEEP_CFG_COND_DEF);
> diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
> index 135d96d..ea722c2 100644
> --- a/drivers/net/wireless/mwifiex/wmm.c
> +++ b/drivers/net/wireless/mwifiex/wmm.c
> @@ -425,8 +425,8 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
>
>                 for (i = 0; i < MAX_NUM_TID; ++i) {
>                         priv->aggr_prio_tbl[i].amsdu = tos_to_tid_inv[i];
> -                       priv->aggr_prio_tbl[i].ampdu_ap = tos_to_tid_inv[i];
> -                       priv->aggr_prio_tbl[i].ampdu_user = tos_to_tid_inv[i];
> +                       priv->aggr_prio_tbl[i].ampdu_ap = BA_STREAM_NOT_ALLOWED;
> +                       priv->aggr_prio_tbl[i].ampdu_user = BA_STREAM_NOT_ALLOWED;
>                         priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
>                 }
>
> --
>
> Patch attached for your convenience.
>
> Thanks,
> Bing
>
>>
>> On Thu, Jan 17, 2013 at 4:53 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Wed, 2013-01-16 at 15:05 -0800, Adrian Chadd wrote:
>> >> .. for testing that out, I ended up just using a NIC that implements
>> >> AMSDU in software.
>> >>
>> >> God knows what it was though (intel?)..
>> >
>> > Probably Broadcom and/or Marvell.
>> >
>> > johannes
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
