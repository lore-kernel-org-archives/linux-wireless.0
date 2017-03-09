Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:14229 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754648AbdCIPvQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 10:51:16 -0500
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
To: Johannes Berg <johannes@sipsolutions.net>,
        Jesse Jones <jjones@uniumwifi.com>, agreen@cococorp.com,
        linux-wireless@vger.kernel.org
References: <58B09082.7020704@cococorp.com>
 <1488202227.28431.9.camel@sipsolutions.net> <58B487A8.7000602@cococorp.com>
 <1488443814.8390.3.camel@sipsolutions.net>
 <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com>
 <1488803913.5761.11.camel@sipsolutions.net>
Cc: Jesse Jones <jjones@cococorp.com>
From: Matthias May <matthias.may@neratec.com>
Message-ID: <19214832-030e-2028-49a2-2db087c8c857@neratec.com> (sfid-20170309_165144_872557_7F772E74)
Date: Thu, 9 Mar 2017 16:49:59 +0100
MIME-Version: 1.0
In-Reply-To: <1488803913.5761.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/17 13:38, Johannes Berg wrote:
> 
>> Well it certainly attempts to via stuff like carrier sense. But that
>> is not fool proof and any time two routers hear a frame and both
>> decide to forward it immediately there is a chance that they will
>> both sense the air at the same time, decide that it is clear, and
>> lose both their forwarded frames due to a collision. How often that
>> happens is hard to say but we have observed that exact behavior a few
>> years ago with an 802.11 multicast routing protocol and adding jitter
>> significantly improved reliability.
> 
> I'm really surprised by this since they both should jitter their
> transmissions already between CWmin and CWmax. Is that window somehow really super small for what you're doing?
> 
> johannes
> 

Isn't CWmin and CWmax only used for retries?
We recently had the problem that on 5MHz channels probe-responses of APs
which can't hear each other (hidden node problem) always collide.
See [1] for a trace showing the problem.
Yellow is the probe-request (and ack on success), the other colours are
3 APs.
Putting probe-responses on their own queue with it's own timing results
in [2] and seems to make the problem less worse.
However the first frame still always collides, and only subsequent
retries have the randomness of cwmin/cwmax added.
5MHz channels make the problem worse since frames are 4 times longer.

I'm currently trying to find a way to add some randomness to the initial
response, which it seems this patchset attempts to solve as well
(different context though).

[1] http://may.nu/images/problem.png
[2] http://may.nu/images/jittered.png
