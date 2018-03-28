Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0048.outbound.protection.outlook.com ([104.47.1.48]:42688
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751166AbeC1RaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 13:30:04 -0400
Subject: Re: [PATCH v3 2/3] mac80211: limit wmm params to comply with ETSI
 requirements
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20180328102411.25677-1-luca@coelho.fi>
 <20180328102411.25677-3-luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <fc2a88ae-b908-028a-9e3b-1457404d2c06@bowerswilkins.com> (sfid-20180328_193009_176801_ADF8C6D2)
Date: Wed, 28 Mar 2018 10:29:45 -0700
MIME-Version: 1.0
In-Reply-To: <20180328102411.25677-3-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	if (sdata->vif.type == NL80211_IFTYPE_AP)
> +		wmm_ac = &rrule->wmm_rule->ap[ac];
> +	else
> +		wmm_ac = &rrule->wmm_rule->client[ac];
> +	qparam->cw_min = max_t(u16, qparam->cw_min, wmm_ac->cw_min);
> +	qparam->cw_max = max_t(u16, qparam->cw_max, wmm_ac->cw_max);
not min_t() for cw_max?

Thanks,
Peter
