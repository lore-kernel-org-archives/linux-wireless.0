Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbXJIOIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 10:08:13 -0400
Subject: Re: [PATCH] libertas: clean up association debug messages
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200710091343.52596.hs4233@mail.mn-solutions.de>
References: <200710091343.52596.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 10:08:35 -0400
Message-Id: <1191938915.17254.3.camel@localhost.localdomain> (sfid-20071009_150818_556010_60D0B6A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-09 at 13:43 +0200, Holger Schurig wrote:
> This makes the debug output of all association stuff clearer by:
> 
> * adding some lbs_deb_enter()/lbs_deb_leave() calls
> * printing the return level in one place
> * lower-casing some string
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> Index: libertas-2.6/drivers/net/wireless/libertas/assoc.c
> ===================================================================
> --- libertas-2.6.orig/drivers/net/wireless/libertas/assoc.c	2007-10-09 13:51:31.000000000 +0200
> +++ libertas-2.6/drivers/net/wireless/libertas/assoc.c	2007-10-09 14:39:30.000000000 +0200
> @@ -14,28 +14,6 @@
>  static const u8 bssid_any[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
>  static const u8 bssid_off[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
>  
> -static void print_assoc_req(const char * extra, struct assoc_request * assoc_req)
> -{
> -	lbs_deb_assoc(
> -	       "#### Association Request: %s\n"
> -	       "       flags:      0x%08lX\n"
> -	       "       SSID:       '%s'\n"
> -	       "       channel:    %d\n"
> -	       "       band:       %d\n"
> -	       "       mode:       %d\n"
> -	       "       BSSID:      " MAC_FMT "\n"
> -	       "       Encryption:%s%s%s\n"
> -	       "       auth:       %d\n",
> -	       extra, assoc_req->flags,
> -	       escape_essid(assoc_req->ssid, assoc_req->ssid_len),
> -	       assoc_req->channel, assoc_req->band, assoc_req->mode,
> -	       MAC_ARG(assoc_req->bssid),
> -	       assoc_req->secinfo.WPAenabled ? " WPA" : "",
> -	       assoc_req->secinfo.WPA2enabled ? " WPA2" : "",
> -	       assoc_req->secinfo.wep_enabled ? " WEP" : "",
> -	       assoc_req->secinfo.auth_mode);
> -}
> -
>  
>  static int assoc_helper_essid(wlan_private *priv,
>                                struct assoc_request * assoc_req)
> @@ -54,7 +32,7 @@ static int assoc_helper_essid(wlan_priva
>  	if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags))
>  		channel = assoc_req->channel;
>  
> -	lbs_deb_assoc("New SSID requested: '%s'\n",
> +	lbs_deb_assoc("SSID '%s' requested\n",
>  	              escape_essid(assoc_req->ssid, assoc_req->ssid_len));
>  	if (assoc_req->mode == IW_MODE_INFRA) {
>  		libertas_send_specific_ssid_scan(priv, assoc_req->ssid,
> @@ -63,13 +41,13 @@ static int assoc_helper_essid(wlan_priva
>  		bss = libertas_find_ssid_in_list(adapter, assoc_req->ssid,
>  				assoc_req->ssid_len, NULL, IW_MODE_INFRA, channel);
>  		if (bss != NULL) {
> -			lbs_deb_assoc("SSID found in scan list, associating\n");
>  			memcpy(&assoc_req->bss, bss, sizeof(struct bss_descriptor));
>  			ret = wlan_associate(priv, assoc_req);
>  		} else {
>  			lbs_deb_assoc("SSID not found; cannot associate\n");
>  		}
> -	} else if (assoc_req->mode == IW_MODE_ADHOC) {
> +	} else
> +	if (assoc_req->mode == IW_MODE_ADHOC) {

This is wrong formatting, no?  The 'else if' should be on the same
line...  Unless kernel style guidelines say otherwise?  The way you've
patched it makes it less clear that the if is actually part of the else.

>  		/* Scan for the network, do not save previous results.  Stale
>  		 *   scan data will cause us to join a non-existant adhoc network
>  		 */
> @@ -136,6 +114,8 @@ static int assoc_helper_associate(wlan_p
>  {
>  	int ret = 0, done = 0;
>  
> +	lbs_deb_enter(LBS_DEB_ASSOC);
> +
>  	/* If we're given and 'any' BSSID, try associating based on SSID */
>  
>  	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
> @@ -143,19 +123,14 @@ static int assoc_helper_associate(wlan_p
>  		    && compare_ether_addr(bssid_off, assoc_req->bssid)) {
>  			ret = assoc_helper_bssid(priv, assoc_req);
>  			done = 1;
> -			if (ret) {
> -				lbs_deb_assoc("ASSOC: bssid: ret = %d\n", ret);
> -			}
>  		}
>  	}
>  
>  	if (!done && test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
>  		ret = assoc_helper_essid(priv, assoc_req);
> -		if (ret) {
> -			lbs_deb_assoc("ASSOC: bssid: ret = %d\n", ret);
> -		}
>  	}
>  
> +	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
>  	return ret;
>  }
>  
> @@ -192,18 +167,24 @@ done:
>  
>  static int update_channel(wlan_private * priv)
>  {
> +	int ret;
>  	/* the channel in f/w could be out of sync, get the current channel */
> -	return libertas_prepare_and_send_command(priv, CMD_802_11_RF_CHANNEL,
> +	lbs_deb_enter(LBS_DEB_ASSOC);
> +	ret = libertas_prepare_and_send_command(priv, CMD_802_11_RF_CHANNEL,
>  				    CMD_OPT_802_11_RF_CHANNEL_GET,
>  				    CMD_OPTION_WAITFORRSP, 0, NULL);
> +	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
> +	return ret;
>  }
>  
>  void libertas_sync_channel(struct work_struct *work)
>  {
>  	wlan_private *priv = container_of(work, wlan_private, sync_channel);
>  
> +	lbs_deb_enter(LBS_DEB_ASSOC);
>  	if (update_channel(priv) != 0)
>  		lbs_pr_info("Channel synchronization failed.");
> +	lbs_deb_leave(LBS_DEB_ASSOC);
>  }
>  
>  static int assoc_helper_channel(wlan_private *priv,
> @@ -435,40 +416,51 @@ static int assoc_helper_wpa_ie(wlan_priv
>  static int should_deauth_infrastructure(wlan_adapter *adapter,
>                                          struct assoc_request * assoc_req)
>  {
> +	int ret = 0;
> +
> +	lbs_deb_enter(LBS_DEB_ASSOC);
> +
>  	if (adapter->connect_status != LIBERTAS_CONNECTED)
>  		return 0;
>  
>  	if (test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
> -		lbs_deb_assoc("Deauthenticating due to new SSID in "
> -			" configuration request.\n");
> -		return 1;
> +		lbs_deb_assoc("Deauthenticating due to new SSID\n");
> +		ret = 1;
> +		goto out;
>  	}
>  
>  	if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
>  		if (adapter->secinfo.auth_mode != assoc_req->secinfo.auth_mode) {
> -			lbs_deb_assoc("Deauthenticating due to updated security "
> -				"info in configuration request.\n");
> -			return 1;
> +			lbs_deb_assoc("Deauthenticating due to new security\n");
> +			ret = 1;
> +			goto out;
>  		}
>  	}
>  
>  	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
> -		lbs_deb_assoc("Deauthenticating due to new BSSID in "
> -			" configuration request.\n");
> -		return 1;
> +		lbs_deb_assoc("Deauthenticating due to new BSSID\n");
> +		ret = 1;
> +		goto out;
>  	}
>  
>  	if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags)) {
> -		lbs_deb_assoc("Deauthenticating due to channel switch.\n");
> -		return 1;
> +		lbs_deb_assoc("Deauthenticating due to channel switch\n");
> +		ret = 1;
> +		goto out;
>  	}
>  
>  	/* FIXME: deal with 'auto' mode somehow */
>  	if (test_bit(ASSOC_FLAG_MODE, &assoc_req->flags)) {
> -		if (assoc_req->mode != IW_MODE_INFRA)
> -			return 1;
> +		if (assoc_req->mode != IW_MODE_INFRA) {
> +			lbs_deb_assoc("Deauthenticating due to leaving "
> +				"infra mode\n");
> +			ret = 1;
> +			goto out;
> +		}
>  	}
>  
> +out:
> +	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
>  	return 0;
>  }
>  
> @@ -476,6 +468,8 @@ static int should_deauth_infrastructure(
>  static int should_stop_adhoc(wlan_adapter *adapter,
>                               struct assoc_request * assoc_req)
>  {
> +	lbs_deb_enter(LBS_DEB_ASSOC);
> +
>  	if (adapter->connect_status != LIBERTAS_CONNECTED)
>  		return 0;
>  
> @@ -495,6 +489,7 @@ static int should_stop_adhoc(wlan_adapte
>  			return 1;
>  	}
>  
> +	lbs_deb_leave(LBS_DEB_ASSOC);
>  	return 0;
>  }
>  
> @@ -518,7 +513,24 @@ void libertas_association_worker(struct 
>  	if (!assoc_req)
>  		goto done;
>  
> -	print_assoc_req(__func__, assoc_req);
> +	lbs_deb_assoc(
> +		"Association Request:\n"
> +		"    flags:     0x%08lx\n"
> +		"    SSID:      '%s'\n"
> +		"    chann:     %d\n"
> +		"    band:      %d\n"
> +		"    mode:      %d\n"
> +		"    BSSID:     " MAC_FMT "\n"
> +		"    secinfo:  %s%s%s\n"
> +		"    auth_mode: %d\n",
> +		assoc_req->flags,
> +		escape_essid(assoc_req->ssid, assoc_req->ssid_len),
> +		assoc_req->channel, assoc_req->band, assoc_req->mode,
> +		MAC_ARG(assoc_req->bssid),
> +		assoc_req->secinfo.WPAenabled ? " WPA" : "",
> +		assoc_req->secinfo.WPA2enabled ? " WPA2" : "",
> +		assoc_req->secinfo.wep_enabled ? " WEP" : "",
> +		assoc_req->secinfo.auth_mode);
>  
>  	/* If 'any' SSID was specified, find an SSID to associate with */
>  	if (test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)
> @@ -535,6 +547,7 @@ void libertas_association_worker(struct 
>  	if (find_any_ssid) {
>  		u8 new_mode;
>  
> +lbs_deb_assoc("##HS find 'any' essid\n");

This must have snuck in :)

>  		ret = libertas_find_best_network_ssid(priv, assoc_req->ssid,
>  				&assoc_req->ssid_len, assoc_req->mode, &new_mode);
>  		if (ret) {
> @@ -563,7 +576,8 @@ void libertas_association_worker(struct 
>  					ret);
>  			}
>  		}
> -	} else if (adapter->mode == IW_MODE_ADHOC) {
> +	} else
> +	if (adapter->mode == IW_MODE_ADHOC) {

Same as above...

>  		if (should_stop_adhoc(adapter, assoc_req)) {
>  			ret = libertas_stop_adhoc_network(priv);
>  			if (ret) {
> @@ -578,59 +592,41 @@ void libertas_association_worker(struct 
>  	/* Send the various configuration bits to the firmware */
>  	if (test_bit(ASSOC_FLAG_MODE, &assoc_req->flags)) {
>  		ret = assoc_helper_mode(priv, assoc_req);
> -		if (ret) {
> -			lbs_deb_assoc("ASSOC(:%d) mode: ret = %d\n",
> -			              __LINE__, ret);
> +		if (ret)
>  			goto out;
>  		}

This brace ^^^ should have one less tab in front, no?  Otherwise it's
not aligned with the 'if (test_bit...' that it's meant for?

> -	}
>  
>  	if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags)) {
>  		ret = assoc_helper_channel(priv, assoc_req);
> -		if (ret) {
> -			lbs_deb_assoc("ASSOC(:%d) channel: ret = %d\n",
> -			              __LINE__, ret);
> +		if (ret)
>  			goto out;
>  		}
> -	}

Same as above.
 
>  	if (   test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)
>  	    || test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
>  		ret = assoc_helper_wep_keys(priv, assoc_req);
> -		if (ret) {
> -			lbs_deb_assoc("ASSOC(:%d) wep_keys: ret = %d\n",
> -			              __LINE__, ret);
> +		if (ret)
>  			goto out;
>  		}
> -	}

Same as above.

>  	if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
>  		ret = assoc_helper_secinfo(priv, assoc_req);
> -		if (ret) {
> -			lbs_deb_assoc("ASSOC(:%d) secinfo: ret = %d\n",
> -			              __LINE__, ret);
> +		if (ret)
>  			goto out;
>  		}
> -	}

Same as above.
 
>  	if (test_bit(ASSOC_FLAG_WPA_IE, &assoc_req->flags)) {
>  		ret = assoc_helper_wpa_ie(priv, assoc_req);
> -		if (ret) {
> -			lbs_deb_assoc("ASSOC(:%d) wpa_ie: ret = %d\n",
> -			              __LINE__, ret);
> +		if (ret)
>  			goto out;
>  		}
> -	}

Same as above.
 
>  	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)
>  	    || test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
>  		ret = assoc_helper_wpa_keys(priv, assoc_req);
> -		if (ret) {
> -			lbs_deb_assoc("ASSOC(:%d) wpa_keys: ret = %d\n",
> -			              __LINE__, ret);
> +		if (ret)
>  			goto out;
>  		}
> -	}

Same as above.
 
>  	/* SSID/BSSID should be the _last_ config option set, because they
>  	 * trigger the association attempt.
> @@ -693,6 +689,7 @@ struct assoc_request * wlan_get_associat
>  {
>  	struct assoc_request * assoc_req;
>  
> +	lbs_deb_enter(LBS_DEB_ASSOC);
>  	if (!adapter->pending_assoc_req) {
>  		adapter->pending_assoc_req = kzalloc(sizeof(struct assoc_request),
>  		                                     GFP_KERNEL);
> @@ -759,7 +756,6 @@ struct assoc_request * wlan_get_associat
>  		assoc_req->wpa_ie_len = adapter->wpa_ie_len;
>  	}
>  
> -	print_assoc_req(__func__, assoc_req);
> -
> +	lbs_deb_leave(LBS_DEB_ASSOC);
>  	return assoc_req;
>  }

