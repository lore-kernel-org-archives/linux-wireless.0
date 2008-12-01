Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18967 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbYLAUwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 15:52:07 -0500
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>, dcbw@redhat.com
Subject: Re: [PATCH] mac80211: deauth when interface is marked down
References: <1228161724-19771-1-git-send-email-linville@tuxdriver.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 01 Dec 2008 22:51:14 +0200
In-Reply-To: <1228161724-19771-1-git-send-email-linville@tuxdriver.com> (ext John W. Linville's message of "Mon\,  1 Dec 2008 15\:02\:04 -0500")
Message-ID: <87d4gbbovx.fsf@nokia.com> (sfid-20081201_215213_371875_C76BA5DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville <linville@tuxdriver.com> writes:

> It seems like proper etiquette to let other stations know when we are
> going down in either STA or IBSS mode.  This also notifies userland, so
> wpa_supplicant doesn't get confused.

I noticed a problem while I was testing my dynamic power save patches,
power save settings were not correctly sent to the driver because
ieee80211_stop() didn't notify mlme. I think this patch will fix this
but I didn't test it, yet.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/iface.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 4608212..b557250 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -435,6 +435,9 @@ static int ieee80211_stop(struct net_device *dev)
>  		break;
>  	case NL80211_IFTYPE_STATION:
>  	case NL80211_IFTYPE_ADHOC:
> +		/* Announce that we are leaving the network. */
> +		ieee80211_sta_deauthenticate(dev, WLAN_REASON_DEAUTH_LEAVING);
> +
>  		sdata->u.sta.state = IEEE80211_STA_MLME_DISABLED;

I think manually setting u.sta.state can be removed now because
ieee80211_sta_deauthenticate() calls ieee80211_set_disassoc() which
again has this:

	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT)
		ifsta->state = IEEE80211_STA_MLME_DISABLED;

-- 
Kalle Valo
