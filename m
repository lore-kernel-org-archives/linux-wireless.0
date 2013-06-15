Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3FORLT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 13:11:19 -0400
Message-ID: <1371316275.8319.0.camel@jlt4.sipsolutions.net> (sfid-20130615_191123_283633_56E96FDF)
Subject: Re: kmemleak report in 3.9.5+, related to cfg80211_inform_bss_frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 15 Jun 2013 19:11:15 +0200
In-Reply-To: <51BB9DC5.2020509@candelatech.com> (sfid-20130615_004841_632650_1CE63E73)
References: <51B773B7.5090301@candelatech.com>
	 <51B77594.20000@candelatech.com> <51B7C29C.1060701@candelatech.com>
	 <51BB9DC5.2020509@candelatech.com> (sfid-20130615_004841_632650_1CE63E73)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-06-14 at 15:48 -0700, Ben Greear wrote:

> I've instrumented all (as far as I can tell) allocation points
> and destruction points for the ies, and I am keeping a separate
> list of structures to record some info about each ies.
> 
> I loaded up lots of stations, let them bounce around for a while,
> and then did an 'rmmod ath9k'.
> 
> I still see 14 ies entries in my debug list.  Should
> I expect to see zero ies data structures left after
> I rmmod all wifi drivers, or is it normal for a few
> to be left around?

No, that's decidedly not normal, but that's pretty much just what
kmemleak already told us, no? Good to verify, but doesn't really help
pinpoint the problem either, I'd say :-(

johannes

