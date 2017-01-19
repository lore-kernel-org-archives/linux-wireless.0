Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44216 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752611AbdASOBv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 09:01:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 19 Jan 2017 19:22:25 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY to
 support BTCOEX
In-Reply-To: <1483958190.17582.15.camel@sipsolutions.net>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
 <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
 <1480949353.31788.27.camel@sipsolutions.net>
 <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
 <1481645351.20412.34.camel@sipsolutions.net>
 <134cc8e58ecb804b6dda0137c4c37be8@codeaurora.org>
 <1481881024.27953.14.camel@sipsolutions.net>
 <ae82112880d55451342e7a6e5a47c33f@codeaurora.org>
 <1483354130.4596.5.camel@sipsolutions.net>
 <a5521b4e246de90ed8526891c84a97e5@codeaurora.org>
 <1483623500.4394.18.camel@sipsolutions.net>
 <6f9711ed6f6fe170b915b67a054b985b@codeaurora.org>
 <1483958190.17582.15.camel@sipsolutions.net>
Message-ID: <53738f0ff79f0cf32026b9c700059fb1@codeaurora.org> (sfid-20170119_150223_256239_935F4885)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Sorry for the late response:(

On 2017-01-09 16:06, Johannes Berg wrote:
>> Is it fine to have something like this
>> 
>> 1) We can have this btcoex_priority value as a optional value in
>> btcoex enable command like below
>> 
>> iw phyX btcoex_state <enable| disable> [prirority(vendor spcific
>> value)]
>> 
>> 2) Or we can have seperate command for btcoex_priority as below
>> 
>> iw phyX set btcoex_priority <priority (vendor spcific value)>
>> 
>> Hopefully this will get rid off all the nl80211 bits.
> 
> That makes no sense.
> 
> If the bits are vendor specific, then there's no value in having this
> as an nl80211 command (rather than a vendor command) to start with.
> 
> You need to understand that I'm differentiating between *capability*
> bits and actual *priority setting* bits - please re-read the thread
> with that in mind.
> 
Those are for priority and not for capability purpose. Hardware is 
capable of
transmitting all the frames when there is a bt traffic. This is just 
setting priority for the wlan
frame, when there is a contention with BT traffic which one has to go 
out first.
Other than that hardware has the capability of sending all the frames.

This priority field is optional, if users does not want to set any 
priority then driver will force the
default priorities when bt_coex is enabled

iw phyX btcoex_state <enable| disable> [prirority]
