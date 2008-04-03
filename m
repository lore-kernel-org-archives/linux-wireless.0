Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760016AbYDCDe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 23:34:59 -0400
Subject: Re: [PATCH] libertas: move association code from scan.c into
	assoc.c
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804021627.42451.hs4233@mail.mn-solutions.de>
References: <200804021627.42451.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 23:32:48 -0400
Message-Id: <1207193568.9435.4.camel@localhost.localdomain> (sfid-20080403_043507_880059_97F99F72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-02 at 16:27 +0200, Holger Schurig wrote:
> Besides code moving, I did the following changes:
> 
> * made some functions static
> * removed some unneeded #include's
> * made patch checkpatch.pl clean
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/dev.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/dev.h	2008-04-02 14:18:20.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/dev.h	2008-04-02 14:23:48.000000000 +0200
> @@ -10,9 +10,10 @@
>  #include <linux/wireless.h>
>  #include <linux/ethtool.h>
>  #include <linux/debugfs.h>
> +#include <net/ieee80211.h>
>  
>  #include "defs.h"
> -#include "scan.h"
> +#include "hostcmd.h"
>  
>  extern struct ethtool_ops lbs_ethtool_ops;
>  
> @@ -318,6 +319,44 @@ struct lbs_private {
>  
>  extern struct cmd_confirm_sleep confirm_sleep;
>  
> +/**
> + *  @brief Structure used to store information for each beacon/probe response
> + */
> +struct bss_descriptor {
> +	u8 bssid[ETH_ALEN];
> +
> +	u8 ssid[IW_ESSID_MAX_SIZE + 1];
> +	u8 ssid_len;
> +
> +	u16 capability;
> +	u32 rssi;
> +	u32 channel;
> +	u16 beaconperiod;
> +	u32 atimwindow;
> +
> +	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
> +	u8 mode;
> +
> +	/* zero-terminated array of supported data rates */
> +	u8 rates[MAX_RATES + 1];
> +
> +	unsigned long last_scanned;
> +
> +	union ieeetypes_phyparamset phyparamset;
> +	union IEEEtypes_ssparamset ssparamset;
> +
> +	struct ieeetypes_countryinfofullset countryinfo;
> +
> +	u8 wpa_ie[MAX_WPA_IE_LEN];
> +	size_t wpa_ie_len;
> +	u8 rsn_ie[MAX_WPA_IE_LEN];
> +	size_t rsn_ie_len;
> +
> +	u8 mesh;
> +
> +	struct list_head list;
> +};
> +
>  /** Association request
>   *
>   * Encapsulates all the options that describe a specific assocation request
> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-04-02 14:18:48.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-04-02 14:22:37.000000000 +0200
> @@ -20,6 +20,7 @@
>  #include "dev.h"
>  #include "wext.h"
>  #include "debugfs.h"
> +#include "scan.h"
>  #include "assoc.h"
>  #include "cmd.h"
>  
> Index: wireless-testing/drivers/net/wireless/libertas/scan.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/scan.h	2008-04-02 14:18:20.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/scan.h	2008-04-02 14:22:37.000000000 +0200
> @@ -7,73 +7,13 @@
>  #ifndef _LBS_SCAN_H
>  #define _LBS_SCAN_H
>  
> -#include <net/ieee80211.h>
> -#include "hostcmd.h"
> -
>  /**
>   *  @brief Maximum number of channels that can be sent in a setuserscan ioctl
>   */
>  #define LBS_IOCTL_USER_SCAN_CHAN_MAX  50
>  
> -//! Infrastructure BSS scan type in cmd_ds_802_11_scan
> -#define LBS_SCAN_BSS_TYPE_BSS         1
> -
> -//! Adhoc BSS scan type in cmd_ds_802_11_scan
> -#define LBS_SCAN_BSS_TYPE_IBSS        2
> -
> -//! Adhoc or Infrastructure BSS scan type in cmd_ds_802_11_scan, no filter
> -#define LBS_SCAN_BSS_TYPE_ANY         3
> -
> -/**
> - *  @brief Structure used to store information for each beacon/probe response
> - */
> -struct bss_descriptor {
> -	u8 bssid[ETH_ALEN];
> -
> -	u8 ssid[IW_ESSID_MAX_SIZE + 1];
> -	u8 ssid_len;
> -
> -	u16 capability;
> -	u32 rssi;
> -	u32 channel;
> -	u16 beaconperiod;
> -	u32 atimwindow;
> -
> -	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
> -	u8 mode;
> -
> -	/* zero-terminated array of supported data rates */
> -	u8 rates[MAX_RATES + 1];
> -
> -	unsigned long last_scanned;
> -
> -	union ieeetypes_phyparamset phyparamset;
> -	union IEEEtypes_ssparamset ssparamset;
> -
> -	struct ieeetypes_countryinfofullset countryinfo;
> -
> -	u8 wpa_ie[MAX_WPA_IE_LEN];
> -	size_t wpa_ie_len;
> -	u8 rsn_ie[MAX_WPA_IE_LEN];
> -	size_t rsn_ie_len;
> -
> -	u8 mesh;
> -
> -	struct list_head list;
> -};
> -
>  int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len);
>  
> -struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_private *priv,
> -		u8 *ssid, u8 ssid_len, u8 *bssid, u8 mode,
> -		int channel);
> -
> -struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_private *priv,
> -	u8 *bssid, u8 mode);
> -
> -int lbs_find_best_network_ssid(struct lbs_private *priv, u8 *out_ssid,
> -			u8 *out_ssid_len, u8 preferred_mode, u8 *out_mode);
> -
>  int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
>  				u8 ssid_len);
>  
> @@ -82,6 +22,8 @@ int lbs_get_scan(struct net_device *dev,
>  int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
>  			 union iwreq_data *wrqu, char *extra);
>  
> +int lbs_scan_networks(struct lbs_private *priv, int full_scan);
> +
>  void lbs_scan_worker(struct work_struct *work);
>  
>  #endif
> Index: wireless-testing/drivers/net/wireless/libertas/wext.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	2008-04-02 14:18:48.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/wext.c	2008-04-02 14:22:37.000000000 +0200
> @@ -17,6 +17,7 @@
>  #include "defs.h"
>  #include "dev.h"
>  #include "wext.h"
> +#include "scan.h"
>  #include "assoc.h"
>  #include "cmd.h"
>  
> Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:19:56.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:22:37.000000000 +0200
> @@ -5,6 +5,7 @@
>  #include "assoc.h"
>  #include "decl.h"
>  #include "host.h"
> +#include "scan.h"
>  #include "cmd.h"
>  
> 
> @@ -170,6 +171,272 @@ int lbs_stop_adhoc_network(struct lbs_pr
>  				     0, CMD_OPTION_WAITFORRSP, 0, NULL);
>  }
>  
> +static inline int match_bss_no_security(struct lbs_802_11_security *secinfo,
> +					struct bss_descriptor *match_bss)
> +{
> +	if (!secinfo->wep_enabled  && !secinfo->WPAenabled
> +	    && !secinfo->WPA2enabled
> +	    && match_bss->wpa_ie[0] != MFIE_TYPE_GENERIC
> +	    && match_bss->rsn_ie[0] != MFIE_TYPE_RSN
> +	    && !(match_bss->capability & WLAN_CAPABILITY_PRIVACY))
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static inline int match_bss_static_wep(struct lbs_802_11_security *secinfo,
> +				       struct bss_descriptor *match_bss)
> +{
> +	if (secinfo->wep_enabled && !secinfo->WPAenabled
> +	    && !secinfo->WPA2enabled
> +	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static inline int match_bss_wpa(struct lbs_802_11_security *secinfo,
> +				struct bss_descriptor *match_bss)
> +{
> +	if (!secinfo->wep_enabled && secinfo->WPAenabled
> +	    && (match_bss->wpa_ie[0] == MFIE_TYPE_GENERIC)
> +	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
> +	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
> +	   )
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static inline int match_bss_wpa2(struct lbs_802_11_security *secinfo,
> +				 struct bss_descriptor *match_bss)
> +{
> +	if (!secinfo->wep_enabled && secinfo->WPA2enabled &&
> +	    (match_bss->rsn_ie[0] == MFIE_TYPE_RSN)
> +	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
> +	    (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
> +	   )
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static inline int match_bss_dynamic_wep(struct lbs_802_11_security *secinfo,
> +					struct bss_descriptor *match_bss)
> +{
> +	if (!secinfo->wep_enabled && !secinfo->WPAenabled
> +	    && !secinfo->WPA2enabled
> +	    && (match_bss->wpa_ie[0] != MFIE_TYPE_GENERIC)
> +	    && (match_bss->rsn_ie[0] != MFIE_TYPE_RSN)
> +	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +/**
> + *  @brief Check if a scanned network compatible with the driver settings
> + *
> + *   WEP     WPA     WPA2    ad-hoc  encrypt                      Network
> + * enabled enabled  enabled   AES     mode   privacy  WPA  WPA2  Compatible
> + *    0       0        0       0      NONE      0      0    0   yes No security
> + *    1       0        0       0      NONE      1      0    0   yes Static WEP
> + *    0       1        0       0       x        1x     1    x   yes WPA
> + *    0       0        1       0       x        1x     x    1   yes WPA2
> + *    0       0        0       1      NONE      1      0    0   yes Ad-hoc AES
> + *    0       0        0       0     !=NONE     1      0    0   yes Dynamic WEP
> + *
> + *
> + *  @param priv A pointer to struct lbs_private
> + *  @param index   Index in scantable to check against current driver settings
> + *  @param mode    Network mode: Infrastructure or IBSS
> + *
> + *  @return        Index in scantable, or error code if negative
> + */
> +static int is_network_compatible(struct lbs_private *priv,
> +				 struct bss_descriptor *bss, uint8_t mode)
> +{
> +	int matched = 0;
> +
> +	lbs_deb_enter(LBS_DEB_SCAN);
> +
> +	if (bss->mode != mode)
> +		goto done;
> +
> +	matched = match_bss_no_security(&priv->secinfo, bss);
> +	if (matched)
> +		goto done;
> +	matched = match_bss_static_wep(&priv->secinfo, bss);
> +	if (matched)
> +		goto done;
> +	matched = match_bss_wpa(&priv->secinfo, bss);
> +	if (matched) {
> +		lbs_deb_scan("is_network_compatible() WPA: wpa_ie 0x%x "
> +			     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> +			     "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> +			     priv->secinfo.wep_enabled ? "e" : "d",
> +			     priv->secinfo.WPAenabled ? "e" : "d",
> +			     priv->secinfo.WPA2enabled ? "e" : "d",
> +			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
> +		goto done;
> +	}
> +	matched = match_bss_wpa2(&priv->secinfo, bss);
> +	if (matched) {
> +		lbs_deb_scan("is_network_compatible() WPA2: wpa_ie 0x%x "
> +			     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> +			     "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> +			     priv->secinfo.wep_enabled ? "e" : "d",
> +			     priv->secinfo.WPAenabled ? "e" : "d",
> +			     priv->secinfo.WPA2enabled ? "e" : "d",
> +			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
> +		goto done;
> +	}
> +	matched = match_bss_dynamic_wep(&priv->secinfo, bss);
> +	if (matched) {
> +		lbs_deb_scan("is_network_compatible() dynamic WEP: "
> +			     "wpa_ie 0x%x wpa2_ie 0x%x privacy 0x%x\n",
> +			     bss->wpa_ie[0], bss->rsn_ie[0],
> +			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
> +		goto done;
> +	}
> +
> +	/* bss security settings don't match those configured on card */
> +	lbs_deb_scan("is_network_compatible() FAILED: wpa_ie 0x%x "
> +		     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s privacy 0x%x\n",
> +		     bss->wpa_ie[0], bss->rsn_ie[0],
> +		     priv->secinfo.wep_enabled ? "e" : "d",
> +		     priv->secinfo.WPAenabled ? "e" : "d",
> +		     priv->secinfo.WPA2enabled ? "e" : "d",
> +		     (bss->capability & WLAN_CAPABILITY_PRIVACY));
> +
> +done:
> +	lbs_deb_leave_args(LBS_DEB_SCAN, "matched: %d", matched);
> +	return matched;
> +}
> +
> +/**
> + *  @brief This function finds a specific compatible BSSID in the scan list
> + *
> + *  Used in association code
> + *
> + *  @param priv  A pointer to struct lbs_private
> + *  @param bssid    BSSID to find in the scan list
> + *  @param mode     Network mode: Infrastructure or IBSS
> + *
> + *  @return         index in BSSID list, or error return code (< 0)
> + */
> +static struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_private *priv,
> +					      uint8_t *bssid, uint8_t mode)
> +{
> +	struct bss_descriptor *iter_bss;
> +	struct bss_descriptor *found_bss = NULL;
> +
> +	lbs_deb_enter(LBS_DEB_SCAN);
> +
> +	if (!bssid)
> +		goto out;
> +
> +	lbs_deb_hex(LBS_DEB_SCAN, "looking for", bssid, ETH_ALEN);
> +
> +	/* Look through the scan table for a compatible match.  The loop will
> +	 *   continue past a matched bssid that is not compatible in case there
> +	 *   is an AP with multiple SSIDs assigned to the same BSSID
> +	 */
> +	mutex_lock(&priv->lock);
> +	list_for_each_entry(iter_bss, &priv->network_list, list) {
> +		if (compare_ether_addr(iter_bss->bssid, bssid))
> +			continue; /* bssid doesn't match */
> +		switch (mode) {
> +		case IW_MODE_INFRA:
> +		case IW_MODE_ADHOC:
> +			if (!is_network_compatible(priv, iter_bss, mode))
> +				break;
> +			found_bss = iter_bss;
> +			break;
> +		default:
> +			found_bss = iter_bss;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&priv->lock);
> +
> +out:
> +	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
> +	return found_bss;
> +}
> +
> +/**
> + *  @brief This function finds ssid in ssid list.
> + *
> + *  Used in association code
> + *
> + *  @param priv  A pointer to struct lbs_private
> + *  @param ssid     SSID to find in the list
> + *  @param bssid    BSSID to qualify the SSID selection (if provided)
> + *  @param mode     Network mode: Infrastructure or IBSS
> + *
> + *  @return         index in BSSID list
> + */
> +static struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_private *priv,
> +					     uint8_t *ssid, uint8_t ssid_len,
> +					     uint8_t *bssid, uint8_t mode,
> +					     int channel)
> +{
> +	u32 bestrssi = 0;
> +	struct bss_descriptor *iter_bss = NULL;
> +	struct bss_descriptor *found_bss = NULL;
> +	struct bss_descriptor *tmp_oldest = NULL;
> +
> +	lbs_deb_enter(LBS_DEB_SCAN);
> +
> +	mutex_lock(&priv->lock);
> +
> +	list_for_each_entry(iter_bss, &priv->network_list, list) {
> +		if (!tmp_oldest ||
> +		    (iter_bss->last_scanned < tmp_oldest->last_scanned))
> +			tmp_oldest = iter_bss;
> +
> +		if (lbs_ssid_cmp(iter_bss->ssid, iter_bss->ssid_len,
> +				 ssid, ssid_len) != 0)
> +			continue; /* ssid doesn't match */
> +		if (bssid && compare_ether_addr(iter_bss->bssid, bssid) != 0)
> +			continue; /* bssid doesn't match */
> +		if ((channel > 0) && (iter_bss->channel != channel))
> +			continue; /* channel doesn't match */
> +
> +		switch (mode) {
> +		case IW_MODE_INFRA:
> +		case IW_MODE_ADHOC:
> +			if (!is_network_compatible(priv, iter_bss, mode))
> +				break;
> +
> +			if (bssid) {
> +				/* Found requested BSSID */
> +				found_bss = iter_bss;
> +				goto out;
> +			}
> +
> +			if (SCAN_RSSI(iter_bss->rssi) > bestrssi) {
> +				bestrssi = SCAN_RSSI(iter_bss->rssi);
> +				found_bss = iter_bss;
> +			}
> +			break;
> +		case IW_MODE_AUTO:
> +		default:
> +			if (SCAN_RSSI(iter_bss->rssi) > bestrssi) {
> +				bestrssi = SCAN_RSSI(iter_bss->rssi);
> +				found_bss = iter_bss;
> +			}
> +			break;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&priv->lock);
> +	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
> +	return found_bss;
> +}
> +
>  static int assoc_helper_essid(struct lbs_private *priv,
>                                struct assoc_request * assoc_req)
>  {
> @@ -617,6 +884,91 @@ static int should_stop_adhoc(struct lbs_
>  }
>  
> 
> +/**
> + *  @brief This function finds the best SSID in the Scan List
> + *
> + *  Search the scan table for the best SSID that also matches the current
> + *   adapter network preference (infrastructure or adhoc)
> + *
> + *  @param priv  A pointer to struct lbs_private
> + *
> + *  @return         index in BSSID list
> + */
> +static struct bss_descriptor *lbs_find_best_ssid_in_list(
> +	struct lbs_private *priv, uint8_t mode)
> +{
> +	uint8_t bestrssi = 0;
> +	struct bss_descriptor *iter_bss;
> +	struct bss_descriptor *best_bss = NULL;
> +
> +	lbs_deb_enter(LBS_DEB_SCAN);
> +
> +	mutex_lock(&priv->lock);
> +
> +	list_for_each_entry(iter_bss, &priv->network_list, list) {
> +		switch (mode) {
> +		case IW_MODE_INFRA:
> +		case IW_MODE_ADHOC:
> +			if (!is_network_compatible(priv, iter_bss, mode))
> +				break;
> +			if (SCAN_RSSI(iter_bss->rssi) <= bestrssi)
> +				break;
> +			bestrssi = SCAN_RSSI(iter_bss->rssi);
> +			best_bss = iter_bss;
> +			break;
> +		case IW_MODE_AUTO:
> +		default:
> +			if (SCAN_RSSI(iter_bss->rssi) <= bestrssi)
> +				break;
> +			bestrssi = SCAN_RSSI(iter_bss->rssi);
> +			best_bss = iter_bss;
> +			break;
> +		}
> +	}
> +
> +	mutex_unlock(&priv->lock);
> +	lbs_deb_leave_args(LBS_DEB_SCAN, "best_bss %p", best_bss);
> +	return best_bss;
> +}
> +
> +/**
> + *  @brief Find the best AP
> + *
> + *  Used from association worker.
> + *
> + *  @param priv         A pointer to struct lbs_private structure
> + *  @param pSSID        A pointer to AP's ssid
> + *
> + *  @return             0--success, otherwise--fail
> + */
> +static int lbs_find_best_network_ssid(struct lbs_private *priv,
> +	uint8_t *out_ssid, uint8_t *out_ssid_len, uint8_t preferred_mode,
> +	uint8_t *out_mode)
> +{
> +	int ret = -1;
> +	struct bss_descriptor *found;
> +
> +	lbs_deb_enter(LBS_DEB_SCAN);
> +
> +	priv->scan_ssid_len = 0;
> +	lbs_scan_networks(priv, 1);
> +	if (priv->surpriseremoved)
> +		goto out;
> +
> +	found = lbs_find_best_ssid_in_list(priv, preferred_mode);
> +	if (found && (found->ssid_len > 0)) {
> +		memcpy(out_ssid, &found->ssid, IW_ESSID_MAX_SIZE);
> +		*out_ssid_len = found->ssid_len;
> +		*out_mode = found->mode;
> +		ret = 0;
> +	}
> +
> +out:
> +	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
> +	return ret;
> +}
> +
> +
>  void lbs_association_worker(struct work_struct *work)
>  {
>  	struct lbs_private *priv = container_of(work, struct lbs_private,
> Index: wireless-testing/drivers/net/wireless/libertas/scan.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/scan.c	2008-04-02 14:18:48.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/scan.c	2008-04-02 14:26:24.000000000 +0200
> @@ -4,22 +4,13 @@
>    * IOCTL handlers as well as command preperation and response routines
>    *  for sending scan commands to the firmware.
>    */
> -#include <linux/ctype.h>
> -#include <linux/if.h>
> -#include <linux/netdevice.h>
> -#include <linux/wireless.h>
>  #include <linux/etherdevice.h>
> -
> -#include <net/ieee80211.h>
> -#include <net/iw_handler.h>
> -
>  #include <asm/unaligned.h>
>  
>  #include "host.h"
>  #include "decl.h"
>  #include "dev.h"
>  #include "scan.h"
> -#include "assoc.h"
>  #include "cmd.h"
>  
>  //! Approximate amount of data needed to pass a scan result back to iwlist
> @@ -110,69 +101,6 @@ int lbs_ssid_cmp(uint8_t *ssid1, uint8_t
>  	return memcmp(ssid1, ssid2, ssid1_len);
>  }
>  
> -static inline int match_bss_no_security(struct lbs_802_11_security *secinfo,
> -					struct bss_descriptor *match_bss)
> -{
> -	if (!secinfo->wep_enabled  && !secinfo->WPAenabled
> -	    && !secinfo->WPA2enabled
> -	    && match_bss->wpa_ie[0] != MFIE_TYPE_GENERIC
> -	    && match_bss->rsn_ie[0] != MFIE_TYPE_RSN
> -	    && !(match_bss->capability & WLAN_CAPABILITY_PRIVACY))
> -		return 1;
> -	else
> -		return 0;
> -}
> -
> -static inline int match_bss_static_wep(struct lbs_802_11_security *secinfo,
> -				       struct bss_descriptor *match_bss)
> -{
> -	if (secinfo->wep_enabled && !secinfo->WPAenabled
> -	    && !secinfo->WPA2enabled
> -	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
> -		return 1;
> -	else
> -		return 0;
> -}
> -
> -static inline int match_bss_wpa(struct lbs_802_11_security *secinfo,
> -				struct bss_descriptor *match_bss)
> -{
> -	if (!secinfo->wep_enabled && secinfo->WPAenabled
> -	    && (match_bss->wpa_ie[0] == MFIE_TYPE_GENERIC)
> -	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
> -	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
> -	   )
> -		return 1;
> -	else
> -		return 0;
> -}
> -
> -static inline int match_bss_wpa2(struct lbs_802_11_security *secinfo,
> -				 struct bss_descriptor *match_bss)
> -{
> -	if (!secinfo->wep_enabled && secinfo->WPA2enabled
> -	    && (match_bss->rsn_ie[0] == MFIE_TYPE_RSN)
> -	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
> -            && (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
> -	   )
> -		return 1;
> -	else
> -		return 0;
> -}
> -
> -static inline int match_bss_dynamic_wep(struct lbs_802_11_security *secinfo,
> -					struct bss_descriptor *match_bss)
> -{
> -	if (!secinfo->wep_enabled && !secinfo->WPAenabled
> -	    && !secinfo->WPA2enabled
> -	    && (match_bss->wpa_ie[0] != MFIE_TYPE_GENERIC)
> -	    && (match_bss->rsn_ie[0] != MFIE_TYPE_RSN)
> -	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
> -		return 1;
> -	else
> -		return 0;
> -}
> -
>  static inline int is_same_network(struct bss_descriptor *src,
>  				  struct bss_descriptor *dst)
>  {
> @@ -185,78 +113,6 @@ static inline int is_same_network(struct
>  		!memcmp(src->ssid, dst->ssid, src->ssid_len));
>  }
>  
> -/**
> - *  @brief Check if a scanned network compatible with the driver settings
> - *
> - *   WEP     WPA     WPA2    ad-hoc  encrypt                      Network
> - * enabled enabled  enabled   AES     mode   privacy  WPA  WPA2  Compatible
> - *    0       0        0       0      NONE      0      0    0   yes No security
> - *    1       0        0       0      NONE      1      0    0   yes Static WEP
> - *    0       1        0       0       x        1x     1    x   yes WPA
> - *    0       0        1       0       x        1x     x    1   yes WPA2
> - *    0       0        0       1      NONE      1      0    0   yes Ad-hoc AES
> - *    0       0        0       0     !=NONE     1      0    0   yes Dynamic WEP
> - *
> - *
> - *  @param priv A pointer to struct lbs_private
> - *  @param index   Index in scantable to check against current driver settings
> - *  @param mode    Network mode: Infrastructure or IBSS
> - *
> - *  @return        Index in scantable, or error code if negative
> - */
> -static int is_network_compatible(struct lbs_private *priv,
> -				 struct bss_descriptor *bss, uint8_t mode)
> -{
> -	int matched = 0;
> -
> -	lbs_deb_enter(LBS_DEB_SCAN);
> -
> -	if (bss->mode != mode)
> -		goto done;
> -
> -	if ((matched = match_bss_no_security(&priv->secinfo, bss))) {
> -		goto done;
> -	} else if ((matched = match_bss_static_wep(&priv->secinfo, bss))) {
> -		goto done;
> -	} else if ((matched = match_bss_wpa(&priv->secinfo, bss))) {
> -		lbs_deb_scan("is_network_compatible() WPA: wpa_ie 0x%x "
> -			     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> -			     "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> -			     priv->secinfo.wep_enabled ? "e" : "d",
> -			     priv->secinfo.WPAenabled ? "e" : "d",
> -			     priv->secinfo.WPA2enabled ? "e" : "d",
> -			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
> -		goto done;
> -	} else if ((matched = match_bss_wpa2(&priv->secinfo, bss))) {
> -		lbs_deb_scan("is_network_compatible() WPA2: wpa_ie 0x%x "
> -			     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> -			     "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> -			     priv->secinfo.wep_enabled ? "e" : "d",
> -			     priv->secinfo.WPAenabled ? "e" : "d",
> -			     priv->secinfo.WPA2enabled ? "e" : "d",
> -			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
> -		goto done;
> -	} else if ((matched = match_bss_dynamic_wep(&priv->secinfo, bss))) {
> -		lbs_deb_scan("is_network_compatible() dynamic WEP: "
> -			     "wpa_ie 0x%x wpa2_ie 0x%x privacy 0x%x\n",
> -			     bss->wpa_ie[0], bss->rsn_ie[0],
> -			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
> -		goto done;
> -	}
> -
> -	/* bss security settings don't match those configured on card */
> -	lbs_deb_scan("is_network_compatible() FAILED: wpa_ie 0x%x "
> -		     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s privacy 0x%x\n",
> -		     bss->wpa_ie[0], bss->rsn_ie[0],
> -		     priv->secinfo.wep_enabled ? "e" : "d",
> -		     priv->secinfo.WPAenabled ? "e" : "d",
> -		     priv->secinfo.WPA2enabled ? "e" : "d",
> -		     (bss->capability & WLAN_CAPABILITY_PRIVACY));
> -
> -done:
> -	lbs_deb_leave_args(LBS_DEB_SCAN, "matched: %d", matched);
> -	return matched;
> -}
>  
> 
> 
> @@ -341,7 +197,6 @@ static int lbs_scan_create_channel_list(
>  	return chanidx;
>  }
>  
> -
>  /*
>   * Add SSID TLV of the form:
>   *
> @@ -359,7 +214,6 @@ static int lbs_scan_add_ssid_tlv(struct 
>  	return sizeof(ssid_tlv->header) + priv->scan_ssid_len;
>  }
>  
> -
>  /*
>   * Add CHANLIST TLV of the form
>   *
> @@ -398,7 +252,6 @@ static int lbs_scan_add_chanlist_tlv(uin
>  	return sizeof(chan_tlv->header) + size;
>  }
>  
> -
>  /*
>   * Add RATES TLV of the form
>   *
> @@ -433,7 +286,6 @@ static int lbs_scan_add_rates_tlv(uint8_
>  	return sizeof(rate_tlv->header) + i;
>  }
>  
> -
>  /*
>   * Generate the CMD_802_11_SCAN command with the proper tlv
>   * for a bunch of channels.
> @@ -482,12 +334,9 @@ out:
>  	return ret;
>  }
>  
> -
>  /**
>   *  @brief Internal function used to start a scan based on an input config
>   *
> - *  Also used from debugfs
> - *
>   *  Use the input user scan configuration information when provided in
>   *    order to send the appropriate scan commands to firmware to populate or
>   *    update the internal driver scan table
> @@ -497,7 +346,7 @@ out:
>   *
>   *  @return              0 or < 0 if error
>   */
> -static int lbs_scan_networks(struct lbs_private *priv, int full_scan)
> +int lbs_scan_networks(struct lbs_private *priv, int full_scan)
>  {
>  	int ret = -ENOMEM;
>  	struct chanscanparamset *chan_list;
> @@ -627,9 +476,6 @@ out:
>  	return ret;
>  }
>  
> -
> -
> -
>  void lbs_scan_worker(struct work_struct *work)
>  {
>  	struct lbs_private *priv =
> @@ -881,214 +727,6 @@ done:
>  }
>  
>  /**
> - *  @brief This function finds a specific compatible BSSID in the scan list
> - *
> - *  Used in association code
> - *
> - *  @param priv  A pointer to struct lbs_private
> - *  @param bssid    BSSID to find in the scan list
> - *  @param mode     Network mode: Infrastructure or IBSS
> - *
> - *  @return         index in BSSID list, or error return code (< 0)
> - */
> -struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_private *priv,
> -					      uint8_t *bssid, uint8_t mode)
> -{
> -	struct bss_descriptor *iter_bss;
> -	struct bss_descriptor *found_bss = NULL;
> -
> -	lbs_deb_enter(LBS_DEB_SCAN);
> -
> -	if (!bssid)
> -		goto out;
> -
> -	lbs_deb_hex(LBS_DEB_SCAN, "looking for", bssid, ETH_ALEN);
> -
> -	/* Look through the scan table for a compatible match.  The loop will
> -	 *   continue past a matched bssid that is not compatible in case there
> -	 *   is an AP with multiple SSIDs assigned to the same BSSID
> -	 */
> -	mutex_lock(&priv->lock);
> -	list_for_each_entry (iter_bss, &priv->network_list, list) {
> -		if (compare_ether_addr(iter_bss->bssid, bssid))
> -			continue; /* bssid doesn't match */
> -		switch (mode) {
> -		case IW_MODE_INFRA:
> -		case IW_MODE_ADHOC:
> -			if (!is_network_compatible(priv, iter_bss, mode))
> -				break;
> -			found_bss = iter_bss;
> -			break;
> -		default:
> -			found_bss = iter_bss;
> -			break;
> -		}
> -	}
> -	mutex_unlock(&priv->lock);
> -
> -out:
> -	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
> -	return found_bss;
> -}
> -
> -/**
> - *  @brief This function finds ssid in ssid list.
> - *
> - *  Used in association code
> - *
> - *  @param priv  A pointer to struct lbs_private
> - *  @param ssid     SSID to find in the list
> - *  @param bssid    BSSID to qualify the SSID selection (if provided)
> - *  @param mode     Network mode: Infrastructure or IBSS
> - *
> - *  @return         index in BSSID list
> - */
> -struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_private *priv,
> -					     uint8_t *ssid, uint8_t ssid_len,
> -					     uint8_t *bssid, uint8_t mode,
> -					     int channel)
> -{
> -	u32 bestrssi = 0;
> -	struct bss_descriptor * iter_bss = NULL;
> -	struct bss_descriptor * found_bss = NULL;
> -	struct bss_descriptor * tmp_oldest = NULL;
> -
> -	lbs_deb_enter(LBS_DEB_SCAN);
> -
> -	mutex_lock(&priv->lock);
> -
> -	list_for_each_entry (iter_bss, &priv->network_list, list) {
> -		if (   !tmp_oldest
> -		    || (iter_bss->last_scanned < tmp_oldest->last_scanned))
> -			tmp_oldest = iter_bss;
> -
> -		if (lbs_ssid_cmp(iter_bss->ssid, iter_bss->ssid_len,
> -				 ssid, ssid_len) != 0)
> -			continue; /* ssid doesn't match */
> -		if (bssid && compare_ether_addr(iter_bss->bssid, bssid) != 0)
> -			continue; /* bssid doesn't match */
> -		if ((channel > 0) && (iter_bss->channel != channel))
> -			continue; /* channel doesn't match */
> -
> -		switch (mode) {
> -		case IW_MODE_INFRA:
> -		case IW_MODE_ADHOC:
> -			if (!is_network_compatible(priv, iter_bss, mode))
> -				break;
> -
> -			if (bssid) {
> -				/* Found requested BSSID */
> -				found_bss = iter_bss;
> -				goto out;
> -			}
> -
> -			if (SCAN_RSSI(iter_bss->rssi) > bestrssi) {
> -				bestrssi = SCAN_RSSI(iter_bss->rssi);
> -				found_bss = iter_bss;
> -			}
> -			break;
> -		case IW_MODE_AUTO:
> -		default:
> -			if (SCAN_RSSI(iter_bss->rssi) > bestrssi) {
> -				bestrssi = SCAN_RSSI(iter_bss->rssi);
> -				found_bss = iter_bss;
> -			}
> -			break;
> -		}
> -	}
> -
> -out:
> -	mutex_unlock(&priv->lock);
> -	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
> -	return found_bss;
> -}
> -
> -/**
> - *  @brief This function finds the best SSID in the Scan List
> - *
> - *  Search the scan table for the best SSID that also matches the current
> - *   adapter network preference (infrastructure or adhoc)
> - *
> - *  @param priv  A pointer to struct lbs_private
> - *
> - *  @return         index in BSSID list
> - */
> -static struct bss_descriptor *lbs_find_best_ssid_in_list(struct lbs_private *priv,
> -							 uint8_t mode)
> -{
> -	uint8_t bestrssi = 0;
> -	struct bss_descriptor *iter_bss;
> -	struct bss_descriptor *best_bss = NULL;
> -
> -	lbs_deb_enter(LBS_DEB_SCAN);
> -
> -	mutex_lock(&priv->lock);
> -
> -	list_for_each_entry (iter_bss, &priv->network_list, list) {
> -		switch (mode) {
> -		case IW_MODE_INFRA:
> -		case IW_MODE_ADHOC:
> -			if (!is_network_compatible(priv, iter_bss, mode))
> -				break;
> -			if (SCAN_RSSI(iter_bss->rssi) <= bestrssi)
> -				break;
> -			bestrssi = SCAN_RSSI(iter_bss->rssi);
> -			best_bss = iter_bss;
> -			break;
> -		case IW_MODE_AUTO:
> -		default:
> -			if (SCAN_RSSI(iter_bss->rssi) <= bestrssi)
> -				break;
> -			bestrssi = SCAN_RSSI(iter_bss->rssi);
> -			best_bss = iter_bss;
> -			break;
> -		}
> -	}
> -
> -	mutex_unlock(&priv->lock);
> -	lbs_deb_leave_args(LBS_DEB_SCAN, "best_bss %p", best_bss);
> -	return best_bss;
> -}
> -
> -/**
> - *  @brief Find the best AP
> - *
> - *  Used from association worker.
> - *
> - *  @param priv         A pointer to struct lbs_private structure
> - *  @param pSSID        A pointer to AP's ssid
> - *
> - *  @return             0--success, otherwise--fail
> - */
> -int lbs_find_best_network_ssid(struct lbs_private *priv, uint8_t *out_ssid,
> -			       uint8_t *out_ssid_len, uint8_t preferred_mode,
> -			       uint8_t *out_mode)
> -{
> -	int ret = -1;
> -	struct bss_descriptor *found;
> -
> -	lbs_deb_enter(LBS_DEB_SCAN);
> -
> -	priv->scan_ssid_len = 0;
> -	lbs_scan_networks(priv, 1);
> -	if (priv->surpriseremoved)
> -		goto out;
> -
> -	found = lbs_find_best_ssid_in_list(priv, preferred_mode);
> -	if (found && (found->ssid_len > 0)) {
> -		memcpy(out_ssid, &found->ssid, IW_ESSID_MAX_SIZE);
> -		*out_ssid_len = found->ssid_len;
> -		*out_mode = found->mode;
> -		ret = 0;
> -	}
> -
> -out:
> -	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
> -	return ret;
> -}
> -
> -
> -/**
>   *  @brief Send a scan command for all available channels filtered on a spec
>   *
>   *  Used in association code and from debugfs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

