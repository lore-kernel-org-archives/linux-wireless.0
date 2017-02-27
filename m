Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34282 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbdB0PRn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 10:17:43 -0500
Received: by mail-io0-f195.google.com with SMTP id n76so4557664ioe.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 07:16:31 -0800 (PST)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com. [209.85.223.171])
        by smtp.gmail.com with ESMTPSA id s90sm1817823ioe.12.2017.02.27.07.16.30
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Feb 2017 07:16:30 -0800 (PST)
Received: by mail-io0-f171.google.com with SMTP id g18so33271023ioe.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 07:16:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1488201862.28431.5.camel@sipsolutions.net>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <CAOq732LiwZ13wVuB+wvk6nOCpY+oq=KWhcY1Au2zpcGSWsZ3uA@mail.gmail.com> <1488201862.28431.5.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Mon, 27 Feb 2017 16:16:29 +0100
Message-ID: <CAOq732L0wT+HMouihfSYu4hwxy=fh6pieMY3r2DOO1tVXxqw1A@mail.gmail.com> (sfid-20170227_161819_569660_21712365)
Subject: Re: [PATCH 1/2] mac80211_hwsim: Make sure NEW_RADIO contains final name
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 27 February 2017 at 14:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2017-02-24 at 01:08 +0100, Andrew Zaborowski wrote:
>> Also related to this I find that the HWSIM_ATTR_RADIO_NAME attributes
>> emitted contain the name string and are exactly of the right length
>> while the HWSIM_ATTR_RADIO_NAME attributes received by the kernel are
>> assumed to be NUL-terminated.
>
> I'll agree this is a bit strange - I guess it's too late to fix now
> though since userspace might assume "length/data" is the string, rather
> than "0-terminated" (especially if there's something like python
> userspace where strings can trivially contain NUL bytes).
>
> nla_put_string() would have added the NUL byte.
>
>> Is there a guarantee that a 0-byte
>> follows an attribute, or should this be changed for consistency?
>
>         [HWSIM_ATTR_RADIO_NAME] = { .type = NLA_STRING },
>
> enforces that a NUL byte *must* be present when userspace gives us the
> information, so we're save - just asymmetric.

It seems that would be NLA_NUL_STRING, whlie for NLA_STRING it's
optional, I know because I didn't add the NUL in my userspace and
things still worked.  We can copy the received nla_data into a buffer
and add the 0-byte there to support this as an option.  I don't have a
problem with the asymmetric usage though.

>
> Anyway, patch applied.

Thanks
Best regards
