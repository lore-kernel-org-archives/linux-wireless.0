Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 8bytes.org ([81.169.241.247]:49159 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbaIHKcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 06:32:06 -0400
Date: Mon, 8 Sep 2014 12:32:03 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Newton <nevion@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	iommu <iommu@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k and AMD IOMMU alias breakage on 3.16?
Message-ID: <20140908103203.GQ28786@8bytes.org> (sfid-20140908_123210_492700_0F3FB2B4)
References: <CAGou9MhCmRajqfh91rxbBUr9PBvJxo7U=g9p4Onp0pJk4BwBnA@mail.gmail.com>
 <1409976104.2982.56.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409976104.2982.56.camel@ul30vt.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 05, 2014 at 10:01:44PM -0600, Alex Williamson wrote:
> On Fri, 2014-09-05 at 20:00 -0700, Jason Newton wrote:
> > Hi,
> > 
> > I have an AR9462 connected over minipcie, it came with the ASRock
> > FM2A88x-itx motherboard and I'm using an AMD A10-7850K cpu with it.  When I
> > have IOMMU enabled, and this is desirable for opencl related things, the
> > AR9462 malfunctions with these two errors occurring:
> > 
> > AMD-Vi: Event logged [INVALID_DEVICE_REQUEST device=00:00.1
> > address=0x000000fdf8080020 flags=0x0a00]

This means that the device 00:00.1 is sending to the interrupt/EOI
address-range while interrupt remapping is enabled. You can boot with
intremap=off on the kernel command line to work around this problem.

This looks either like another PCI aliasing issue or a 00:00.1 hidden
device is sending interrupt requests (which it is not allowed to do).


	Joerg

