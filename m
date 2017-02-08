Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43044 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752577AbdBHKVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 05:21:47 -0500
Message-ID: <1486548021.24745.3.camel@sipsolutions.net> (sfid-20170208_112658_484939_AD060F7A)
Subject: Re: [PATCH v4 5/5] wireless: Set NL80211_EXT_FEATURE_CQM_RSSI_LIST
 in multiple drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 08 Feb 2017 11:00:21 +0100
In-Reply-To: <20170125114344.8179-5-andrew.zaborowski@intel.com> (sfid-20170125_124404_230290_DDCD5537)
References: <20170125114344.8179-1-andrew.zaborowski@intel.com>
         <20170125114344.8179-5-andrew.zaborowski@intel.com>
         (sfid-20170125_124404_230290_DDCD5537)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-25 at 12:43 +0100, Andrew Zaborowski wrote:
> Set the NL80211_EXT_FEATURE_CQM_RSSI_LIST wiphy extended feature
> wholesale in all mac80211-based drivers that do not set the
> IEEE80211_VIF_BEACON_FILTER flags on their interfaces.  mac80211 will
> be processing supplied RSSI values in ieee80211_rx_mgmt_beacon and
> will detect when the thresholds set by
> ieee80211_set_cqm_rssi_range_config are crossed.  Remaining (few)
> drivers need code to enable the firmware to monitor the thresholds.
> This is mostly only compile-tested.

4 and 5 look fine, but obviously depend on 3.

johannes
