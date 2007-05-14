Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47522 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754308AbXENRFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 13:05:48 -0400
Date: Mon, 14 May 2007 19:05:45 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH V5] mac80211: Add support for SIOCGIWRATE ioctl to  provide rate information
Message-ID: <20070514190545.39ba42e7@griffin.suse.cz>
In-Reply-To: <46436a83.ryrsLlZyRAF/iwC6%Larry.Finger@lwfinger.net>
References: <46436a83.ryrsLlZyRAF/iwC6%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 10 May 2007 13:54:59 -0500, Larry Finger wrote:
> +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	if (sdata->type == IEEE80211_IF_TYPE_STA ||
> +	    sdata->type == IEEE80211_IF_TYPE_IBSS)
> +		sta = sta_info_get(local, sdata->u.sta.bssid);

Quoting Michael's comment about V3 version of your patch:

> Also, this function is safe in adhoc mode.. but it most likely won't do
> anything useful since all the sta entries have different addresses and
> it is likely that none of them are the same as the one in
> sdata->u.sta.bssid.

Do you have some reason for implementing this function for IBSS mode?
If not, could you return -EOPNOTSUPP in IBSS mode?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
