Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39494 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbeC0QtH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 12:49:07 -0400
Received: by mail-wm0-f67.google.com with SMTP id f125so79562wme.4
        for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2018 09:49:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
From: Steve deRosier <derosier@gmail.com>
Date: Tue, 27 Mar 2018 09:48:25 -0700
Message-ID: <CALLGbR+d8gCS0-_NV8i0K6ktL14OEiDjxVG4bvubmti7Yp5OoQ@mail.gmail.com> (sfid-20180327_184938_281447_DA3C4F6E)
Subject: Re: [RFC 0/4] wireless: Per-sta NoAck and offload support
To: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vasanthakumar,

On Tue, Mar 27, 2018 at 1:42 AM, Vasanthakumar Thiagarajan
<vthiagar@codeaurora.org> wrote:
> Adds infrastructure for driver to offload NoAck functionality, driver
> like ath10k could make use of it. Also extends the current ndev wide

I'm not really much of a fan of adding a feature without some use of
the feature. Perhaps if drivers "like" ath10k could use it, maybe you
should add a patch(s) to the series where one of those drivers
actually uses the feature.  An API without an example of use is also
harder to evaluate effectively.

Additionally, if it's relevant, adding use of the feature to hwsim
would both serve the above comment as well as provide testing
capability.


> NoAck policy to per-station, with sta level NoAck policy configuration
> userspace could selectively turn off/on Noack based on various connection
> parameters of the station.
>

This is my own ignorance, perhaps from missing recent netdev
conferences - can you send a link to some documentation of what NoAck
is? Certain things in 802.11 use ack transmissions and
interoperability would be compromised if we didn't conform to spec. I
don't imagine that's what's going on here but I'd like to understand
what the heck NoAck is and I failed to bring up anything useful when I
Googled it.

- Steve
