Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54360 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab0LGCfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:35:53 -0500
Received: by qyk11 with SMTP id 11so4405781qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 18:35:52 -0800 (PST)
Message-ID: <4CFD9D96.6090003@lwfinger.net>
Date: Mon, 06 Dec 2010 20:36:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: build error without  CONFIG_MAC80211_MESH
References: <201012071123.03046.br1@einfach.org>
In-Reply-To: <201012071123.03046.br1@einfach.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2010 08:23 PM, Bruno Randolf wrote:
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
>                         case NL80211_IFTYPE_MESH_POINT:
>                                 sdata->vif.bss_conf.enable_beacon =
>                                         !!sdata->u.mesh.mesh_id_len;
>                                 break;
> +#endif
>                         default:
>                                 /* not reached */
>                                 WARN_ON(1);

Happens here too.

Larry
