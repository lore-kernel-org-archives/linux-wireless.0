Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58428 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1GLPVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 11:21:35 -0400
Received: by vxb39 with SMTP id 39so3492823vxb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jul 2011 08:21:34 -0700 (PDT)
Message-ID: <4E1C667B.2040009@lwfinger.net> (sfid-20110712_172138_576208_F4218141)
Date: Tue, 12 Jul 2011 10:21:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ali Bahar <ali@internetdog.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: r8712u: Sets to SSID, and to AP MAC#, can
 now be done when the interface is Down.
References: <1310483456-10543-1-git-send-email-ali@internetDog.org> <1310483456-10543-2-git-send-email-ali@internetDog.org>
In-Reply-To: <1310483456-10543-2-git-send-email-ali@internetDog.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2011 10:10 AM, Ali Bahar wrote:
> The original Realtek code assumed that ioctl Sets get done after the
> interface is Up. This included the set to Essid and to the AP MAC#;
> and it fit Realtek's installation procedure. But there is no such
> necessity for the adapter, and no stated requirement found
> elsewhere. Also, wireless drivers typically permit this.
>
> A typical error message used to be:
> Error for wireless request "Set ESSID" (8B1A) :
>      SET failed on device wlan0 ; Operation not permitted.
>
> Signed-off-by: Ali Bahar<ali@internetDog.org>
> ---
> Larry,
>
> this matches _your_ patch, of course. So it is a good candidate for an initial
> submission -- to ensure that I don't fall foul of the process.
>
> Ali
>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Greg,

This patch might be pushed to stable, but I'm not 100% sure. If r8712u is 
controlled by NetworkManager, it behaves correctly. It fails only when used as 
an AP, and perhaps with some versions of manual network control.

Larry

> ---
>   drivers/staging/rtl8712/drv_types.h           |    5 +++++
>   drivers/staging/rtl8712/rtl871x_ioctl_linux.c |   25 +++++++++++++++++++++----
>   2 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
> index 3bb66dc..fd50f78 100644
> --- a/drivers/staging/rtl8712/drv_types.h
> +++ b/drivers/staging/rtl8712/drv_types.h
> @@ -118,6 +118,11 @@ struct dvobj_priv {
>   	struct usb_device *pusbdev;
>   };
>
> +/**
> + * struct _adapter - the main adapter structure for this device.
> + *
> + * bup: True indicates that the interface is Up.
> + */
>   struct _adapter {
>   	struct	dvobj_priv dvobjpriv;
>   	struct	mlme_priv mlmepriv;
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index 40e6b5c..59bdab1 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -975,6 +975,13 @@ static int r871x_wx_set_priv(struct net_device *dev,
>    * s2. set_802_11_authentication_mode()
>    * s3. set_802_11_encryption_mode()
>    * s4. set_802_11_bssid()
> + *
> + * This function intends to handle the Set AP command, which specifies the
> + * MAC# of a preferred Access Point.
> + * Currently, the request comes via Wireless Extensions' SIOCSIWAP ioctl.
> + *
> + * For this operation to succeed, there is no need for the interface to be Up.
> + *
>    */
>   static int r8711_wx_set_wap(struct net_device *dev,
>   			 struct iw_request_info *info,
> @@ -992,8 +999,6 @@ static int r8711_wx_set_wap(struct net_device *dev,
>   	struct wlan_network *pnetwork = NULL;
>   	enum NDIS_802_11_AUTHENTICATION_MODE	authmode;
>
> -	if (padapter->bup == false)
> -		return -1;
>   	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
>   		return -1;
>   	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
> @@ -1074,6 +1079,14 @@ static int r871x_wx_set_mlme(struct net_device *dev,
>   	return ret;
>   }
>
> +/**
> + *
> + * This function intends to handle the Set Scan command.
> + * Currently, the request comes via Wireless Extensions' SIOCSIWSCAN ioctl.
> + *
> + * For this operation to succeed, the interface is brought Up beforehand.
> + *
> + */
>   static int r8711_wx_set_scan(struct net_device *dev,
>   			struct iw_request_info *a,
>   			union iwreq_data *wrqu, char *extra)
> @@ -1169,6 +1182,12 @@ static int r8711_wx_get_scan(struct net_device *dev,
>    * s2. set_802_11_authenticaion_mode()
>    * s3. set_802_11_encryption_mode()
>    * s4. set_802_11_ssid()
> + *
> + * This function intends to handle the Set ESSID command.
> + * Currently, the request comes via the Wireless Extensions' SIOCSIWESSID ioctl.
> + *
> + * For this operation to succeed, there is no need for the interface to be Up.
> + *
>    */
>   static int r8711_wx_set_essid(struct net_device *dev,
>   				struct iw_request_info *a,
> @@ -1184,8 +1203,6 @@ static int r8711_wx_set_essid(struct net_device *dev,
>   	struct list_head *phead;
>   	u32 len;
>
> -	if (padapter->bup == false)
> -		return -1;
>   	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
>   		return -1;
>   	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))

