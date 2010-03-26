Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0CZRZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 13:25:57 -0400
Subject: Re: [PATCH 1/2] mac80211: explicitly disable/enable QoS
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, wey-yi.w.guy@intel.com
In-Reply-To: <1269621992-5034-1-git-send-email-sgruszka@redhat.com>
References: <1269621992-5034-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 10:26:03 -0700
Message-ID: <1269624363.4342.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 17:46 +0100, Stanislaw Gruszka wrote:

> + * QIEEE80211_CONF_QOS: Enable 802.11e QoS also know as WMM (Wireless
      ^ typo

> +
> +	/* activate new settings */
> +	if (wmm_on)
> +		local->hw.conf.flags |=	IEEE80211_CONF_QOS;
> +	else
> +		local->hw.conf.flags &=	~IEEE80211_CONF_QOS;
> +
> +	drv_config(local, IEEE80211_CONF_CHANGE_QOS);

Ok, fair enough, we need to think this through in the multi-vif case
anyway.
 
>  void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
> @@ -816,7 +824,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
>  	else
>  		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
>  
> -	ieee80211_set_wmm_default(sdata);
> +	ieee80211_set_wmm_default(sdata, true);

Shouldn't that be false though?

johannes

