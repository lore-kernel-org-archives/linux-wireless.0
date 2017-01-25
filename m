Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34415 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdAYGBp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 01:01:45 -0500
Received: by mail-io0-f194.google.com with SMTP id c80so894152iod.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2017 22:01:45 -0800 (PST)
Received: from mail-io0-f176.google.com (mail-io0-f176.google.com. [209.85.223.176])
        by smtp.gmail.com with ESMTPSA id j88sm12908312ioo.29.2017.01.24.22.01.44
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Jan 2017 22:01:44 -0800 (PST)
Received: by mail-io0-f176.google.com with SMTP id j18so6392018ioe.2
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2017 22:01:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1485271099.1236.3.camel@sipsolutions.net>
References: <20170120085509.13222-1-andrew.zaborowski@intel.com>
 <20170120085509.13222-4-andrew.zaborowski@intel.com> <1485271099.1236.3.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Wed, 25 Jan 2017 07:01:43 +0100
Message-ID: <CAOq732+ODXq+ug4OjX2ktw5Ag9rBHdUEGCO1xd7iQ9bFGey2DQ@mail.gmail.com> (sfid-20170125_070217_230212_5D505F19)
Subject: Re: [PATCH v3 4/4] mac80211: Add set_cqm_rssi_range_config
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 24 January 2017 at 16:18, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2017-01-20 at 09:55 +0100, Andrew Zaborowski wrote:
>> Support .set_cqm_rssi_range_config if the beacons are available for
>> processing in mac80211.  There's no reason that this couldn't be
>> offloaded by mac80211-based drivers but there's no driver method for
>> that added in this patch as I don't have the hardware.
>
> I thought you only required now that the level was given or something
> like that, so most HW should support it?

There's not much you can do with the current CQM one-threshold
mechanism so drivers will need this new method unfortunately.

>
>> The NL80211_EXT_FEATURE_CQM_RSSI_LIST feature is automatically set
>> during ieee80211_register_hw if the default interface being created
>> doesn't indicate beacon filtering enabled.  For drivers that don't
>> want a default interface but want to support this feature the flag
>> needs to be set explicitly in the driver.
>>
>> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
>> ---
>> changes in v3:
>>  - set NL80211_EXT_FEATURE_CQM_RSSI_LIST automatically in
>>    ieee80211_register_hw based on the default interface's
>>    IEEE80211_VIF_BEACON_FILTER flag.  This is a bit of an RFC as I'm
>>    not sure how practical it is for a driver to allow creation of
>>    additional interfaces that also implement CQM, but which filter
>>    beacons in the firmware.  In any case userspace would only
>>    receive EOPNOTSUPP on those addiitonal interfaces when trying to
>>    use the feature.
>
> That can't possibly work, since the flag can't be set by a driver at
> this point - the interface isn't brought up yet, so the driver knows
> nothing about it.

True... I'd assumed ieee80211_if_add would result in drv_add_interface
perhaps because of name similarity.

I'll update the patches.

Best regards
