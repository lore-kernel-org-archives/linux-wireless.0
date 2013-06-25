Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8322 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3FYHGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 03:06:49 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: RE: [PATCH v10 2/2] cfg80211: P2P find phase offload
Date: Tue, 25 Jun 2013 07:06:28 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A01AD22795@HASMSX106.ger.corp.intel.com> (sfid-20130625_090652_683282_B65752DA)
References: <1372063757-24286-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1372063757-24286-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
In-Reply-To: <1372063757-24286-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  /**
> + * struct cfg80211_p2p_find_params - parameters for P2P find
> + * @probe_ie: extra IE's for probe frames
> + * @probe_ie_len: length, bytes, of @probe_ie
> + * @probe_resp_ie: extra IE's for probe response frames
> + * @probe_resp_ie_len: length, bytes, of @probe_resp_ie
> + *	Driver/firmware may add additional IE's as well as modify
> + *	provided ones; typical IE's to be added are
> + *	WLAN_EID_EXT_SUPP_RATES, WLAN_EID_DS_PARAMS,
> + *	WLAN_EID_HT_CAPABILITY.
> + * @min_discoverable_interval: and
> + * @max_discoverable_interval: min/max for random multiplier of 100TU's
> + *	for the listen state duration
> + * @listen_channel: channels to listen on; not NULL

s/channels/channel/  (only a single listen channel)

> + * @start_p2p_find: start P2P find phase
> + *	Parameters include IEs for probe/probe-resp frames;
> + *	and channels to operate on.
> + *	Parameters are not retained after call, driver need to copy data if
> + *	it need it later.
> + *	P2P find can't run concurrently with ROC or scan,
> + *	conflict with scan detected by cfg80211 and -EBUSY returned;
> + *	and driver should check for ROC and return -EBUSY to indicate conflict.
> + *	While performing P2P discovery, driver should report received
> + *	probe-request and probe-response frames via cfg80211_rx_mgmt
> + *	accordingly to the rx mgmt filter, as set by mgmt_frame_register().
> + *	If device indicates NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD, it
> may
> + *	reply some matching probes and replied probes may be not reported to
> + *	the upper layers; otherwise it must not reply any probe.

Just to clarify something: even if the driver reports that it supports probe response offloading, can wpas choose not to use this capability and handle all the probe requests on its own (at least for debugging)? For example in case that the probe response IE len is zero, the driver can deduce the it should not respond to probe requests.

> @@ -1740,6 +1748,10 @@ enum nl80211_attrs {
> 
>  	NL80211_ATTR_RXMGMT_FLAGS,
> 
> +	NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL,
> +	NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL,
> +	NL80211_ATTR_LISTEN_FREQ,

You can use NL80211_ATTR_WIPHY_FREQ

> +TRACE_EVENT(rdev_start_p2p_find,
> +	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
> +		 struct cfg80211_p2p_find_params *params),
> +	TP_ARGS(wiphy, wdev, params),
> +	TP_STRUCT__entry(
> +		WIPHY_ENTRY
> +		WDEV_ENTRY
> +		__field(u32, min_di)
> +		__field(u32, max_di)
> +		__field(int, n_channels)

Can you also add here the listen channel?

Thanks,

Ilan
