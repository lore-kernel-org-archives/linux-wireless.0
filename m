Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:36263 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdB0P2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 10:28:03 -0500
Received: by mail-it0-f47.google.com with SMTP id h10so60167243ith.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 07:26:17 -0800 (PST)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com. [209.85.223.175])
        by smtp.gmail.com with ESMTPSA id h69sm4430180ith.16.2017.02.27.07.26.16
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Feb 2017 07:26:16 -0800 (PST)
Received: by mail-io0-f175.google.com with SMTP id j18so33472900ioe.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 07:26:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1488202062.28431.7.camel@sipsolutions.net>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <20170223120211.22358-2-andrew.zaborowski@intel.com> <1488202062.28431.7.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Mon, 27 Feb 2017 16:26:15 +0100
Message-ID: <CAOq732JzrGxFUa5BiuO=Sz7gscRV7PFxOOyy1xf6mtmQfUqkaA@mail.gmail.com> (sfid-20170227_162833_193675_87235D59)
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in NEW_RADIO/GET_RADIO
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 27 February 2017 at 14:27, Johannes Berg <johannes@sipsolutions.net> wrote:
>> Additionally I tried to add a HWSIM_ATTR_WIPHY to report the wiphy
>> index directly without users going through wiphy name to index
>> mapping, but get_wiphy_idx() is internal to cfg80211.  The index is
>> exposed to userspace and is more useful than the name so I wonder if
>> this function should be exported from cfg80211.
>
> Do you really need the address?

As it turns out it can be read from /sys, but I do need it so I can
know what to put in HWSIM_ATTR_ADDR_RECEIVER based on the destination
addr in the frame or if I want to forward the frame to all radios.  Or
is there another way to know that?

>
> I'd actually prefer to *only* have the wiphy index, and I don't really
> see a problem with moving the wiphy_idx from struct
> cfg80211_registered_device to struct wiphy.

Ok, I'll try that.  get_wiphy_idx can stay in place, not sure if I
should just drop it.

By having *only* the wiphy index you don't mean dropping the radio
names altogether?  The don't seem useful but userspace may expect
them.

Best regards
