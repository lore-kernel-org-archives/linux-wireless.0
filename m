Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:43410 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbeHTPS4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 11:18:56 -0400
Message-ID: <1534766611.6287.20.camel@sipsolutions.net> (sfid-20180820_140337_496159_F4BCE18F)
Subject: FTM/measurement APIs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Lior David <liord@codeaurora.org>
Date: Mon, 20 Aug 2018 14:03:31 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After much delay on our side (don't ask), I'm contemplating upstream
APIs for FTM again.

Luca tells me that there are also other things to take into
consideration, notably angle of arrival. Or CIR/CFR but I have no idea
what those are, unless they're "Channel Impulse/Frequency Response" and
then perhaps that's what's used for angle measurement?

Anyway, I'll use the angle measurement as an example here.

In building the APIs for this, I'm wondering how much "generics" make
sense. We could build an API that's structured like this:

Measure(
 - [timeout]
 - [MAC randomization]
 - FTM
   - <FTM settings like TSF request?>
   - targets
     0: - MAC address
        - channel
        - ...
     1: - MAC address
        - channel
        - ...
 - Angle
   - <common settings>
   - targets
     0: - MAC address
        - channel
        - ...
)

This is very generic, so you could add something like

  - my_other_measurement
    - param1
    - param2

that's in no way connected to the target list.

However, note the duplication of MAC/channel.

You could also have only partially overlapping (or entirely disjoint)
target lists, in which case the concurrency no longer makes much sense.
The driver would have to build a combined target list, and then execute
the measurements. This implies more logic is needed.


The other option is to restrict this new API to doing "peer-related"
measurements, and build the list like this:

Peer-Measurement(
  - [timeout]
  - [MAC randomization]
  - global FTM options
    - ...
  - global angle options
    - ...
  - peers
    0: - MAC address
       - channel
       - FTM
         - ... [FTM settings]
       - Angle
         - ... [Angle settings]
    1: - MAC address
       - channel
       - ...
)

This is less generic, since it's restricted to a list of MAC/channel
pairs as the list of targets, and you can't add any other non-target
measurements to do simultaneously, at least not directly in this
structure. We could possibly still add it, but it would be more complex.

(And maybe the global options aren't really needed, for FTM the only one
I can think of is "request associated AP TSF" but that could be a per-
peer setting too.)


In a way, I prefer the second option. It's far simpler to start out
with, technically could be extended to non-peer measurements (though not
as cleanly perhaps), and matches the various location use cases far
better.


Any thoughts? Is anyone aware of any other measurements that are coming
up to be used in products that we'd want to cover here?


johannes
