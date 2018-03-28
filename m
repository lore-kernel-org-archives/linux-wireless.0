Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbeC1GJz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 02:09:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 28 Mar 2018 11:39:54 +0530
From: vthiagar@codeaurora.org
To: Steve deRosier <derosier@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        steve.derosier@gmail.com
Subject: Re: [RFC 0/4] wireless: Per-sta NoAck and offload support
In-Reply-To: <CALLGbR+d8gCS0-_NV8i0K6ktL14OEiDjxVG4bvubmti7Yp5OoQ@mail.gmail.com>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
 <CALLGbR+d8gCS0-_NV8i0K6ktL14OEiDjxVG4bvubmti7Yp5OoQ@mail.gmail.com>
Message-ID: <94497d97976ff1934a08e70cc118bf56@codeaurora.org> (sfid-20180328_080959_223387_D3343692)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-27 22:18, Steve deRosier wrote:
> Hi Vasanthakumar,
> 
> On Tue, Mar 27, 2018 at 1:42 AM, Vasanthakumar Thiagarajan
> <vthiagar@codeaurora.org> wrote:
>> Adds infrastructure for driver to offload NoAck functionality, driver
>> like ath10k could make use of it. Also extends the current ndev wide
> 
> I'm not really much of a fan of adding a feature without some use of
> the feature. Perhaps if drivers "like" ath10k could use it, maybe you
> should add a patch(s) to the series where one of those drivers
> actually uses the feature.  An API without an example of use is also
> harder to evaluate effectively.

I agree driver patch using the new NoAck infrastructure would help with
understanding, ill post it once it is ready. But not sure the driver 
patch
can be part of the same series.

> 
> Additionally, if it's relevant, adding use of the feature to hwsim
> would both serve the above comment as well as provide testing
> capability.

Does not seem like this offload feature is something applicable for 
hwsim
especially mac80211 already offers the same functionality.

> 
> 
>> NoAck policy to per-station, with sta level NoAck policy configuration
>> userspace could selectively turn off/on Noack based on various 
>> connection
>> parameters of the station.
>> 
> 
> This is my own ignorance, perhaps from missing recent netdev
> conferences - can you send a link to some documentation of what NoAck
> is? Certain things in 802.11 use ack transmissions and
> interoperability would be compromised if we didn't conform to spec. I
> don't imagine that's what's going on here but I'd like to understand
> what the heck NoAck is and I failed to bring up anything useful when I
> Googled it.

The NoAck configuration is a bitmap of tid which is used to set NoAck in 
Qos
control field of the data frame for that particular tid. Perhaps you 
could
look at Ack policy subfield section in 802.11 spec.

Vasanth
