Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34079 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752871AbcLRALZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Dec 2016 19:11:25 -0500
Received: by mail-it0-f67.google.com with SMTP id 75so6721495ite.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2016 16:11:25 -0800 (PST)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id c71sm5467772ioe.19.2016.12.17.16.11.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Dec 2016 16:11:24 -0800 (PST)
Received: by mail-io0-f174.google.com with SMTP id d9so126897835ioe.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2016 16:11:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1481643200.20412.9.camel@sipsolutions.net>
References: <20161212164500.691-1-andrew.zaborowski@intel.com> <1481643200.20412.9.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Sat, 17 Dec 2016 19:11:23 -0500
Message-ID: <CAOq732+a+nSFTtJuouxBiPPySN9RLdy-h2Fxh7VkpPuM0Wk9QA@mail.gmail.com> (sfid-20161218_011128_940471_725B358D)
Subject: Re: [PATCH v3] cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 13 December 2016 at 10:33, Johannes Berg <johannes@sipsolutions.net> wrote:
> [snip]
>
> Please fix coding style, particularly indentation.

Ok, fixed the wrapped lines.

>
>> +static void cfg80211_disconnect_wk(struct work_struct *work)
>> +{
>> +       struct cfg80211_registered_device *rdev;
>> +       struct wireless_dev *wdev;
>> +
>> +       wdev = container_of(work, struct wireless_dev, disconnect_wk);
>> +       rdev = wiphy_to_rdev(wdev->wiphy);
>
>
> Those should also be possible as initializers on the same line, I
> guess?
>
> It might also be worthwhile moving this function into a better file,
> even if then it needs a prototype in core.h (it can't be inlined anyway
> since it's called through a function pointer in the work struct)

Ok, I pick sme.c because cfg80211_disconnect is there and I renamed
this function to autodisconnect_wk to avoid confusion.

>
>> +       if (!wdev->netdev)
>> +               return;
>
> This obviously cannot happen.
>
> All the code you added to nl80211.c is racy.

Will use wdev_lock in the command handlers.

Best regards
