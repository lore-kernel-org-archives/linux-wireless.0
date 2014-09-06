Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaIFEBs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2014 00:01:48 -0400
Message-ID: <1409976104.2982.56.camel@ul30vt.home> (sfid-20140906_060156_011482_B449E4F5)
Subject: Re: ath9k and AMD IOMMU alias breakage on 3.16?
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Newton <nevion@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	iommu <iommu@lists.linux-foundation.org>
Date: Fri, 05 Sep 2014 22:01:44 -0600
In-Reply-To: <CAGou9MhCmRajqfh91rxbBUr9PBvJxo7U=g9p4Onp0pJk4BwBnA@mail.gmail.com>
References: <CAGou9MhCmRajqfh91rxbBUr9PBvJxo7U=g9p4Onp0pJk4BwBnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-05 at 20:00 -0700, Jason Newton wrote:
> Hi,
> 
> I have an AR9462 connected over minipcie, it came with the ASRock
> FM2A88x-itx motherboard and I'm using an AMD A10-7850K cpu with it.  When I
> have IOMMU enabled, and this is desirable for opencl related things, the
> AR9462 malfunctions with these two errors occurring:
> 
> AMD-Vi: Event logged [INVALID_DEVICE_REQUEST device=00:00.1
> address=0x000000fdf8080020 flags=0x0a00]
> 
> Followed by this  looping error, which reoccurs shortly after associating
> and obtaining an IP.  I've attached a large snippet from dmesg, due to it's
> length.
> 
> I'm not sure where the error is coming from but I did see that Alex
> Williamson posted a patch that dealt with aliased devices (like pci
> bridges) and AMD's IOMMU issues, see
> e028a9e6b8a637af09ac4114083280df4a7045f1 for reference.
> 
> I then disable IOMMU in the bios, and immediately the ath9k/AR9462 pair is
> working without flaw or retries.  Bios is up to date btw, updated it after
> building the machine last friday.
> 
> So anyone have a clue what's going on here?

Please boot with "amd_iommu_dump" on the kernel boot line and send the
full dmesg log and 'sudo lspci -vvv' output.  Thanks,

Alex

