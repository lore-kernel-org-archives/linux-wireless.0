Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37442 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993259AbXEBOfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 10:35:21 -0400
Message-ID: <4638A163.8030505@trash.net>
Date: Wed, 02 May 2007 16:34:11 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Jiri Benc <jbenc@suse.cz>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix for missing global (tcf_destroy_chain)  in build
References: <46389ebb.JZh37v8gJUSOn1+U%Larry.Finger@lwfinger.net>
In-Reply-To: <46389ebb.JZh37v8gJUSOn1+U%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> If MAC80211 is selected in the configuration without also selecting NET_SCHED,
> there is a missing global (tcf_destroy_chain) in the build.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-dev/net/mac80211/Kconfig
> ===================================================================
> --- wireless-dev.orig/net/mac80211/Kconfig
> +++ wireless-dev/net/mac80211/Kconfig
> @@ -9,6 +9,7 @@ config MAC80211
>  	select WIRELESS_EXT
>  	select CFG80211
>  	select NET_SCH_FIFO
> +	select NET_SCHED


That pretty much defeats the reason why CONFIG_NET_SCH_FIFO was created.
So far without CONFIG_NET_SCHED the wme scheduler didn't even register,
so it seems the proper fix is to get rid of all #ifdef CONFIG_NET_SCHED
and simply avoid building it.

