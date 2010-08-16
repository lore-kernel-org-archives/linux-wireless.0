Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.151]:34212 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755621Ab0HPTmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 15:42:15 -0400
Date: Mon, 16 Aug 2010 20:41:54 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: =?UTF-8?B?R8OhYm9y?= Stefanik <netrolller.3d@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT] BCM4312 users with DMA errors, please test!
Message-ID: <20100816204154.5100b604@boulder.homenet>
In-Reply-To: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com>
References: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 16 Aug 2010 19:59:36 +0200
Gábor Stefanik <netrolller.3d@gmail.com> wrote:
> Hello Everyone!
> 
> If you are experiencing DMA errors on a BCM4312, please test the
> attached patch. It implements the PCI-E SERDES workaround, which the
> hybrid driver is applying during early init to LP-PHY cards, and which
> is a good candidate for the cause of the DMA error.
> Note that this is not a final patch & it may cause collateral damage
> for non-4312 cards; if it helps the 4312 problem, I will submit a
> cleaned-up version.

This applies to 2.6.35.2, but does not compile:

drivers/ssb/driver_pcicore.c: In function 'ssb_pcie_mdio_set_block':
drivers/ssb/driver_pcicore.c:457: error: 'i' undeclared (first use in
this function) drivers/ssb/driver_pcicore.c:457: error: (Each
undeclared identifier is reported only once
drivers/ssb/driver_pcicore.c:457: error: for each function it appears
in.) drivers/ssb/driver_pcicore.c: In function 'ssb_pcie_mdio_read':
drivers/ssb/driver_pcicore.c:503: error: expected ';' before
'pcicore_write32'

With the obvious fixes (providing a variable 'i' of int type as the
count variable and terminating the line which had no terminating
semi-colon), it compiled OK and the first time I booted up, booted up
OK but didn't fix the DMA error.  Subsequent attempts to boot up gave me
a slew of errors on boot up so I am not sure what is going on there.

You might want to check that the obvious fixes to the patch are
complete.

Chris


