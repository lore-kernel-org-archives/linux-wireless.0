Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751022AbdAPKLT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 05:11:19 -0500
Date: Mon, 16 Jan 2017 11:08:57 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 09/14] rt2x00: rt2x00pci: set PCI MWI only if supported
Message-ID: <20170116100856.GB6968@redhat.com> (sfid-20170116_111122_330304_3DA75AC4)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116030613.GA32249@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116030613.GA32249@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2017 at 04:06:25AM +0100, Daniel Golle wrote:
> From: Claudio Mignanti <c.mignanti@gmail.com>
> 
> This is needed for devices without support for PCI MWI. See also
> https://dev.openwrt.org/changeset/21850
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00pci.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
> index eb6dbcd4fddf..4becfeb75ba8 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
> @@ -94,8 +94,10 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
>  
>  	pci_set_master(pci_dev);
>  
> +#ifdef CONFIG_PCI_SET_MWI
>  	if (pci_set_mwi(pci_dev))
>  		rt2x00_probe_err("MWI not available\n");
> +#endif

There is no CONFIG_PCI_SET_MWI in the kernel. This patch is either not
needed (pci subsystem has own PCI_DISABLE_MWI define) or wrong (we
should not call this function for some devices).

Stanislaw
