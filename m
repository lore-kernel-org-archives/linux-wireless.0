Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42481 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932177AbcI3Llv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 07:41:51 -0400
Message-ID: <1475235707.17481.44.camel@sipsolutions.net> (sfid-20160930_134155_498978_8540E741)
Subject: Re: [PATCH] mac80211: fix CMD_FRAME for AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Fri, 30 Sep 2016 13:41:47 +0200
In-Reply-To: <1474786035-15410-1-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_084724_986737_6CBE9669)
References: <1474786035-15410-1-git-send-email-michael-dev@fami-braun.de>
         (sfid-20160925_084724_986737_6CBE9669)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  net/mac80211/offchannel.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
> index 55a9c5b..2afd329 100644
> --- a/net/mac80211/offchannel.c
> +++ b/net/mac80211/offchannel.c
> @@ -819,7 +819,10 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy,
> struct wireless_dev *wdev,
>  		    mgmt->u.action.category ==
> WLAN_CATEGORY_SPECTRUM_MGMT)
>  			break;
>  		rcu_read_lock();
> -		sta = sta_info_get(sdata, mgmt->da);
> +		if (ieee80211_vif_is_mesh(&sdata->vif))
> +			sta = sta_info_get(sdata, mgmt->da);
> +		else
> +			sta = sta_info_get_bss(sdata, mgmt->da);
> 
I don't see why you need to distinguish between mesh and non-mesh here?
get_bss() will ignore the BSS pointer if it's NULL, and that will
always be the case when the type is mesh, so ... why?

johannes
