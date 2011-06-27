Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:36168 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1F0SD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 14:03:29 -0400
Date: Mon, 27 Jun 2011 11:03:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-bluetooth@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH -next] bluetooth: uses crypto interfaces, select CRYPTO
Message-Id: <20110627110308.dc64e3a7.randy.dunlap@oracle.com> (sfid-20110627_200401_160699_C9572DBB)
In-Reply-To: <20110622100811.258091ff.randy.dunlap@oracle.com>
References: <20110622163651.7ebc407c.sfr@canb.auug.org.au>
	<20110622100811.258091ff.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 22 Jun 2011 10:08:11 -0700 Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>

ping.  still need this patch in linux-next....


> Recent changes to hci_core.c use crypto interfaces, so select CRYPTO
> to make sure that those interfaces are present.
> 
> Fixes these build errors when CRYPTO is not enabled:
> 
> net/built-in.o: In function `hci_register_dev':
> (.text+0x4cf86): undefined reference to `crypto_alloc_base'
> net/built-in.o: In function `hci_unregister_dev':
> (.text+0x4f912): undefined reference to `crypto_destroy_tfm'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  net/bluetooth/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20110622.orig/net/bluetooth/Kconfig
> +++ linux-next-20110622/net/bluetooth/Kconfig
> @@ -6,6 +6,7 @@ menuconfig BT
>  	tristate "Bluetooth subsystem support"
>  	depends on NET && !S390
>  	depends on RFKILL || !RFKILL
> +	select CRYPTO
>  	help
>  	  Bluetooth is low-cost, low-power, short-range wireless technology.
>  	  It was designed as a replacement for cables and other short-range
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
