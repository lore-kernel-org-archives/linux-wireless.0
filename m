Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39086 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967249AbdADPyL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 10:54:11 -0500
Message-ID: <1483545210.7312.17.camel@sipsolutions.net> (sfid-20170104_165415_762198_340B6059)
Subject: Re: [PATCH v2 3/4] cfg80211: Accept multiple RSSI thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 04 Jan 2017 16:53:30 +0100
In-Reply-To: <20161212015213.21323-3-andrew.zaborowski@intel.com> (sfid-20161212_025242_049227_EF1C6F2B)
References: <20161212015213.21323-2-andrew.zaborowski@intel.com>
         <20161212015213.21323-3-andrew.zaborowski@intel.com>
         (sfid-20161212_025242_049227_EF1C6F2B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should userspace really just get -EOPNOTSUPP back?

Also, this whole business with using an array in the existing
NL80211_ATTR_CQM_RSSI_THOLD is not very backward compatible, because an
old kernel would interpret this as just a single value (the first one
in your array) - ignoring entirely the fact that you requested
multiple.

Thus, you either need an nl80211 protocol feature bit (enum
nl80211_protocol_features) or a new attribute, or so, I think.


> +		cqm_config = kzalloc(sizeof(struct
> cfg80211_cqm_config) +
> +				     n_thresholds * sizeof(s32),
> GFP_KERNEL);
> +		cqm_config->rssi_hyst = hysteresis;

You definitely need error checking here :)

johannes
