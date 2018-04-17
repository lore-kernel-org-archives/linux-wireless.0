Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33504 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbeDQW0K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 18:26:10 -0400
Received: by mail-wr0-f194.google.com with SMTP id z73so39602647wrb.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2018 15:26:10 -0700 (PDT)
Received: from mail-wr0-f180.google.com (mail-wr0-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id j89sm28822edd.37.2018.04.17.15.26.07
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Apr 2018 15:26:08 -0700 (PDT)
Received: by mail-wr0-f180.google.com with SMTP id q6so27523158wrd.6
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2018 15:26:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5AD66BD9.4000706@broadcom.com>
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
 <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org> <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
 <e16557d0891352ae0b83902faee97023@codeaurora.org> <877epbs5v7.fsf@kamboji.qca.qualcomm.com>
 <5AD11D7C.1030603@broadcom.com> <242be71eb87140c9560163c4000255b2@codeaurora.org>
 <8736zvqtcw.fsf@kamboji.qca.qualcomm.com> <20180417002854.GA186697@rodete-desktop-imager.corp.google.com>
 <5AD5AEB5.1040808@broadcom.com> <20180417160715.GA255263@rodete-desktop-imager.corp.google.com>
 <5AD66BD9.4000706@broadcom.com>
From: Brian Norris <briannorris@chromium.org>
Date: Tue, 17 Apr 2018 15:26:06 -0700
Message-ID: <CA+ASDXOoxMyTq2CVnUwvN1LBWj1Y9wpsRPKuM0tVzA80sDYG-w@mail.gmail.com> (sfid-20180418_002615_581904_034B9DAD)
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, cjhuang@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 17, 2018 at 2:49 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 4/17/2018 6:07 PM, Brian Norris wrote:
>> On Tue, Apr 17, 2018 at 10:22:13AM +0200, Arend van Spriel wrote:
>>> I believe checking command support is not really recommended. Instead, you
>>> better check NL80211_ATTR_SCHED_SCAN_MAX_REQS being non-zero (since kernel
>>> 4.12 that is).
>>
>>
>> Why not? Command support checking is what wpa_supplicant is doing.
>
>
> That's not really a good argument. A couple (or more) years ago wpa_supplicant was not doing nl80211 but wext and some other using driver private ioctls, but that did not make it the best approach.

I see what you're saying (though your comparison doesn't seem that
fair either; private ioctls are nothing like a well-defined nl80211
support list), and I'm totally good on looking at the new flag
eventually. But you still haven't answered my question ("why not?").
Is there a problem with the "supported commands" list?

> The START_SCHED_SCAN command is indeed still provided to user-space:

And as I see it, it probably needs to be for essentially forever. Or
at least a significant amount of time after wpa_supplicant stops
relying on it. (Hint: it's still using it today, with no reference to
NL80211_ATTR_SCHED_SCAN_MAX_REQS.) There's a reason the kernel has ABI
guarantees. I suspect you only get a chance to rewrite the world (WEXT
-> nl80211) a few times in the life of kernel ABIs.

Brian
