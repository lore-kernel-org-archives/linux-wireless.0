Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbZBDXZ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:25:26 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Dan Williams <dcbw@redhat.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090204150857.GA5069@sortiz.org>
References: <20090204150857.GA5069@sortiz.org>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 18:23:57 -0500
Message-Id: <1233789837.24227.19.camel@localhost.localdomain> (sfid-20090205_002533_129658_8CBEAF4A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-04 at 16:08 +0100, Samuel Ortiz wrote:
> From: Samuel Ortiz <samuel.ortiz@intel.com>
> 
> In very dense environment, the scan result buffer can get really large, mostly
> due to the addition of proprietary IEs. iwlist fails, typically warning about:
> "print_scanning_info: Allocation failed". wpa_supplicant fails as well, after
> reallocating the scan result buffer several times, up to 132 Kbytes:
> 	[snip]
> 	Scan results did not fit - trying larger buffer (131072 bytes)
> 	ioctl[SIOCGIWSCAN]: Argument list too long
> 
> By adding a mac80211 module parameter, we can filter the scan results and keep
> only the ones userspace currently worries about, i.e. WPA1, WPA2, WMM and WPS.

A somewhat more acceptable, but still unacceptable hack would be to
figure out when the returned scan results buffer would be too large, and
automatically filter the IEs when it would be to large.

The module parameter is the largest dealbreaker here.

Dan

> To activate this feature, 1 has to be written to
> /sys/module/mac80211/parameters/ieee80211_scan_ie_filter
> 
> Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> ---
>  net/mac80211/ieee80211_i.h |    1 
>  net/mac80211/scan.c        |   65 ++++++++++++++++++++++++++++++---------------
>  net/mac80211/util.c        |   40 +++++++++++++++++++++++++++
>  3 files changed, 85 insertions(+), 21 deletions(-)
> 
> Index: wireless-testing/net/mac80211/scan.c
> ===================================================================
> --- wireless-testing.orig/net/mac80211/scan.c	2009-01-28 11:37:55.000000000 +0100
> +++ wireless-testing/net/mac80211/scan.c	2009-01-28 17:32:48.000000000 +0100
> @@ -31,6 +31,11 @@
>  #define IEEE80211_CHANNEL_TIME (HZ / 33)
>  #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
>  
> +static int ieee80211_scan_ie_filter;
> +module_param(ieee80211_scan_ie_filter, bool, 0644);
> +MODULE_PARM_DESC(ieee80211_scan_ie_filter,
> +		 "Filter IEs from scan results");
> +
>  void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
>  {
>  	spin_lock_init(&local->bss_lock);
> @@ -725,33 +730,51 @@ static void ieee80211_scan_add_ies(struc
>  	if (bss == NULL || bss->ies == NULL)
>  		return;
>  
> -	/*
> -	 * If needed, fragment the IEs buffer (at IE boundaries) into short
> -	 * enough fragments to fit into IW_GENERIC_IE_MAX octet messages.
> -	 */
>  	pos = bss->ies;
>  	end = pos + bss->ies_len;
>  
> -	while (end - pos > IW_GENERIC_IE_MAX) {
> -		next = pos + 2 + pos[1];
> -		while (next + 2 + next[1] - pos < IW_GENERIC_IE_MAX)
> -			next = next + 2 + next[1];
> +	if (ieee80211_scan_ie_filter) {
> +		while (pos - end) {
> +			next = pos + 2 + pos[1];
> +			if (ieee80211_filter_ie(pos)) {
> +				memset(&iwe, 0, sizeof(iwe));
> +				iwe.cmd = IWEVGENIE;
> +				iwe.u.data.length = next - pos;
> +				*current_ev =
> +					iwe_stream_add_point(info, *current_ev,
> +							     end_buf, &iwe,
> +							     pos);
> +			}
> +			pos = next;
> +		}
> +	} else {
> +		/*
> +		 * If needed, fragment the IEs buffer (at IE boundaries) into
> +		 * short enough fragments to fit into IW_GENERIC_IE_MAX octet
> +		 * messages.
> +		 */
> +
> +		while (end - pos > IW_GENERIC_IE_MAX) {
> +			next = pos + 2 + pos[1];
> +			while (next + 2 + next[1] - pos < IW_GENERIC_IE_MAX)
> +				next = next + 2 + next[1];
>  
> -		memset(&iwe, 0, sizeof(iwe));
> -		iwe.cmd = IWEVGENIE;
> -		iwe.u.data.length = next - pos;
> -		*current_ev = iwe_stream_add_point(info, *current_ev,
> -						   end_buf, &iwe, pos);
> +			memset(&iwe, 0, sizeof(iwe));
> +			iwe.cmd = IWEVGENIE;
> +			iwe.u.data.length = next - pos;
> +			*current_ev = iwe_stream_add_point(info, *current_ev,
> +							   end_buf, &iwe, pos);
>  
> -		pos = next;
> -	}
> +			pos = next;
> +		}
>  
> -	if (end > pos) {
> -		memset(&iwe, 0, sizeof(iwe));
> -		iwe.cmd = IWEVGENIE;
> -		iwe.u.data.length = end - pos;
> -		*current_ev = iwe_stream_add_point(info, *current_ev,
> -						   end_buf, &iwe, pos);
> +		if (end > pos) {
> +			memset(&iwe, 0, sizeof(iwe));
> +			iwe.cmd = IWEVGENIE;
> +			iwe.u.data.length = end - pos;
> +			*current_ev = iwe_stream_add_point(info, *current_ev,
> +							   end_buf, &iwe, pos);
> +		}
>  	}
>  }
>  
> Index: wireless-testing/net/mac80211/util.c
> ===================================================================
> --- wireless-testing.orig/net/mac80211/util.c	2009-01-28 11:37:41.000000000 +0100
> +++ wireless-testing/net/mac80211/util.c	2009-01-28 15:57:03.000000000 +0100
> @@ -675,6 +675,46 @@ void ieee802_11_parse_elems(u8 *start, s
>  	}
>  }
>  
> +/*
> + * ieee80211_filter_ie() tries to keep only the relevant IEs for
> + * userspace (mostly hostap code).
> + */
> +int ieee80211_filter_ie(u8 *ie)
> +{
> +	u8 id, ie_len, *pos;
> +	u8 microsoft_oui[4] = {0x00, 0x50, 0xf2};
> +	u8 wpa2_oui[3] = {0x00, 0x0f, 0xac};
> +
> +	pos = ie;
> +	id = *pos++;
> +	ie_len = *pos++;
> +
> +	switch (id) {
> +	case WLAN_EID_RSN:
> +		/* WPA2 */
> +		if (ie_len >= 3 &&
> +		    !memcmp(pos, wpa2_oui, 3))
> +			return 1;
> +
> +		return 0;
> +
> +	case WLAN_EID_VENDOR_SPECIFIC:
> +		/* We're trying to catch WPA1, WMM and WPS IEs. */
> +		if (ie_len >= 3 &&
> +		    !memcmp(pos, microsoft_oui, 3)) {
> +			if ((pos[3] == 1) || /* WPA1 */
> +			    (pos[3] == 2) || /* WMM */
> +			    (pos[3] == 4))   /* WPS */
> +				return 1;
> +		}
> +
> +		return 0;
> +
> +	default:
> +		return 0;
> +	}
> +}
> +
>  void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
>  {
>  	struct ieee80211_local *local = sdata->local;
> Index: wireless-testing/net/mac80211/ieee80211_i.h
> ===================================================================
> --- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-28 11:37:41.000000000 +0100
> +++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-28 13:49:17.000000000 +0100
> @@ -1028,6 +1028,7 @@ void ieee80211_tx_skb(struct ieee80211_s
>  		      int encrypt);
>  void ieee802_11_parse_elems(u8 *start, size_t len,
>  			    struct ieee802_11_elems *elems);
> +int ieee80211_filter_ie(u8 *ie);
>  int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
>  u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
>  			      enum ieee80211_band band);

