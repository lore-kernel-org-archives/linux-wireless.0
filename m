Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm7-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.151]:26930 "HELO
	nm7-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757684Ab1F0LbS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 07:31:18 -0400
Message-ID: <1309173961.49279.YahooMailClassic@web161605.mail.bf1.yahoo.com> (sfid-20110627_133626_275303_27D01FFC)
Date: Mon, 27 Jun 2011 04:26:01 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Compat-wireless release for 2011-06-26 is baked
To: linux-wireless@vger.kernel.org,
	Fred Matthews <fredmm@hotmail.co.uk>
In-Reply-To: <blu158-w716EEAA2F0043B4BEAFB387570@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Hi all,
> I have had compiler errors when making compat-2011-06-23 -
> compat-2011-06-26. 
>   CC [M]
>  /home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.o/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.c:
> In function
> ‘nl80211_send_bss’:/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.c:3641:
> error: implicit declaration of function
> ‘genl_dump_check_consistent’/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.c:
> In function
> ‘nl80211_dump_scan’:/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.c:3731:
> error: ‘struct netlink_callback’ has no member named
> ‘seq’make[3]: ***
> [/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.o]
> Error 1make[2]: ***
> [/home/wimo/new/compat-wireless-2011-06-26/net/wireless]
> Error 2make[1]: ***
> [_module_/home/wimo/new/compat-wireless-2011-06-26] Error
> 2make[1]: Leaving directory
> `/usr/src/linux-headers-2.6.32-25-generic'make: ***
> [modules] Error 2
> There appears to be a problem with nl80211.c as you see in
> the error messages. However when I copied compat-2011-06-22
> version's nl80211.c and nl80211.h to compat-2011-06-26
> (replacing its original), it compiled and worked just fine.
> Thanks!

This patch: nl80211: use netlink consistent dump feature for BSS dumps, submitted by Johannes appears to be the culprit and I already notified him.

In the mean time you can reverse it to complete c/w compilation.

Walter
