Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759143Ab3GaIuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:50:39 -0400
Message-ID: <1375260632.8289.10.camel@jlt4.sipsolutions.net> (sfid-20130731_105052_925662_9BA0255A)
Subject: Re: AP changed bandwidth, new config is  ... changed bandwidth in a
 way we can't support - disconnect - why? (intel advanced-n 6250)
From: Johannes Berg <johannes@sipsolutions.net>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
	Andy Isaacson <adi@hexapodia.org>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Wed, 31 Jul 2013 10:50:32 +0200
In-Reply-To: <201307310855.28080.a.miskiewicz@gmail.com> (sfid-20130731_085534_667847_F735B965)
References: <201307310855.28080.a.miskiewicz@gmail.com>
	 (sfid-20130731_085534_667847_F735B965)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-31 at 08:55 +0200, Arkadiusz Miskiewicz wrote:

> It basically reports:
> [79477.496067] eth1: AP 68:7f:74:06:b3:1b changed bandwidth, new config is 2422 MHz, width 1 (2422/0 MHz)
> [79477.496072] eth1: AP 68:7f:74:06:b3:1b changed bandwidth in a way we can't support - disconnect
> 
> (note I have two wrt160nl here and problem happens with both)
> 
> Any hints on why "we can't support" configuration issued by this (common) AP?

As far as I can tell, it seems to be an AP bug, but I had no idea this
was so common.

Testing with hostapd, I can switch bandwidth between 20 and 40 MHz just
fine, and it only prints "new config is ..." and then carries on.

Since you seem to be able to reproduce this easily, can you run tcpdump
with the beacon info?

sudo iw wlan0 interface add moni0 type monitor flags none
sudo ip link set moni0 up
sudo tcpdump -i moni0 -s0 -w /tmp/dump

and then wait for the problem to occur and send me (privately) the dump
file (best compressed)?

There's also a bug here:
https://bugzilla.redhat.com/show_bug.cgi?id=981445

johannes


