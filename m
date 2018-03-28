Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38597 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752941AbeC1PNg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 11:13:36 -0400
Received: by mail-wr0-f194.google.com with SMTP id m13so2595851wrj.5
        for <linux-wireless@vger.kernel.org>; Wed, 28 Mar 2018 08:13:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <94497d97976ff1934a08e70cc118bf56@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
 <CALLGbR+d8gCS0-_NV8i0K6ktL14OEiDjxVG4bvubmti7Yp5OoQ@mail.gmail.com> <94497d97976ff1934a08e70cc118bf56@codeaurora.org>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 28 Mar 2018 08:12:54 -0700
Message-ID: <CALLGbRJHrYr0ErBEaGtL8MdumgwFeCcjV3PtG9Gv5_dtgxqQqg@mail.gmail.com> (sfid-20180328_171340_676330_54405A6D)
Subject: Re: [RFC 0/4] wireless: Per-sta NoAck and offload support
To: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 27, 2018 at 11:09 PM,  <vthiagar@codeaurora.org> wrote:
> On 2018-03-27 22:18, Steve deRosier wrote:
>>
>> Hi Vasanthakumar,
>>
>> On Tue, Mar 27, 2018 at 1:42 AM, Vasanthakumar Thiagarajan
>> <vthiagar@codeaurora.org> wrote:
>>>
>>> Adds infrastructure for driver to offload NoAck functionality, driver
>>> like ath10k could make use of it. Also extends the current ndev wide
>>
>>
>> I'm not really much of a fan of adding a feature without some use of
>> the feature. Perhaps if drivers "like" ath10k could use it, maybe you
>> should add a patch(s) to the series where one of those drivers
>> actually uses the feature.  An API without an example of use is also
>> harder to evaluate effectively.
>
>
> I agree driver patch using the new NoAck infrastructure would help with
> understanding, ill post it once it is ready. But not sure the driver patch
> can be part of the same series.
>

It can. I think both Arend and Johannes already covered it.


>>
>> Additionally, if it's relevant, adding use of the feature to hwsim
>> would both serve the above comment as well as provide testing
>> capability.
>
>
> Does not seem like this offload feature is something applicable for hwsim
> especially mac80211 already offers the same functionality.
>

Well, if we desire hwsim to be able to test all the features of
mac80211 (which I don't know if that's true), then it would be
appropriate to place the functionality in hwsim as an optional
turn-on-able feature and have it utilize this API if it's turned on.
It actually would be nice to add it for that purpose. But, admittedly
it's a bit of work as you have to replicate the "hardware" offload
portion in hwsim which obviously you don't if you're working with
actual hardware that implements this feature.

I'd say it's a nice-to-have. If only to keep hwsim in-sync with
mac80211 features for testing. But, I admit I'm asking for work that
is perhaps out-of-scope.

All I really want is a driver that actually uses this as an example of use.

>
> The NoAck configuration is a bitmap of tid which is used to set NoAck in Qos
> control field of the data frame for that particular tid. Perhaps you could
> look at Ack policy subfield section in 802.11 spec.
>

Thank you. Because you gave it a name, I thought we were talking about
something more...involved. I'd appreciate if you pointed out that
context in the commit comment of the first patch in the series.
Something mentioning the Ack policy subfield specifically would give
context for those of us trying to tie it to specific 802.11
specifications.

Thanks,
- Steve
