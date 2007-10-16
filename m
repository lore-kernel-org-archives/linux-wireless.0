Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:53485 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932640AbXJPNkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 09:40:12 -0400
Message-ID: <4714BF2C.6060008@lwfinger.net> (sfid-20071016_144017_454417_D6F046BB)
Date: Tue, 16 Oct 2007 08:39:56 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	WANG Cong <xiyou.wangcong@gmail.com>,
	Adrian Bunk <bunk@kernel.org>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: Fwd: [-mm Patch] drivers/net/wireless/b43legacy/main.c: initialize
 the correct return value
References: <200710151454.46047.mb@bu3sch.de>
In-Reply-To: <200710151454.46047.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> From: Adrian Bunk <bunk@kernel.org>
> 
> Initialize "err" in drivers/net/wireless/b43legacy/main.c::b43legacy_start()
> in case of returning an uninitialized value.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> ---
>  drivers/net/wireless/b43/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
> ===================================================================
> --- linux-2.6.23-mm1.orig/drivers/net/wireless/b43legacy/main.c
> +++ linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
> @@ -3306,7 +3306,7 @@ static int b43legacy_start(struct ieee80
>  	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
>  	struct b43legacy_wldev *dev = wl->current_dev;
>  	int did_init = 0;
> -	int err;
> +	int err = 0;
>  
>  	mutex_lock(&wl->mutex);
>  
> 
> 
> -------------------------------------------------------
> 

