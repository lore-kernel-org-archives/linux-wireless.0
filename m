Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snt0-omc4-s34.snt0.hotmail.com ([65.55.90.237]:42124 "EHLO
	snt0-omc4-s34.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbZHBMzH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 08:55:07 -0400
Message-ID: <SNT102-W3920579242C5261F6A86DBBD0E0@phx.gbl>
From: Jack Lau <jackelectronics@hotmail.com>
To: <proski@gnu.org>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: kernel panic ieee80211_agg_splice_packets+0x3d/0xc0 [mac80211]
Date: Sun, 2 Aug 2009 12:55:08 +0000
In-Reply-To: <1248821338.5206.12.camel@mj>
References: <BAY0-DP2-2945C3011C834624418944BD170@phx.gbl>
	 <1248640816.32168.42.camel@mj>
   	 <BAY0-DP3-241EC0B1A0E15935251FCBBD150@phx.gbl>
   <1248821338.5206.12.camel@mj>  
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Pavel

> If you are using compat-wireless, I suggest that you try the current
> kernel from wireless-testing. It was quite unstable a few days ago, but
> it should be cleaned up by now. Since you are using the AP mode, you'll
> need this patch, it's still not applied as of now:
>
> http://marc.info/?l=linux-wireless&m=124871936602667&w=2
>
> compat-wireless is great if everything is working, but if something is
> broken, the first suspicion is that compat-wireless doesn't backport
> something correctly.

I have downloaded v2.6.31-rc4-29204-g6b3a8c9 and compiled it with debugging options mac80211 and ath9k enabled.

> You can find where it happens if you kernel is compiled with the debug
> information (CONFIG_DEBUG_INFO in .config). Load the mac80211 module in
> gdb:
>
> gdb /lib/modules/`uname -r`/kernel/net/mac80211/mac80211.ko
>
> On the gdb prompt, run:
>
> l *(ieee80211_agg_splice_packets+0x3d)

I have compiled the above kernel with debug enabled and the symbols are now present and shows me the lines of code concerned.

> Actually, ieee80211_agg_splice_packets is a short function. Perhaps you
> could add debug print statements to find possible errors. For instance,
> local->hw is used. It would crash if local is NULL. So you add before
> that place:
>
> printk("local = %p\n", local);

I have inserted the above printk just above and now prints out on kernel messages.

> Likewise, check sta, sta->ampdu_mlme.tid_tx[tid] and local->pending. Or
> just print the line numbers. You will see which printk is run last
> before the crash.

I am not too sure what you mean by your first sentence. I have added just the one printk line as above.

I now enclose log files of kernel messages from the start of the boot sessions right to the crash.

Also, for some strange reason, the system does not crash when I do a killall on hostapd (I have set it automatically load on startup) and then reload it as detailed on the second log enclosed. This did not use to happen with earlier pre-compiled kernels packages from Ubuntu such as linux-image-2.6.31-4-generic and linux-image-2.6.28-14 where it used to crash all the time.

Regards


Jack
_________________________________________________________________
Windows Live Messenger: Thanks for 10 great years—enjoy free winks and emoticons.
http://clk.atdmt.com/UKM/go/157562755/direct/01/