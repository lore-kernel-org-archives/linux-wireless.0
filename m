Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46662 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753595AbaGDWFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2014 18:05:53 -0400
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 1A4C020CFE
	for <linux-wireless@vger.kernel.org>; Fri,  4 Jul 2014 18:05:50 -0400 (EDT)
Date: Fri, 4 Jul 2014 15:05:33 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] brcmfmac: Fix brcmf_chip_ai_coredisable not applying
 reset bits to BCMA_IOCTL
Message-ID: <20140704220533.GA10958@kroah.com> (sfid-20140705_000613_413932_7968A295)
References: <1402091675-6515-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1402091675-6515-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 06, 2014 at 11:54:31PM +0200, Arend van Spriel wrote:
> From: Hans de Goede <hdegoede@redhat.com>
> 
> brcmfmac has been broken on my cubietruck with a BCM43362:
> 
> brcmfmac: brcmf_chip_recognition: found AXI chip: BCM43362, rev=1
> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
>         Apr 22 2013 14:50:00 version 5.90.195.89.6 FWID 01-b30a427d
> 
> since commit 53036261033: "brcmfmac: update core reset and disable routines".
> 
> The problem is that since this commit brcmf_chip_ai_resetcore no longer sets
> BCMA_IOCTL itself before bringing the core out of reset, instead relying on
> brcmf_chip_ai_coredisable to do so. But brcmf_chip_ai_coredisable is a nop
> of the chip is already in reset. This patch modifies brcmf_chip_ai_coredisable
> to always set BCMA_IOCTL even if the core is already in reset.
> 
> This fixes brcmfmac hanging in firmware loading on my board.
> 
> upstream: 75691d9e4f4e156f71f3eaee69a5bd27b7b10384

I see no such commit id in Linus's tree, are you sure this is the id you
need?

thanks,

greg k-h
