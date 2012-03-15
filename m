Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37860 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032392Ab2COXff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 19:35:35 -0400
Received: by dajr28 with SMTP id r28so5213910daj.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 16:35:34 -0700 (PDT)
Date: Thu, 15 Mar 2012 16:35:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stern@rowland.harvard.edu, linux-mips@linux-mips.org,
	ralf@linux-mips.org, m@bues.ch, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 4/7] USB: Add driver for the bcma bus
Message-ID: <20120315233531.GA2052@kroah.com> (sfid-20120316_003541_657211_CD690E4E)
References: <1331597093-425-1-git-send-email-hauke@hauke-m.de>
 <1331597093-425-5-git-send-email-hauke@hauke-m.de>
 <20120315194426.GA30682@kroah.com>
 <4F626FCB.6010103@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F626FCB.6010103@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 11:40:11PM +0100, Hauke Mehrtens wrote:
> On 03/15/2012 08:44 PM, Greg KH wrote:
> > On Tue, Mar 13, 2012 at 01:04:50AM +0100, Hauke Mehrtens wrote:
> >> This adds a USB driver using the generic platform device driver for the
> >> USB controller found on the Broadcom bcma bus. The bcma bus just
> >> exposes one device which serves the OHCI and the EHCI controller at the
> >> same time. This driver probes for this USB controller and creates and
> >> registers two new platform devices which will be probed by the new
> >> generic platform device driver. This makes it possible to use the EHCI
> >> and the OCHI controller on the bcma bus at the same time.
> >>
> >> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> >> ---
> >>  drivers/usb/host/Kconfig    |   12 ++
> > 
> > This patch fails to apply here, and I can't seem to figure out what tree
> > you made this against to fix it up by hand on my end.
> > 
> > Any thoughts?
> > 
> > greg k-h
> 
> This patch was against
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git#master, but
> I will rebase it onto usb/usb-next and send a new version of the patches
> you have not applied.

Thanks, master tracks Linus's tree, which is not good to send patches
against :)

greg k-h
