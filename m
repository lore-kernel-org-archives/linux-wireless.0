Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48650 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2GEOor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 10:44:47 -0400
Received: by werb14 with SMTP id b14so5340689wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 07:44:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341498452.4455.44.camel@jlt3.sipsolutions.net>
References: <CADnjpYvb15WvfZVnSpNvUiUAEdUgntOS2yoCyfxDZqHu+JBA5Q@mail.gmail.com>
	<1341498452.4455.44.camel@jlt3.sipsolutions.net>
Date: Thu, 5 Jul 2012 16:44:44 +0200
Message-ID: <CADnjpYuWL1DQabomZiGPajv9108p7DwNHyTWwaKn48vVhRbMDg@mail.gmail.com> (sfid-20120705_164452_918522_50F839FB)
Subject: Re: SIOCSIFFLAGS: operation not supported error message when
 tryinging to bring up an interface in adhoc mode
From: Philippe Agostini <philippe.agostini@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

What a quick answer ! :)

Ok here's my code :

This is the part for the struct ieee80211_hw and struct wiphy
initialization (between ieee80211_alloc_hw() and
ieee80211_register_hw() calls)

Global variables

/* Supported channel */
static struct ieee80211_channel channels = {
	.band = IEEE80211_BAND_2GHZ,
	.center_freq = 2437,
	.hw_value = 0,
	.flags = 0,
	.max_antenna_gain = 3,
	.max_power = 20,
	.max_reg_power = 20,
	.beacon_found = FALSE,
	.orig_flags = 0,
	.orig_mag = 0,
	.orig_mpwr = 0,
};/* struct ieee80211_channel */

/* Supported bitrate */
static struct ieee80211_rate bitrates = {
	.flags = 0,
	/* bitrate in units of 100 Kbps */
	.bitrate = 10,
	.hw_value = 0,
	.hw_value_short = 0,
};/* struct ieee80211_rate */

/* Supported band (channel + bitrate) */
static struct ieee80211_supported_band bands = {
	.channels = &channels,
	.bitrates = &bitrates,
	.band = IEEE80211_BAND_2GHZ,
	.n_channels = 1,
	.n_bitrates = 1,
	.ht_cap.ht_supported = FALSE,
};/* struct ieee80211_supported_band */

	/* Configuration and hardware information for an 802.11 PHY */	
	struct ieee80211_hw *hw = priv->hw;
	struct wiphy *wiphy = hw->wiphy; 	

	int i = 0;
	int ret = 0;
	
	/* Test MAC address */	
	char mac_address[ETH_ALEN] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05};

	/******************************
	 * Initializing hardware data *
	 ******************************/
	
	/* Received frames include FCS field */
	/* Received signal power is given in dBm */	
	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS | IEEE80211_HW_SIGNAL_DBM;

	/* Headroom to reserve in each transmit skb */	
	hw->extra_tx_headroom = 0;

	//hw->channel_change_time = 0;
	//hw->max_signal = 100;
	//hw->max_listen_interval = 5;

	/* Number of available hardware queues */
	hw->queues = IEEE80211P_NUM_TXQ;

	//hw->rate_control_algorithm = NULL;
	hw->vif_data_size = sizeof(struct ieee80211p_vif_priv);
	//hw->sta_data_size = sizeof(struct ieee80211p_sta_priv);
	//hw->max_rates = 1;
	//hw->max_report_rates = 1;
	//hw->max_rate_tries = 1;
	//hw->napi_weight = 0;
	//hw->max_rx_aggregation = 0;
	//hw->max_tx_aggregation = 0;

	/***************************
	 * Initializing wiphy data *
	 ***************************/
        /* Regulatory domain */
	//wiphy->reg_notifier = &ieee80211p_reg_notifier;
	//ret = reg_copy_regd(&wiphy->regd,&regd);

	//wiphy->signal_type = CFG80211p_SIGNAL_TYPE_NONE;
	//wiphy->cipher_suites = NULL;
	//wiphy->n_cipher_suites = 0;
	//wiphy->retry_short = 1;
	//wiphy->retry_long = 1;
	//wiphy->frag_threshold = -1;
	//wiphy->rts_threshold = -1;
	//wiphy_net_set(&hw->wiphy,NULL);
	
	/* Set MAC address to hw->wiphy->perm_addr */
	SET_IEEE80211_PERM_ADDR(hw,&mac_address[0]);

	//wiphy->addr_mask
	//wiphy->n_addresses = 0;
	//wiphy->addresses = NULL;
	//wiphy->registered
	//wiphy->debugfsdir
	//SET_IEEE80211_DEV(hw,NULL);
	//wiphy->wext = NULL;

	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
BIT(NL80211_IFTYPE_ADHOC);

	//wiphy->iface_combinations = NULL;
	//wiphy->n_iface_combinations = 0;
	//wiphy->software_iftypes = 0;

	//wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
	//wiphy->flags = 0;
	//wiphy->features = 0;
	//wiphy->bss_priv_size = sizeof(struct ieee80211p_bss);
	//wiphy->max_scan_ssids = 0;
	//wiphy->max_sched_scan_ssids = 0;
	//wiphy->max_match_sets = 0;
	//wiphy->max_scan_ie_len = 0;
	//wiphy->max_sched_scan_ie = 0;
	//wiphy->coverage_class = 0;
	//wiphy->fw_version
	//wiphy->hw_version = 0;
	//wiphy->max_num_pmkids = 0;
	//wiphy->privid
	
	/* Describes the frequency bands a wiphy is able to operate in */
	for (i = 0;i<IEEE80211_NUM_BANDS;i++) {
		wiphy->bands[i] = NULL;
	}
	wiphy->bands[IEEE80211_BAND_2GHZ] = &bands;

	//wiphy->mgmt_stypes = NULL;
	//wiphy->available_antennas_tx = 0x3;
	//wiphy->available_antennas_rx = 0x3;
	//wiphy->probe_resp_offload = 0;
	//wiphy->max_remain_on_channel_duration = 0;
	//wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
	//wiphy->wowlan.n_patterns = 0;
	//wiphy->wowlan.pattern_max_len = 0;
	//wiphy->wowlan.pattern_min_len = 0;	
	//wiphy->ap_sme_capa = 0;
	//wiphy->ht_capa_mod_mask = NULL;

Best regards.

Philippe

On Thu, Jul 5, 2012 at 4:27 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2012-07-05 at 16:25 +0200, Philippe Agostini wrote:
>> Hello,
>>
>> I am currently developing a wifi driver and I am having trouble with
>> the adhoc mode. I am developing on Ubuntu 10.04 with kernel 2.6.32. To
>> verify that my initialization is correct, I try to bring up and
>> configure virtual interfaces. It's working in managed mode, but when I
>> try an "ifconfig wlan0 up" in adhoc mode I get the following error
>> message: "SIOCSIFFLAGS: operation not supported". At first I thought
>> that it was because of the regulatory domain, but I defined only one
>> supported channel (channel 6, F=2437 MHz) and it seems to me that iw
>> reg get tells me that on this frequency I am allowed to set up
>> wireless device in adhoc mode (country 00: (2402 - 2472 @ 40), (3, 20)
>> and no flags following).
>>
>> Are there mandatory flags to set up (besides wiphy->interface_modes =
>> BIT(NL80211_IFTYPE_ADHOC)) that I missed, or callbacks to define in
>> order to have a working adhoc interface ?
>
> This would be a lot easier if you'd post your code :-)
>
> johannes
>



-- 
P.
