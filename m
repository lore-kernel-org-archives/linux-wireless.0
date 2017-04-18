Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753094AbdDRLvc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 07:51:32 -0400
Date: Tue, 18 Apr 2017 13:51:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Aditya Shankar <aditya.shankar@microchip.com>
Cc: devel@driverdev.osuosl.org, ganesh.krishna@microchip.com,
        arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] staging: wilc1000: New cfg packet format in
 handle_set_wfi_drv_handler
Message-ID: <20170418115123.GB17911@kroah.com> (sfid-20170418_135135_211309_8D938C8D)
References: <1491928903-2866-1-git-send-email-aditya.shankar@microchip.com>
 <20170411173546.GA29399@kroah.com>
 <20170413081423.333c25fa@aditya-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170413081423.333c25fa@aditya-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 13, 2017 at 08:14:23AM +0530, Aditya Shankar wrote:
> On Tue, 11 Apr 2017 19:35:46 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, Apr 11, 2017 at 10:11:43PM +0530, Aditya Shankar wrote:
> > > Change the config packet format used in handle_set_wfi_drv_handler()
> > > to align the host driver with the new format used in the wilc firmware.  
> > 
> > So does this break devices with "old" firmware?
> > 
> > Where is the "new" firmware?  What is enforcing the usage only of new
> > firmware?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Yes, this new change would break devices with firmware older than ver 14.2(released on our vendor tree in March 2016). The older firmware in the linux-firmware repository is close to 2 years old and not being used with the staging driver even before this change  was submitted. Developers picked up the firmware mostly from one of our vendor trees on github.
> 
> To resolve this confusion about firmware location, I submitted a patch to linux-firmware to make the latest firmware available through this channel. Below are the details. The driver currently does not enforce usage of new firmware but would fail to properly configure the older firmware.

Please put that information in the changelog text for the next version
of this patch that you submit.

thanks,

greg k-h
