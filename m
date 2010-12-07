Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab0LGKF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 05:05:26 -0500
Subject: Re: build error without  CONFIG_MAC80211_MESH
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
In-Reply-To: <201012071123.03046.br1@einfach.org>
References: <201012071123.03046.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 11:05:23 +0100
Message-ID: <1291716323.3607.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 11:23 +0900, Bruno Randolf wrote:
> Hi!
> 
> Building current wireless-testing (master-2010-12-06) without the Mesh option 
> is broken:
> 
>   CC [M]  net/mac80211/main.o
> /home/br1/ath/wireless-testing/net/mac80211/main.c: In function 
> ‘ieee80211_bss_info_change_notify’:
> /home/br1/ath/wireless-testing/net/mac80211/main.c:250: error: ‘union 
> <anonymous>’ has no member named ‘mesh’
> make[3]: *** [net/mac80211/main.o] Error 1
> make[2]: *** [net/mac80211] Error 2
> make[1]: *** [net] Error 2
> make: *** [sub-make] Error 2
> 
> It needs something like:
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 40bd12e..3d988ca 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -245,10 +245,12 @@ void ieee80211_bss_info_change_notify(struct 
> ieee80211_sub_if_data *sdata,
>                                 sdata->vif.bss_conf.enable_beacon =
>                                         !!sdata->u.ibss.presp;
>                                 break;
> +#ifdef CONFIG_MAC80211_MESH

Indeed, care to submit a patch?

thx,
johannes

