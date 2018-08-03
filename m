Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:48918 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbeHCKYP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 06:24:15 -0400
Date: Fri, 3 Aug 2018 13:58:51 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <ganesh.krishna@microchip.com>,
        <adham.abozaeid@microchip.com>, <aditya.shankar@microchip.com>
Subject: Re: [PATCH 7/8] staging: wilc1000: replace udelay with usleep_range
Message-ID: <20180803135851.0b576ef0@ajaysk-VirtualBox> (sfid-20180803_102905_198370_F66DFDB4)
In-Reply-To: <20180802073415.GB14107@kroah.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
        <1532844417-3192-8-git-send-email-ajay.kathat@microchip.com>
        <20180802073415.GB14107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Thu, 2 Aug 2018 09:34:15 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Jul 29, 2018 at 11:36:56AM +0530, Ajay Singh wrote:
> > Cleanup patch to avoid the below checkpatch reported issue.
> > 
> > "usleep_range is preferred over udelay; see
> > Documentation/timers/timers-howto.txt".
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/wilc_wlan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_wlan.c
> > b/drivers/staging/wilc1000/wilc_wlan.c index 6bac3f7..655952a 100644
> > --- a/drivers/staging/wilc1000/wilc_wlan.c
> > +++ b/drivers/staging/wilc1000/wilc_wlan.c
> > @@ -425,7 +425,7 @@ void chip_wakeup(struct wilc *wilc)
> >  		} while (wilc_get_chipid(wilc, true) == 0);
> >  	} else if ((wilc->io_type & 0x1) == HIF_SDIO) {
> >  		wilc->hif_func->hif_write_reg(wilc, 0xfa, 1);
> > -		udelay(200);
> > +		usleep_range(200, 201);  
> 
> Hah, that's funny.
> 
> No, do it right, don't try to game checkpatch here.

The delay of 200us was added to have a short wait between HW register
write and read operation. The short delay of 200us was enough for this
but the duration range is not available. So to replace udelay() of
200us with usleep_range(), I have used used range from 200, 201.

How should we handle these type of scenarios and is there any suggested
way to specify these range.
 
Should we leave this code as it is and ignore this checkpatch warning.

Please provide your suggestion/input.

Thank you.

Regards,
Ajay
