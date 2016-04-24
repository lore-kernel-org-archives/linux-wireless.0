Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.hostsharing.net ([83.223.95.204]:57981 "EHLO
	mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbcDXRBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2016 13:01:51 -0400
Date: Sun, 24 Apr 2016 19:04:23 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Andrew Worsley <amworsley@gmail.com>
Cc: b43-dev@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160424170423.GB17019@wunner.de> (sfid-20160424_190158_676435_B2CEA168)
References: <E1akxli-00030z-BC@bombadil.infradead.org>
 <CA+Y=x3=cLDHc7PK5h9n=ixdgVKWdVSu_v+-7jHJ-vBnDrv4sgg@mail.gmail.com>
 <20160403114912.GA11540@wunner.de>
 <CA+Y=x3nfe7CniNhruOhGmdxY3g4B1n3YRVWChoVYJns7D8pNEg@mail.gmail.com>
 <CA+Y=x3mVrSKMgzy74xtO5ZOc5kYLYU=iKZgqyjn0j94bXoebjg@mail.gmail.com>
 <20160412183202.GC13637@wunner.de>
 <CA+Y=x3mBm6==ffohf+aH2tHm9m+RSa7mZBJkDSvSmdCmEDdkNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+Y=x3mBm6==ffohf+aH2tHm9m+RSa7mZBJkDSvSmdCmEDdkNQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrew,

On Thu, Apr 14, 2016 at 06:42:50AM +1000, Andrew Worsley wrote:
> The only time I am getting the IRQ 17 nobody cared message is on
> suspend / resume. A fresh boot always had below the 100k interrupt
> threshold level.
> 
> I tried your new patch and the number is even lower < 30,000 over two boots.

Hm, that's still way too much. You should have < 100 interrupts on IRQ 17
on *every* boot, anything else isn't satisfactory. I'm working on a patch
that runs before EFI ExitBootServices() but will need a little longer to
find an optimal solution.


> Have you any insights on fixing suspend to disk  / resume paths which
> presumably face the same issue of being passed live hardware on boot
> up?

Suspend to disk involves two kernels, the boot kernel and the image kernel.
Perhaps these two are not the same on your machine and you've only compiled
the patch into one of them?

Best regards,

Lukas
