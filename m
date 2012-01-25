Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab2AYJy2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 04:54:28 -0500
Date: Wed, 25 Jan 2012 10:54:08 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 4/4] rt2800usb: remove PWR_PIN_CFG=0x3
 during init
Message-ID: <20120125095407.GA3406@redhat.com> (sfid-20120125_105431_795152_151C5DC0)
References: <1327410549-4714-1-git-send-email-sgruszka@redhat.com>
 <1327410549-4714-4-git-send-email-sgruszka@redhat.com>
 <201201241737.q0OHbmX5003698@mail.maya.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201201241737.q0OHbmX5003698@mail.maya.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Tue, Jan 24, 2012 at 06:37:45PM +0100, Andreas Hartmann wrote:
> Stanislaw Gruszka schrieb:
> > This seems to be only needed as workaround for hardware problem on 
> > PCI devices.
> 
> I tested this series (with all other resent patches applied) against a
> rt3572usb based device (Linksys WUSB600N) on to different machines
> (64bit smp (linux 3.2.1) and 32bit single core (linux 2.6.37.6)). I
> couldn't see any functional change. Unfortunately it's as bad as
> always :-(.
> 
> But one thing is new: I'm getting now these errors in messages (with
> kernel 3.2.1) in the moment of the stall (which never stops until the
> module is unloaded (or I didn't display enough patience)):
> 
> 
> Jan 24 18:10:23 nb kernel: [  798.289036] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
This is write to BBP_CSR_CFG. I don't know, which patch is is responsible
for that error (patch4 looks most suspicious), can you check those 4 patches
one by one, and tell us which is causing this error? 

Thanks
Stanislaw
