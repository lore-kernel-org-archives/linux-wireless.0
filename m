Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:37971 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791AbZKDVmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 16:42:51 -0500
Received: by ewy3 with SMTP id 3so3619720ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 13:42:55 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Derek Smithies <derek@indranet.co.nz>
Subject: Re: compat-wireless and minstrel
Date: Wed, 4 Nov 2009 22:42:48 +0100
Cc: Adam Wozniak <awozniak@irobot.com>, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
References: <4AF0D54D.4090303@irobot.com> <200911041653.33737.chunkeey@googlemail.com> <alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz>
In-Reply-To: <alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911042242.48991.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009 22:01:39 Derek Smithies wrote:
> Hi,
> On Wed, 4 Nov 2009, Christian Lamparter wrote:
> 
> > On Wednesday 04 November 2009 02:13:49 Adam Wozniak wrote:
> >> I have two systems under test, both Dell laptops (a Latitude D630 and an
> >> Inspiron 600m) both running Ubuntu 9.10 with the latest updates, and
> >> bleeding edge compat-wireless-2009-11-02.  I'm using identical AR9170
> >> based D-Link DWA-160 USB 802.11adapters.  I'm using nuttcp to measure
> >> throughput.  I'm running in ad-hoc mode.  Both machines have the same
> >> ar9170 files in /lib/firmware.  The machines are sitting about 5 feet
> >> apart in my office.
by the way: I forgot to ask, but which firmware do you use?
If you still have *two - stage*, then get rid of it.
Since one-stage fws contain a few fixes for most temporarily MAC/BB-hiccups.

> >> I'm having occasional problems where throughput drops through the floor
> >> (0.5Mbps - 1.5Mbps).  When I cat
> >> /sys/kernel/debug/ieee80211/*/stations/*/rc_stats, one of the machines
> >> lists the full set of rates, but the other only lists 1M and 54M.  After
> >> a period of time, that machine drops 54M and lists only one rate
> >> (1Mbps), and the throughput listed by nuttcp drops accordingly.  I
> >> assume that, for whatever reason, the rates drop off the list and
> >> minstrel uses the only one left available to it.
> >>
> >> If I modify include/net/mac80211.h and force the inline function
> >> rate_supported to always return 1, this fixes the problem.  However, I
> >> think this is a band aid around some other issue.
> >>
> >> Any clues or ideas what the real issue might be here?
> 
> My guess::
> 
> When an adhoc node (call it A) merges with a second adhoc node (call it 
> B) there is a capability comparison.
> Node A looks at the rates supported by B and says,
>    "I must only transmit at rates supported by B"
>
> Some management frames don't contain a full report of the rates supported 
> by the sender.
> My view is that node A (in this example) is incorrectly determining that B 
> only supports the 1mb/sec rate. Consequently, node A fills the 
> rate_supported  array with one rate - 1mb/sec.
well, that's the thing... it sounds like something in cfg80211/mac80211 has
gone wrong. Since ibss supported/basic rates IEs should always include all
mandatory rates for the given band & mode. Therefore you should see the
2Mbit, 11Mbit, 6MBit, 12Mbit 24Mbit rates in rc_stats array as well.
 
> =====
=====

> There is no evidence that Minstrel is doing anything wrong.
?but no one said it was minstrel fault? And it clearly isn't.

But something OT: do you have already thoughts about
_extending_ minstrel to support 802.11n MCS rates?

The current endeavor is stuck and needs a kick-start.
This is partly because of a hen-egg problem: 
no driver <-> no 11n rc. But it should be easy to get
11n capable hw now (e.g. Mikrotik's R52N) and
ath9k should be the perfect testing platform right now.

nbd has/had some thought about grouping rates and options
(e.g SGI/40MHz) together to reduce the number of rates to
improve the _search for best tp_ time. But dunno, maybe he
has already something better than the proof-of-concept I wrote earlier.

Regards,
	Chr
