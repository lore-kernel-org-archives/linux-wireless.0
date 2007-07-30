Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:46009 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760592AbXG3XsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 19:48:23 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 40E451804B256
	for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 00:25:24 +0100 (BST)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id B4FEFFEE9
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2007 23:25:26 +0000 (UTC)
Message-ID: <46AE7361.90406@warmcat.com>
Date: Tue, 31 Jul 2007 00:25:21 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
References: <20070730023128.99E927B409F@zog.reactivated.net> <20070730145125.GC6586@tuxdriver.com> <20070730225205.GA17252@deine-taler.de> <200707310105.55863.mb@bu3sch.de>
In-Reply-To: <200707310105.55863.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Tuesday 31 July 2007, Ulrich Kunitz wrote:
>> What about add_interface/remove_interfaces and monitor interfaces?
>>
>> There seems to be difference between "hard" and "soft" monitor
>> mode. Currently I'm not sure what the semantics is. There seems to
>> be also calls to add_interface/remote_interface with if_id -1. I
>> guess that means something like all interfaces. The expected
>> behaviour is not documented for that case. 

> I don't know what you mean by hard/soft monitor.

Currently there are two distinct kinds of "monitor mode" result returned
by zd1211rw-mac80211 and iwl3945 at least.

The "hard" one to use Ulrich's name is what you want to see with Monitor
mode, the physical device is in hardware promisc and you see all kinds
of beacons and foreign network encrypted packets.

The "soft" one is a faked up repeating of incoming (and outgoing!
twice!) packets that happen to be around during the filtered operation
of the device, in the case where the device operates as Managed and is
not in hardware promisc.  In this mode, you see only your associated
station beacons and your own packets, not even packets from other
stations on your AP.

You get "hard" monitoring when you have only one virtual interface and
it is in monitor mode.  You get "soft" bogus monitoring when your
monitor mode interface is a second virtual one.

I posted a few times about this last week giving details of what you get
under what circumstances.  It really would be much better if the device
is kicked to hardware promisc if ANY virtual interface is in Monitor
mode, therefore the results are consistent regardless of the number of
virtual interfaces that happen to be around.

-Andy
