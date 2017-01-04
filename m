Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34490 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbdADUTt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 15:19:49 -0500
Received: by mail-it0-f65.google.com with SMTP id q186so3276237itb.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 12:19:49 -0800 (PST)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id k130sm34809396ita.20.2017.01.04.12.19.48
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2017 12:19:48 -0800 (PST)
Received: by mail-io0-f174.google.com with SMTP id p42so463390990ioo.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 12:19:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483545210.7312.17.camel@sipsolutions.net>
References: <20161212015213.21323-2-andrew.zaborowski@intel.com>
 <20161212015213.21323-3-andrew.zaborowski@intel.com> <1483545210.7312.17.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Wed, 4 Jan 2017 15:19:47 -0500
Message-ID: <CAOq732JfxTx7KrPhic+2aej0ddj6igaqjcGzg+9MJ6=zDYfWAw@mail.gmail.com> (sfid-20170104_212003_357043_EE2F3248)
Subject: Re: [PATCH v2 3/4] cfg80211: Accept multiple RSSI thresholds for CQM
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 4 January 2017 at 10:53, Johannes Berg <johannes@sipsolutions.net> wrote:
> Should userspace really just get -EOPNOTSUPP back?

In what circumstance?

>
> Also, this whole business with using an array in the existing
> NL80211_ATTR_CQM_RSSI_THOLD is not very backward compatible, because an
> old kernel would interpret this as just a single value (the first one
> in your array) - ignoring entirely the fact that you requested
> multiple.
>
> Thus, you either need an nl80211 protocol feature bit (enum
> nl80211_protocol_features) or a new attribute, or so, I think.

True, I'd assumed that netlink would check for exact attribute length
with NLA_S32.

I'll add the feature bit but I wonder if it's better as a
driver/device feature (enum nl80211_ext_feature_index) so that it can
take into account whether rdev->set_cqm_rssi_range_config is set.

>
>
>> +             cqm_config = kzalloc(sizeof(struct
>> cfg80211_cqm_config) +
>> +                                  n_thresholds * sizeof(s32),
>> GFP_KERNEL);
>> +             cqm_config->rssi_hyst = hysteresis;
>
> You definitely need error checking here :)

Ok.

Best regards
