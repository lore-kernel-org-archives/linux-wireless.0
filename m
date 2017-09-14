Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42670 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbdINIyN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 04:54:13 -0400
Message-ID: <1505379250.31630.3.camel@sipsolutions.net> (sfid-20170914_105415_508864_FE7A0449)
Subject: Re: [PATCH v1] iwlwifi: mvm: allow monitor mode capture in STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: gavinli@thegavinli.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless@vger.kernel.org, Gavin Li <git@thegavinli.com>
Date: Thu, 14 Sep 2017 10:54:10 +0200
In-Reply-To: <20170914085006.15933-1-gavinli@thegavinli.com> (sfid-20170914_105018_121624_BDD0005B)
References: <20170914085006.15933-1-gavinli@thegavinli.com>
         (sfid-20170914_105018_121624_BDD0005B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-14 at 01:50 -0700, gavinli@thegavinli.com wrote:
> 
>  	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP);
>  
> +	if (mvm->hw->conf.flags & IEEE80211_CONF_MONITOR)
> +		cmd->filter_flags |=
> cpu_to_le32(MAC_FILTER_IN_PROMISC |
> +						 MAC_FILTER_IN_CONTR
> OL_AND_MGMT |
> +						 MAC_FILTER_IN_BEACO
> N |
> +						 MAC_FILTER_IN_PROBE
> _REQUEST);

[...]

> +	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
> +		mutex_lock(&mvm->mutex);
> +		ieee80211_iterate_active_interfaces(hw,
> IEEE80211_IFACE_ITER_NORMAL,
> +				iwl_mvm_monitor_changed_iterator,
> mvm);
> +		mutex_unlock(&mvm->mutex);
> +	}

This isn't right from a mac80211 perspective - at the very least it
should follow the monitor flags; checking CONF_CHANGE_MONITOR is always
a bad idea.

johannes
