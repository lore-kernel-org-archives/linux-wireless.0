Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53314 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdAXPPc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 10:15:32 -0500
Message-ID: <1485270914.1236.1.camel@sipsolutions.net> (sfid-20170124_161541_213590_41ACECB4)
Subject: Re: [PATCH v3 3/4] cfg80211: Accept multiple RSSI thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 24 Jan 2017 16:15:14 +0100
In-Reply-To: <20170120085509.13222-3-andrew.zaborowski@intel.com> (sfid-20170120_095526_118299_B7F54C3F)
References: <20170120085509.13222-1-andrew.zaborowski@intel.com>
         <20170120085509.13222-3-andrew.zaborowski@intel.com>
         (sfid-20170120_095526_118299_B7F54C3F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	if (n_thresholds <= 1 && rdev->ops->set_cqm_rssi_config) {
> +		const s32 disable = 0;
> +
> +		if (n_thresholds == 0) {
> +			n_thresholds = 1;
> +			thresholds = &disable;
> +		}

This doesn't really make sense,

> +		return rdev_set_cqm_rssi_config(rdev, dev,
> +						thresholds[0],
> hysteresis);
> +	}

since you return immediately afterwards anyway, and don't even use the
n_thresholds?

Perhaps also removing the earlier "hysteresis = 0" part and
distinguishing here directly to call the function with different
arguments based on enable/disable would make sense.

> +		s32 *thresholds =
> nla_data(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);

const?

johannes
