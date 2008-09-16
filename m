Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:2062 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYIPSFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 14:05:36 -0400
Received: by ug-out-1314.google.com with SMTP id k3so162645ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 11:05:35 -0700 (PDT)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] Redesigning aggregation on mac80211
Date: Tue, 16 Sep 2008 20:05:29 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <43e72e890809151203p213fae37ia3bd6871c3bfe2c2@mail.gmail.com>
In-Reply-To: <43e72e890809151203p213fae37ia3bd6871c3bfe2c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809162005.30002.IvDoorn@gmail.com> (sfid-20080916_200541_645838_730315AA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> We're considering redesigning how aggregation works on mac80211 to
> ensure its vendor neutral and to remove as much as redundant code in
> drivers. We'd like some feedback from people and driver developers,
> even those who haven't *yet* posted their new shiny 11n drivers, like
> Marvell or Ralink driver developers.

Well technically speaking there are 2 Ralink drivers in the Kernel already
which *should* support aggregation (rt61 and rt73).

I'm sorry I have not read the entire thread on the new aggregation support
yet, but I'll write what I know from rt61/rt73/rt2800 here anyway. :)

> Ivo, are you familiar yet with how aggregation works on Ralink
> hardware? Does the new 11n hardware require firmware? Specifically
> we're curious about how the hardware queues are managed.

Ralink defines 4 queues, 1 Management queue (can be abused as regular TX queue)
and a Beacon queue.

There is no such thing as seperate aggregation queues, as soon as the device
wants to perform aggregation it grabs a normal entry from the TX queue,
and assignes all frames to it.

rt61: 5 addresses can be provided for Aggrated frames, I am not sure
if the first is a header only frame or not.
rt73: Not sure what should be done
rt2800: 2 addresses can be provided, where the first is a header/descriptor
only address. In the second address frames can be provided.

Because the aggregated frame is created directly into a TX entry, no other
frames should go through that queue until the aggregated frame has been
completed.

I'm afraid that is currently all the information I got at this time,
It is only a little, but I never got around to fully look into the aggregation support,
although I definately want it implemented in the drivers to increase the
performance a bit. :)

Ivo
