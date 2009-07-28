Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:60201 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZG1GRy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 02:17:54 -0400
Received: by ewy26 with SMTP id 26so3724510ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 23:17:53 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] rt2x00: remove experimental on kconfig
Date: Tue, 28 Jul 2009 08:17:50 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1248736854-443-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248736854-443-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200907280817.50877.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 28 July 2009, Luis R. Rodriguez wrote:
> These have been around for a while, if there are issues
> they should be reported.
> 
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> Ivo, is this fair to say? Was surprised to see rt2x00 marked
> as experimental still.

Well I think removing the experimental flag is fine, the most serious
problem with most drivers is the throughput, but I guess that is not
a blocker for removing the experimental flag.

However please move the experimental flag to rt2800usb, since that
driver is very recent and is not working correctly for a lot of people.

Thanks,

Ivo

>  drivers/net/wireless/rt2x00/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index f970aa2..379da5c 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -1,8 +1,8 @@
>  menuconfig RT2X00
>  	tristate "Ralink driver support"
> -	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
> +	depends on MAC80211 && WLAN_80211
>  	---help---
> -	  This will enable the experimental support for the Ralink drivers,
> +	  This will enable the support for the Ralink drivers,
>  	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
>  
>  	  These drivers make use of the mac80211 stack.


