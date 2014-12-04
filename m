Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:52157 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbaLDTUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 14:20:02 -0500
Message-ID: <5480B3DF.9030709@broadcom.com> (sfid-20141204_202008_861182_05BC0999)
Date: Thu, 4 Dec 2014 20:19:59 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: <m_del_buon@libero.it>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: help
References: <19484232.27307.1417719685831.JavaMail.httpd@fep-mail-gateway-l2b.virgilio.net>
In-Reply-To: <19484232.27307.1417719685831.JavaMail.httpd@fep-mail-gateway-l2b.virgilio.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/04/14 20:01, m_del_buon@libero.it wrote:
> can you help me with this problems? thx

Suspect that you are building newer kernel driver code against an older 
kernel. How did you populate /home/hp/rtl8192su-master/rtlwifi?

Regards,
Arend

> Sent from Libero Mobile
> ________________________________
>
> Il 04/12/2014, m_del_buon@libero.it ha scritto:
>
> hi I am an italian user of one realtek based device Bus 001 Device 005: ID 0df6:004b Sitecom Europe B.V. WL-349v3 Wireless Micro Adapter 150N X1 [Realtek RTL8192SU] on an ubuntu 14.04 64bit 3.13.0-40-generic kernel and I received following error
> make
> make -C /lib/modules/3.13.0-40-generic/build M=/home/hp/rtl8192su-master/rtlwifi CONFIG_RTL_CARDS=y CONFIG_RTLWIFI=m CONFIG_RTLWIFI_DEBUG=y CONFIG_RTLWIFI_DEBUGFS=y CONFIG_RTLWIFI_USB=m CONFIG_RTLWIFI_PCI=m CONFIG_RTL8192SU=m CONFIG_RTL8192SE=m CONFIG_RTL8192S_COMMON=m CONFIG_RTL8192CU=n CONFIG_RTL8192DE=n CONFIG_RTL8192CE=n CONFIG_RTL8192C_COMMON=n CONFIG_RTL8723AE=n CONFIG_RTL8188EE=n  EXTRA_CFLAGS="-DDEBUG -DCONFIG_RTLWIFI_DEBUGFS=m -w"
> make[1]: ingresso nella directory "/usr/src/linux-headers-3.13.0-40-generic"
>    CC [M]  /home/hp/rtl8192su-master/rtlwifi/regd.o
> In file included from include/net/cfg80211.h:23:0,
>                   from include/net/mac80211.h:21,
>                   from /home/hp/rtl8192su-master/rtlwifi/wifi.h:41,
>                   from /home/hp/rtl8192su-master/rtlwifi/regd.c:30:
> /home/hp/rtl8192su-master/rtlwifi/regd.c:62:4: error: ‘NL80211_RRF_NO_IR’ undeclared here (not in a function)
>      NL80211_RRF_NO_IR)
>      ^
> include/net/regulatory.h:128:11: note: in definition of macro ‘REG_RULE’
>    .flags = reg_flags,    \
>             ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c:99:6: note: in expansion of macro ‘RTL819x_2GHZ_CH12_13’
>        RTL819x_2GHZ_CH12_13,
>        ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c: In function ‘_rtl_reg_apply_beaconing_flags’:
> /home/hp/rtl8192su-master/rtlwifi/regd.c:186:20: error: ‘IEEE80211_CHAN_NO_IR’ undeclared (first use in this function)
>        ch->flags&= ~IEEE80211_CHAN_NO_IR;
>                      ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c:186:20: note: each undeclared identifier is reported only once for each function it appears in
> /home/hp/rtl8192su-master/rtlwifi/regd.c: In function ‘_rtl_reg_apply_active_scan_flags’:
> /home/hp/rtl8192su-master/rtlwifi/regd.c:214:19: error: ‘IEEE80211_CHAN_NO_IR’ undeclared (first use in this function)
>     if (ch->flags&  IEEE80211_CHAN_NO_IR)
>                     ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c: In function ‘_rtl_reg_apply_radar_flags’:
> /home/hp/rtl8192su-master/rtlwifi/regd.c:279:10: error: ‘IEEE80211_CHAN_NO_IR’ undeclared (first use in this function)
>            IEEE80211_CHAN_NO_IR;
>            ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c: In function ‘_rtl_regd_init_wiphy’:
> /home/hp/rtl8192su-master/rtlwifi/regd.c:348:7: error: ‘struct wiphy’ has no member named ‘regulatory_flags’
>    wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
>         ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c:348:29: error: ‘REGULATORY_CUSTOM_REG’ undeclared (first use in this function)
>    wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
>                               ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c:349:7: error: ‘struct wiphy’ has no member named ‘regulatory_flags’
>    wiphy->regulatory_flags&= ~REGULATORY_STRICT_REG;
>         ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c:349:30: error: ‘REGULATORY_STRICT_REG’ undeclared (first use in this function)
>    wiphy->regulatory_flags&= ~REGULATORY_STRICT_REG;
>                                ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c:350:7: error: ‘struct wiphy’ has no member named ‘regulatory_flags’
>    wiphy->regulatory_flags&= ~REGULATORY_DISABLE_BEACON_HINTS;
>         ^
> /home/hp/rtl8192su-master/rtlwifi/regd.c:350:30: error: ‘REGULATORY_DISABLE_BEACON_HINTS’ undeclared (first use in this function)
>    wiphy->regulatory_flags&= ~REGULATORY_DISABLE_BEACON_HINTS;
>                                ^
> make[2]: *** [/home/hp/rtl8192su-master/rtlwifi/regd.o] Errore 1
> make[1]: *** [_module_/home/hp/rtl8192su-master/rtlwifi] Errore 2
> make[1]: uscita dalla directory "/usr/src/linux-headers-3.13.0-40-generic"
> make: *** [all] Errore 2
> can you help me?
>
> Sent from Libero Mobile

