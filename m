Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:34850 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2DRMex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 08:34:53 -0400
Date: Wed, 18 Apr 2012 13:34:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: brcmsmac hangs machine if loaded after busmastering disabled
Message-ID: <20120418123449.GB26953@srcf.ucam.org> (sfid-20120418_143456_235287_04701ECA)
References: <20120319215154.GA18508@srcf.ucam.org>
 <4F856EE9.2040407@broadcom.com>
 <20120411115118.GA3791@srcf.ucam.org>
 <4F8EA657.7020006@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F8EA657.7020006@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 01:32:39PM +0200, Arend van Spriel wrote:
> I discussed this with hardware designer and here is his quote "You
> would need to disable the DMA engines before disable PCIe master
> mode. If you didn't do that, and the DMA engines were active, the
> MAC would almost certainly hang."
> 
> So disabling the master mode solved your memory corruption, but the
> chip will hang. The DMA engines mentioned are the on-chip engines.
> As you indicated you can only use common PCI operations so I do not
> expect disabling BAR decoding will solve the hang in the chip.

Yeah, I can get away with putting generic PCI operations in the 
bootloader, but a specific Broadcom driver is probably going a bit 
far...

> Only as an experiment you could try to reset the device toggling the
> pci power state.

Should putting the PCI device in D3 be sufficient for this, or would I 
also need to touch any state in the 802.11 core?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
