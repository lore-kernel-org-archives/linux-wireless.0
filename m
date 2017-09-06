Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52808 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753484AbdIFMsi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 08:48:38 -0400
Message-ID: <1504702115.13457.16.camel@sipsolutions.net> (sfid-20170906_144854_264235_DD6F357A)
Subject: Re: hung task in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <sbrivio@redhat.com>,
        Matteo Croce <mcroce@redhat.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Sep 2017 14:48:35 +0200
In-Reply-To: <20170906144019.1c98a636@elisabeth> (sfid-20170906_144115_600908_441D9559)
References: <CAGnkfhwi9MmtLneeU23iWEGLj9cb1ODb3KzzOqTDvA6nNVsugg@mail.gmail.com>
         <20170906144019.1c98a636@elisabeth> (sfid-20170906_144115_600908_441D9559)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'll look in a bit - but

> +			mutex_unlock(&sta->ampdu_mlme.mtx);
>  			___ieee80211_stop_rx_ba_session(
>  				sta, tid, WLAN_BACK_RECIPIENT,
>  				WLAN_REASON_QSTA_TIMEOUT, true);

This already has three underscores so shouldn't drop.

> 
> +			mutex_unlock(&sta->ampdu_mlme.mtx);
>  			___ieee80211_stop_rx_ba_session(

ditto

> +			mutex_unlock(&sta->ampdu_mlme.mtx);
>  			__ieee80211_start_rx_ba_session(sta, 0, 0,
> 0, 1, tid,

maybe this one needs a ___ version then?

> +			mutex_unlock(&sta->ampdu_mlme.mtx);
>  			___ieee80211_stop_rx_ba_session(
> 
already ___

I'm surprised nobody saw this before - though perhaps Sebastian's
useless report is the same.

johannes
