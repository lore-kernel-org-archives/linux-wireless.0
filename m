Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:37018 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbeH2MtR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 08:49:17 -0400
Message-ID: <1535532794.5215.20.camel@sipsolutions.net> (sfid-20180829_105328_767089_3D258F26)
Subject: Re: [PATCH v2 3/3] ath10k: management tx ack rssi capability check
From: Johannes Berg <johannes@sipsolutions.net>
To: Balaji Pothunoori <bpothuno@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Aug 2018 10:53:14 +0200
In-Reply-To: <1532006789-32454-4-git-send-email-bpothuno@codeaurora.org> (sfid-20180719_152706_974046_A35360D2)
References: <1532006789-32454-1-git-send-email-bpothuno@codeaurora.org>
         <1532006789-32454-4-git-send-email-bpothuno@codeaurora.org>
         (sfid-20180719_152706_974046_A35360D2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-07-19 at 18:56 +0530, Balaji Pothunoori wrote:
> 
>  
> -	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
> +	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map) ||
> +	    test_bit(WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS, ar->wmi.svc_map))
>  		wiphy_ext_feature_set(ar->hw->wiphy,
> -				NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
> +			NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);

You should use the new name, and fix indentation.

johannes
