Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:34081 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941AbZKDTQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 14:16:24 -0500
MIME-Version: 1.0
In-Reply-To: <20091104173313.28463.67108.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173313.28463.67108.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:16:26 +0100
Message-ID: <14add3d10911041116q1bb293a9hbd6c5361d59fe588@mail.gmail.com>
Subject: Re: [PATCH 10/41] rt2800pci: add rt2800_register_[read,write]()
	wrappers
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 6:33 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: add rt2800_register_[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |  479 ++++++++++++++++----------------
>  drivers/net/wireless/rt2x00/rt2800pci.h |   21 +
>  2 files changed, 261 insertions(+), 239 deletions(-)
>
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -57,7 +57,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
>  /*
>  * Register access.
>  * All access to the CSR registers will go through the methods
> - * rt2x00pci_register_read and rt2x00pci_register_write.
> + * rt2800_register_read and rt2800_register_write.
>  * BBP and RF register require indirect register access,
>  * and use the CSR registers BBPCSR and RFCSR to achieve this.
>  * These indirect registers work with busy bits,
> @@ -66,6 +66,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
>  * between each attampt. When the busy bit is still set at that time,
>  * the access attempt is considered to have failed,
>  * and we will print an error.
> + * The _lock versions must be used if you already hold the csr_mutex
>  */
>  #define WAIT_FOR_BBP(__dev, __reg) \
>        rt2x00pci_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))

The change to the _lock variant seems a bit odd. See below.

<snip>

> Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.h
> @@ -27,6 +27,27 @@
>  #ifndef RT2800PCI_H
>  #define RT2800PCI_H
>
> +static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
> +                                       const unsigned int offset,
> +                                       u32 *value)
> +{
> +       rt2x00pci_register_read(rt2x00dev, offset, value);
> +}
> +
> +static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
> +                                        const unsigned int offset,
> +                                        u32 value)
> +{
> +       rt2x00pci_register_write(rt2x00dev, offset, value);
> +}
> +
> +static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
> +                                             const unsigned int offset,
> +                                             u32 value)
> +{
> +       rt2x00pci_register_write(rt2x00dev, offset, value);
> +}
> +
>  /*
>  * RF chip defines.
>  *

Can we add a comment to the _lock variant explaining that this one
technically isn't
needed, but is present for alignment purposes with rt2800usb?

Otherwise this looks a bit odd, and may confuse people.

---
Gertjan.
