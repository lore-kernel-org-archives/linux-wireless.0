Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:14942 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbeHLH25 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 03:28:57 -0400
Date: Sun, 12 Aug 2018 10:22:06 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH v2] staging: wilc1000: fix undefined reference to
 `__this_module' compilation error
Message-ID: <20180812102206.2e854be1@ajaysk-VirtualBox> (sfid-20180812_065222_358192_58E056C9)
In-Reply-To: <20180809122133.GB6937@kroah.com>
References: <1533814179-21436-1-git-send-email-ajay.kathat@microchip.com>
        <20180809122133.GB6937@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Thu, 9 Aug 2018 14:21:33 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, Aug 09, 2018 at 04:59:39PM +0530, Ajay Singh wrote:
> > wilc_debug.o object file is included for both SDIO and SPI module.
> > When anyone(either SDIO or SPI) module is compiled as loaded module
> > and another as buildin module then below compilation error occurs.
> > 
> > "drivers/staging/wilc1000/wilc_debugfs.o:(.data+0x10): undefined
> > reference to `__this_module'"
> > 
> > Moved the declaration of file_operation variable in SDIO/SPI files
> > and pass this as parameter to wilc_debugfs_init().
> > Refactor wilc_debugfs_init() as its not required to maintain
> > 'wilc_debugfs_info_t' in debugfs_info[] array. Also modified file
> > permission from 0666 to 0600 & use 'data' field as 'NULL' in
> > debugfs_create_file() call.  
> 
> That is a lot of different things all in one patch.  Please never do
> that.
> 

Please ignore this patch. I have split these changes and resubmitted a
new patch series to address this issue.

Regards,
Ajay
