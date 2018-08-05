Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbeHEQQF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Aug 2018 12:16:05 -0400
Date: Sun, 5 Aug 2018 16:11:17 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: devel@driverdev.osuosl.org, venkateswara.kaja@microchip.com,
        linux-wireless@vger.kernel.org, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 7/8] staging: wilc1000: replace udelay with usleep_range
Message-ID: <20180805141117.GA3895@kroah.com> (sfid-20180805_161126_254248_CD6A1DC1)
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
 <1532844417-3192-8-git-send-email-ajay.kathat@microchip.com>
 <20180802073415.GB14107@kroah.com>
 <20180803135851.0b576ef0@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180803135851.0b576ef0@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 03, 2018 at 01:58:51PM +0530, Ajay Singh wrote:
> Hi Greg,
> 
> On Thu, 2 Aug 2018 09:34:15 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Sun, Jul 29, 2018 at 11:36:56AM +0530, Ajay Singh wrote:
> > > Cleanup patch to avoid the below checkpatch reported issue.
> > > 
> > > "usleep_range is preferred over udelay; see
> > > Documentation/timers/timers-howto.txt".
> > > 
> > > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > > ---
> > >  drivers/staging/wilc1000/wilc_wlan.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/staging/wilc1000/wilc_wlan.c
> > > b/drivers/staging/wilc1000/wilc_wlan.c index 6bac3f7..655952a 100644
> > > --- a/drivers/staging/wilc1000/wilc_wlan.c
> > > +++ b/drivers/staging/wilc1000/wilc_wlan.c
> > > @@ -425,7 +425,7 @@ void chip_wakeup(struct wilc *wilc)
> > >  		} while (wilc_get_chipid(wilc, true) == 0);
> > >  	} else if ((wilc->io_type & 0x1) == HIF_SDIO) {
> > >  		wilc->hif_func->hif_write_reg(wilc, 0xfa, 1);
> > > -		udelay(200);
> > > +		usleep_range(200, 201);  
> > 
> > Hah, that's funny.
> > 
> > No, do it right, don't try to game checkpatch here.
> 
> The delay of 200us was added to have a short wait between HW register
> write and read operation. The short delay of 200us was enough for this
> but the duration range is not available. So to replace udelay() of
> 200us with usleep_range(), I have used used range from 200, 201.

What do you mean that "the duration range is not available"?  You know
what is allowed here, please provide that range.  You do know the reason
for this suggestion from checkpatch, right?  By doing what you did here,
you are totally subverting the real goal here, you are not solving
anything.

thanks,

greg k-h
