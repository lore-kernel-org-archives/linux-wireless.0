Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56510 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751210AbdBOI21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 03:28:27 -0500
Message-ID: <1487147305.4026.14.camel@sipsolutions.net> (sfid-20170215_092831_056205_596E7DBE)
Subject: Re: [PATCH v5 3/3] wireless: Set NL80211_EXT_FEATURE_CQM_RSSI_LIST
 in multiple drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2017 09:28:25 +0100
In-Reply-To: <20170210035023.11471-3-andrew.zaborowski@intel.com> (sfid-20170210_045049_440020_1A693483)
References: <20170210035023.11471-1-andrew.zaborowski@intel.com>
         <20170210035023.11471-3-andrew.zaborowski@intel.com>
         (sfid-20170210_045049_440020_1A693483)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-02-10 at 04:50 +0100, Andrew Zaborowski wrote:
> Set the NL80211_EXT_FEATURE_CQM_RSSI_LIST wiphy extended feature
> wholesale in all mac80211-based drivers that do not set the
> IEEE80211_VIF_BEACON_FILTER flags on their interfaces.  mac80211 will
> be processing supplied RSSI values in ieee80211_rx_mgmt_beacon and
> will detect when the thresholds set by
> ieee80211_set_cqm_rssi_range_config are crossed.  Remaining (few)
> drivers need code to enable the firmware to monitor the thresholds.
> This is mostly only compile-tested.
> 

Also applied 2 & 3 of this set, but I removed the staging driver
changes since I don't really want to deal with those. If you care much
send them to Greg separately, I guess.

johannes
