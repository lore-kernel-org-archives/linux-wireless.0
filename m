Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41473 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756742AbcJYJDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 05:03:35 -0400
Date: Tue, 25 Oct 2016 11:03:40 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com
Subject: Re: [PATCH] staging: rtl8712: Free memory and return failure when
 kmalloc fails
Message-ID: <20161025090340.GA7765@kroah.com> (sfid-20161025_110413_294033_D1F58148)
References: <20161020065932.GA21705@symbol-HP-ZBook-15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161020065932.GA21705@symbol-HP-ZBook-15>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2016 at 12:29:33PM +0530, Souptick Joarder wrote:
> This patch is added to free memory and return failure when kmalloc fails

I'm sorry, but I can not parse that sentance.  Can you rephrase this a
bit better?  What exactly are you doing here?

> 
> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
> ---
>  drivers/staging/rtl8712/os_intfs.c     | 3 ++-
>  drivers/staging/rtl8712/rtl871x_cmd.c  | 5 ++++-
>  drivers/staging/rtl8712/rtl871x_xmit.c | 5 ++++-
>  3 files changed, 10 insertions(+), 3 deletions(-)

Any reason why you didn't cc: the driverdevel mailing list?  I doubt
linux-wireless cares about staging drivers :(

> 
> diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
> index cbe4de0..aab3141 100644
> --- a/drivers/staging/rtl8712/os_intfs.c
> +++ b/drivers/staging/rtl8712/os_intfs.c
> @@ -313,7 +313,8 @@ u8 r8712_init_drv_sw(struct _adapter *padapter)
>  		return _FAIL;
>  	if (r8712_init_mlme_priv(padapter) == _FAIL)
>  		return _FAIL;
> -	_r8712_init_xmit_priv(&padapter->xmitpriv, padapter);
> +	if ((_r8712_init_xmit_priv(&padapter->xmitpriv, padapter)) != _SUCCESS)
> +		return _FAIL;

You don't have to unwind anything that r8712_init_mlme_priv() did?

>  	_r8712_init_recv_priv(&padapter->recvpriv, padapter);
>  	memset((unsigned char *)&padapter->securitypriv, 0,
>  	       sizeof(struct security_priv));

thanks,

greg k-h
