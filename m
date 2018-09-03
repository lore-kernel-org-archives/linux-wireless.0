Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:58816 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbeICNP1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:15:27 -0400
Message-ID: <1535964968.3437.20.camel@sipsolutions.net> (sfid-20180903_105622_501645_DC62E994)
Subject: Re: [PATCH 12/28] cfg80211: add he_capabilities (ext) IE to AP
 settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 03 Sep 2018 10:56:08 +0200
In-Reply-To: <20180831083130.15525-13-luca@coelho.fi> (sfid-20180831_105558_739876_7BB84AB1)
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180831083130.15525-13-luca@coelho.fi>
         (sfid-20180831_105558_739876_7BB84AB1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-08-31 at 11:31 +0300, Luca Coelho wrote:
> 
> +	cap = cfg80211_find_ext_ie(WLAN_EID_EXT_HE_CAPABILITY, ies, ies_len);
> +	if (cap && cap[1] >= sizeof(*params->he_cap) + 1)
> +		params->he_cap = (void *)(cap + 3);

I think this should validate that the element is actually well-formed
before passing it to the driver. To do this, need to refactor the size
checks from ieee80211_he_cap_ie_to_sta_he_cap().

johannes
