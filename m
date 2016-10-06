Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:41749 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934479AbcJFJ5D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 05:57:03 -0400
Date: Thu, 6 Oct 2016 15:26:59 +0530
From: Aditya Shankar <aditya.shankar@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Aditya Shankar <Aditya.Shankar@microchip.com>,
        <ganesh.krishna@microchip.com>, <linux-wireless@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>
Subject: Re: [PATCH 2/2] Revert
 "staging: wilc1000: Replace kthread with workqueue for host interface"
Message-ID: <20161006152659.15a4c38b1dc8d4f781c20e0a@microchip.com> (sfid-20161006_115920_227152_33D9C744)
In-Reply-To: <20160930132215.GB3016@kroah.com>
References: <20160930101318.GA24973@aditya-ubuntu.local>
        <20160930132215.GB3016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 30 Sep 2016 15:22:15 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Sep 30, 2016 at 03:43:18PM +0530, Aditya Shankar wrote:
> > This reverts commit 2518ac59eb27 ("staging: wilc1000: Replace kthread
> > with workqueue for host interface")
> > 
> > This commit breaks wilc1000 driver init. A crash was seen
> > everytime the wlan interface was brought up and wilc device
> > open was attempted. This change is being reverted until we
> > figure out the problem in this change. The driver is
> > usable now with this change reverted.
> > 
> > Signed-off-by: Aditya Shankar <Aditya.Shankar@microchip.com>
> > 
> > Conflicts:
> > 	drivers/staging/wilc1000/host_interface.c
> 
> What is this line doing here?
> 
> And shouldn't we add a cc: stable tag as well?  Or at the least, put a
> "fixes:" tag to let people know exactly what commit it is fixing (the
> id that it is reverting.)
> 
> thanks,
> 
> greg k-h

Apologies for this bad commit message.

I have an update on this wilc1000 crash issue. I've figured out
the cause for the crash and fixed it. Therefore,
I request you to ignore the patch I sent out to
revert the change causing the regression. The cause was a misplaced
call to destroy workqueue soon after creating it.
With this removed, the issue is not seen.

I will send out a separate patch to fix the issue.

Thanks,
Aditya
