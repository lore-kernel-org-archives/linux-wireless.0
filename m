Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:33459 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZKWHyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 02:54:12 -0500
Received: by iwn1 with SMTP id 1so457117iwn.33
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2009 23:54:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258931158.12095.33.camel@localhost.localdomain>
References: <1258931158.12095.33.camel@localhost.localdomain>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 23 Nov 2009 16:42:14 +1100
Message-ID: <646765f40911222142we220796v5fdfb541e522505f@mail.gmail.com>
Subject: Re: [PATCH] mwl8k: split driver by chipset
To: Dan Williams <dcbw@redhat.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2009 at 10:05, Dan Williams <dcbw@redhat.com> wrote:
> No functional changes, but split the code up to make it
> easier to add support for other Libertas softmac chipsets
> like the 88w8361, which has slightly different RX and TX
> descriptors and some slightly different commands.
>
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Yay, potential 88w8335 support!

> ---
> Note: patch is large (code reshuffle) so in case it gets rejected:
>
> http://bigw.org/~dan/mwl8k-split.patch

Diffstat?

> diff --git a/drivers/net/wireless/mwl8k/Kconfig b/drivers/net/wireless/mwl8k/Kconfig
> new file mode 100644
> index 0000000..48b4071
> --- /dev/null
> +++ b/drivers/net/wireless/mwl8k/Kconfig
> @@ -0,0 +1,29 @@
> +config MWL8K_COMMON
> +       tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
> +       depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
> +       ---help---
> +         This is common code for Marvell TOPDOG 802.11 wireless cards.  This
> +         module does nothing by itself - the device-specific front-ends
> +         also need to be enabled in order to support any devices.
> +
> +         To compile this driver as a module, choose M here: the module
> +         will be called mwl8k.  If unsure, say N.
> +
> +config MWL8687
> +       tristate "Marvell 88W8687 PCI/PCIe Wireless support"
> +       depends on MWL8K_COMMON
> +       ---help---
> +         This driver is for Marvell TOPDOG 88w8687-based wireless cards.
> +
> +         To compile this driver as a module, choose M here: the module
> +         will be called mwl8687.  If unsure, say N.
> +
> +config MWL8366
> +       tristate "Marvell 88W8366 PCI/PCIe Wireless support"
> +       depends on MWL8K_COMMON
> +       ---help---
> +         This driver is for Marvell TOPDOG 88w8366-based wireless cards.
> +
> +         To compile this driver as a module, choose M here: the module
> +         will be called mwl8366.  If unsure, say N.
> +

Isn't there a menuconfig option that'd make the depends on
MWL8K_COMMON redundant?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
