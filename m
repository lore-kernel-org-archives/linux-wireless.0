Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:52000 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbZKDP6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 10:58:07 -0500
Received: by iwn10 with SMTP id 10so5026284iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 07:58:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911041653.33737.chunkeey@googlemail.com>
References: <4AF0D54D.4090303@irobot.com> <200911041653.33737.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 4 Nov 2009 07:57:52 -0800
Message-ID: <43e72e890911040757t58ec910dk5ffe273c9b83aae6@mail.gmail.com>
Subject: Re: compat-wireless and minstrel
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Adam Wozniak <awozniak@irobot.com>, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, derek@indranet.co.nz
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 7:53 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Wednesday 04 November 2009 02:13:49 Adam Wozniak wrote:
>> I have two systems under test, both Dell laptops (a Latitude D630 and an
>> Inspiron 600m) both running Ubuntu 9.10 with the latest updates, and
>> bleeding edge compat-wireless-2009-11-02.  I'm using identical AR9170
>> based D-Link DWA-160 USB 802.11adapters.  I'm using nuttcp to measure
>> throughput.  I'm running in ad-hoc mode.  Both machines have the same
>> ar9170 files in /lib/firmware.  The machines are sitting about 5 feet
>> apart in my office.
>>
>> I'm having occasional problems where throughput drops through the floor
>> (0.5Mbps - 1.5Mbps).  When I cat
>> /sys/kernel/debug/ieee80211/*/stations/*/rc_stats, one of the machines
>> lists the full set of rates, but the other only lists 1M and 54M.  After
>> a period of time, that machine drops 54M and lists only one rate
>> (1Mbps), and the throughput listed by nuttcp drops accordingly.  I
>> assume that, for whatever reason, the rates drop off the list and
>> minstrel uses the only one left available to it.
>>
>> If I modify include/net/mac80211.h and force the inline function
>> rate_supported to always return 1, this fixes the problem.  However, I
>> think this is a band aid around some other issue.
>>
>> Any clues or ideas what the real issue might be here?
> no, but there are a few knobs you can play with...
>
> First of: more debug data
>
> 1. enable some ibss-related verbose messages
>   open config.mk (in your compat-wireless directory)
>   and get rid of the leading "# " <-- "sharp + space"
>   in front of # CONFIG_MAC80211_IBSS_DEBUG=y
>   (rebuild, reload, retest & checkout dmesg for a _flood_
>    of potential interesting data)

If you can just use wireless-testing directly for debugging I
recommend that as we don't use mconf and friends for cofiguration
selection so we cannot be sure the config changes you make to enable
something are indeed agreeable by current upstream Kconfig rules. That
is, unless you know what you are doing I'd advise against using
debugging on compat-wireless.

  Luis
