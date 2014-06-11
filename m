Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:45827 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbaFKLky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 07:40:54 -0400
Received: by mail-ig0-f181.google.com with SMTP id h3so626651igd.14
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 04:40:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401969147-3532-2-git-send-email-sgruszka@redhat.com>
References: <1401969147-3532-1-git-send-email-sgruszka@redhat.com>
	<1401969147-3532-2-git-send-email-sgruszka@redhat.com>
Date: Wed, 11 Jun 2014 13:40:53 +0200
Message-ID: <CAGXE3d8wQscwEnk04L7LFh6RoasmJ4JumqCUT_44hKepdM_Xvw@mail.gmail.com> (sfid-20140611_134108_105603_6FD59023)
Subject: Re: [PATCH 2/5] rt2x00: change beaconing setup on RT2800
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Matthias Fend <Matthias.Fend@wolfvision.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 5, 2014 at 1:52 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> As reported by Matthias, on 5572 chip, even if we clear up TXWI
> of corresponding beacon, hardware still try to send it or do other
> action that increase power consumption peak up to 1A.
>
> To avoid the issue, setup beaconing dynamically by configuring offsets
> of currently active beacons and MAC_BSSID_DW1_BSS_BCN_NUM variable,
> which limit number of beacons that hardware will try to send.

I was thinking of doing that for a long time, glad you've picked it up!
Thanks a lot Stanislaw.

> Reported-by: Matthias Fend <Matthias.Fend@wolfvision.net>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>


No extensive review but still looks good to me:

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c   | 45 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2x00queue.h |  1 +
>  2 files changed, 46 insertions(+)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index c17fcf2..c45b2d3 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -947,6 +947,40 @@ static inline u8 rt2800_get_beacon_offset(struct rt2x00_dev *rt2x00dev,
>         return BEACON_BASE_TO_OFFSET(rt2800_hw_beacon_base(rt2x00dev, index));
>  }
>
> +static void rt2800_update_beacons_setup(struct rt2x00_dev *rt2x00dev)
> +{
> +       struct data_queue *queue = rt2x00dev->bcn;
> +       struct queue_entry *entry;
> +       int i, bcn_num = 0;
> +       u64 off, reg = 0;
> +       u32 bssid_dw1;
> +
> +       /*
> +        * Setup offsets of all active beacons in BCN_OFFSET{0,1} registers.
> +        */
> +       for (i = 0; i < queue->limit; i++) {
> +               entry = &queue->entries[i];
> +               if (!test_bit(ENTRY_BCN_ENABLED, &entry->flags))
> +                       continue;
> +               off = rt2800_get_beacon_offset(rt2x00dev, entry->entry_idx);
> +               reg |= off << (8 * bcn_num);
> +               bcn_num++;
> +       }
> +
> +       WARN_ON_ONCE(bcn_num != rt2x00dev->intf_beaconing);
> +
> +       rt2800_register_write(rt2x00dev, BCN_OFFSET0, (u32) reg);
> +       rt2800_register_write(rt2x00dev, BCN_OFFSET1, (u32) (reg >> 32));
> +
> +       /*
> +        * H/W sends up to MAC_BSSID_DW1_BSS_BCN_NUM + 1 consecutive beacons.
> +        */
> +       rt2800_register_read(rt2x00dev, MAC_BSSID_DW1, &bssid_dw1);
> +       rt2x00_set_field32(&bssid_dw1, MAC_BSSID_DW1_BSS_BCN_NUM,
> +                          bcn_num > 0 ? bcn_num - 1 : 0);
> +       rt2800_register_write(rt2x00dev, MAC_BSSID_DW1, bssid_dw1);
> +}
> +
>  void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>  {
>         struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
> @@ -1003,6 +1037,12 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>
>         rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
>                                    entry->skb->len + padding_len);
> +       __set_bit(ENTRY_BCN_ENABLED, &entry->flags);
> +
> +       /*
> +        * Change global beacons settings.
> +        */
> +       rt2800_update_beacons_setup(rt2x00dev);
>
>         /*
>          * Restore beaconing state.
> @@ -1053,8 +1093,13 @@ void rt2800_clear_beacon(struct queue_entry *entry)
>          * Clear beacon.
>          */
>         rt2800_clear_beacon_register(rt2x00dev, entry->entry_idx);
> +       __clear_bit(ENTRY_BCN_ENABLED, &entry->flags);
>
>         /*
> +        * Change global beacons settings.
> +        */
> +       rt2800_update_beacons_setup(rt2x00dev);
> +       /*
>          * Restore beaconing state.
>          */
>         rt2800_register_write(rt2x00dev, BCN_TIME_CFG, orig_reg);
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
> index c48125b..2233b91 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
> @@ -353,6 +353,7 @@ struct txentry_desc {
>   */
>  enum queue_entry_flags {
>         ENTRY_BCN_ASSIGNED,
> +       ENTRY_BCN_ENABLED,
>         ENTRY_OWNER_DEVICE_DATA,
>         ENTRY_DATA_PENDING,
>         ENTRY_DATA_IO_FAILED,
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
