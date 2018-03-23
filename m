Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50080 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbeCWNWz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 09:22:55 -0400
Message-ID: <1521811372.11491.3.camel@sipsolutions.net> (sfid-20180323_142258_713223_3A02DFFB)
Subject: Re: [PATCHv4 2/3] mac80211: enable setting cqm rssi config for AP
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Date: Fri, 23 Mar 2018 14:22:52 +0100
In-Reply-To: <1519544998-2621-3-git-send-email-tamizhr@codeaurora.org> (sfid-20180225_085011_885309_75C5EC6D)
References: <1519544998-2621-1-git-send-email-tamizhr@codeaurora.org>
         <1519544998-2621-3-git-send-email-tamizhr@codeaurora.org>
         (sfid-20180225_085011_885309_75C5EC6D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  
> +static void ieee80211_update_rssi_config(struct
> ieee80211_sub_if_data *sdata)
> +{
> +	if (!(sdata->vif.driver_flags &
> IEEE80211_VIF_SUPPORTS_CQM_RSSI))
> +		return;
> +
> +	/* tell the driver upon association, unless already
> associated */
> +	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
> +	    !sdata->u.mgd.associated)
> +		return;
> +
> +	/* if AP, always tell the driver by checking beacon status
> */
> +	if (!sdata->vif.bss_conf.enable_beacon ||
> +	    !wiphy_ext_feature_isset(sdata->local->hw.wiphy,
> +				NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_
> CONFIG))
> +		return;

This probably should check for AP mode as well - not sure we use
enable_beacon for e.g. IBSS but I guess we could.

johannes
