Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935288AbdAIKK7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 05:10:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 09 Jan 2017 15:40:57 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY to
 support BTCOEX
In-Reply-To: <1483623500.4394.18.camel@sipsolutions.net>
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
Message-ID: <6f9711ed6f6fe170b915b67a054b985b@codeaurora.org> (sfid-20170109_111109_678226_B4156143)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thank you for the reply.

On 2017-01-05 19:08, Johannes Berg wrote:
>> > IOW - why have all these bits rather than just one?
>> 
>> Hardware supports data across all the access categories, this is
>> just  meant for prioritising the traffic. f.e, If the fw/target has
>> both wlan and bt traffic queued and if VO is  set as priority, then
>> wlan VO packets will be pushed out of the radio first and then the bt
>> traffic.
> 
> Exactly. So as far as *capabilities* are concerned, why do we need so
> many bits?
> 
Is it fine to have something like this

1) We can have this btcoex_priority value as a optional value in btcoex 
enable command like below

iw phyX btcoex_state <enable| disable> [prirority(vendor spcific value)]

2) Or we can have seperate command for btcoex_priority as below

iw phyX set btcoex_priority <priority (vendor spcific value)>

Hopefully this will get rid off all the nl80211 bits.

Kindly suggest your thoughts.

Thanks,
Tamizh.
