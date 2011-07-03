Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr16.hinet.net ([168.95.4.116]:39373 "EHLO msr16.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1GCBHz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2011 21:07:55 -0400
Date: Sun, 3 Jul 2011 09:06:05 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
Message-ID: <20110703010605.GA3736@internetdog.org> (sfid-20110703_030758_996428_6C8B370D)
Reply-To: ali@internetdog.org
References: <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com>
 <4DC06BF3.6070208@lwfinger.net>
 <20110621124954.GA8462@internetdog.org>
 <4E011644.3070906@lwfinger.net>
 <20110622010057.GA12123@internetdog.org>
 <4E0154B7.2000204@lwfinger.net>
 <20110622025623.GC12547@internetdog.org>
 <4E015CE8.3000304@lwfinger.net>
 <20110627072351.GA4251@internetdog.org>
 <4E0F50B4.3080805@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E0F50B4.3080805@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Sat, Jul 02, 2011 at 12:09:08PM -0500, Larry Finger wrote:
> On 06/27/2011 02:23 AM, Ali Bahar wrote:

> >The cause is that the driver's handler for the Set expects that the
> >interface is Up. In my case, it was not, and so it returns a -1. This
> >pops back up the call-chain until it gets misinterpreted as an EPERM.

> The attached patch has been floating around for a while. Does it help?

Of course, it will, but the general problem with the -1 return-values
(and any other Up assumptions) will remain.

As I'd indicated earlier, I have no interest in, or use for, this
device. I dug into it because there seemed to be a need within this
ML (and I was already looking for an 802.11 project anyway.)

If that is the case, I can implement the changes, merge recent Realtek
changes, and determine how much nl80211 interface is needed.
On the other hand, if changes are on-hold, then I'll focus elsewhere.

regards,
ali


> Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> ===================================================================
> --- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -990,8 +990,6 @@ static int r8711_wx_set_wap(struct net_d
>  	struct wlan_network *pnetwork = NULL;
>  	enum NDIS_802_11_AUTHENTICATION_MODE	authmode;
>  
> -	if (padapter->bup == false)
> -		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
>  		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
> @@ -1182,8 +1180,6 @@ static int r8711_wx_set_essid(struct net
>  	struct list_head *phead;
>  	u32 len;
>  
> -	if (padapter->bup == false)
> -		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
>  		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))

