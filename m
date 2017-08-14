Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0055.outbound.protection.outlook.com ([104.47.40.55]:41664
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751098AbdHNUgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 16:36:42 -0400
Subject: Re: [PATCH] nl80211: add an option to allow MFP without requiring it
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "avinashp@quantenna.com" <avinashp@quantenna.com>,
        "sergey.matyukevich.os@quantenna.com"
        <sergey.matyukevich.os@quantenna.com>
References: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
 <a35aea64-b391-2719-c8cb-92ef9c9288c7@broadcom.com>
 <1723b617-2272-330e-958c-bb988aa504d5@quantenna.com>
 <1502741597.8162.1.camel@intel.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <ac8bfacb-9b2c-c3e5-12df-a5f7b4711bce@quantenna.com> (sfid-20170814_223646_577625_C93BBE9E)
Date: Mon, 14 Aug 2017 13:36:36 -0700
MIME-Version: 1.0
In-Reply-To: <1502741597.8162.1.camel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/14/2017 01:13 PM, Grumbach, Emmanuel wrote:
>> It is kind of not clear right now for drivers where to get
>> information from:
>> - NL attributes passed from userspace and forwarded to a driver
> 
> Since those exist, it seems to make more sense to me to use those
> rather than any in-driver decided policy. Usually, deciding upon
> policies from lower levels is frowned upon I'd say.

I agree, what I mean is that drivers should know where to take this 
information from, if there are multiple sources.

An example are HT/VHT capabilities for start_ap command: they can be 
parsed directly by drivers by looking at beacon's IEs in 
"cfg80211_ap_settings". At the same time those are also parsed by 
nl80211 which fills cfg80211_ap_settings::ht_cap, 
cfg80211_ap_settings::vht_cap.
Why HT/VHT caps are not passed directly from usespace as one of NL 
attributes? I guess because there is not much point in it since 
userspace passes entire IE set anyway, which can be used by lower levels.


> 
>> - IEs passed from userspace, parsed by nl80211 and forwarded to a
>> driver
>> - IEs that are passed from userspace and parsed by drivers directly
>>
>>>
>>> Thanks,
>>> Arend
>>
>>
