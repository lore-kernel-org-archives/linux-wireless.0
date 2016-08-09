Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35026 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbcHISoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 14:44:12 -0400
Received: by mail-pa0-f41.google.com with SMTP id iw10so7725535pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2016 11:44:12 -0700 (PDT)
Date: Tue, 9 Aug 2016 11:44:08 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-kernel@vger.kernel.org
Subject: Re: mwifiex: PCIe8997 chip specific handling
Message-ID: <20160809184406.GA12186@localhost> (sfid-20160809_204416_708670_2BAC7947)
References: <1469788731-5361-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469788731-5361-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Jul 29, 2016 at 04:08:51PM +0530, Amitkumar Karwar wrote:
> The patch corrects the revision id register and uses it along with
> magic value and chip version registers to download appropriate firmware
> image.
> 
> PCIe8997 Z chipset variant code has been removed, as it won't be used in
> production.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 35 ++++++++++-------------------
>  drivers/net/wireless/marvell/mwifiex/pcie.h | 14 +++++-------
>  2 files changed, 18 insertions(+), 31 deletions(-)

[...]

> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
> index f6992f0..46f99ca 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.h
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
> @@ -32,12 +32,9 @@
>  #define PCIE8897_DEFAULT_FW_NAME "mrvl/pcie8897_uapsta.bin"
>  #define PCIE8897_A0_FW_NAME "mrvl/pcie8897_uapsta_a0.bin"
>  #define PCIE8897_B0_FW_NAME "mrvl/pcie8897_uapsta.bin"
> -#define PCIE8997_DEFAULT_FW_NAME "mrvl/pcieusb8997_combo_v2.bin"
> -#define PCIEUART8997_FW_NAME_Z "mrvl/pcieuart8997_combo.bin"
> -#define PCIEUART8997_FW_NAME_V2 "mrvl/pcieuart8997_combo_v2.bin"
> -#define PCIEUSB8997_FW_NAME_Z "mrvl/pcieusb8997_combo.bin"
> -#define PCIEUSB8997_FW_NAME_V2 "mrvl/pcieusb8997_combo_v2.bin"
> -#define PCIE8997_DEFAULT_WIFIFW_NAME "mrvl/pcie8997_wlan.bin"
> +#define PCIEUART8997_FW_NAME_V4 "mrvl/pcieuart8997_combo_v4.bin"
> +#define PCIEUSB8997_FW_NAME_V4 "mrvl/pcieusb8997_combo_v4.bin"
> +#define PCIE8997_DEFAULT_WIFIFW_NAME "mrvl/pcie8997_wlan_v4.bin"

Why do version bumps require firmware renames? Is this just to make sure
you don't load the new firmware on old chip revs that you don't plan to
support for production (i.e., only early revs like the _Z you're
dropping)? This doesn't seems like a good long-term solution, at least
once you start getting this silicon out in the wild. At some point, I'd
expect to see a stable file name.

Brian

>  
>  #define PCIE_VENDOR_ID_MARVELL              (0x11ab)
>  #define PCIE_VENDOR_ID_V2_MARVELL           (0x1b4b)
> @@ -47,9 +44,10 @@
>  
>  #define PCIE8897_A0	0x1100
>  #define PCIE8897_B0	0x1200
> -#define PCIE8997_Z	0x0
> -#define PCIE8997_V2	0x471
> +#define PCIE8997_A0	0x10
> +#define PCIE8997_A1	0x11
>  #define CHIP_VER_PCIEUART	0x3
> +#define CHIP_MAGIC_VALUE	0x24
>  
>  /* Constants for Buffer Descriptor (BD) rings */
>  #define MWIFIEX_MAX_TXRX_BD			0x20
