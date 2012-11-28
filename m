Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37856 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2K1H5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 02:57:41 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so9873253vcm.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 23:57:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354037225-30237-1-git-send-email-helmut.schaa@googlemail.com>
References: <1354037225-30237-1-git-send-email-helmut.schaa@googlemail.com>
Date: Wed, 28 Nov 2012 08:57:40 +0100
Message-ID: <CAL1gcdNLhwECUiJo7c-J3A349ZKNTYjgro6TY564UF7qCQkCmQ@mail.gmail.com> (sfid-20121128_085745_335920_3399658E)
Subject: Re: [PATCH] rt2x00: Use addr_mask to catch invalid MAC addresses
 (rt61pci, rt73usb)
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sgruszka@redhat.com, IvDoorn@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

On Tue, Nov 27, 2012 at 6:27 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> rt61pci and rt73usb support up to four MAC addresses but only the last
> two bits may differ. Hence, tell mac80211 an addr_mask of 0x3.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>  drivers/net/wireless/rt2x00/rt61pci.c |    3 +++
>  drivers/net/wireless/rt2x00/rt73usb.c |    3 +++
>  2 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index d6582a2..ee8b44f 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2771,6 +2771,9 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>                                 rt2x00_eeprom_addr(rt2x00dev,
>                                                    EEPROM_MAC_ADDR_0));
>
> +       /* Only the last two bits are variable in rt61pci devices. */
> +       rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] = 0x3;
> +
>         /*
>          * As rt61 has a global fallback table we cannot specify
>          * more then one tx rate per frame but since the hw will
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 24eec66..6014cfe 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2126,6 +2126,9 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>                                 rt2x00_eeprom_addr(rt2x00dev,
>                                                    EEPROM_MAC_ADDR_0));
>
> +       /* Only the last two bits are variable in rt73usb devices. */
> +       rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] = 0x3;
> +
>         /*
>          * Initialize hw_mode information.
>          */

I think it is possible to collapse your rt2800 related patch and this
patch with a single patch only touching generic rt2x00 code.

We could use the max_ap_intf field of the rt2x00_ops struct to
determine the mask in a generic manner.

So, we could have the following statement in generic code (e.g. in
rt2x00lib_probe_dev):

        rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] =
(rt2x00dev->ops->max_ap_intf - 1);

---
Gertjan
