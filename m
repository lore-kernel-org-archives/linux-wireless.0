Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53285 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965409Ab2COTrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 15:47:12 -0400
Received: by yenl12 with SMTP id l12so3435303yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 12:47:11 -0700 (PDT)
Date: Thu, 15 Mar 2012 12:47:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stern@rowland.harvard.edu, linux-mips@linux-mips.org,
	ralf@linux-mips.org, m@bues.ch, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 0/7] USB: OHCI/EHCI: generic platform driver
Message-ID: <20120315194707.GA8079@kroah.com> (sfid-20120315_204718_454254_21A77D41)
References: <1331597093-425-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331597093-425-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2012 at 01:04:46AM +0100, Hauke Mehrtens wrote:
> This EHCI/OHCI platform driver should replace the simple EHCI and OHCI 
> platform drivers. It was developed to be used for the USB core of the 
> Broadcom SoCs supported by ssb and bcma, but it should also work for 
> other devices.
> 
> Drivers like ehci-ath79.c, ehci-xls.c and ehci-ixp4xx.c should be 
> relative easy be ported to this EHCI driver.
> And drivers like ohci-ath79.c, ohci-ppc-soc.c, ohci-sh.c and ohci-xls.c 
> should be easy be ported to the this OHCI driver.
> 
> I am unable to test the suspend and resume part, as my SoC does not 
> support this, but most of the platform driver do not support 
> suspend/resume too. The code here should work, but was never runtime 
> tested.
> 
> This also contains patches adding USB support for the SoCs based on ssb 
> and bcma and converts the ath79 code to use the generic usb driver.
> 
> This patch series is based on the usb tree and should go through it to Linus.

I've applied patches 1, 2, and 7 of this series.  3 and 4 I've commented
on, and I'm guessing 5 and 6 depend on 3 and 4.

Care to refresh the remaining ones and get the BCMA developers ack so
that I can take them?

thanks,

greg k-h
