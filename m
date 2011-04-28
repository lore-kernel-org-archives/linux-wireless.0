Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab1D1Lkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 07:40:51 -0400
Date: Thu, 28 Apr 2011 13:40:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Colin Guthrie <gmane@colin.guthr.ie>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [Regression] Problem with rfkill on 2.6.38
Message-ID: <20110428114010.GA7030@redhat.com> (sfid-20110428_134054_892923_ED9E793A)
References: <ip6j66$o5f$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ip6j66$o5f$1@dough.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2011 at 03:00:38PM +0100, Colin Guthrie wrote:
> RFKILL used to work fine on 2.6.37 for me but I have a regression on .38.
[snip]

> iwlagn 0000:0b:00.0: RF_KILL bit toggled to enable radio.
> usb 4-2: new full speed USB device using uhci_hcd and address 4
> usb 4-2: New USB device found, idVendor=413c, idProduct=8126
> usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 4-2: Product: BCM2045
> usb 4-2: Manufacturer: Broadcom Corp
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> iwlagn 0000:0b:00.0: RF_KILL bit toggled to disable radio.
> <------------Problem here?

That mean device see rf switch in state to disable radio.

> I've been looking through the various commits that could come into play
> (although I am sure there are others):
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=commitdiff;h=3dd823e6b86407aed1a025041d8f1df77e43a9c8
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=commitdiff;h=554d1d027b19265c4aa3f718b3126d2b86e09a08

You may want to revert these commits and see if that helps. 

> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=commitdiff;h=6cd0b1cb872b3bf9fc5de4536404206ab74bafdd
> 
> What is odd about the 3dd8 commit is that there is code that says:
> 
>         if (test_bit(STATUS_INT_ENABLED, &priv->status))
>                 iwl_enable_interrupts(priv);
> 
> I presume test_bit returns "true" if the bit is set? If so, then the
> call, is a little strange as iwl_enable_interrupts sets the bit again.
> 
> So it's only enabled if it's already set? Perhaps test_bit returns 0
> when it's already set?

Sometimes function iwl_enable_interrupts() is called unconditionally
without STATUS_INT_ENABLED check. This part is generally ok.  

If reverting 2 above commit will not help, you may wish to blacklist
all *wmi* and/or *acpi* modules. This problems looks more like platform
problem than rfkill core or iwlagn. If that will not help, bisection
will be needed to solve the issue.

Stanislaw
