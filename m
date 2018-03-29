Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:39304 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeC2IzL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:55:11 -0400
Received: by mail-qk0-f175.google.com with SMTP id j73so5250011qke.6
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2018 01:55:10 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] mac80211: limit wmm params to comply with ETSI
 requirements
To: Johannes Berg <johannes@sipsolutions.net>,
        Peter Oh <peter.oh@bowerswilkins.com>,
        Luca Coelho <luca@coelho.fi>
References: <20180328102411.25677-1-luca@coelho.fi>
 <20180328102411.25677-3-luca@coelho.fi>
 <fc2a88ae-b908-028a-9e3b-1457404d2c06@bowerswilkins.com>
 <1522312501.5932.0.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ABCA9EB.3060808@broadcom.com> (sfid-20180329_105514_881355_C3C62EE8)
Date: Thu, 29 Mar 2018 10:55:07 +0200
MIME-Version: 1.0
In-Reply-To: <1522312501.5932.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/29/2018 10:35 AM, Johannes Berg wrote:
> On Wed, 2018-03-28 at 10:29 -0700, Peter Oh wrote:
>>> +	if (sdata->vif.type == NL80211_IFTYPE_AP)
>>> +		wmm_ac = &rrule->wmm_rule->ap[ac];
>>> +	else
>>> +		wmm_ac = &rrule->wmm_rule->client[ac];
>>> +	qparam->cw_min = max_t(u16, qparam->cw_min, wmm_ac->cw_min);
>>> +	qparam->cw_max = max_t(u16, qparam->cw_max, wmm_ac->cw_max);
>>
>> not min_t() for cw_max?
>
> No, the regulations say you have to use a long content window, hence

Guess you mean "contention window" :-p

> limiting both min and max at the lower end (hence max_t).

Do you have any reference to the new ETSI requirements. I would like to 
know their motivation for putting requirements on WMM parameters.

Regards,
Arend
