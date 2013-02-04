Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3BDPtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:49:43 -0500
Message-ID: <1359993002.10311.29.camel@jlt4.sipsolutions.net> (sfid-20130204_164947_284261_45D3B998)
Subject: Re: [PATCH] cfg80211: pass wiphy to cfg80211_ref_bss/put_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Mon, 04 Feb 2013 16:50:02 +0100
In-Reply-To: <1359992842-14660-1-git-send-email-johannes@sipsolutions.net> (sfid-20130204_164706_960708_BA11AF9A)
References: <1359992842-14660-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130204_164706_960708_BA11AF9A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 16:47 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This prepares for using the spinlock instead of krefs
> which is needed in the next patch to track the refs
> of combined BSSes correctly.

The "next patch" was "cfg80211: track hidden SSID networks properly", I
just forgot to send out this patch. Also clearly forgot to Cc all the
maintainers, fixing (and keeping the patch below for them)

johannes

> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c            |  4 ++--
>  drivers/net/wireless/ath/ath6kl/wmi.c                 |  2 +-
>  drivers/net/wireless/ath/wil6210/cfg80211.c           |  2 +-
>  drivers/net/wireless/ath/wil6210/wmi.c                |  2 +-
>  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |  4 ++--
>  drivers/net/wireless/libertas/cfg.c                   |  8 ++++----
>  drivers/net/wireless/mwifiex/cfg80211.c               |  2 +-
>  drivers/net/wireless/mwifiex/scan.c                   |  2 +-
>  drivers/net/wireless/mwifiex/sta_ioctl.c              |  4 ++--
>  drivers/net/wireless/orinoco/scan.c                   |  4 ++--
>  drivers/net/wireless/rndis_wlan.c                     |  4 ++--
>  drivers/staging/wlan-ng/cfg80211.c                    |  2 +-
>  include/net/cfg80211.h                                |  6 ++++--
>  net/mac80211/ibss.c                                   |  4 ++--
>  net/mac80211/mlme.c                                   |  6 +++---
>  net/mac80211/scan.c                                   |  3 ++-
>  net/wireless/core.c                                   |  2 +-
>  net/wireless/ibss.c                                   |  4 ++--
>  net/wireless/mlme.c                                   | 14 +++++++-------
>  net/wireless/scan.c                                   |  4 ++--
>  net/wireless/sme.c                                    | 16 ++++++++--------
>  21 files changed, 51 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index 4225cca..a7fb442 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -767,7 +767,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
>  		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "ad-hoc %s selected\n",
>  			   nw_type & ADHOC_CREATOR ? "creator" : "joiner");
>  		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(ar->wiphy, bss);
>  		return;
>  	}
>  
> @@ -778,7 +778,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
>  					assoc_req_ie, assoc_req_len,
>  					assoc_resp_ie, assoc_resp_len,
>  					WLAN_STATUS_SUCCESS, GFP_KERNEL);
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(ar->wiphy, bss);
>  	} else if (vif->sme_state == SME_CONNECTED) {
>  		/* inform roam event to cfg80211 */
>  		cfg80211_roamed_bss(vif->ndev, bss, assoc_req_ie, assoc_req_len,
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index 998f8b0..d366cf1 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -1108,7 +1108,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
>  	kfree(mgmt);
>  	if (bss == NULL)
>  		return -ENOMEM;
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(ar->wiphy, bss);
>  
>  	/*
>  	 * Firmware doesn't return any event when scheduled scan has
> diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
> index 116f4e8..238cb6c 100644
> --- a/drivers/net/wireless/ath/wil6210/cfg80211.c
> +++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
> @@ -342,7 +342,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
>  	}
>  
>   out:
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(wiphy, bss);
>  
>  	return rc;
>  }
> diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
> index 12915f6..f64d210 100644
> --- a/drivers/net/wireless/ath/wil6210/wmi.c
> +++ b/drivers/net/wireless/ath/wil6210/wmi.c
> @@ -337,7 +337,7 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
>  		if (bss) {
>  			wil_dbg_WMI(wil, "Added BSS %pM\n",
>  				    rx_mgmt_frame->bssid);
> -			cfg80211_put_bss(bss);
> +			cfg80211_put_bss(wiphy, bss);
>  		} else {
>  			wil_err(wil, "cfg80211_inform_bss() failed\n");
>  		}
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> index 62a528e..95a4237 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> @@ -2060,7 +2060,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
>  	if (!bss)
>  		return -ENOMEM;
>  
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(wiphy, bss);
>  
>  	return err;
>  }
> @@ -2166,7 +2166,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
>  		goto CleanUp;
>  	}
>  
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(wiphy, bss);
>  
>  CleanUp:
>  
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 230f8eb..61735db 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -657,7 +657,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
>  					capa, intvl, ie, ielen,
>  					LBS_SCAN_RSSI_TO_MBM(rssi),
>  					GFP_KERNEL);
> -				cfg80211_put_bss(bss);
> +				cfg80211_put_bss(wiphy, bss);
>  			}
>  		} else
>  			lbs_deb_scan("scan response: missing BSS channel IE\n");
> @@ -1444,7 +1444,7 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
>  
>   done:
>  	if (bss)
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(wiphy, bss);
>  	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
>  	return ret;
>  }
> @@ -1766,7 +1766,7 @@ static void lbs_join_post(struct lbs_private *priv,
>  				  params->beacon_interval,
>  				  fake_ie, fake - fake_ie,
>  				  0, GFP_KERNEL);
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(priv->wdev->wiphy, bss);
>  
>  	memcpy(priv->wdev->ssid, params->ssid, params->ssid_len);
>  	priv->wdev->ssid_len = params->ssid_len;
> @@ -2011,7 +2011,7 @@ static int lbs_join_ibss(struct wiphy *wiphy, struct net_device *dev,
>  
>  	if (bss) {
>  		ret = lbs_ibss_join_existing(priv, params, bss);
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(wiphy, bss);
>  	} else
>  		ret = lbs_ibss_start_new(priv, params);
>  
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index 3a004b8..81c84a2 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -1430,7 +1430,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
>  	bss = cfg80211_inform_bss(priv->wdev->wiphy, chan,
>  				  bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
>  				  0, ie_buf, ie_len, 0, GFP_KERNEL);
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(priv->wdev->wiphy, bss);
>  	memcpy(priv->cfg_bssid, bss_info.bssid, ETH_ALEN);
>  
>  	return 0;
> diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
> index 9189a32..2324924 100644
> --- a/drivers/net/wireless/mwifiex/scan.c
> +++ b/drivers/net/wireless/mwifiex/scan.c
> @@ -1746,7 +1746,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
>  					    .mac_address, ETH_ALEN))
>  					mwifiex_update_curr_bss_params(priv,
>  								       bss);
> -				cfg80211_put_bss(bss);
> +				cfg80211_put_bss(priv->wdev->wiphy, bss);
>  			}
>  		} else {
>  			dev_dbg(adapter->dev, "missing BSS channel IE\n");
> diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
> index f542bb8..ee85b41 100644
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -324,7 +324,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
>  		}
>  
>  		if (bss)
> -			cfg80211_put_bss(bss);
> +			cfg80211_put_bss(priv->adapter->wiphy, bss);
>  	} else {
>  		/* Adhoc mode */
>  		/* If the requested SSID matches current SSID, return */
> @@ -354,7 +354,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
>  							" list. Joining...\n");
>  			ret = mwifiex_adhoc_join(priv, bss_desc);
>  			if (bss)
> -				cfg80211_put_bss(bss);
> +				cfg80211_put_bss(priv->adapter->wiphy, bss);
>  		} else {
>  			dev_dbg(adapter->dev, "info: Network not found in "
>  				"the list, creating adhoc with ssid = %s\n",
> diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
> index 96e39ed..e8c5714 100644
> --- a/drivers/net/wireless/orinoco/scan.c
> +++ b/drivers/net/wireless/orinoco/scan.c
> @@ -125,7 +125,7 @@ static void orinoco_add_hostscan_result(struct orinoco_private *priv,
>  	cbss = cfg80211_inform_bss(wiphy, channel, bss->a.bssid, timestamp,
>  				   capability, beacon_interval, ie_buf, ie_len,
>  				   signal, GFP_KERNEL);
> -	cfg80211_put_bss(cbss);
> +	cfg80211_put_bss(wiphy, cbss);
>  }
>  
>  void orinoco_add_extscan_result(struct orinoco_private *priv,
> @@ -158,7 +158,7 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
>  	cbss = cfg80211_inform_bss(wiphy, channel, bss->bssid, timestamp,
>  				   capability, beacon_interval, ie, ie_len,
>  				   signal, GFP_KERNEL);
> -	cfg80211_put_bss(cbss);
> +	cfg80211_put_bss(wiphy, cbss);
>  }
>  
>  void orinoco_add_hostscan_results(struct orinoco_private *priv,
> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
> index abe1d03..fe2f272 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -2029,7 +2029,7 @@ static bool rndis_bss_info_update(struct usbnet *usbdev,
>  	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid->mac,
>  		timestamp, capability, beacon_interval, ie, ie_len, signal,
>  		GFP_KERNEL);
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(priv->wdev.wiphy, bss);
>  
>  	return (bss != NULL);
>  }
> @@ -2718,7 +2718,7 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
>  	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid,
>  		timestamp, capability, beacon_period, ie_buf, ie_len,
>  		signal, GFP_KERNEL);
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(priv->wdev.wiphy, bss);
>  }
>  
>  /*
> diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
> index 18c06a5..a233f64 100644
> --- a/drivers/staging/wlan-ng/cfg80211.c
> +++ b/drivers/staging/wlan-ng/cfg80211.c
> @@ -424,7 +424,7 @@ int prism2_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
>  			goto exit;
>  		}
>  
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(wiphy, bss);
>  	}
>  
>  	if (result)
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 378adb4..c761c1c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3178,19 +3178,21 @@ cfg80211_get_ibss(struct wiphy *wiphy,
>  
>  /**
>   * cfg80211_ref_bss - reference BSS struct
> + * @wiphy: the wiphy this BSS struct belongs to
>   * @bss: the BSS struct to reference
>   *
>   * Increments the refcount of the given BSS struct.
>   */
> -void cfg80211_ref_bss(struct cfg80211_bss *bss);
> +void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
>  
>  /**
>   * cfg80211_put_bss - unref BSS struct
> + * @wiphy: the wiphy this BSS struct belongs to
>   * @bss: the BSS struct
>   *
>   * Decrements the refcount of the given BSS struct.
>   */
> -void cfg80211_put_bss(struct cfg80211_bss *bss);
> +void cfg80211_put_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
>  
>  /**
>   * cfg80211_unlink_bss - unlink BSS from internal data structures
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index a54c824..71c55cc 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -228,7 +228,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  
>  	bss = cfg80211_inform_bss_frame(local->hw.wiphy, chan,
>  					mgmt, skb->len, 0, GFP_KERNEL);
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(local->hw.wiphy, bss);
>  	netif_carrier_on(sdata->dev);
>  	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
>  }
> @@ -1159,7 +1159,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
>  
>  		if (cbss) {
>  			cfg80211_unlink_bss(local->hw.wiphy, cbss);
> -			cfg80211_put_bss(cbss);
> +			cfg80211_put_bss(local->hw.wiphy, cbss);
>  		}
>  	}
>  
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 636efe9..396a740 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1933,7 +1933,7 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
>  		ieee80211_vif_release_channel(sdata);
>  	}
>  
> -	cfg80211_put_bss(auth_data->bss);
> +	cfg80211_put_bss(sdata->local->hw.wiphy, auth_data->bss);
>  	kfree(auth_data);
>  	sdata->u.mgd.auth_data = NULL;
>  }
> @@ -2386,7 +2386,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
>  		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
>  			/* oops -- internal error -- send timeout for now */
>  			ieee80211_destroy_assoc_data(sdata, false);
> -			cfg80211_put_bss(*bss);
> +			cfg80211_put_bss(sdata->local->hw.wiphy, *bss);
>  			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
>  		}
>  		sdata_info(sdata, "associated\n");
> @@ -3857,7 +3857,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>  	}
>  
>  	/* hold our own reference */
> -	cfg80211_ref_bss(auth_data->bss);
> +	cfg80211_ref_bss(local->hw.wiphy, auth_data->bss);
>  	err = 0;
>  	goto out_unlock;
>  
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 7f80f0a..400153f 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -34,7 +34,8 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
>  {
>  	if (!bss)
>  		return;
> -	cfg80211_put_bss(container_of((void *)bss, struct cfg80211_bss, priv));
> +	cfg80211_put_bss(local->hw.wiphy,
> +			 container_of((void *)bss, struct cfg80211_bss, priv));
>  }
>  
>  static bool is_uapsd_supported(struct ieee802_11_elems *elems)
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 3b85d0c..d915376 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -716,7 +716,7 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
>  		kfree(reg);
>  	}
>  	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
> -		cfg80211_put_bss(&scan->pub);
> +		cfg80211_put_bss(&rdev->wiphy, &scan->pub);
>  	kfree(rdev);
>  }
>  
> diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
> index 9b9551e..d80e471 100644
> --- a/net/wireless/ibss.c
> +++ b/net/wireless/ibss.c
> @@ -37,7 +37,7 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid)
>  
>  	if (wdev->current_bss) {
>  		cfg80211_unhold_bss(wdev->current_bss);
> -		cfg80211_put_bss(&wdev->current_bss->pub);
> +		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
>  	}
>  
>  	cfg80211_hold_bss(bss_from_pub(bss));
> @@ -182,7 +182,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
>  
>  	if (wdev->current_bss) {
>  		cfg80211_unhold_bss(wdev->current_bss);
> -		cfg80211_put_bss(&wdev->current_bss->pub);
> +		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
>  	}
>  
>  	wdev->current_bss = NULL;
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index fee9bf7..8e69207 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -58,7 +58,7 @@ void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
>  	 */
>  	if (status_code != WLAN_STATUS_SUCCESS && wdev->conn &&
>  	    cfg80211_sme_failed_reassoc(wdev)) {
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(wiphy, bss);
>  		goto out;
>  	}
>  
> @@ -70,7 +70,7 @@ void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
>  		 * do not call connect_result() now because the
>  		 * sme will schedule work that does it later.
>  		 */
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(wiphy, bss);
>  		goto out;
>  	}
>  
> @@ -108,7 +108,7 @@ void __cfg80211_send_deauth(struct net_device *dev,
>  	if (wdev->current_bss &&
>  	    ether_addr_equal(wdev->current_bss->pub.bssid, bssid)) {
>  		cfg80211_unhold_bss(wdev->current_bss);
> -		cfg80211_put_bss(&wdev->current_bss->pub);
> +		cfg80211_put_bss(wiphy, &wdev->current_bss->pub);
>  		wdev->current_bss = NULL;
>  		was_current = true;
>  	}
> @@ -164,7 +164,7 @@ void __cfg80211_send_disassoc(struct net_device *dev,
>  	    ether_addr_equal(wdev->current_bss->pub.bssid, bssid)) {
>  		cfg80211_sme_disassoc(dev, wdev->current_bss);
>  		cfg80211_unhold_bss(wdev->current_bss);
> -		cfg80211_put_bss(&wdev->current_bss->pub);
> +		cfg80211_put_bss(wiphy, &wdev->current_bss->pub);
>  		wdev->current_bss = NULL;
>  	} else
>  		WARN_ON(1);
> @@ -324,7 +324,7 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
>  	err = rdev_auth(rdev, dev, &req);
>  
>  out:
> -	cfg80211_put_bss(req.bss);
> +	cfg80211_put_bss(&rdev->wiphy, req.bss);
>  	return err;
>  }
>  
> @@ -432,7 +432,7 @@ out:
>  	if (err) {
>  		if (was_connected)
>  			wdev->sme_state = CFG80211_SME_CONNECTED;
> -		cfg80211_put_bss(req.bss);
> +		cfg80211_put_bss(&rdev->wiphy, req.bss);
>  	}
>  
>  	return err;
> @@ -572,7 +572,7 @@ void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
>  
>  	if (wdev->current_bss) {
>  		cfg80211_unhold_bss(wdev->current_bss);
> -		cfg80211_put_bss(&wdev->current_bss->pub);
> +		cfg80211_put_bss(&rdev->wiphy, &wdev->current_bss->pub);
>  		wdev->current_bss = NULL;
>  	}
>  }
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 36daacb..dacb44a 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -818,7 +818,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
>  }
>  EXPORT_SYMBOL(cfg80211_inform_bss_frame);
>  
> -void cfg80211_ref_bss(struct cfg80211_bss *pub)
> +void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
>  {
>  	struct cfg80211_internal_bss *bss;
>  
> @@ -830,7 +830,7 @@ void cfg80211_ref_bss(struct cfg80211_bss *pub)
>  }
>  EXPORT_SYMBOL(cfg80211_ref_bss);
>  
> -void cfg80211_put_bss(struct cfg80211_bss *pub)
> +void cfg80211_put_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
>  {
>  	struct cfg80211_internal_bss *bss;
>  
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index a825dfe..f432bd3 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -301,7 +301,7 @@ static void __cfg80211_sme_scan_done(struct net_device *dev)
>  
>  	bss = cfg80211_get_conn_bss(wdev);
>  	if (bss) {
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(&rdev->wiphy, bss);
>  	} else {
>  		/* not found */
>  		if (wdev->conn->state == CFG80211_CONN_SCAN_AGAIN)
> @@ -464,7 +464,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>  
>  	if (wdev->current_bss) {
>  		cfg80211_unhold_bss(wdev->current_bss);
> -		cfg80211_put_bss(&wdev->current_bss->pub);
> +		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
>  		wdev->current_bss = NULL;
>  	}
>  
> @@ -480,7 +480,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>  		kfree(wdev->connect_keys);
>  		wdev->connect_keys = NULL;
>  		wdev->ssid_len = 0;
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(wdev->wiphy, bss);
>  		return;
>  	}
>  
> @@ -586,7 +586,7 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
>  	}
>  
>  	cfg80211_unhold_bss(wdev->current_bss);
> -	cfg80211_put_bss(&wdev->current_bss->pub);
> +	cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
>  	wdev->current_bss = NULL;
>  
>  	cfg80211_hold_bss(bss_from_pub(bss));
> @@ -621,7 +621,7 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
>  
>  	return;
>  out:
> -	cfg80211_put_bss(bss);
> +	cfg80211_put_bss(wdev->wiphy, bss);
>  }
>  
>  void cfg80211_roamed(struct net_device *dev,
> @@ -663,7 +663,7 @@ void cfg80211_roamed_bss(struct net_device *dev,
>  
>  	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
>  	if (!ev) {
> -		cfg80211_put_bss(bss);
> +		cfg80211_put_bss(wdev->wiphy, bss);
>  		return;
>  	}
>  
> @@ -704,7 +704,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
>  
>  	if (wdev->current_bss) {
>  		cfg80211_unhold_bss(wdev->current_bss);
> -		cfg80211_put_bss(&wdev->current_bss->pub);
> +		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
>  	}
>  
>  	wdev->current_bss = NULL;
> @@ -875,7 +875,7 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
>  		if (bss) {
>  			wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
>  			err = cfg80211_conn_do_work(wdev);
> -			cfg80211_put_bss(bss);
> +			cfg80211_put_bss(wdev->wiphy, bss);
>  		} else {
>  			/* otherwise we'll need to scan for the AP first */
>  			err = cfg80211_conn_scan(wdev);


