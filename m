Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f177.google.com ([74.125.82.177]:32860 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbdCBRdG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 12:33:06 -0500
Received: by mail-ot0-f177.google.com with SMTP id k4so56983360otc.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Mar 2017 09:32:16 -0800 (PST)
From: Jesse Jones <jjones@uniumwifi.com>
References: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
In-Reply-To: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
MIME-Version: 1.0
Date: Thu, 2 Mar 2017 09:32:14 -0800
Message-ID: <b285e11810b612a6a156693f34e232ac@mail.gmail.com> (sfid-20170302_183311_880293_C994F211)
Subject: RE: [PATCH v2] mac80211: mesh - always do every discovery retry
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        linux-wireless@vger.kernel.org, Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Instead of stopping path discovery when a path is found continue
> > attempting to find paths until we hit the dot11MeshHWMPmaxPREQretries
> > limit.
>
> I am not too sure whether by simply broadcasting the PREQ frame could
> actually solve the problem and this may cause problem of PREQ flooding in
> your network when the number of nodes scale. Please take note that all
> nodes need to rebroadcast the PREQ frame until target STA.

Yes, that is a real issue. We are planning on doing some further work in
this area to  try to minimize the explosions that can be seen with PREQs in
larger networks while balancing the need for reliability.

Path discovery
> should stop once the path is established. By attempting 2nd, 3rd or 4th
> doesn't guarantee the next path will be "good".

It doesn't guarantee anything of course but it does raise the probability
that the right path will be found. For example take four nodes in a ring
where the A-B, B-C, C-D links are all good but the A-D link is poor. Poor
enough that the higher data rates are hosed for that link but the basic rate
used by management frames is relatively unaffected. If we assume that the
reliability of management frames is 90% then in order for A to route to D it
needs to get a PREQ to D and a PREP back. It has two options 1) for A-D the
reliability will be 0.9^2 = 81% 2) for A-B-C-D the reliability will be 0.9^6
= 53%.

This isn't a good situation because it makes it much too easy for routing to
pick a *really* bad path. And we have seen reliability improvements with
this patch.

We have already made changes to dial way back on the number of PREQs sent
out so this patch made quite a bit of sense for us. In the default
configuration where PREQs go out every 4s I don't think we have a good
solution: picking a bad path, even for 4s, can be a horrible user experience
but PREQ volumes quickly start consuming too much airtime as network sizes
increase.

  -- Jesse
