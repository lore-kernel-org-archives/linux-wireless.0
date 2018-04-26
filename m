Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753007AbeDZHk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 03:40:28 -0400
Date: Thu, 26 Apr 2018 09:40:20 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@Microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH v2 01/21] staging: wilc1000: replace crc7_byte() with
 inline macro CRC7_BYTE
Message-ID: <20180426074020.GA18831@kroah.com> (sfid-20180426_094032_486043_748252C1)
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
 <1524676706-13179-2-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524676706-13179-2-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2018 at 10:48:06PM +0530, Ajay Singh wrote:
> Replace the function call for crc7_byte() with macro CRC7_BYTE.
> crc7_byte() was called in close while(), so replaced it with macro to
> avoid extra functional call depth.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_spi.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> index 2cb9f4e..3bb8fec 100644
> --- a/drivers/staging/wilc1000/wilc_spi.c
> +++ b/drivers/staging/wilc1000/wilc_spi.c
> @@ -75,15 +75,12 @@ static const u8 crc7_syndrome_table[256] = {
>  	0x46, 0x4f, 0x54, 0x5d, 0x62, 0x6b, 0x70, 0x79
>  };
>  
> -static u8 crc7_byte(u8 crc, u8 data)
> -{
> -	return crc7_syndrome_table[(crc << 1) ^ data];
> -}
> +#define CRC7_BYTE(crc, data) crc7_syndrome_table[(crc << 1) ^ data]

Ick, no.  That's not needed at all, a function is always much better.

And a good compiler will just inline this, are you _sure_ you are
actually changing anything here?

But most importantly, why not just use the build-in crc7 functionality
that the kernel already provides?  Don't have a duplicate version here.

That would be a much better cleanup, right?

thanks,

greg k-h
