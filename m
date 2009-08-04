Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27823 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbZHDUdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 16:33:06 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 13:33:07 -0700
Date: Tue, 4 Aug 2009 13:33:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jack Lau <jackelectronics@hotmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath9k kernel panic ieee_agg_splice_packets
Message-ID: <20090804203303.GA21890@mosca>
References: <BAY0-DP4-20A46D98D5EDA86B774180BD0C0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <BAY0-DP4-20A46D98D5EDA86B774180BD0C0@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 04, 2009 at 12:00:36PM -0700, Jack Lau wrote:
> 
> Dear Luis
> 
> I wonder if you can really help me.

Do not e-mail me directly.

> I have installed a SparkLAN WMIA-268N wireless card http://www.sparklan.com/product_details.php?prod_id=174 in my Linux server / router to use as an access point.
> 
> I am using it with my Intel 4965AGN in my laptop computer and is fully wireless N compatible.
> 
> The big problem is that I am getting very frequent crashes with ieee_agg_splice_packets and is extremely annoying and tried all sorts to fix it with no avail.

Report it.

> I have tried to report it to the mailing list linux-wireless@vger.kernel.org because this was what the page http://wireless.kernel.org/en/users/Documentation/Reporting_bugs told me to do.

Good, please try today's wireless-testing or compat-wireless and report if you
still see the issue. If not one gets back to you just reply again to the
thread and notice that you are still seeing the issue (if you are) on
current wireless-testing.

If you are seeing an issue with a stable kernel release then report
a bug on the kernel.org bugzilla.

> The thread that is concerned is at http://marc.info/?t=124863015500005&r=1&w=2 with one of my posts containing a load of log files being deleted by the moderator.

Refer to logs with a URL.

> I am getting absolutely nowhere with this mailing list and I feel that I am all on my own to debug it and I am wasting time collecting information to help them fix the bug and feel that I am getting ignored.

Do not let this discourage you. Developers tend to not have
as much patience as you wish for, specially since wireless-testing
is bleeding edge and users are expected to at least be able to
report oops messages properly without much hand holding. It seems
to me Pavel was very patient with you.

> I am a complete idiot when it comes to programming because I only install and configure Linux but very weak with C programming.
> 
> I would appreciate any advice that you can offer me so that the bug is heard and seen to and the information you need rather than being ignored.
> 
> If you do need me to do any programming bits such as the use of the GDB tool to collect information, please tell me very clearly because again, I am a complete idiot with programming.


make sure you have the latest wireless-testing, if you've applied any patches
on top of it make sure to clear them first:

git checkout -f

and then pull the latest changes:

git pull

Please refer to the git guide for more:

http://wireless.kernel.org/en/developers/Documentation/git-guide

With today's changes this means your git describe should spit
out something like:

mcgrof@tux ~/wireless-testing (git::master)$ git describe
v2.6.31-rc5-30113-gf1aa58f

If you don't see that you don't have the latest wireless-testing.
Another indicator if you are on the latest-wireless testing
is the last commit you see via 'git log'. Today this should be:

commit f1aa58f92c1dfd16c4a0dbeb4c5fc7e797b5a4dd
Author: Luis R. Rodriguez <lrodriguez@atheros.com>
Date:   Mon Aug 3 13:51:49 2009 -0700

    ath9k: fix compile warning on ath9k_hw_AR9287_check_eeprom()
    
    CC [M]  drivers/net/wireless/ath/ath9k/eeprom.o
    drivers/net/wireless/ath/ath9k/eeprom.c: In function ‘ath9k_hw_AR9287_check_eeprom’:
    drivers/net/wireless/ath/ath9k/eeprom.c:2866: warning: comparison of distinct pointer types lacks a c
    
    Cc: Vivek Natarajan <vnatarajan@atheros.com>
    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Once you are certain you are on the latest wireless-testing build it,
install it, and then report the oops you said you were seeing. If
you are not seeing an oops then chances are its been fixed or it
was only a compat-wireless bug. Either way issues should be reported.

  Luis
