Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51785 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2EHXvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 19:51:44 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id E960C3EE0C0
	for <linux-wireless@vger.kernel.org>; Wed,  9 May 2012 08:51:42 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id D023345DEB2
	for <linux-wireless@vger.kernel.org>; Wed,  9 May 2012 08:51:42 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id B86AB45DEA6
	for <linux-wireless@vger.kernel.org>; Wed,  9 May 2012 08:51:42 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id AD2361DB803E
	for <linux-wireless@vger.kernel.org>; Wed,  9 May 2012 08:51:42 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 674031DB803C
	for <linux-wireless@vger.kernel.org>; Wed,  9 May 2012 08:51:42 +0900 (JST)
Message-ID: <4FA9B170.2000704@jp.fujitsu.com> (sfid-20120509_015148_383193_01448F28)
Date: Wed, 09 May 2012 08:51:12 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] b43: use pci_is_pcie() instead of obsolete pci_dev.is_pcie
References: <20120508232732.19543.37241.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120508232732.19543.37241.stgit@bhelgaas.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Regards,
Kenji Kaneshige


(2012/05/09 8:27), Bjorn Helgaas wrote:
> Use pci_is_pcie() instead of looking at obsolete is_pcie field in
> struct pci_dev.
> 
> CC: Stefano Brivio<stefano.brivio@polimi.it>
> CC: b43-dev@lists.infradead.org
> CC: Kenji Kaneshige<kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Bjorn Helgaas<bhelgaas@google.com>
> ---
>   drivers/net/wireless/b43/dma.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
> index b5f1b91..777cd74 100644
> --- a/drivers/net/wireless/b43/dma.c
> +++ b/drivers/net/wireless/b43/dma.c
> @@ -1109,7 +1109,7 @@ static bool b43_dma_translation_in_low_word(struct b43_wldev *dev,
>   #ifdef CONFIG_B43_SSB
>   	if (dev->dev->bus_type == B43_BUS_SSB&&
>   	dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI&&
> -	    !(dev->dev->sdev->bus->host_pci->is_pcie&&
> +	    !(pci_is_pcie(dev->dev->sdev->bus->host_pci)&&
>   	ssb_read32(dev->dev->sdev, SSB_TMSHIGH)&  SSB_TMSHIGH_DMA64))
>   			return 1;
>   #endif
> 
> 

