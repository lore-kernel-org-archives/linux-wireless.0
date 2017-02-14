Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34497 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751983AbdBNIz7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 03:55:59 -0500
Received: by mail-it0-f65.google.com with SMTP id r141so4076700ita.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 00:55:59 -0800 (PST)
Subject: Re: [PATCH] iw: Fix bitrate output when no rate info found
To: Johannes Berg <johannes@sipsolutions.net>
References: <1487049663-2942-1-git-send-email-masashi.honma@gmail.com>
 <1487061321.4705.1.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <a2ffeab5-dd9c-1c9d-3fd1-c098a6d1e748@gmail.com> (sfid-20170214_095603_424551_B338AEF7)
Date: Tue, 14 Feb 2017 17:55:50 +0900
MIME-Version: 1.0
In-Reply-To: <1487061321.4705.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-14 17:35, Johannes Berg wrote:
> On Tue, 2017-02-14 at 14:21 +0900, Masashi Honma wrote:
>> Previously, bitrate showed uninitialized buffer when no rate info
>> found.
>
> When would this happen?

I could see in mesh STA connection with 11n and legacy mixed.
STA A has disable_ht=1.
STA B has disable_ht=0.

 > I'm not really sure this is right - perhaps we don't have
 > RATE_INFO_BITRATE(32), but still have the MCS data?

I recognized there was a issue on such a case. I will send a patch to 
wpa_supplicant. Anyway, showing string message is better than showing 
raw binary data.

> How about we just add "(unknown)" or so and not return here?

Yes. First time, I supposed to use "unknown". But in the function 
parse_bitrate(), nla_parse_nested() returns message "failed to parse 
nested rate attributes!". This explains why the bitrate is unknown. So I 
used explaining message. We could see the message like this.

tx bitrate: No rate info found!
rx bitrate: 48.0 MBit/s

Masashi Honma.
