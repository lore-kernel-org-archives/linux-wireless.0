Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34716 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941317AbdAGJne (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 04:43:34 -0500
Received: by mail-it0-f68.google.com with SMTP id q186so4401300itb.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2017 01:43:34 -0800 (PST)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com. [209.85.223.180])
        by smtp.gmail.com with ESMTPSA id u130sm6215549iod.8.2017.01.07.01.43.33
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Jan 2017 01:43:33 -0800 (PST)
Received: by mail-io0-f180.google.com with SMTP id j18so3034806ioe.2
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2017 01:43:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483616947.4394.10.camel@sipsolutions.net>
References: <20161212015213.21323-2-andrew.zaborowski@intel.com>
 <20161212015213.21323-3-andrew.zaborowski@intel.com> <1483545210.7312.17.camel@sipsolutions.net>
 <CAOq732JfxTx7KrPhic+2aej0ddj6igaqjcGzg+9MJ6=zDYfWAw@mail.gmail.com> <1483616947.4394.10.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Sat, 7 Jan 2017 04:43:31 -0500
Message-ID: <CAOq732JhLoeMQSwadM=ReBv7gAy9zb1uQ9RZAzEtvyDo7je+ww@mail.gmail.com> (sfid-20170107_104448_334801_07DB7451)
Subject: Re: [PATCH v2 3/4] cfg80211: Accept multiple RSSI thresholds for CQM
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 5 January 2017 at 06:49, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2017-01-04 at 15:19 -0500, Andrew Zaborowski wrote:
>> On 4 January 2017 at 10:53, Johannes Berg <johannes@sipsolutions.net>
>> wrote:
>> > Thus, you either need an nl80211 protocol feature bit (enum
>> > nl80211_protocol_features) or a new attribute, or so, I think.
>>
>> True, I'd assumed that netlink would check for exact attribute length
>> with NLA_S32.
>>
>> I'll add the feature bit but I wonder if it's better as a
>> driver/device feature (enum nl80211_ext_feature_index) so that it can
>> take into account whether rdev->set_cqm_rssi_range_config is set.
>
> Well, it's even more complicated than that because mac80211 may have
> the callback but still not be able to support it, with filtering,
> perhaps? Not quite sure now.

With the basic mac80211 implementation in my patch 4/4 this feature
should be set when IEEE80211_VIF_BEACON_FILTER is not set.  The
problem with a nl80211_ext_feature is that it's per wiphy instead of
per interface.  So in the case mac80211, it would need to be set if
all interfaces can accept lists of thresholds and that can change
dynamically as interfaces are added.  And nl80211 has no per-interface
features.

I wonder if it's better to add a ieee80211_hw_flags flag to advertise
this feature per wiphy, or, as an approximation, set the flag based on
the default interface that is created in ieee80211_register_hw.

Best regards
