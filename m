Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37408 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933376AbdCHAop (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 19:44:45 -0500
Message-ID: <1488933811.4723.1.camel@sipsolutions.net> (sfid-20170308_014621_102295_69E5699A)
Subject: rate mask resulting in no usable rates - WARN_ON
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ben Greear <greearb@candelatech.com>
Date: Wed, 08 Mar 2017 01:43:31 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben, all,

There are scenarios where setting a rate mask from userspace will
result in no usable rates, e.g. when you set a rate mask of 6,9,12
MBps, and the AP reports it only supports 36,48,54 (which some APs do).
This results in a WARN_ONCE() hitting since we can't find a usable
rate, and then we fall back to 1 or 6 MBps, which is a mandatory rate
but the AP didn't report it as supported (is it thus misbehaving?
doesn't matter much though)

I'd go and reject a setting that results in no usable rates, but
because the setting is sticky this is very complicated (it's a good
thing I insisted we have very few of these, but some I couldn't get
around).

Would there be any objection to making this setting non-sticky, i.e.
always resetting it for a new association? It's kinda designed to be
sticky, with the per-band setting, but clearly this is causing big
problems.

Alternatively, the really proper behaviour would be for this setting to
actually influence whether or not we can connect to the AP, but that
will just lead to massive problems because wpa_s will be unaware and
will pick APs that we can't support with the setting etc. Therefore I'm
not going to do this.

I could also reset the setting only when it would result in no usable
rates, but that doesn't even give userspace any good way at all to
predict it.

Is anyone - other than ChromeOS, which sets it just after association -
actually using this?

johannes
