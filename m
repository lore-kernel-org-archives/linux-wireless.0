Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57214 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbeANWku (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Jan 2018 17:40:50 -0500
Message-ID: <1515969647.26804.33.camel@sipsolutions.net> (sfid-20180114_234108_094387_D2CBE21E)
Subject: Re: [PATCH v2] nl80211: take RCU read lock when calling
 ieee80211_bss_get_ie()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: regressions@leemhuis.info, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 14 Jan 2018 23:40:47 +0100
In-Reply-To: <20180114222255.GA9036@light.dominikbrodowski.net>
References: <20171222072012.GA3110@light.dominikbrodowski.net>
         <20171230131132.GA2624@light.dominikbrodowski.net>
         <20180108100403.GA4715@light.dominikbrodowski.net>
         <20180114180338.GA1569@light.dominikbrodowski.net>
         <1515967102.26804.31.camel@sipsolutions.net>
         <20180114222255.GA9036@light.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-01-14 at 23:22 +0100, Dominik Brodowski wrote:
> 
> +		rcu_read_lock();
>  		ssid_ie = ieee80211_bss_get_ie(&wdev->current_bss->pub,
>  					       WLAN_EID_SSID);
>  		if (!ssid_ie)
> -			break;

nit-picking now: that "break" here may have been easier before these
changes

> +			goto nla_rcu_unlock;
>  		if (nla_put(msg, NL80211_ATTR_SSID, ssid_ie[1], ssid_ie + 2))
> -			goto nla_put_failure_locked;
> +			goto nla_put_failure_rcu_locked;
> + nla_rcu_unlock:
> +		rcu_read_unlock();
>  		break;

but after, perhaps it's easier to just do

		if (ssid_ie &&
		    nla_put(...)
			goto nla_put_failure_rcu_locked;

and avoid the extra label (but yeah, it's getting late)

johannes
