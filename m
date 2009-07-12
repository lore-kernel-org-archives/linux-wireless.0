Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41674 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbZGLScd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 14:32:33 -0400
Message-ID: <4A5A2C26.90902@openwrt.org>
Date: Sun, 12 Jul 2009 20:32:06 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] [compat-2.6] Update compat.diff for master-2009-07-10
References: <1247397966-1374-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1247397966-1374-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens írta:
> This is now compiling with kernel at least 2.6.26 to 2.6.30.
> MAC80211_DRIVER_API_TRACER is only working with kernel >= 2.6.30.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---

<snip>

>   
>   /*
> +--- a/net/mac80211/driver-trace.h
> ++++ b/net/mac80211/driver-trace.h
> +@@ -1,7 +1,9 @@
> + #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
> + #define __MAC80211_DRIVER_TRACE
> + 
> ++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
> + #include <linux/tracepoint.h>
> ++#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
                                                       ^^ typo?
> + #include <net/mac80211.h>
> + #include "ieee80211_i.h"
> + 
> +@@ -645,4 +647,6 @@ TRACE_EVENT(drv_ampdu_action,
> + #define TRACE_INCLUDE_PATH .
> + #undef TRACE_INCLUDE_FILE
> + #define TRACE_INCLUDE_FILE driver-trace
> ++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
> + #include <trace/define_trace.h>
> ++#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
>  --- a/net/mac80211/iface.c	2009-07-08 15:46:16.452255410 -0700
>  +++ b/net/mac80211/iface.c	2009-07-08 15:46:06.060257895 -0700
>  @@ -643,6 +643,7 @@

