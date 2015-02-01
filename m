Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbbBAXBZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 18:01:25 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: hal: usb_ops_linux: Removed variables that is never used
References: <1422717177-5865-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 01 Feb 2015 18:01:13 -0500
In-Reply-To: <1422717177-5865-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 31 Jan 2015 16:12:57 +0100")
Message-ID: <wrfjfvap1bk6.fsf@redhat.com> (sfid-20150202_000130_120552_35146836)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:
> Variable was assigned a value that was never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/rtl8723au/hal/usb_ops_linux.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/hal/usb_ops_linux.c b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
> index a6d16ad..4ae0a8a 100644
> --- a/drivers/staging/rtl8723au/hal/usb_ops_linux.c
> +++ b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
> @@ -26,11 +26,10 @@ u8 rtl8723au_read8(struct rtw_adapter *padapter, u16 addr)
>  {
>  	struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
>  	struct usb_device *udev = pdvobjpriv->pusbdev;
> -	int len;
>  	u8 data;
>  
>  	mutex_lock(&pdvobjpriv->usb_vendor_req_mutex);
> -	len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +	usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  			      REALTEK_USB_VENQT_CMD_REQ, REALTEK_USB_VENQT_READ,
>  			      addr, 0, &pdvobjpriv->usb_buf.val8, sizeof(data),
>  			      RTW_USB_CONTROL_MSG_TIMEOUT);
> @@ -45,11 +44,10 @@ u16 rtl8723au_read16(struct rtw_adapter *padapter, u16 addr)
>  {
>  	struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
>  	struct usb_device *udev = pdvobjpriv->pusbdev;
> -	int len;
>  	u16 data;
>  
>  	mutex_lock(&pdvobjpriv->usb_vendor_req_mutex);
> -	len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +	usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  			      REALTEK_USB_VENQT_CMD_REQ, REALTEK_USB_VENQT_READ,
>  			      addr, 0, &pdvobjpriv->usb_buf.val16, sizeof(data),
>  			      RTW_USB_CONTROL_MSG_TIMEOUT);
> @@ -64,11 +62,10 @@ u32 rtl8723au_read32(struct rtw_adapter *padapter, u16 addr)
>  {
>  	struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
>  	struct usb_device *udev = pdvobjpriv->pusbdev;
> -	int len;
>  	u32 data;
>  
>  	mutex_lock(&pdvobjpriv->usb_vendor_req_mutex);
> -	len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +	usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  			      REALTEK_USB_VENQT_CMD_REQ, REALTEK_USB_VENQT_READ,
>  			      addr, 0, &pdvobjpriv->usb_buf.val32, sizeof(data),
>  			      RTW_USB_CONTROL_MSG_TIMEOUT);

Again, fix the formatting if you want to make this change.

NACK

Jes
