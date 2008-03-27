Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbYC0LSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 07:18:17 -0400
Subject: Re: [PATCH, take 2] libertas: don't depend on IEEE80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803261756.27077.hs4233@mail.mn-solutions.de>
References: <200803261324.21938.hs4233@mail.mn-solutions.de>
	 <200803261735.59235.hs4233@mail.mn-solutions.de>
	 <200803261756.27077.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 07:17:00 -0400
Message-Id: <1206616620.6368.15.camel@localhost.localdomain> (sfid-20080327_111825_691037_5B1E9DCA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 17:56 +0100, Holger Schurig wrote:
> [PATCH] libertas: don't depend on IEEE80211
> 
> Runtime-wise we only need escape_ssid from the deprecated IEEE80211
> subsystem. However, it's easy to provide our own copy.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> 
> The previous patch also exported this as GPL. However, there is no
> need to to is. Actually there is no need to export this at all. It's
> only used inside libertas.ko.
> 
> Index: wireless-testing/drivers/net/wireless/Kconfig
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/Kconfig	2008-03-26 16:45:21.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/Kconfig	2008-03-26 16:46:43.000000000 +0100
> @@ -271,7 +271,6 @@ config LIBERTAS
>  	tristate "Marvell 8xxx Libertas WLAN driver support"
>  	depends on WLAN_80211
>  	select WIRELESS_EXT
> -	select IEEE80211
>  	select FW_LOADER
>  	---help---
>  	  A library for Marvell Libertas 8xxx devices.
> Index: wireless-testing/drivers/net/wireless/libertas/decl.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-03-26 16:45:21.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-03-26 16:46:43.000000000 +0100
> @@ -71,4 +71,9 @@ int lbs_stop_card(struct lbs_private *pr
>  void lbs_host_to_card_done(struct lbs_private *priv);
>  
>  int lbs_update_channel(struct lbs_private *priv);
> +
> +#ifndef CONFIG_IEEE80211
> +const char *escape_essid(const char *essid, u8 essid_len);
> +#endif
> +
>  #endif
> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-03-26 16:46:43.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-03-26 16:46:58.000000000 +0100
> @@ -1565,6 +1565,32 @@ out:
>  	return ret;
>  }
>  
> +#ifndef CONFIG_IEEE80211
> +const char *escape_essid(const char *essid, u8 essid_len)
> +{
> +	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
> +	const char *s = essid;
> +	char *d = escaped;
> +
> +	if (ieee80211_is_empty_essid(essid, essid_len)) {
> +		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
> +		return escaped;
> +	}
> +
> +	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
> +	while (essid_len--) {
> +		if (*s == '\0') {
> +			*d++ = '\\';
> +			*d++ = '0';
> +			s++;
> +		} else {
> +			*d++ = *s++;
> +		}
> +	}
> +	*d = '\0';
> +	return escaped;
> +}
> +#endif
>  
>  module_init(lbs_init_module);
>  module_exit(lbs_exit_module);

