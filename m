Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46622 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474Ab0E1QTj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 12:19:39 -0400
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable ASPM
From: Pavel Roskin <proski@gnu.org>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <20100528100901.14580.1322.stgit@fate.lan>
References: <20100528100901.14580.1322.stgit@fate.lan>
Content-Type: text/plain
Date: Fri, 28 May 2010 12:19:36 -0400
Message-Id: <1275063576.15168.14.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 13:09 +0300, Jussi Kivilinna wrote:
> +static void		__ath5k_disable_aspm(struct pci_dev *pdev, u16 state);
> +static void		ath5k_disable_aspm(struct pci_dev *pdev, u16 state);

Forward declarations should not be needed unless the functions are
called before their implementations, which is not the case here.

> @@ -424,6 +427,47 @@ module_exit(exit_ath5k_pci);
>  * PCI Initialization *
>  \********************/
>  
> +#ifdef CONFIG_PCIEASPM
> +static void __ath5k_disable_aspm(struct pci_dev *pdev, u16 state)
> +{
> +	pci_disable_link_state(pdev, state);
> +}
> +#else
> +static void __ath5k_disable_aspm(struct pci_dev *pdev, u16 state)
> +{

It looks like a replacement for pci_disable_link_state() if
CONFIG_PCIEASPM is disabled.  I guess it should be in the PCI code, not
in ath5k.  At least the PCI developers should have a look at the
replacement code.

-- 
Regards,
Pavel Roskin
