Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2GZRrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 13:47:39 -0400
Message-ID: <1343324856.4477.9.camel@jlt3.sipsolutions.net> (sfid-20120726_194742_882154_1E6365F1)
Subject: Re: [PATCH] mac80211: add PS flag to bss_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Jul 2012 19:47:36 +0200
In-Reply-To: <1343231359-3024-1-git-send-email-eliad@wizery.com> (sfid-20120725_174933_259741_C18DB574)
References: <1343231359-3024-1-git-send-email-eliad@wizery.com>
	 (sfid-20120725_174933_259741_C18DB574)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-25 at 18:49 +0300, Eliad Peller wrote:

> @@ -2085,6 +2092,9 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
>  
>  	ieee80211_recalc_ps(local, -1);
>  
> +	sdata->vif.bss_conf.ps = ieee80211_powersave_allowed(sdata);
> +	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_PS);

It need not have changed, since the AP could be broken? We might also
not even be associated, so I don't think this is right.


I also wonder if ieee80211_recalc_ps() should use vif.bss_conf.ps
instead of calling powersave_allowed() itself?

johannes

