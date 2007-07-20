Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51025 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbXGTKes (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 06:34:48 -0400
Date: Fri, 20 Jul 2007 13:34:44 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: Li YanBo <dreamfly281@gmail.com>
cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jeff willam <angelbane@gmail.com>
Subject: Re: Airgo MIMO Wireless card mac80211 driver (unfinished)
In-Reply-To: <1197ff4c0707190820s26f28fafy784900d41f6b1ad4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707201142480.20559@kivilampi-30.cs.helsinki.fi>
References: <1197ff4c0707190820s26f28fafy784900d41f6b1ad4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Jul 2007, Li YanBo wrote:

> On 7/19/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > It might be useful for you to put all your current code into a git tree
> > and publish that to linux-wireless@vger.kernel.org so other people can
> > take a look too :)
> >
> 
> First of all, the code is far away be finished and full of bugs,  We
> can't success control the RX and TX yet.

It's important to have an early reviews too though not all issues 
are not yet resolved.

> Thanks for all your suggestions and fixes, I'll fix it later.
> Because the code is big , so I attach it in this mail. (Be attention,
> it is far from finished and has tons of bugs).

Here are some things which you'll probably encounter when you try to get 
this stuff merged, so you'll have to adjust the code sooner or later 
(these can easily add many unnecessary post-comment round-trips when you 
would like to get it merged asap):


- You seem to define assert and never use it, besides you could probably
use either WARN_ON or BUG_ON which belongs to kernel's generic machinery 
already...

- agnx_read32 & agnx_write32
	* change to static inline, solves also the use of implicit 
	  variable (reg) as you have return & assign instead (implicit
 	  variables confuse readers, see Documentation/CodingStyle) 
	* You seem to be also doing direct access using ioread/write32
	  here and there?!?

- no // comments allowed, use /* */ instead, however, most of them are 
  for dead code anyway which just makes things messy looking and should be 
  removed (I'd say that removing them speeds up review too)... Besides, 
  if you use repository, there's no need to keep dead code lying around.

> +
> +#ifdef CONFIG_PM
> +static int agnx_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> [...snip...]
> +       
> +       return 0;
> +}

Usually they ask you to add these...:

#else
#define agnx_pci_suspend NULL
#define agnx_pci_resume NULL

> +#endif /* CONFIG_PM */
> +
> +static struct pci_driver agnx_pci_driver = {
> +       .name           = "agnx-pci",
> +       .id_table       = agnx_pci_id_tbl,
> +       .probe          = agnx_pci_probe,
> +       .remove         = __devexit_p(agnx_pci_remove),
> +#ifdef CONFIG_PM       
> +       .suspend        = agnx_pci_suspend,
> +       .resume         = agnx_pci_resume,
> +#endif /* CONFIG_PM */
> +};

...and then to remove this #ifdefing.

> +       /* FIXME */
> +       reg = (bssid[0] << 24) | (bssid[1] << 16) | (bssid[2] << 8) | bssid[3];
> +       agnx_write32(ctl_mem, AGNX_RXMC_BSSIDHI, reg);
> +
> +       agnx_read32(ctl_mem, AGNX_RXMC_BSSIDLO);
> +       reg &= 0xffff0000;

Define this BSSIDLO_MASK and use it here with ~ operator.

> +       reg |= (bssid[4] << 8) | bssid[5];
> +       agnx_write32(ctl_mem, AGNX_RXMC_BSSIDLO, reg);

...Maybe the "FIXME" already indicates the questionability of that
bssid endianess stuff...? The same comments apply to MACHI/LO stuff...


- I'm not sure if the comments per reg in phy_init() are that useful if 
the same information is found in the header file already (just a matter 
of taste though, shouldn't prevent merging, just IMHO)


> +       /* Clear the Disable Tx interrupt bit in Interrupt Mask */
> +       agnx_read32(ctl_mem, AGNX_INT_MASK);
> +       reg &= ~0x20000;
> +       agnx_write32(ctl_mem, AGNX_INT_MASK, reg);

You should not use numeric constant then (besides, IRQ_TX_DISABLE is 
already defined!), if the purpose of this is known (there are more this 
kind of things I suppose)... Then the comment would not be necessary any 
more either as the code itself would explain the same to the reader... :-) 
Obviously some/many values (in other places) will remain unknown as
reverse-engineered and that's something we just have to live with but 
that's no excuse for known bits...

> +/* Recieve Management Control Registers */

typo

> +#define                calibra_delay(priv) \
> +               do {                                                   \
> +                       udelay(40);                                    \
> +               } while (0)

static inline


- ...other endianess issues should be dealt with...


> +#define FIR_TABLE_NUM  24
> +static const u32 
> +tx_fir_table[FIR_TABLE_NUM] = { 0x19, 0x5d, 0xce, 0x151, 0x1c3, 0x1ff, 0x1ea,
[...snip...]
> +       for (i = 0; i < FIR_TABLE_NUM; i++) 

Drop FIR_TABLE_NUM and use ARRAY_SIZE macro in the for construct (and 
elsewhere if there are other users). It's available in linux/kernel.h, 
also check if your code implements something that is already given in
linux/kernel.h and replace them with the generic machinery. Same applies 
to #define GAIN_TABLE_NUM 32 (and others?)


...those people specialized to wireless stuff have probably some / many
additional notes too...


-- 
 i.
