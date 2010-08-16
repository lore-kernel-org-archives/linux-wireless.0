Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41344 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab0HPTGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 15:06:20 -0400
Received: by fxm13 with SMTP id 13so3088644fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 12:06:19 -0700 (PDT)
Message-ID: <4C698C19.5010902@lwfinger.net>
Date: Mon, 16 Aug 2010 14:06:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?windows-1252?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT] BCM4312 users with DMA errors, please test!
References: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com>
In-Reply-To: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2010 12:59 PM, Gábor Stefanik wrote:
> Hello Everyone!
> 
> If you are experiencing DMA errors on a BCM4312, please test the
> attached patch. It implements the PCI-E SERDES workaround, which the
> hybrid driver is applying during early init to LP-PHY cards, and which
> is a good candidate for the cause of the DMA error.
> Note that this is not a final patch & it may cause collateral damage
> for non-4312 cards; if it helps the 4312 problem, I will submit a
> cleaned-up version.

The patch that you distributed had a couple of errors in compiling, namely:

  CC [M]  drivers/ssb/driver_pcicore.o
drivers/ssb/driver_pcicore.c: In function ‘ssb_pcie_mdio_set_block’:
drivers/ssb/driver_pcicore.c:457:7: error: ‘i’ undeclared (first use in this
function)
drivers/ssb/driver_pcicore.c:457:7: note: each undeclared identifier is reported
only once for each function it appears in
drivers/ssb/driver_pcicore.c: In function ‘ssb_pcie_mdio_read’:
drivers/ssb/driver_pcicore.c:503:2: error: expected ‘;’ before ‘pcicore_write32’
make[2]: *** [drivers/ssb/driver_pcicore.o] Error 1
make[1]: *** [drivers/ssb] Error 2
make[1]: *** Waiting for unfinished jobs....

Did you forget a quilt refresh?

My machine does not have the DMA error, but I will be testing.

Larry
