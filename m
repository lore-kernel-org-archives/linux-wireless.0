Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3480 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbXJ2UyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 16:54:24 -0400
Date: Mon, 29 Oct 2007 16:52:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi,
	akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] hostap: fix section mismatch warning
Message-ID: <20071029205254.GA27547@tuxdriver.com> (sfid-20071029_205426_869277_F21CD699)
References: <20071029112026.f66473c5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071029112026.f66473c5.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 29, 2007 at 11:20:26AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch warning:
> 
> WARNING: vmlinux.o(.data+0x36fcc): Section mismatch: reference to .init.data:prism2_pci_id_table (between 'prism2_pci_drv_id' and 'prism2_pci_funcs')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/net/wireless/hostap/hostap_pci.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-2624-rc1g4-v1.orig/drivers/net/wireless/hostap/hostap_pci.c
> +++ linux-2624-rc1g4-v1/drivers/net/wireless/hostap/hostap_pci.c
> @@ -444,7 +444,7 @@ static int prism2_pci_resume(struct pci_
>  
>  MODULE_DEVICE_TABLE(pci, prism2_pci_id_table);
>  
> -static struct pci_driver prism2_pci_drv_id = {
> +static struct pci_driver prism2_pci_driver = {
>  	.name		= "hostap_pci",
>  	.id_table	= prism2_pci_id_table,
>  	.probe		= prism2_pci_probe,

Randy,

Would you mind explaining how changing the name of the pci_driver
variable resolves this?  There must be some magic here...

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
