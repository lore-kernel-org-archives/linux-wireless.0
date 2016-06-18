Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37774 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbcFRTca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2016 15:32:30 -0400
Received: by mail-wm0-f49.google.com with SMTP id a66so28447560wme.0
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2016 12:32:30 -0700 (PDT)
Subject: Re: [PATCH RFC 2/2] brcmfmac: support removing AP interfaces with
 "interface_remove"
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1466273932-11554-1-git-send-email-zajec5@gmail.com>
 <1466273932-11554-2-git-send-email-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list.pdl@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5765A1CB.9060700@broadcom.com> (sfid-20160618_213310_982873_7A9927A2)
Date: Sat, 18 Jun 2016 21:32:27 +0200
MIME-Version: 1.0
In-Reply-To: <1466273932-11554-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-06-16 20:18, Rafał Miłecki wrote:
> New firmwares (e.g. 10.10.69.36 for BCM4366) support "interface_remove"
> for removing interfaces. Try to use this method on cfg80211 request. In
> case of older firmwares (e.g. 7.35.177.56 for BCM43602 as I tested) this
> will just result in firmware rejecting command and this won't change any
> behavior.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 37 +++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 502b0a0..aff76c2 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -785,12 +785,46 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
>  	return err;
>  }
>  
> +static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
> +				       struct wireless_dev *wdev)
> +{
> +	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
> +	struct net_device *ndev = wdev->netdev;
> +	struct brcmf_if *ifp = netdev_priv(ndev);
> +	int ret;
> +	int err;
> +
> +	brcmf_cfg80211_arm_vif_event(cfg, ifp->vif);
> +
> +	err = brcmf_fil_bsscfg_data_set(ifp, "interface_remove", NULL, 0);
> +	if (err) {
> +		brcmf_err("interface_remove failed %d\n", err);
> +		goto err_unarm;
> +	}
> +
> +	/* wait for firmware event */
> +	ret = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_DEL,
> +					    BRCMF_VIF_EVENT_TIMEOUT);
> +	if (!ret) {
> +		brcmf_err("timeout occurred\n");
> +		err = -EIO;
> +		goto err_unarm;
> +	}
> +
> +err_unarm:
> +	brcmf_cfg80211_arm_vif_event(cfg, NULL);
> +	return err;
> +}
> +
>  static
>  int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
>  {
>  	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
>  	struct net_device *ndev = wdev->netdev;
>  
> +	if (ndev == cfg_to_ndev(cfg))

ndev can be NULL, ie. for IFTYPE_P2P_DEVICE.

Regards,
Arend

> +		return -ENOTSUPP;
> +
>  	/* vif event pending in firmware */
>  	if (brcmf_cfg80211_vif_event_armed(cfg))
>  		return -EBUSY;
> @@ -807,12 +841,13 @@ int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
>  	switch (wdev->iftype) {
>  	case NL80211_IFTYPE_ADHOC:
>  	case NL80211_IFTYPE_STATION:
> -	case NL80211_IFTYPE_AP:
>  	case NL80211_IFTYPE_AP_VLAN:
>  	case NL80211_IFTYPE_WDS:
>  	case NL80211_IFTYPE_MONITOR:
>  	case NL80211_IFTYPE_MESH_POINT:
>  		return -EOPNOTSUPP;
> +	case NL80211_IFTYPE_AP:
> +		return brcmf_cfg80211_del_ap_iface(wiphy, wdev);
>  	case NL80211_IFTYPE_P2P_CLIENT:
>  	case NL80211_IFTYPE_P2P_GO:
>  	case NL80211_IFTYPE_P2P_DEVICE:
> 
