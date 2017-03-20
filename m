Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:34466 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbdCTQmc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 12:42:32 -0400
Received: by mail-qk0-f179.google.com with SMTP id p64so114894100qke.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 09:41:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com>
References: <58B09082.7020704@cococorp.com> <1488202227.28431.9.camel@sipsolutions.net>
 <58B487A8.7000602@cococorp.com> <1488443814.8390.3.camel@sipsolutions.net> <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com>
From: Thomas Pedersen <thomas@eero.com>
Date: Mon, 20 Mar 2017 09:41:57 -0700
Message-ID: <CADjYELzEjOYEVPykd2Oqzk78Kq36zKi0FG_OfGq5u9sp3mp+WQ@mail.gmail.com> (sfid-20170320_174503_960830_ECF31077)
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
To: Jesse Jones <jjones@uniumwifi.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, agreen@cococorp.com,
        linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 2, 2017 at 9:41 AM, Jesse Jones <jjones@uniumwifi.com> wrote:
>> Hi Alexis,
>>
>> > This is loosely based on RFC5148, specifically event-triggered message
>> > generation as described in section 5.2.
>>
>> I'm confused. I see how that generally seems to apply to any mobile
>> network, but it *does* state up-front that
>>     In some instances, these problems can be solved in these lower
>>     layers, but in other instances, some help at the network and higher
>>     layers is necessary.
>>
>> I believe 802.11 *does* in fact solve these issues at lower layers. Can
>> you explain how you observed any problem in this area?
>
> Well it certainly attempts to via stuff like carrier sense. But that is not
> fool proof and any time two routers hear a frame and both decide to forward
> it immediately there is a chance that they will both sense the air at the
> same time, decide that it is clear, and lose both their forwarded frames due
> to a collision. How often that happens is hard to say but we have observed
> that exact behavior a few years ago with an 802.11 multicast routing
> protocol and adding jitter significantly improved reliability.

Have you tried performing RTS/CTS before sending path selection frames
to manage the hidden node problem?


-- 
thomas
