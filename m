Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55252 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0FDAPe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 20:15:34 -0400
Date: Fri, 4 Jun 2010 09:15:16 +0900
To: reinette.chatre@intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, yi.zhu@intel.com,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] iwlwifi: use the DMA state API instead of the pci
 equivalents
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1275582441.2091.31678.camel@rchatre-DESK>
References: <20100603141853Z.fujita.tomonori@lab.ntt.co.jp>
	<1275582441.2091.31678.camel@rchatre-DESK>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100604091433Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 03 Jun 2010 09:27:21 -0700
reinette chatre <reinette.chatre@intel.com> wrote:

> On Wed, 2010-06-02 at 22:19 -0700, FUJITA Tomonori wrote:
> > This can be cleanly applied to wireless-2.6 and iwlwifi git trees.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] iwlwifi: use the DMA state API instead of the pci equivalents
> > 
> > This replace the PCI DMA state API (include/linux/pci-dma.h) with the
> > DMA equivalents since the PCI DMA state API will be obsolete.
> 
> Does that mean we need to modify out other PCI DMA calls (eg.
> pci_unmap_single etc.) also?

Yeah, in the long term. PCI DMA API is just the wrapper of DMA API
(all the architectures use include/asm-generic/pci-dma-compat.h) so
you can safely move to DMA API.


> > 
> > No functional change.
> > 
> > For further information about the background:
> > 
> > http://marc.info/?l=linux-netdev&m=127037540020276&w=2
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Thank you
> 
> Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thanks!
