Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:52765 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2DKLvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 07:51:23 -0400
Date: Wed, 11 Apr 2012 12:51:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: brcmsmac hangs machine if loaded after busmastering disabled
Message-ID: <20120411115118.GA3791@srcf.ucam.org> (sfid-20120411_135127_344905_F2E40C2B)
References: <20120319215154.GA18508@srcf.ucam.org>
 <4F856EE9.2040407@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F856EE9.2040407@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2012 at 01:45:45PM +0200, Arend van Spriel wrote:
> On 03/19/2012 10:51 PM, Matthew Garrett wrote:
> >
> >I'm dealing with a platform with some buggy system firmware that enables
> >DMA on the wireless card and leaves it running even after OS handover,
> 
> From what you showed me we are dealing with a MacBook Air using
> UEFI. As our meeting was brief I may have misunderstood, but am I
> correct to say the wireless card is active with UEFI mode to allow
> wireless network selection for netboot or something like that?

Yes.

> I also assume the proper fix should be to have the system firmware
> shutdown the wireless device properly before OS handover. My guess
> is that the device is still doing DMA transfers to some physical
> address space which is OK in UEFI context but the OS has assigned it
> for something else.

That seems to be exactly the problem.

> >triggering memory corruption. I'm working around that by disabling bus
> >mastering on the device in the bootloader, but that results in the
> >system hanging during brcmsmac init. pci_set_master() is being called in
> >the bcma code, so it's nothing that straghtforward. Any idea what might
> >be going wrong here?
> >
> 
> You showed me a boot menu. So after selecting Fedora the system is
> moving to the grub bootloader first?

Yup.

> Are you disabling bus master or the entire wireless device? Could
> you try disabling the device in the bootloader, ie.
> pci_disable_device() or something equivalent.

I'm just disabling the bus mastering. Do you expect there to be a 
behavioural difference in the core if I disable BAR decoding as well?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
