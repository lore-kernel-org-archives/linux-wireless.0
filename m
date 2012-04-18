Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3737 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab2DRP36 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 11:29:58 -0400
Message-ID: <4F8EDDE6.9080802@broadcom.com> (sfid-20120418_173001_446558_5B228B03)
Date: Wed, 18 Apr 2012 17:29:42 +0200
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
 <4F8EA657.7020006@broadcom.com> <20120418123449.GB26953@srcf.ucam.org>
In-Reply-To: <20120418123449.GB26953@srcf.ucam.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2012 02:34 PM, Matthew Garrett wrote:
> On Wed, Apr 18, 2012 at 01:32:39PM +0200, Arend van Spriel wrote:
>> I discussed this with hardware designer and here is his quote "You
>> would need to disable the DMA engines before disable PCIe master
>> mode. If you didn't do that, and the DMA engines were active, the
>> MAC would almost certainly hang."
>>
>> So disabling the master mode solved your memory corruption, but the
>> chip will hang. The DMA engines mentioned are the on-chip engines.
>> As you indicated you can only use common PCI operations so I do not
>> expect disabling BAR decoding will solve the hang in the chip.
>
> Yeah, I can get away with putting generic PCI operations in the
> bootloader, but a specific Broadcom driver is probably going a bit
> far...
>
>> Only as an experiment you could try to reset the device toggling the
>> pci power state.
>
> Should putting the PCI device in D3 be sufficient for this, or would I
> also need to touch any state in the 802.11 core?
>

I am not sure, but D3 is a good guess. It is all a workaround as the 
real fix should be in Apple's UEFI implementation. I think it is 
unlikely we can make them do that although we probably supplied them the 
wireless part.

Gr. AvS

