Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:50005 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752764AbeBVIjK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 03:39:10 -0500
Date: Thu, 22 Feb 2018 14:09:01 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 1/4] staging: wilc1000: remove use of 'happened'
 variable in wilc_spi_read_int()
Message-ID: <20180222140901.1a2b6ca8@ajaysk-VirtualBox> (sfid-20180222_093914_778574_5621128D)
In-Reply-To: <20180222072058.g6wyrsmg5lr6vnef@mwanda>
References: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
        <1519229532-11265-2-git-send-email-ajay.kathat@microchip.com>
        <20180222072058.g6wyrsmg5lr6vnef@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Thu, 22 Feb 2018 10:20:58 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Wed, Feb 21, 2018 at 09:42:09PM +0530, Ajay Singh wrote:
> > Modified wilc_spi_read_int() by removing unnecessary use of "happened"
> > variable.
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/wilc_spi.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> > index 6b392c9..131d2b7 100644
> > --- a/drivers/staging/wilc1000/wilc_spi.c
> > +++ b/drivers/staging/wilc1000/wilc_spi.c
> > @@ -936,7 +936,7 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
> >  	int ret;
> >  	u32 tmp;
> >  	u32 byte_cnt;
> > -	int happened, j;
> > +	int j;
> >  	u32 unknown_mask;
> >  	u32 irq_flags;
> >  	int k = IRG_FLAGS_OFFSET + 5;
> > @@ -956,8 +956,6 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
> >  
> >  	j = 0;
> >  	do {
> > -		happened = 0;
> > -
> >  		wilc_spi_read_reg(wilc, 0x1a90, &irq_flags);
> >  		tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
> >  
> > @@ -972,11 +970,11 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
> >  			dev_err(&spi->dev,
> >  				"Unexpected interrupt(2):j=%d,tmp=%x,mask=%x\n",
> >  				j, tmp, unknown_mask);
> > -				happened = 1;
> > +				break;  
> 
> This is flipped around.  happened means don't break, but you've changed
> it to be the opposite.

You are right. Thanks for pointing it out. It's was a mistake. I will
change 'break' to 'continue' and while(1) to while(0) and resubmit the
patch.


Regards,
Ajay

> 
> regards,
> dan carpenter
> 
> >  		}
> >  
> >  		j++;
> > -	} while (happened);
> > +	} while (1);
> >    
> 
