Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbeHLOE5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 10:04:57 -0400
Date: Sun, 12 Aug 2018 13:27:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: devel@driverdev.osuosl.org, venkateswara.kaja@microchip.com,
        linux-wireless@vger.kernel.org, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 2/5] staging: wilc1000: fixes for undefined reference to
 `__this_module' error
Message-ID: <20180812112710.GA25209@kroah.com> (sfid-20180812_132840_474340_33365795)
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
 <1534049265-5600-3-git-send-email-ajay.kathat@microchip.com>
 <20180812064250.GA31152@kroah.com>
 <20180812165204.5dfb54db@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180812165204.5dfb54db@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 12, 2018 at 04:52:04PM +0530, Ajay Singh wrote:
> Hi Greg,
> 
> On Sun, 12 Aug 2018 08:42:50 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Sun, Aug 12, 2018 at 10:17:42AM +0530, Ajay Singh wrote:
> > > wilc_debug.o object file is included for both SDIO and SPI module.
> > > When anyone(either SDIO or SPI) module is compiled as loaded module
> > > and another as buildin module then below compilation error occurs.
> > > 
> > > "drivers/staging/wilc1000/wilc_debugfs.o:(.data+0x10): undefined
> > > reference to `__this_module'"
> > > 
> > > Moved the declaration of file_operation variable in SDIO/SPI files
> > > and pass this as parameter to wilc_debugfs_init(). Remove 'fops'
> > > element from 'wilc_debugfs_info_t' struct, as its not required.
> > > 
> > > Fixes: 9abc44ba4e2f ("staging: wilc1000: fix TODO to compile spi
> > > and sdio components in single module") Reported-by: kbuild test
> > > robot <lkp@intel.com> Signed-off-by: Ajay Singh
> > > <ajay.kathat@microchip.com> ---  
> > 
> > Can this be the first patch in the series so it can go to Linus for
> > 4.19 and the rest can be postponed for later?
> > 
> 
> No, the patches are in order. To apply this patch the first patch has
> to be also applied. 
> 
> If its okay, I can merge the first 2 patches and give a single patch
> so it can be sent for 4.19 release. Rest of the patches can be
> postponed for later.

No, no need for merging them, I'll just split them up that way then, I
was just hoping for a simpler path toward getting this fixed.  I'll work
on this after 4.19-rc1 is out.

thanks,

greg k-h
