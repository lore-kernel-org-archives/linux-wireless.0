Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42870 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZFHARS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 20:17:18 -0400
Subject: Re: [PATCH] rfkill: remove input Kconfig
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244396398.12956.12.camel@johannes.local>
References: <1244396398.12956.12.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 02:16:49 +0200
Message-Id: <1244420209.23850.111.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Now that we added the ioctl, there's no need to ask
> the user to configure this. We will keept it enabled
> for now, and eventually swap the default to n, maybe
> let people configure it under EMBEDDED or so. In any
> case, there's no need to bother users with this now.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/rfkill/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- wireless-testing.orig/net/rfkill/Kconfig	2009-06-07 19:37:34.000000000 +0200
> +++ wireless-testing/net/rfkill/Kconfig	2009-06-07 19:37:41.000000000 +0200
> @@ -18,7 +18,7 @@ config RFKILL_LEDS
>  	default y
>  
>  config RFKILL_INPUT
> -	bool "RF switch input support"
> +	bool
>  	depends on RFKILL
>  	depends on INPUT = y || RFKILL = INPUT
> -	default y if !EMBEDDED
> +	default y

if you want this for normal setups, I totally agree that we not should
ask the user. However when in EMBEDDED, lets give them a chance to not
compile this in. Since most likely it is not needed at all.

Regards

Marcel


