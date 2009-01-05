Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:35890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbZAEOE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 09:04:29 -0500
Date: Mon, 5 Jan 2009 15:04:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Enforce module build if rfkill is a module
Message-ID: <20090105140413.GE4190@elte.hu> (sfid-20090105_150432_863294_6DFF296B)
References: <3f9a31f40901020936l4bed87e2jb64678572d2ad45b@mail.gmail.com> <20090102180730.GA10072@elte.hu> <3f9a31f40901021040l2afb5e19sc37e61d3f9728531@mail.gmail.com> <495E6C96.3040102@kernel.org> <20090102195802.GA28494@elte.hu> <20090105115124.GA2235@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090105115124.GA2235@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


* Jouni Malinen <jouni.malinen@atheros.com> wrote:

> CONFIG_ATH9K=y results in build issues if CONFIG_RFKILL=m since ath9k
> does not depend on rfkill in kconfig (i.e., CONFIG_RFKILL is used to
> select whether to enable rfkill in ath9k), but uses its functions if
> rfkill is enabled. Enforce ath9k to be build as a module if
> CONFIG_RFKILL=m to avoid this invalid configuration.
> 
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
> 
> ---
>  drivers/net/wireless/ath9k/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- wireless-testing.orig/drivers/net/wireless/ath9k/Kconfig	2009-01-05 13:27:01.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/ath9k/Kconfig	2009-01-05 13:36:27.000000000 +0200
> @@ -1,6 +1,7 @@
>  config ATH9K
>  	tristate "Atheros 802.11n wireless cards support"
>  	depends on PCI && MAC80211 && WLAN_80211
> +	depends on RFKILL || RFKILL=n
>  	select MAC80211_LEDS
>  	select LEDS_CLASS
>  	select NEW_LEDS

thanks - i'll let you know if there's still any build failures in this 
area. (Sidenote: next time around please also add a Reported-by line 
crediting bugreporters. Doesnt matter to me but matters to contributors 
and testers in general.)

	Ingo
