Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:19380 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754785AbeDZI4n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 04:56:43 -0400
Date: Thu, 26 Apr 2018 13:24:36 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <ganesh.krishna@microchip.com>,
        <adham.abozaeid@Microchip.com>, <aditya.shankar@microchip.com>
Subject: Re: [PATCH v2 01/21] staging: wilc1000: replace crc7_byte() with
 inline macro CRC7_BYTE
Message-ID: <20180426132436.6317618e@ajaysk-VirtualBox> (sfid-20180426_105650_794945_AA2E151F)
In-Reply-To: <20180426074020.GA18831@kroah.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
        <1524676706-13179-2-git-send-email-ajay.kathat@microchip.com>
        <20180426074020.GA18831@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Thu, 26 Apr 2018 09:40:20 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Wed, Apr 25, 2018 at 10:48:06PM +0530, Ajay Singh wrote:
> > Replace the function call for crc7_byte() with macro CRC7_BYTE.
> > crc7_byte() was called in close while(), so replaced it with
> > macro to avoid extra functional call depth.
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/wilc_spi.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_spi.c
> > b/drivers/staging/wilc1000/wilc_spi.c index 2cb9f4e..3bb8fec
> > 100644 --- a/drivers/staging/wilc1000/wilc_spi.c
> > +++ b/drivers/staging/wilc1000/wilc_spi.c
> > @@ -75,15 +75,12 @@ static const u8 crc7_syndrome_table[256] = {
> >  	0x46, 0x4f, 0x54, 0x5d, 0x62, 0x6b, 0x70, 0x79
> >  };
> >  
> > -static u8 crc7_byte(u8 crc, u8 data)
> > -{
> > -	return crc7_syndrome_table[(crc << 1) ^ data];
> > -}
> > +#define CRC7_BYTE(crc, data) crc7_syndrome_table[(crc << 1) ^
> > data]  
> 
> Ick, no.  That's not needed at all, a function is always much
> better.
> 
> And a good compiler will just inline this, are you _sure_ you are
> actually changing anything here?

As you mentioned, we can leave as it is for good compiler to
handle.

> 
> But most importantly, why not just use the build-in crc7
> functionality that the kernel already provides?  Don't have a
> duplicate version here.
> 
> That would be a much better cleanup, right?
> 

Thank you for your suggestion.

Yes, I agree its better to use the existing crc7 functionality.

It seems the same crc7() functions was available in kernel version
before v3.16-rc1 (in /lib/crc7.c) but later it got changed to
crc7_be() with a different crc lookup table. So i think it can not be
changed directly now.

I will check more on this and see how can we can make use of
modified version of crc7, by also considering the receiver end
changes.

> thanks,
> 
> greg k-h



Regards,
Ajay
