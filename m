Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbcECXFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 19:05:15 -0400
Date: Tue, 3 May 2016 16:05:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kangjie Lu <kangjielu@gmail.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	linux-wireless@vger.kernel.org, evel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, taesoo@gatech.edu, insu@gatech.edu,
	csong84@gatech.edu, Kangjie Lu <kjlu@gatech.edu>
Subject: Re: [PATCH] fix infoleak in ioctl_cfg80211
Message-ID: <20160503230513.GA15078@kroah.com> (sfid-20160504_010534_069950_E9090FED)
References: <1462313506-7742-1-git-send-email-kjlu@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462313506-7742-1-git-send-email-kjlu@gatech.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 03, 2016 at 06:11:46PM -0400, Kangjie Lu wrote:
> "mac" is an array allocated in stack without being initialized,
> and will be sent out via "nla_put". The dump_station() is supposed
> to initialize the mac address; otherwise, sensitive data in kernel
> stack will be leaked. To fix this, either initialize it (e.g.,
> memset) or completely remove this dump_station().
> 
> Signed-off-by: Kangjie Lu <kjlu@gatech.edu>
> ---
>  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> index 12d1844..44a1582 100644
> --- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> +++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> @@ -2926,6 +2926,7 @@ static int cfg80211_rtw_dump_station(struct wiphy *wiphy,
>  
>  	/* TODO: dump scanned queue */
>  
> +	memset(mac, 0, ETH_ALEN);
>  	return -ENOENT;
>  }

This isn't needed, as it returns -ENOENT and so mac never gets used.

thanks,

greg k-h
