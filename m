Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:34863 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZCBQ4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 11:56:51 -0500
Message-ID: <49AC0FAB.6000604@oracle.com> (sfid-20090302_175657_112643_C773A075)
Date: Mon, 02 Mar 2009 08:56:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: linux-next: Tree for March 2 (wireless/b43)
References: <20090302182217.90ca3356.sfr@canb.auug.org.au>
In-Reply-To: <20090302182217.90ca3356.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090227:
> 
> Undropped trees:
> 	wireless

when CONFIG_SSB_DRIVER_PCICORE=n:

        if ((bus->bustype == SSB_BUSTYPE_PCI) &&
            (bus->pcicore.dev->id.revision <= 10))
                hf |= B43_HF_PCISCW; /* PCI slow clock workaround. */

==>
drivers/net/wireless/b43/main.c:4182: error: 'struct ssb_pcicore' has no member named 'dev'


