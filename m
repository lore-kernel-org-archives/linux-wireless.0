Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34001 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbdCCNKz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 08:10:55 -0500
Received: by mail-qk0-f182.google.com with SMTP id s186so173813270qkb.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Mar 2017 05:10:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b285e11810b612a6a156693f34e232ac@mail.gmail.com>
References: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
 <b285e11810b612a6a156693f34e232ac@mail.gmail.com>
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Date: Fri, 3 Mar 2017 18:39:36 +0800
Message-ID: <CAEFj9874ynLcjn7AhpB-ajre3twpwHM4iEVN2ozYEGDPGErs0Q@mail.gmail.com> (sfid-20170303_141106_963315_A1892D53)
Subject: Re: [PATCH v2] mac80211: mesh - always do every discovery retry
To: Jesse Jones <jjones@uniumwifi.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Yes, that is a real issue. We are planning on doing some further work in
> this area to  try to minimize the explosions that can be seen with PREQs in
> larger networks while balancing the need for reliability.
>
> Path discovery
>> should stop once the path is established. By attempting 2nd, 3rd or 4th
>> doesn't guarantee the next path will be "good".
>
> It doesn't guarantee anything of course but it does raise the probability
> that the right path will be found. For example take four nodes in a ring
> where the A-B, B-C, C-D links are all good but the A-D link is poor. Poor
> enough that the higher data rates are hosed for that link but the basic rate
> used by management frames is relatively unaffected. If we assume that the
> reliability of management frames is 90% then in order for A to route to D it
> needs to get a PREQ to D and a PREP back. It has two options 1) for A-D the
> reliability will be 0.9^2 = 81% 2) for A-B-C-D the reliability will be 0.9^6
> = 53%.

What is round trip delay between A-D compared to A-B-C-D? 1 hop away
the throughput is reduced by half. Also if you have more nodes using
longer path, you consume more airtime leads to really bad network
performance, especially when B, C, or even D wants to start initial
data transmission.

> This isn't a good situation because it makes it much too easy for routing to
> pick a *really* bad path. And we have seen reliability improvements with
> this patch.
>
> We have already made changes to dial way back on the number of PREQs sent
> out so this patch made quite a bit of sense for us. In the default
> configuration where PREQs go out every 4s I don't think we have a good
> solution: picking a bad path, even for 4s, can be a horrible user experience

Reduce dot11MeshHWMPpreqMinInterval to send out more PREQ in your network.

> but PREQ volumes quickly start consuming too much airtime as network sizes
> increase.

One way of improving the path is either enhancing the airtime link
metric by considering the factor that you mentioned in or else
introducing vendor-specific path metric. Sending more broadcast frames
over the network won't be a good solution.

---
Chun-Yeow
