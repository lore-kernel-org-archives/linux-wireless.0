Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38358 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYIOTDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 15:03:41 -0400
Received: by gxk9 with SMTP id 9so25854736gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 12:03:40 -0700 (PDT)
Message-ID: <43e72e890809151203p213fae37ia3bd6871c3bfe2c2@mail.gmail.com> (sfid-20080915_210344_710978_CE092643)
Date: Mon, 15 Sep 2008 12:03:39 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] Redesigning aggregation on mac80211
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're considering redesigning how aggregation works on mac80211 to
ensure its vendor neutral and to remove as much as redundant code in
drivers. We'd like some feedback from people and driver developers,
even those who haven't *yet* posted their new shiny 11n drivers, like
Marvell or Ralink driver developers.

First let me review the current design and how the different hardware
supported uses aggregation *as I understand it* so far.

I'll start with Atheros hardware and mac80211. Atheros hardware uses 4
main HW queues, one for each AC, and we also have one for beacons,
another for queued stuff after beacon (aka "Crap After Beacon") where
things like queued frames for broadcast / multicast or for frames for
stations in power save mode, and I think another hw queue for uapsd.
Right now mac80211 queues skb's for drivers into the netdev_queues.
Under the current mac80211 design we have 4 netdev_queues, one for
each AC and then there is a number of "aggregation queues". We
essentially just declare one "aggregation" queue as we do our own
queue mapping internally to our own hardware queues -- and that
consist of just mapping frames to each HQ queue as per AC.

Intel's hardware seems to have a hardware scheduler for aggregation
and although it does seem you are sending frames onto a real hardware
queue you are actually passing it to the hardware so it can itself do
the hardware scheduling onto a proper AC queue somewhere or something
(perhaps someone from Intel can elaborate a little more on this). The
Intel drivers make use of the "aggregation queues" more as buffer
space in case of retransmit on failed frames. So these aren't actually
HW queues per se as we thought they were.

We were thinking of just ditching the "aggregation queues" because
they seemed to represent actual hardware queues (and it seems they are
but in a different way) but its now evident the "aggregation queues"
are more useful as a way to move the queuing outside of the driver and
make it part of the stack.

Ivo, are you familiar yet with how aggregation works on Ralink
hardware? Does the new 11n hardware require firmware? Specifically
we're curious about how the hardware queues are managed.

Anyone know about Marvell's stuff? How about Broadcom?

  Luis
