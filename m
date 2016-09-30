Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36291 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932707AbcI3NWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 09:22:11 -0400
Date: Fri, 30 Sep 2016 15:22:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Aditya Shankar <Aditya.Shankar@microchip.com>
Cc: ganesh.krishna@microchip.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nicolas.Ferre@microchip.com
Subject: Re: [PATCH 2/2] Revert "staging: wilc1000: Replace kthread with
 workqueue for host interface"
Message-ID: <20160930132215.GB3016@kroah.com> (sfid-20160930_152226_883989_01545B84)
References: <20160930101318.GA24973@aditya-ubuntu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160930101318.GA24973@aditya-ubuntu.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 30, 2016 at 03:43:18PM +0530, Aditya Shankar wrote:
> This reverts commit 2518ac59eb27 ("staging: wilc1000: Replace kthread
> with workqueue for host interface")
> 
> This commit breaks wilc1000 driver init. A crash was seen
> everytime the wlan interface was brought up and wilc device
> open was attempted. This change is being reverted until we
> figure out the problem in this change. The driver is
> usable now with this change reverted.
> 
> Signed-off-by: Aditya Shankar <Aditya.Shankar@microchip.com>
> 
> Conflicts:
> 	drivers/staging/wilc1000/host_interface.c

What is this line doing here?

And shouldn't we add a cc: stable tag as well?  Or at the least, put a
"fixes:" tag to let people know exactly what commit it is fixing (the
id that it is reverting.)

thanks,

greg k-h
