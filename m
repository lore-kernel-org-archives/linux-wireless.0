Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZGCICo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 04:02:44 -0400
Subject: Re: [PATCH] iwmc3200wifi: cfg80211 managed mode port
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090702235513.GA4143@sortiz.org>
References: <20090701192641.072258140@sipsolutions.net>
	 <20090701193421.155074452@sipsolutions.net>
	 <20090702235513.GA4143@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yXhvjX/01xcFRtsEHP56"
Date: Fri, 03 Jul 2009 10:02:39 +0200
Message-Id: <1246608159.16770.53.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yXhvjX/01xcFRtsEHP56
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-03 at 01:55 +0200, Samuel Ortiz wrote:
> This patch ports iwm to the new cfg80211 managed mode API.
> Whenever those managed mode routines get combined with the ibss one, we w=
ill
> just have to entirely get rid of the wext implementation (We may have to =
only
> keep the iw_handler until cfg80211 does the wext registration for us).

Looks good. I'll take care of the combine part later.

johannes

> Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> ---
>  drivers/net/wireless/iwmc3200wifi/cfg80211.c |  195 ++++++++++++++++
>  drivers/net/wireless/iwmc3200wifi/rx.c       |   13 -
>  drivers/net/wireless/iwmc3200wifi/wext.c     |  320 ++------------------=
-------
>  3 files changed, 239 insertions(+), 289 deletions(-)
>=20
> Index: iwm-2.6/drivers/net/wireless/iwmc3200wifi/cfg80211.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- iwm-2.6.orig/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2009-07-02 =
21:20:34.000000000 +0200
> +++ iwm-2.6/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2009-07-03 01:43=
:09.000000000 +0200
> @@ -305,6 +305,25 @@ static int iwm_cfg80211_set_default_key(
>  	return iwm_reset_profile(iwm);
>  }
> =20
> +int iwm_cfg80211_get_station(struct wiphy *wiphy, struct net_device *nde=
v,
> +			     u8 *mac, struct station_info *sinfo)
> +{
> +	struct iwm_priv *iwm =3D ndev_to_iwm(ndev);
> +
> +	if (memcmp(mac, iwm->bssid, ETH_ALEN))
> +		return -ENOENT;
> +
> +	sinfo->filled |=3D STATION_INFO_TX_BITRATE;
> +	sinfo->txrate.legacy =3D iwm->rate * 10;
> +
> +	if (test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)) {
> +		sinfo->filled |=3D STATION_INFO_SIGNAL;
> +		sinfo->signal =3D iwm->wstats.qual.level;
> +	}
> +
> +	return 0;
> +}
> +
> =20
>  int iwm_cfg80211_inform_bss(struct iwm_priv *iwm)
>  {
> @@ -500,6 +519,179 @@ static int iwm_cfg80211_leave_ibss(struc
>  	return 0;
>  }
> =20
> +static int iwm_set_auth_type(struct iwm_priv *iwm,
> +			     enum nl80211_auth_type sme_auth_type)
> +{
> +	u8 *auth_type =3D &iwm->umac_profile->sec.auth_type;
> +
> +	switch (sme_auth_type) {
> +	case NL80211_AUTHTYPE_AUTOMATIC:
> +	case NL80211_AUTHTYPE_OPEN_SYSTEM:
> +		IWM_DBG_WEXT(iwm, DBG, "OPEN auth\n");
> +		*auth_type =3D UMAC_AUTH_TYPE_OPEN;
> +		break;
> +	case NL80211_AUTHTYPE_SHARED_KEY:
> +		if (iwm->umac_profile->sec.flags &
> +		    (UMAC_SEC_FLG_WPA_ON_MSK | UMAC_SEC_FLG_RSNA_ON_MSK)) {
> +			IWM_DBG_WEXT(iwm, DBG, "WPA auth alg\n");
> +			*auth_type =3D UMAC_AUTH_TYPE_RSNA_PSK;
> +		} else {
> +			IWM_DBG_WEXT(iwm, DBG, "WEP shared key auth alg\n");
> +			*auth_type =3D UMAC_AUTH_TYPE_LEGACY_PSK;
> +		}
> +
> +		break;
> +	default:
> +		IWM_ERR(iwm, "Unsupported auth alg: 0x%x\n", sme_auth_type);
> +		return -ENOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int iwm_set_wpa_version(struct iwm_priv *iwm, u32 wpa_version)
> +{
> +	if (!wpa_version) {
> +		iwm->umac_profile->sec.flags =3D UMAC_SEC_FLG_LEGACY_PROFILE;
> +		return 0;
> +	}
> +
> +	if (wpa_version & NL80211_WPA_VERSION_2)
> +		iwm->umac_profile->sec.flags =3D UMAC_SEC_FLG_RSNA_ON_MSK;
> +
> +	if (wpa_version & NL80211_WPA_VERSION_1)
> +		iwm->umac_profile->sec.flags |=3D UMAC_SEC_FLG_WPA_ON_MSK;
> +
> +	return 0;
> +}
> +
> +static int iwm_set_cipher(struct iwm_priv *iwm, u32 cipher, bool ucast)
> +{
> +	u8 *profile_cipher =3D ucast ? &iwm->umac_profile->sec.ucast_cipher :
> +		&iwm->umac_profile->sec.mcast_cipher;
> +
> +	if (!cipher) {
> +		*profile_cipher =3D UMAC_CIPHER_TYPE_NONE;
> +		return 0;
> +	}
> +
> +	switch (cipher) {
> +	case IW_AUTH_CIPHER_NONE:
> +		*profile_cipher =3D UMAC_CIPHER_TYPE_NONE;
> +		break;
> +	case WLAN_CIPHER_SUITE_WEP40:
> +		*profile_cipher =3D UMAC_CIPHER_TYPE_WEP_40;
> +		break;
> +	case WLAN_CIPHER_SUITE_WEP104:
> +		*profile_cipher =3D UMAC_CIPHER_TYPE_WEP_104;
> +		break;
> +	case WLAN_CIPHER_SUITE_TKIP:
> +		*profile_cipher =3D UMAC_CIPHER_TYPE_TKIP;
> +		break;
> +	case WLAN_CIPHER_SUITE_CCMP:
> +		*profile_cipher =3D UMAC_CIPHER_TYPE_CCMP;
> +		break;
> +	default:
> +		IWM_ERR(iwm, "Unsupported cipher: 0x%x\n", cipher);
> +		return -ENOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int iwm_set_key_mgt(struct iwm_priv *iwm, u32 key_mgt)
> +{
> +	u8 *auth_type =3D &iwm->umac_profile->sec.auth_type;
> +
> +	IWM_DBG_WEXT(iwm, DBG, "key_mgt: 0x%x\n", key_mgt);
> +
> +	if (key_mgt =3D=3D WLAN_AKM_SUITE_8021X)
> +		*auth_type =3D UMAC_AUTH_TYPE_8021X;
> +	else if (key_mgt =3D=3D WLAN_AKM_SUITE_PSK) {
> +		if (iwm->umac_profile->sec.flags &
> +		    (UMAC_SEC_FLG_WPA_ON_MSK | UMAC_SEC_FLG_RSNA_ON_MSK))
> +			*auth_type =3D UMAC_AUTH_TYPE_RSNA_PSK;
> +		else
> +			*auth_type =3D UMAC_AUTH_TYPE_LEGACY_PSK;
> +	} else {
> +		IWM_ERR(iwm, "Invalid key mgt: 0x%x\n", key_mgt);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static int iwm_cfg80211_connect(struct wiphy *wiphy, struct net_device *=
dev,
> +				 struct cfg80211_connect_params *sme)
> +{
> +	struct iwm_priv *iwm =3D wiphy_to_iwm(wiphy);
> +	struct ieee80211_channel *chan =3D sme->channel;
> +	int ret;
> +
> +	if (!test_bit(IWM_STATUS_READY, &iwm->status))
> +		return -EIO;
> +
> +	if (!sme->ssid)
> +		return -EINVAL;
> +
> +	if (chan)
> +		iwm->channel =3D
> +			ieee80211_frequency_to_channel(chan->center_freq);
> +
> +	iwm->umac_profile->ssid.ssid_len =3D sme->ssid_len;
> +	memcpy(iwm->umac_profile->ssid.ssid, sme->ssid, sme->ssid_len);
> +
> +	if (sme->bssid) {
> +		IWM_DBG_WEXT(iwm, DBG, "BSSID: %pM\n", sme->bssid);
> +		memcpy(&iwm->umac_profile->bssid[0], sme->bssid, ETH_ALEN);
> +		iwm->umac_profile->bss_num =3D 1;
> +	} else {
> +		memset(&iwm->umac_profile->bssid[0], 0, ETH_ALEN);
> +		iwm->umac_profile->bss_num =3D 0;
> +	}
> +
> +	ret =3D iwm_set_auth_type(iwm, sme->auth_type);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D iwm_set_wpa_version(iwm, sme->crypto.wpa_versions);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (sme->crypto.n_ciphers_pairwise) {
> +		ret =3D iwm_set_cipher(iwm, sme->crypto.ciphers_pairwise[0],
> +				     true);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	ret =3D iwm_set_cipher(iwm, sme->crypto.cipher_group, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (sme->crypto.n_akm_suites) {
> +		ret =3D iwm_set_key_mgt(iwm, sme->crypto.akm_suites[0]);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return iwm_send_mlme_profile(iwm);
> +}
> +
> +static int iwm_cfg80211_disconnect(struct wiphy *wiphy, struct net_devic=
e *dev,
> +				   u16 reason_code)
> +{
> +	struct iwm_priv *iwm =3D wiphy_to_iwm(wiphy);
> +
> +	IWM_DBG_WEXT(iwm, DBG, "Active: %d\n", iwm->umac_profile_active);
> +
> +	if (iwm->umac_profile_active)
> +		return iwm_invalidate_mlme_profile(iwm);
> +
> +	return 0;
> +}
> +
>  static int iwm_cfg80211_set_txpower(struct wiphy *wiphy,
>  				    enum tx_power_setting type, int dbm)
>  {
> @@ -549,8 +741,11 @@ static struct cfg80211_ops iwm_cfg80211_
>  	.get_key =3D iwm_cfg80211_get_key,
>  	.del_key =3D iwm_cfg80211_del_key,
>  	.set_default_key =3D iwm_cfg80211_set_default_key,
> +	.get_station =3D iwm_cfg80211_get_station,
>  	.scan =3D iwm_cfg80211_scan,
>  	.set_wiphy_params =3D iwm_cfg80211_set_wiphy_params,
> +	.connect =3D iwm_cfg80211_connect,
> +	.disconnect =3D iwm_cfg80211_disconnect,
>  	.join_ibss =3D iwm_cfg80211_join_ibss,
>  	.leave_ibss =3D iwm_cfg80211_leave_ibss,
>  	.set_tx_power =3D iwm_cfg80211_set_txpower,
> Index: iwm-2.6/drivers/net/wireless/iwmc3200wifi/wext.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- iwm-2.6.orig/drivers/net/wireless/iwmc3200wifi/wext.c	2009-07-02 21:2=
0:34.000000000 +0200
> +++ iwm-2.6/drivers/net/wireless/iwmc3200wifi/wext.c	2009-07-03 01:18:56.=
000000000 +0200
> @@ -21,31 +21,11 @@
>   *
>   */
> =20
> -#include <linux/kernel.h>
> -#include <linux/netdevice.h>
>  #include <linux/wireless.h>
> -#include <linux/if_arp.h>
> -#include <linux/etherdevice.h>
>  #include <net/cfg80211.h>
> -#include <net/iw_handler.h>
> =20
>  #include "iwm.h"
> -#include "umac.h"
>  #include "commands.h"
> -#include "debug.h"
> -
> -static struct iw_statistics *iwm_get_wireless_stats(struct net_device *d=
ev)
> -{
> -	struct iwm_priv *iwm =3D ndev_to_iwm(dev);
> -	struct iw_statistics *wstats =3D &iwm->wstats;
> -
> -	if (!test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)) {
> -		memset(wstats, 0, sizeof(struct iw_statistics));
> -		wstats->qual.updated =3D IW_QUAL_ALL_INVALID;
> -	}
> -
> -	return wstats;
> -}
> =20
>  static int iwm_wext_siwfreq(struct net_device *dev,
>  			    struct iw_request_info *info,
> @@ -53,14 +33,12 @@ static int iwm_wext_siwfreq(struct net_d
>  {
>  	struct iwm_priv *iwm =3D ndev_to_iwm(dev);
> =20
> -	if (freq->flags =3D=3D IW_FREQ_AUTO)
> -		return 0;
> -
> -	/* frequency/channel can only be set in IBSS mode */
> -	if (iwm->conf.mode !=3D UMAC_MODE_IBSS)
> +	switch (iwm->conf.mode) {
> +	case UMAC_MODE_IBSS:
> +		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
> +	default:
>  		return -EOPNOTSUPP;
> -
> -	return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
> +	}
>  }
> =20
>  static int iwm_wext_giwfreq(struct net_device *dev,
> @@ -69,69 +47,29 @@ static int iwm_wext_giwfreq(struct net_d
>  {
>  	struct iwm_priv *iwm =3D ndev_to_iwm(dev);
> =20
> -	if (iwm->conf.mode =3D=3D UMAC_MODE_IBSS)
> +	switch (iwm->conf.mode) {
> +	case UMAC_MODE_IBSS:
>  		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
> -
> -	freq->e =3D 0;
> -	freq->m =3D iwm->channel;
> -
> -	return 0;
> +	case UMAC_MODE_BSS:
> +		return cfg80211_mgd_wext_giwfreq(dev, info, freq, extra);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
>  }
> =20
>  static int iwm_wext_siwap(struct net_device *dev, struct iw_request_info=
 *info,
>  			  struct sockaddr *ap_addr, char *extra)
>  {
>  	struct iwm_priv *iwm =3D ndev_to_iwm(dev);
> -	int ret;
> -
> -	IWM_DBG_WEXT(iwm, DBG, "Set BSSID: %pM\n", ap_addr->sa_data);
> =20
> -	if (iwm->conf.mode =3D=3D UMAC_MODE_IBSS)
> +	switch (iwm->conf.mode) {
> +	case UMAC_MODE_IBSS:
>  		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
> -
> -	if (!test_bit(IWM_STATUS_READY, &iwm->status))
> -		return -EIO;
> -
> -	if (is_zero_ether_addr(ap_addr->sa_data) ||
> -	    is_broadcast_ether_addr(ap_addr->sa_data)) {
> -		IWM_DBG_WEXT(iwm, DBG, "clear mandatory bssid %pM\n",
> -			     iwm->umac_profile->bssid[0]);
> -		memset(&iwm->umac_profile->bssid[0], 0, ETH_ALEN);
> -		iwm->umac_profile->bss_num =3D 0;
> -	} else {
> -		IWM_DBG_WEXT(iwm, DBG, "add mandatory bssid %pM\n",
> -			     ap_addr->sa_data);
> -		memcpy(&iwm->umac_profile->bssid[0], ap_addr->sa_data,
> -		       ETH_ALEN);
> -		iwm->umac_profile->bss_num =3D 1;
> -	}
> -
> -	if (iwm->umac_profile_active) {
> -		int i;
> -
> -		if (!memcmp(&iwm->umac_profile->bssid[0], iwm->bssid, ETH_ALEN))
> -			return 0;
> -
> -		/*
> -		 * If we're clearing the BSSID, and we're associated,
> -		 * we have to clear the keys as they're no longer valid.
> -		 */
> -		if (is_zero_ether_addr(ap_addr->sa_data)) {
> -			for (i =3D 0; i < IWM_NUM_KEYS; i++)
> -				iwm->keys[i].key_len =3D 0;
> -		}
> -
> -		ret =3D iwm_invalidate_mlme_profile(iwm);
> -		if (ret < 0) {
> -			IWM_ERR(iwm, "Couldn't invalidate profile\n");
> -			return ret;
> -		}
> +	case UMAC_MODE_BSS:
> +		return cfg80211_mgd_wext_siwap(dev, info, ap_addr, extra);
> +	default:
> +		return -EOPNOTSUPP;
>  	}
> -
> -	if (iwm->umac_profile->ssid.ssid_len)
> -		return iwm_send_mlme_profile(iwm);
> -
> -	return 0;
>  }
> =20
>  static int iwm_wext_giwap(struct net_device *dev, struct iw_request_info=
 *info,
> @@ -143,17 +81,10 @@ static int iwm_wext_giwap(struct net_dev
>  	case UMAC_MODE_IBSS:
>  		return cfg80211_ibss_wext_giwap(dev, info, ap_addr, extra);
>  	case UMAC_MODE_BSS:
> -		if (test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)) {
> -			ap_addr->sa_family =3D ARPHRD_ETHER;
> -			memcpy(&ap_addr->sa_data, iwm->bssid, ETH_ALEN);
> -		} else
> -			memset(&ap_addr->sa_data, 0, ETH_ALEN);
> -		break;
> +		return cfg80211_mgd_wext_giwap(dev, info, ap_addr, extra);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> -
> -	return 0;
>  }
> =20
>  static int iwm_wext_siwessid(struct net_device *dev,
> @@ -161,36 +92,15 @@ static int iwm_wext_siwessid(struct net_
>  			     struct iw_point *data, char *ssid)
>  {
>  	struct iwm_priv *iwm =3D ndev_to_iwm(dev);
> -	size_t len =3D data->length;
> -	int ret;
> -
> -	IWM_DBG_WEXT(iwm, DBG, "Set ESSID: >%s<\n", ssid);
> =20
> -	if (iwm->conf.mode =3D=3D UMAC_MODE_IBSS)
> +	switch (iwm->conf.mode) {
> +	case UMAC_MODE_IBSS:
>  		return cfg80211_ibss_wext_siwessid(dev, info, data, ssid);
> -
> -	if (!test_bit(IWM_STATUS_READY, &iwm->status))
> -		return -EIO;
> -
> -	if (len > 0 && ssid[len - 1] =3D=3D '\0')
> -		len--;
> -
> -	if (iwm->umac_profile_active) {
> -		if (iwm->umac_profile->ssid.ssid_len =3D=3D len &&
> -		    !memcmp(iwm->umac_profile->ssid.ssid, ssid, len))
> -			return 0;
> -
> -		ret =3D iwm_invalidate_mlme_profile(iwm);
> -		if (ret < 0) {
> -			IWM_ERR(iwm, "Couldn't invalidate profile\n");
> -			return ret;
> -		}
> +	case UMAC_MODE_BSS:
> +		return cfg80211_mgd_wext_siwessid(dev, info, data, ssid);
> +	default:
> +		return -EOPNOTSUPP;
>  	}
> -
> -	iwm->umac_profile->ssid.ssid_len =3D len;
> -	memcpy(iwm->umac_profile->ssid.ssid, ssid, len);
> -
> -	return iwm_send_mlme_profile(iwm);
>  }
> =20
>  static int iwm_wext_giwessid(struct net_device *dev,
> @@ -199,174 +109,14 @@ static int iwm_wext_giwessid(struct net_
>  {
>  	struct iwm_priv *iwm =3D ndev_to_iwm(dev);
> =20
> -	if (iwm->conf.mode =3D=3D UMAC_MODE_IBSS)
> +	switch (iwm->conf.mode) {
> +	case UMAC_MODE_IBSS:
>  		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
> -
> -	if (!test_bit(IWM_STATUS_READY, &iwm->status))
> -		return -EIO;
> -
> -	data->length =3D iwm->umac_profile->ssid.ssid_len;
> -	if (data->length) {
> -		memcpy(ssid, iwm->umac_profile->ssid.ssid, data->length);
> -		data->flags =3D 1;
> -	} else
> -		data->flags =3D 0;
> -
> -	return 0;
> -}
> -
> -static int iwm_wext_giwrate(struct net_device *dev,
> -			    struct iw_request_info *info,
> -			    struct iw_param *rate, char *extra)
> -{
> -	struct iwm_priv *iwm =3D ndev_to_iwm(dev);
> -
> -	rate->value =3D iwm->rate * 1000000;
> -
> -	return 0;
> -}
> -
> -static int iwm_set_wpa_version(struct iwm_priv *iwm, u8 wpa_version)
> -{
> -	if (wpa_version & IW_AUTH_WPA_VERSION_WPA2)
> -		iwm->umac_profile->sec.flags =3D UMAC_SEC_FLG_RSNA_ON_MSK;
> -	else if (wpa_version & IW_AUTH_WPA_VERSION_WPA)
> -		iwm->umac_profile->sec.flags =3D UMAC_SEC_FLG_WPA_ON_MSK;
> -	else
> -		iwm->umac_profile->sec.flags =3D UMAC_SEC_FLG_LEGACY_PROFILE;
> -
> -	return 0;
> -}
> -
> -static int iwm_set_key_mgt(struct iwm_priv *iwm, u8 key_mgt)
> -{
> -	u8 *auth_type =3D &iwm->umac_profile->sec.auth_type;
> -
> -	IWM_DBG_WEXT(iwm, DBG, "key_mgt: 0x%x\n", key_mgt);
> -
> -	if (key_mgt =3D=3D IW_AUTH_KEY_MGMT_802_1X)
> -		*auth_type =3D UMAC_AUTH_TYPE_8021X;
> -	else if (key_mgt =3D=3D IW_AUTH_KEY_MGMT_PSK) {
> -		if (iwm->umac_profile->sec.flags &
> -		    (UMAC_SEC_FLG_WPA_ON_MSK | UMAC_SEC_FLG_RSNA_ON_MSK))
> -			*auth_type =3D UMAC_AUTH_TYPE_RSNA_PSK;
> -		else
> -			*auth_type =3D UMAC_AUTH_TYPE_LEGACY_PSK;
> -	} else {
> -		IWM_ERR(iwm, "Invalid key mgt: 0x%x\n", key_mgt);
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -static int iwm_set_cipher(struct iwm_priv *iwm, u8 cipher, u8 ucast)
> -{
> -	u8 *profile_cipher =3D ucast ? &iwm->umac_profile->sec.ucast_cipher :
> -		&iwm->umac_profile->sec.mcast_cipher;
> -
> -	switch (cipher) {
> -	case IW_AUTH_CIPHER_NONE:
> -		*profile_cipher =3D UMAC_CIPHER_TYPE_NONE;
> -		break;
> -	case IW_AUTH_CIPHER_WEP40:
> -		*profile_cipher =3D UMAC_CIPHER_TYPE_WEP_40;
> -		break;
> -	case IW_AUTH_CIPHER_TKIP:
> -		*profile_cipher =3D UMAC_CIPHER_TYPE_TKIP;
> -		break;
> -	case IW_AUTH_CIPHER_CCMP:
> -		*profile_cipher =3D UMAC_CIPHER_TYPE_CCMP;
> -		break;
> -	case IW_AUTH_CIPHER_WEP104:
> -		*profile_cipher =3D UMAC_CIPHER_TYPE_WEP_104;
> -		break;
> -	default:
> -		IWM_ERR(iwm, "Unsupported cipher: 0x%x\n", cipher);
> -		return -ENOTSUPP;
> -	}
> -
> -	return 0;
> -}
> -
> -static int iwm_set_auth_alg(struct iwm_priv *iwm, u8 auth_alg)
> -{
> -	u8 *auth_type =3D &iwm->umac_profile->sec.auth_type;
> -
> -	IWM_DBG_WEXT(iwm, DBG, "auth_alg: 0x%x\n", auth_alg);
> -
> -	switch (auth_alg) {
> -	case IW_AUTH_ALG_OPEN_SYSTEM:
> -		*auth_type =3D UMAC_AUTH_TYPE_OPEN;
> -		break;
> -	case IW_AUTH_ALG_SHARED_KEY:
> -		if (iwm->umac_profile->sec.flags &
> -		    (UMAC_SEC_FLG_WPA_ON_MSK | UMAC_SEC_FLG_RSNA_ON_MSK)) {
> -			if (*auth_type =3D=3D UMAC_AUTH_TYPE_8021X)
> -				return -EINVAL;
> -			*auth_type =3D UMAC_AUTH_TYPE_RSNA_PSK;
> -		} else {
> -			IWM_DBG_WEXT(iwm, DBG, "WEP shared key\n");
> -			*auth_type =3D UMAC_AUTH_TYPE_LEGACY_PSK;
> -		}
> -		break;
> -	case IW_AUTH_ALG_LEAP:
> -	default:
> -		IWM_ERR(iwm, "Unsupported auth alg: 0x%x\n", auth_alg);
> -		return -ENOTSUPP;
> -	}
> -
> -	return 0;
> -}
> -
> -static int iwm_wext_siwauth(struct net_device *dev,
> -			    struct iw_request_info *info,
> -			    struct iw_param *data, char *extra)
> -{
> -	struct iwm_priv *iwm =3D ndev_to_iwm(dev);
> -	int ret;
> -
> -	if ((data->flags) &
> -	    (IW_AUTH_WPA_VERSION | IW_AUTH_KEY_MGMT |
> -	     IW_AUTH_WPA_ENABLED | IW_AUTH_80211_AUTH_ALG)) {
> -		/* We need to invalidate the current profile */
> -		if (iwm->umac_profile_active) {
> -			ret =3D iwm_invalidate_mlme_profile(iwm);
> -			if (ret < 0) {
> -				IWM_ERR(iwm, "Couldn't invalidate profile\n");
> -				return ret;
> -			}
> -		}
> -	}
> -
> -	switch (data->flags & IW_AUTH_INDEX) {
> -	case IW_AUTH_WPA_VERSION:
> -		return iwm_set_wpa_version(iwm, data->value);
> -		break;
> -	case IW_AUTH_CIPHER_PAIRWISE:
> -		return iwm_set_cipher(iwm, data->value, 1);
> -		break;
> -	case IW_AUTH_CIPHER_GROUP:
> -		return iwm_set_cipher(iwm, data->value, 0);
> -		break;
> -	case IW_AUTH_KEY_MGMT:
> -		return iwm_set_key_mgt(iwm, data->value);
> -		break;
> -	case IW_AUTH_80211_AUTH_ALG:
> -		return iwm_set_auth_alg(iwm, data->value);
> -		break;
> +	case UMAC_MODE_BSS:
> +		return cfg80211_mgd_wext_giwessid(dev, info, data, ssid);
>  	default:
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  	}
> -
> -	return 0;
> -}
> -
> -static int iwm_wext_giwauth(struct net_device *dev,
> -			    struct iw_request_info *info,
> -			    struct iw_param *data, char *extra)
> -{
> -	return 0;
>  }
> =20
>  static const iw_handler iwm_handlers[] =3D
> @@ -404,7 +154,7 @@ static const iw_handler iwm_handlers[] =3D
>  	(iw_handler) NULL,				/* -- hole -- */
>  	(iw_handler) NULL,				/* -- hole -- */
>  	(iw_handler) NULL,				/* SIOCSIWRATE */
> -	(iw_handler) iwm_wext_giwrate,			/* SIOCGIWRATE */
> +	(iw_handler) cfg80211_wext_giwrate,		/* SIOCGIWRATE */
>  	(iw_handler) cfg80211_wext_siwrts,		/* SIOCSIWRTS */
>  	(iw_handler) cfg80211_wext_giwrts,		/* SIOCGIWRTS */
>  	(iw_handler) cfg80211_wext_siwfrag,	        /* SIOCSIWFRAG */
> @@ -419,10 +169,10 @@ static const iw_handler iwm_handlers[] =3D
>  	(iw_handler) cfg80211_wext_giwpower,		/* SIOCGIWPOWER */
>  	(iw_handler) NULL,				/* -- hole -- */
>  	(iw_handler) NULL,				/* -- hole -- */
> -	(iw_handler) NULL,                              /* SIOCSIWGENIE */
> +	(iw_handler) cfg80211_wext_siwgenie,            /* SIOCSIWGENIE */
>  	(iw_handler) NULL,				/* SIOCGIWGENIE */
> -	(iw_handler) iwm_wext_siwauth,			/* SIOCSIWAUTH */
> -	(iw_handler) iwm_wext_giwauth,			/* SIOCGIWAUTH */
> +	(iw_handler) cfg80211_wext_siwauth,		/* SIOCSIWAUTH */
> +	(iw_handler) cfg80211_wext_giwauth,		/* SIOCGIWAUTH */
>  	(iw_handler) cfg80211_wext_siwencodeext,	/* SIOCSIWENCODEEXT */
>  	(iw_handler) NULL,				/* SIOCGIWENCODEEXT */
>  	(iw_handler) NULL,				/* SIOCSIWPMKSA */
> @@ -432,6 +182,6 @@ static const iw_handler iwm_handlers[] =3D
>  const struct iw_handler_def iwm_iw_handler_def =3D {
>  	.num_standard	=3D ARRAY_SIZE(iwm_handlers),
>  	.standard	=3D (iw_handler *) iwm_handlers,
> -	.get_wireless_stats =3D iwm_get_wireless_stats,
> +	.get_wireless_stats =3D cfg80211_wireless_stats,
>  };
> =20
> Index: iwm-2.6/drivers/net/wireless/iwmc3200wifi/rx.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- iwm-2.6.orig/drivers/net/wireless/iwmc3200wifi/rx.c	2009-07-02 21:19:=
58.000000000 +0200
> +++ iwm-2.6/drivers/net/wireless/iwmc3200wifi/rx.c	2009-07-03 00:24:46.00=
0000000 +0200
> @@ -521,7 +521,10 @@ static int iwm_mlme_assoc_complete(struc
> =20
>  		iwm_link_on(iwm);
> =20
> -		memcpy(wrqu.ap_addr.sa_data, complete->bssid, ETH_ALEN);
> +		cfg80211_connect_result(iwm_to_ndev(iwm),
> +					complete->bssid,
> +					NULL, 0, NULL, 0,
> +					WLAN_STATUS_SUCCESS, GFP_KERNEL);
>  		break;
>  	case UMAC_ASSOC_COMPLETE_FAILURE:
>  		clear_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
> @@ -529,6 +532,11 @@ static int iwm_mlme_assoc_complete(struc
>  		iwm->channel =3D 0;
> =20
>  		iwm_link_off(iwm);
> +
> +		cfg80211_connect_result(iwm_to_ndev(iwm), complete->bssid,
> +					NULL, 0, NULL, 0,
> +					WLAN_STATUS_UNSPECIFIED_FAILURE,
> +					GFP_KERNEL);
>  	default:
>  		break;
>  	}
> @@ -538,9 +546,6 @@ static int iwm_mlme_assoc_complete(struc
>  		return 0;
>  	}
> =20
> -	wrqu.ap_addr.sa_family =3D ARPHRD_ETHER;
> -	wireless_send_event(iwm_to_ndev(iwm), SIOCGIWAP, &wrqu, NULL);
> -
>  	return 0;
>  }
> =20

--=-yXhvjX/01xcFRtsEHP56
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKTbscAAoJEODzc/N7+Qma2psP/1++J2Xjeo98XT/0E9UVwwrD
zdDAWYHNxQdkY8XACzhaThoh8x1a/utYcu1/3hxT0/EZEZdhVCi0nxv1q8JyxcQ1
aw1gt38t0Rx84MMLUXMfYoiVbSmw3SOIYHGuFDrnMDjkVmHKbEAKuYB0RBuraNi/
FyNXdfAdEBz8IY567Sk1SrFTl64WZSuvomTPd7/Div3a5cJLHXOppNEaNQ/t+m87
hiQ5OeONZTyYNRA3MWDz8hecT5SfQYCcejDMykcuhIXdwcoBxu/QB2wB1QcJ9RY5
Tf6m3tMk60LPIHPzK6kNb95Q6Ln/gk/uGWOILntGNomBXDiBEKD6AJ0gBSzn8iqN
BGmjz2IVxQCc/CgT1uma0XSHHuUcAJ9j/uK4CtT0AGjHEHSykt9tpwsMdeRiAgoJ
hXKRG0sW7+aXrlJWqoebKCbqpxw51tgqQQ2kcNOA2v92jZYzavs73Suit8BrH1Bc
VddrOEWt6I8MPgBps/0DbACA3Aw2O7YNiQ+T55ZAnVM64DKvaLaOV0IZnnhWIoH1
/zbAlvYibWWigmsHCSAngC/JPE5QnQXP8joxmHKzKToLbVT80oekC+p3KvCK3bDm
TBLWWsfNcgf8aGS4hrZ5qRgTUsFg3Pv+3JJzH4oPuVkTZn5IePP/poISbkGG4vj6
A99me8OebkXKzqoPiWmn
=FpUV
-----END PGP SIGNATURE-----

--=-yXhvjX/01xcFRtsEHP56--

