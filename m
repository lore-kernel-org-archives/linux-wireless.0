Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:50518 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab2FYHXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 03:23:11 -0400
Received: by lbbgg6 with SMTP id gg6so8177741lbb.22
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 00:23:09 -0700 (PDT)
Message-ID: <1340608985.1631.453.camel@cumari.coelho.fi> (sfid-20120625_092315_458405_10429671)
Subject: Re: [PATCH] wlcore: drop INET dependency
From: Luciano Coelho <coelho@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Jun 2012 10:23:05 +0300
In-Reply-To: <4FE7CA1C.9030204@xenotime.net>
References: <4FE7CA1C.9030204@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(updated to my new email address).

On Sun, 2012-06-24 at 19:17 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Mainline build reports:
> 
> warning: (WL12XX) selects WLCORE which has unmet direct dependencies (NETDEVICES && WLAN && WL_TI && GENERIC_HARDIRQS && MAC80211 && INET)
> 
> The INET dependency was added in commit
> 3c6af5b54fe74b6e56efadc22927e4055d00e9fc:
>     wl1271_main.c:(.text+0x271052): undefined reference to `unregister_inetaddr_
> notifier'
>     wl1271_main.c:(.text+0x2714d7): undefined reference to `register_inetaddr_no
> tifier'
>     
>     Driver is doing some filtering based on IP addresses...
> 
> but this driver no longer has that code and it builds fine even when
> CONFIG_INET is not enabled, so drop that dependency and eliminate the
> kconfig warning message.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Luciano Coelho <luciano.coelho@nokia.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> ---

Acked-by: Luciano Coelho <coelho@ti.com>

Thanks, Randy!

This one goes quite far back, the dependency in the code was removed in
commit eb887d (wl1271: Use the ARP configuration function from
mac80211), 2 years ago.

I think this should be applied to 3.5 and maybe even to stable (is this
kind of warning important enough to deserve going to stable releases?)

John, can you take this directly into wireless.git?

--
Cheers,
Luca.

