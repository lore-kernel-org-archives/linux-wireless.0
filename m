Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41431 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751425AbcKIHvX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 02:51:23 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        "security@kernel.org" <security@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] mwifiex: printk() overflow with 32-byte SSIDs
Date: Wed, 9 Nov 2016 07:51:18 +0000
Message-ID: <7f1fea03d4034bb1b8b6984de06e7ced@SC-EXCH04.marvell.com> (sfid-20161109_085127_711112_99944A35)
References: <1478658504-31045-1-git-send-email-briannorris@chromium.org>
In-Reply-To: <1478658504-31045-1-git-send-email-briannorris@chromium.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Wednesday, November 09, 2016 7:58 AM
> To: Amitkumar Karwar; Nishant Sarmukadam; Kalle Valo
> Cc: linux-kernel@vger.kernel.org; linux-wireless@vger.kernel.org; Cathy
> Luo; security@kernel.org; stable@vger.kernel.org; Brian Norris
> Subject: [PATCH] mwifiex: printk() overflow with 32-byte SSIDs
> 
> SSIDs aren't guaranteed to be 0-terminated. Let's cap the max length
> when we print them out.
> 
> This can be easily noticed by connecting to a network with a 32-octet
> SSID:
> 
> [ 3903.502925] mwifiex_pcie 0000:01:00.0: info: trying to associate to
> '0123456789abcdef0123456789abcdef <uninitialized mem>' bssid
> xx:xx:xx:xx:xx:xx
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell
> mwifiex driver")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index 39ce76ad00bc..16241d21727b 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -2222,8 +2222,9 @@ mwifiex_cfg80211_assoc(struct mwifiex_private
> *priv, size_t ssid_len,
>  			is_scanning_required = 1;
>  		} else {
>  			mwifiex_dbg(priv->adapter, MSG,
> -				    "info: trying to associate to '%s' bssid
> %pM\n",
> -				    (char *)req_ssid.ssid, bss->bssid);
> +				    "info: trying to associate to '%.*s' bssid
> %pM\n",
> +				    req_ssid.ssid_len, (char *)req_ssid.ssid,
> +				    bss->bssid);
>  			memcpy(&priv->cfg_bssid, bss->bssid, ETH_ALEN);
>  			break;
>  		}
> @@ -2283,8 +2284,8 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy,
> struct net_device *dev,
>  	}
> 
>  	mwifiex_dbg(adapter, INFO,
> -		    "info: Trying to associate to %s and bssid %pM\n",
> -		    (char *)sme->ssid, sme->bssid);
> +		    "info: Trying to associate to %.*s and bssid %pM\n",
> +		    (int)sme->ssid_len, (char *)sme->ssid, sme->bssid);
> 
>  	if (!mwifiex_stop_bg_scan(priv))
>  		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy);
> @@ -2417,8 +2418,8 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy,
> struct net_device *dev,
>  	}
> 
>  	mwifiex_dbg(priv->adapter, MSG,
> -		    "info: trying to join to %s and bssid %pM\n",
> -		    (char *)params->ssid, params->bssid);
> +		    "info: trying to join to %.*s and bssid %pM\n",
> +		    params->ssid_len, (char *)params->ssid, params->bssid);
> 
>  	mwifiex_set_ibss_params(priv, params);
> 
> --
> 2.8.0.rc3.226.g39d4020

Thanks for fixing this.

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
