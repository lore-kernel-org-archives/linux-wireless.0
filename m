Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60743 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZKDPxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 10:53:37 -0500
Received: by ewy3 with SMTP id 3so3232790ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 07:53:42 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adam Wozniak <awozniak@irobot.com>
Subject: Re: compat-wireless and minstrel
Date: Wed, 4 Nov 2009 16:53:33 +0100
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	derek@indranet.co.nz
References: <4AF0D54D.4090303@irobot.com>
In-Reply-To: <4AF0D54D.4090303@irobot.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911041653.33737.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009 02:13:49 Adam Wozniak wrote:
> I have two systems under test, both Dell laptops (a Latitude D630 and an 
> Inspiron 600m) both running Ubuntu 9.10 with the latest updates, and 
> bleeding edge compat-wireless-2009-11-02.  I'm using identical AR9170 
> based D-Link DWA-160 USB 802.11adapters.  I'm using nuttcp to measure 
> throughput.  I'm running in ad-hoc mode.  Both machines have the same 
> ar9170 files in /lib/firmware.  The machines are sitting about 5 feet 
> apart in my office.
> 
> I'm having occasional problems where throughput drops through the floor 
> (0.5Mbps - 1.5Mbps).  When I cat 
> /sys/kernel/debug/ieee80211/*/stations/*/rc_stats, one of the machines 
> lists the full set of rates, but the other only lists 1M and 54M.  After 
> a period of time, that machine drops 54M and lists only one rate 
> (1Mbps), and the throughput listed by nuttcp drops accordingly.  I 
> assume that, for whatever reason, the rates drop off the list and 
> minstrel uses the only one left available to it.
> 
> If I modify include/net/mac80211.h and force the inline function 
> rate_supported to always return 1, this fixes the problem.  However, I 
> think this is a band aid around some other issue.
> 
> Any clues or ideas what the real issue might be here?
no, but there are a few knobs you can play with...

First of: more debug data

1. enable some ibss-related verbose messages
   open config.mk (in your compat-wireless directory)
   and get rid of the leading "# " <-- "sharp + space"
   in front of # CONFIG_MAC80211_IBSS_DEBUG=y
   (rebuild, reload, retest & checkout dmesg for a _flood_
    of potential interesting data)

2. do you think you can get a capture any beacons, auth, assoc, reassoc 
   management frames form the misbehaving setup?

3. cat /sys/kernel/debug/ieee80211/*/stations/*/rc_stats perhaps?
   (yeah, I know... sort of pointless, but people have different believes
    and somehow they have the bad tendency to really _stick_ to it!)

Regards,
	Chr
