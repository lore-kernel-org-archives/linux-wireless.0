Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:39657 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817Ab3FFMs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 08:48:56 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kirshenbaum Erez <erezk@wilocity.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wil6210: Fix AP/PCP start flow
Date: Thu, 6 Jun 2013 15:48:52 +0300
Message-ID: <1851236.sMbJgcI0xu@lx-vladimir> (sfid-20130606_144901_206120_8D01E4DF)
In-Reply-To: <1370507740-9178-1-git-send-email-erezk@wilocity.com>
References: <1370507740-9178-1-git-send-email-erezk@wilocity.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, June 06, 2013 11:35:40 AM Kirshenbaum Erez wrote:
> 

Please, provide explanation - what is motivation for the change,
what was wrong, why do you need this change etc.
Good comment is essential.

> Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
> ---
>  drivers/net/wireless/ath/wil6210/main.c | 35 ---------------------------------
>  1 file changed, 35 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
> index c97b864..271ee22 100644
> --- a/drivers/net/wireless/ath/wil6210/main.c
> +++ b/drivers/net/wireless/ath/wil6210/main.c
> @@ -286,41 +286,31 @@ static int __wil_up(struct wil6210_priv *wil)
>  {
>  	struct net_device *ndev = wil_to_ndev(wil);
>  	struct wireless_dev *wdev = wil->wdev;
> -	struct ieee80211_channel *channel = wdev->preset_chandef.chan;
>  	int rc;
> -	int bi;
> -	u16 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
>  
>  	rc = wil_reset(wil);
>  	if (rc)
>  		return rc;
>  
> -	/* FIXME Firmware works now in PBSS mode(ToDS=0, FromDS=0) */
> -	wmi_nettype = wil_iftype_nl2wmi(NL80211_IFTYPE_ADHOC);
>  	switch (wdev->iftype) {
>  	case NL80211_IFTYPE_STATION:
>  		wil_dbg_misc(wil, "type: STATION\n");
> -		bi = 0;
>  		ndev->type = ARPHRD_ETHER;
>  		break;
>  	case NL80211_IFTYPE_AP:
>  		wil_dbg_misc(wil, "type: AP\n");
> -		bi = 100;
>  		ndev->type = ARPHRD_ETHER;
>  		break;
>  	case NL80211_IFTYPE_P2P_CLIENT:
>  		wil_dbg_misc(wil, "type: P2P_CLIENT\n");
> -		bi = 0;
>  		ndev->type = ARPHRD_ETHER;
>  		break;
>  	case NL80211_IFTYPE_P2P_GO:
>  		wil_dbg_misc(wil, "type: P2P_GO\n");
> -		bi = 100;
>  		ndev->type = ARPHRD_ETHER;
>  		break;
>  	case NL80211_IFTYPE_MONITOR:
>  		wil_dbg_misc(wil, "type: Monitor\n");
> -		bi = 0;
>  		ndev->type = ARPHRD_IEEE80211_RADIOTAP;
>  		/* ARPHRD_IEEE80211 or ARPHRD_IEEE80211_RADIOTAP ? */
>  		break;
> @@ -328,34 +318,9 @@ static int __wil_up(struct wil6210_priv *wil)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	/* Apply profile in the following order: */
> -	/* SSID and channel for the AP */
> -	switch (wdev->iftype) {
> -	case NL80211_IFTYPE_AP:
> -	case NL80211_IFTYPE_P2P_GO:
> -		if (wdev->ssid_len == 0) {
> -			wil_err(wil, "SSID not set\n");
> -			return -EINVAL;
> -		}
> -		rc = wmi_set_ssid(wil, wdev->ssid_len, wdev->ssid);
> -		if (rc)
> -			return rc;
> -		break;
> -	default:
> -		break;
> -	}
> -
>  	/* MAC address - pre-requisite for other commands */
>  	wmi_set_mac_address(wil, ndev->dev_addr);
>  
> -	/* Set up beaconing if required. */
> -	if (bi > 0) {
> -		rc = wmi_pcp_start(wil, bi, wmi_nettype,
> -				   (channel ? channel->hw_value : 0));
> -		if (rc)
> -			return rc;
> -	}
> -
>  	/* Rx VRING. After MAC and beacon */
>  	wil_rx_init(wil);
>  
> 
>From what I see in the code, you want not start AP through netdev open()
but want to keep NL80211_IFTYPE_AP and NL80211_IFTYPE_P2P_GO to be OK,
doing nothing. I agree that AP should be started via start_ap() instead, as
it is the way to pass all parameters like IE's and security.
What I want so see is why not return -EOPNOTSUPP for AP/P2P_GO?

Thanks, Vladimir

