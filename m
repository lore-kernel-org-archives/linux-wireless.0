Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2848 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab2DRLc5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 07:32:57 -0400
Message-ID: <4F8EA657.7020006@broadcom.com> (sfid-20120418_133301_140424_4A7653C4)
Date: Wed, 18 Apr 2012 13:32:39 +0200
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
 <4F856EE9.2040407@broadcom.com> <20120411115118.GA3791@srcf.ucam.org>
In-Reply-To: <20120411115118.GA3791@srcf.ucam.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2012 01:51 PM, Matthew Garrett wrote:
> On Wed, Apr 11, 2012 at 01:45:45PM +0200, Arend van Spriel wrote:
>>
>> Are you disabling bus master or the entire wireless device? Could
>> you try disabling the device in the bootloader, ie.
>> pci_disable_device() or something equivalent.
>
> I'm just disabling the bus mastering. Do you expect there to be a
> behavioural difference in the core if I disable BAR decoding as well?
>

I discussed this with hardware designer and here is his quote "You would 
need to disable the DMA engines before disable PCIe master mode. If you 
didn't do that, and the DMA engines were active, the MAC would almost 
certainly hang."

So disabling the master mode solved your memory corruption, but the chip 
will hang. The DMA engines mentioned are the on-chip engines. As you 
indicated you can only use common PCI operations so I do not expect 
disabling BAR decoding will solve the hang in the chip.

Only as an experiment you could try to reset the device toggling the pci 
power state.

Gr. AvS

