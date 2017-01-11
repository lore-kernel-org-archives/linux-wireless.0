Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32842 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757891AbdAKNZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:25:11 -0500
Message-ID: <1484141107.29931.7.camel@sipsolutions.net> (sfid-20170111_142514_102472_DB7F99F1)
Subject: Re: [PATCH v2 2/3] cfg80211: Add support to randomize TA of Public
 Action frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Wed, 11 Jan 2017 14:25:07 +0100
In-Reply-To: <1483984388-30237-2-git-send-email-jouni@qca.qualcomm.com>
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
         <1483984388-30237-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-01-09 at 19:53 +0200, Jouni Malinen wrote:
> 
> +		if (!wdev->current_bss &&
> +		    !wiphy_ext_feature_isset(
> +			    &rdev->wiphy,
> +			    NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA))
> +			return -EINVAL;
> +		if (wdev->current_bss &&
> +		    !wiphy_ext_feature_isset(
> +			    &rdev->wiphy,
> +			    NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CO
> NNECTED))
> +			return -EINVAL;
> +	}

This current_bss stuff is going to be somewhat racy, but I guess we can
live with that.

Looks good, but doesn't apply without the first patch.

johannes
