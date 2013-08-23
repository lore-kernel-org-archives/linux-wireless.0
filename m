Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33699 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3HWIbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 04:31:14 -0400
Received: by mail-wi0-f171.google.com with SMTP id hr7so1670567wib.16
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 01:31:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377197602-5567-2-git-send-email-juhosg@openwrt.org>
References: <1377197602-5567-1-git-send-email-juhosg@openwrt.org>
	<1377197602-5567-2-git-send-email-juhosg@openwrt.org>
Date: Fri, 23 Aug 2013 10:31:13 +0200
Message-ID: <CAGXE3d8f2ND3yOienUK0t=OGcWmLzm-+dug_LC6k+RN9xwSPOQ@mail.gmail.com> (sfid-20130823_103120_076041_75EB6057)
Subject: Re: [PATCH v3 2/2] rt2x00: rt2800lib: don't hardcode beacon offsets
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 22, 2013 at 8:53 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The values written into the BCN_OFFSET[01] registers are
> hardcoded in the rt2800_init_register function.
>
> Add a macro and a helper function to derive these values
> directly from the base address of a given beacon, and use
> the new function instead of the hardcoded numbers.
>
> The patch contains no functional changes. The programmed
> register values are the same before and after the patch.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Fine with me as well.
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> ---
> Changes since v2:
>   - separated from the 'rt2x00: fix beaconing on RT3593' patch-set
>
> Changes since v1: ---
> ---
>  drivers/net/wireless/rt2x00/rt2800.h    |    2 ++
>  drivers/net/wireless/rt2x00/rt2800lib.c |   30 ++++++++++++++++++++++--------
>  2 files changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index e25e5bf..fa33b5e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -2024,6 +2024,8 @@ struct mac_iveiv_entry {
>           (((__index) < 6) ? (HW_BEACON_BASE4 + ((__index - 4) * 0x0200)) : \
>           (HW_BEACON_BASE6 - ((__index - 6) * 0x0200))))
>
> +#define BEACON_BASE_TO_OFFSET(_base)   (((_base) - 0x4000) / 64)
> +
>  /*
>   * BBP registers.
>   * The wordsize of the BBP is 8 bits.
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 38606e2..20243dc 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -946,6 +946,12 @@ static unsigned int rt2800_hw_beacon_base(struct rt2x00_dev *rt2x00dev,
>         return HW_BEACON_BASE(index);
>  }
>
> +static inline u8 rt2800_get_beacon_offset(struct rt2x00_dev *rt2x00dev,
> +                                         unsigned int index)
> +{
> +       return BEACON_BASE_TO_OFFSET(rt2800_hw_beacon_base(rt2x00dev, index));
> +}
> +
>  void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>  {
>         struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
> @@ -4474,17 +4480,25 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>                 return ret;
>
>         rt2800_register_read(rt2x00dev, BCN_OFFSET0, &reg);
> -       rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0, 0xe0); /* 0x3800 */
> -       rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1, 0xe8); /* 0x3a00 */
> -       rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2, 0xf0); /* 0x3c00 */
> -       rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3, 0xf8); /* 0x3e00 */
> +       rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0,
> +                          rt2800_get_beacon_offset(rt2x00dev, 0));
> +       rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1,
> +                          rt2800_get_beacon_offset(rt2x00dev, 1));
> +       rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2,
> +                          rt2800_get_beacon_offset(rt2x00dev, 2));
> +       rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3,
> +                          rt2800_get_beacon_offset(rt2x00dev, 3));
>         rt2800_register_write(rt2x00dev, BCN_OFFSET0, reg);
>
>         rt2800_register_read(rt2x00dev, BCN_OFFSET1, &reg);
> -       rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4, 0xc8); /* 0x3200 */
> -       rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5, 0xd0); /* 0x3400 */
> -       rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6, 0x77); /* 0x1dc0 */
> -       rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7, 0x6f); /* 0x1bc0 */
> +       rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4,
> +                          rt2800_get_beacon_offset(rt2x00dev, 4));
> +       rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5,
> +                          rt2800_get_beacon_offset(rt2x00dev, 5));
> +       rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6,
> +                          rt2800_get_beacon_offset(rt2x00dev, 6));
> +       rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7,
> +                          rt2800_get_beacon_offset(rt2x00dev, 7));
>         rt2800_register_write(rt2x00dev, BCN_OFFSET1, reg);
>
>         rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
> --
> 1.7.10
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
