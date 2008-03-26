Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYCZOPx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 10:15:53 -0400
Subject: Re: [PATCH] libertas: don't depend on IEEE80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803261324.21938.hs4233@mail.mn-solutions.de>
References: <200803261324.21938.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 10:14:37 -0400
Message-Id: <1206540877.30998.7.camel@localhost.localdomain> (sfid-20080326_141558_043245_27D7BC2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 13:24 +0100, Holger Schurig wrote:
> Runtime-wise we only need escape_ssid from the deprecated IEEE80211
> subsystem. However, it's easy to provide our own copy.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/Kconfig
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/Kconfig	2008-03-26 12:13:45.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/Kconfig	2008-03-26 12:14:07.000000000 +0100
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
> --- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-03-26 12:13:44.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-03-26 12:16:33.000000000 +0100
> @@ -71,4 +71,9 @@ int lbs_stop_card(struct lbs_private *pr
>  void lbs_host_to_card_done(struct lbs_private *priv);
>  
>  int lbs_update_channel(struct lbs_private *priv);
> +
> +#if !defined(CONFIG_IEEE80211) && defined(CONFIG_LIBERTAS_DEBUG)
> +const char *escape_essid(const char *essid, u8 essid_len);
> +#endif
> +
>  #endif
> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-03-26 12:14:07.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-03-26 12:15:47.000000000 +0100
> @@ -1559,6 +1559,33 @@ out:
>  	return ret;
>  }
>  
> +#if !defined(CONFIG_IEEE80211) && defined(CONFIG_LIBERTAS_DEBUG)
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
> +EXPORT_SYMBOL(escape_essid);
> +#endif
>  
>  module_init(lbs_init_module);
>  module_exit(lbs_exit_module);

