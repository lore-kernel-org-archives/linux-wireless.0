Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:54201 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704AbZLOVKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 16:10:23 -0500
Received: by ywh12 with SMTP id 12so359221ywh.21
        for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 13:10:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091215204432.GE8735@tuxdriver.com>
References: <1260819235-8017-1-git-send-email-gwingerde@gmail.com>
	 <20091215204432.GE8735@tuxdriver.com>
Date: Tue, 15 Dec 2009 22:10:19 +0100
Message-ID: <14add3d10912151310s6b36cc60vabbdac4afff2e4b4@mail.gmail.com>
Subject: Re: [PATCH v2 2.6.33] rt2x00: Disable powersaving for rt61pci and
	rt2800pci.
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Ivo van Doorn <ivdoorn@gmail.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 9:44 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Dec 14, 2009 at 08:33:55PM +0100, Gertjan van Wingerde wrote:
>> We've had many reports of rt61pci failures with powersaving enabled.
>> Therefore, as a stop-gap measure, disable powersaving of the rt61pci
>> until we have found a proper solution.
>> Also disable powersaving on rt2800pci as it most probably will show
>> the same problem.
>>
>> Cc: stable@kernel.org
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>
>> John, this is an urgent fix for 2.6.33.
>>
>> v2:
>> - Handled feedback from Ivo:
>>       - Only disable powersaving by default, not permanent.
>>       - Also apply to rt2800pci.
>
> As posted, it will only compile on 2.6.32...
>

Me confused, as the patch was against the wireless-2.6.git tree, which
I thought was 2.6.33, and not 2.6.32. Please explain to which tree to
prepare fixes for 2.6.33.

> This is what I'm merging:
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index a199f85..6bf6c0f 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2022,6 +2022,12 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>        u16 eeprom;
>
>        /*
> +        * Disable powersaving as default on PCI devices.
> +        */
> +       if (rt2x00_intf_is_pci(rt2x00dev))
> +               rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +
> +       /*
>         * Initialize all hw fields.
>         */
>        rt2x00dev->hw->flags =
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 687e17d..0ca5893 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2539,6 +2539,11 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>        unsigned int i;
>
>        /*
> +        * Disable powersaving as default.
> +        */
> +       rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +
> +       /*
>         * Initialize all hw fields.
>         */
>        rt2x00dev->hw->flags =

Looks good to me.

---
Gertjan.
