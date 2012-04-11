Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2374 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531Ab2DKLpy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 07:45:54 -0400
Message-ID: <4F856EE9.2040407@broadcom.com> (sfid-20120411_134557_989816_A135EE2D)
Date: Wed, 11 Apr 2012 13:45:45 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: brcmsmac hangs machine if loaded after busmastering
 disabled
References: <20120319215154.GA18508@srcf.ucam.org>
In-Reply-To: <20120319215154.GA18508@srcf.ucam.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/2012 10:51 PM, Matthew Garrett wrote:
>
> I'm dealing with a platform with some buggy system firmware that enables
> DMA on the wireless card and leaves it running even after OS handover,

 From what you showed me we are dealing with a MacBook Air using UEFI. 
As our meeting was brief I may have misunderstood, but am I correct to 
say the wireless card is active with UEFI mode to allow wireless network 
selection for netboot or something like that?

I also assume the proper fix should be to have the system firmware 
shutdown the wireless device properly before OS handover. My guess is 
that the device is still doing DMA transfers to some physical address 
space which is OK in UEFI context but the OS has assigned it for 
something else.

> triggering memory corruption. I'm working around that by disabling bus
> mastering on the device in the bootloader, but that results in the
> system hanging during brcmsmac init. pci_set_master() is being called in
> the bcma code, so it's nothing that straghtforward. Any idea what might
> be going wrong here?
>

You showed me a boot menu. So after selecting Fedora the system is 
moving to the grub bootloader first?

Are you disabling bus master or the entire wireless device? Could you 
try disabling the device in the bootloader, ie. pci_disable_device() or 
something equivalent.

Gr. AvS

