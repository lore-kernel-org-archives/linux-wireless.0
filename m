Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42365 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbZGZUkT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 16:40:19 -0400
Subject: Re: kernel panic ieee80211_agg_splice_packets+0x3d/0xc0 [mac80211]
From: Pavel Roskin <proski@gnu.org>
To: Jack Lau <jackelectronics@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAY0-DP2-2945C3011C834624418944BD170@phx.gbl>
References: <BAY0-DP2-2945C3011C834624418944BD170@phx.gbl>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 16:40:16 -0400
Message-Id: <1248640816.32168.42.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-07-26 at 17:35 +0000, Jack Lau wrote:
>  
> This is my very first post on a public mailing list where I am not
> into programming.  I just set up and configure Linux but have very
> little experience with programing except BASIC and shell scripting.
>  
> I have recently assembled a Linux server and router (no GUI) where I
> am using an Atheros AR9160 controller (Sparklan WMIA-268N) as an
> access point.  I am using Ubuntu 9.04 jaunty release but using hostapd
> 0.69 from the upcoming 9.10 karmic release because the one that comes
> with jaunty does not support nl80211.
>  
> The problem is that I am constantly getting kernel panics, each time
> of the same error kernel panic ieee80211_agg_splice_packets+0x3d/0xc0
> [mac80211]

You can find where it happens if you kernel is compiled with the debug
information (CONFIG_DEBUG_INFO in .config).  Load the mac80211 module in
gdb:

gdb /lib/modules/`uname -r`/kernel/net/mac80211/mac80211.ko

On the gdb prompt, run:

l *(ieee80211_agg_splice_packets+0x3d)

Actually, ieee80211_agg_splice_packets is a short function.  Perhaps you
could add debug print statements to find possible errors.  For instance,
local->hw is used.  It would crash if local is NULL.  So you add before
that place:

printk("local = %p\n", local);

Likewise, check sta, sta->ampdu_mlme.tid_tx[tid] and local->pending.  Or
just print the line numbers.  You will see which printk is run last
before the crash.

> I enclose screenshots of 3 occurrences, the last occurrence with the
> options nosmp noacpi acpi=off noapic just to see if it solves the
> problem but it didn't.  Most frustratingly, I hate it when I am the
> only person experiencing it because searching Google yields nothing
> with this error.

Chances are it's because 802.11n is not used much with ath9k in AP mode.

-- 
Regards,
Pavel Roskin
