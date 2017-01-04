Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38906 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757498AbdADPkh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 10:40:37 -0500
Message-ID: <1483544433.7312.13.camel@sipsolutions.net> (sfid-20170104_164040_614627_E85CD4F9)
Subject: Re: [PATCH v4] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 04 Jan 2017 16:40:33 +0100
In-Reply-To: <20161218002554.6362-1-andrew.zaborowski@intel.com> (sfid-20161218_013029_456399_B1802872)
References: <20161218002554.6362-1-andrew.zaborowski@intel.com>
         (sfid-20161218_013029_456399_B1802872)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/net/wireless/mlme.c
> @@ -340,6 +340,8 @@ int cfg80211_mlme_deauth(struct
> cfg80211_registered_device *rdev,
>  
>  	ASSERT_WDEV_LOCK(wdev);
>  
> +	wdev->conn_owner_nlportid = 0;

Is this really correct? The deauth might not be to the current_bss, as
you can see in the following if statement:

>  	if (local_state_change &&
>  	    (!wdev->current_bss ||
>  	     !ether_addr_equal(wdev->current_bss->pub.bssid, bssid)))

It seems that perhaps this should go into some other place, perhaps
only be reset when current_bss is also reset to NULL?

> @@ -14539,13 +14554,21 @@ static int nl80211_netlink_notify(struct
> notifier_block * nb,
>  				spin_unlock(&rdev-
> >destroy_list_lock);
>  				schedule_work(&rdev->destroy_work);
>  			}
> -		} else if (schedule_scan_stop) {
> +
> +			continue;
> +		}

This also doesn't seem right - the same socket could possibly own both
an interface and a connection? If the connection is on the same
interface you might not really want to do both - though it shouldn't
hurt if all the cancel_work is in the right place - but it could be a
different interface?

johannes
