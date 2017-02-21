Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37060 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdBUBrl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 20:47:41 -0500
Received: by mail-it0-f54.google.com with SMTP id 203so29059966ith.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2017 17:47:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1487633211.484.1.camel@sipsolutions.net>
References: <CALs6+XLDZLmc6JWMPun4sT+W_M4Cqh47LcK+HjiuZ8gKFLkbTA@mail.gmail.com>
 <1487633211.484.1.camel@sipsolutions.net>
From: "Thomas d'Otreppe" <tdotreppe@gmail.com>
Date: Mon, 20 Feb 2017 18:46:59 -0700
Message-ID: <CALs6+X+p_bANrbXjuQpbRWj_qpK7ssERMMKRdVDzH1yEOvT5fA@mail.gmail.com> (sfid-20170221_024745_193285_C725BD7D)
Subject: Re: Monitor mode 'cook' flag meaning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do you have any example of devices where control or otherbss would be
useful? Would both be for FullMAC devices?

Thanks,

Thomas


On Mon, Feb 20, 2017 at 4:26 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2017-02-20 at 16:22 -0700, Thomas d'Otreppe wrote:
>> I've been looking through the different flags for monitor mode in iw.
>> Most of them are rather obvious (and well explained) but what is
>> exactly 'cooked mode'?
>>
>> I looked up in Google and in the linux-wireless wiki (nothing in
>> there) and I only found explanations in 2 patches (most likely still
>> in the source code) which are still vague:
>> - A monitor interface in "cooked" mode will see all frames that
>> mac80211 has not used internally
>> - report frames after processing. Overrides all other flags.
>>
>> Thinking about what the first one says, it doesn't seem any different
>> than just fcsfail.
>
> No, that's the wrong idea. "cook" means that e.g. auth frames that
> mac80211 didn't actually look at will be sent there.
>
> Anyway, ignore cooked mode. It's only for ancient hostapd versions.
>
>> I don't even see when control or otherbss should be needed since
>> 'none' is already providing them.
>
> Those are hw-dependent.
>
> johannes
