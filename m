Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3J0NsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 09:48:03 -0400
Date: Sun, 27 Oct 2013 06:49:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: device.h  Remove typedef enum
 __device_init_type.
Message-ID: <20131027134950.GB31053@kroah.com> (sfid-20131027_144811_318028_3B575120)
References: <1382469974.6738.8.camel@canaries64-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382469974.6738.8.camel@canaries64-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 22, 2013 at 08:26:14PM +0100, Malcolm Priestley wrote:
> Since typedef enum __device_init_type is only ever called
> in one state.

Then why not remove it entirely?

> Remove the typedef from main_usb.c:device_init_registers
> and if braces and just apply the enum value to sInitCmd.byInitClass.

You kind of did this, but things are still a bit messed up:

>      }
> -    if (InitType == DEVICE_INIT_COLD) {
>  
>          ntStatus = CONTROLnsRequestIn(pDevice,MESSAGE_TYPE_INIT_RSP,0,0,sizeof(RSP_CARD_INIT), (u8 *) &(sInitRsp));
>  
> @@ -574,7 +572,6 @@ static int device_init_registers(struct vnt_private *pDevice,
>  	/* if exist SW network address, use it */
>  	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %pM\n",
>  		pDevice->abyCurrentNetAddr);
> -    }

You remove this if, but the indentation is not fixed up.

Just remove the enum entirely if it's not used.

thanks,

greg k-h
