Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:60867 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932994Ab1BPBIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 20:08:13 -0500
Message-ID: <20110216030805.34044ohmmyriiwmc@hayate.sektori.org>
Date: Wed, 16 Feb 2011 03:08:05 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH] zd1211rw: change endpoint types of EP_REGS_OUT and
 EP_INT_IN from interrupt to bulk
References: <20110206083522.16858.24185.stgit@fate.lan>
 <20110215184945.GF2557@tuxdriver.com>
In-Reply-To: <20110215184945.GF2557@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "John W. Linville" <linville@tuxdriver.com>:

> On Sun, Feb 06, 2011 at 10:35:22AM +0200, Jussi Kivilinna wrote:
>> This fixes high CPU usage when writing beacon frame to hardware. With this
>> patch CPU usage of kworker on Intel Atom with 100 TU beacon interval goes
>> from ~10% down to <1%.
>>
>> Checking vendor driver appears it's also ignoring fact that endpoints are
>> interrupt type and is using bulk urbs on these.
>>
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>
> This patch led to a lengthy thread.  I'm not 100% clear on the
> outcome, but it seems like the conclusion was that the driver should
> be doing something else -- at least that seemed to be the conclusion
> for ath9k_htc.
>
> So, is this patch still wanted?
>
> John

It's not needed. The patchset [1] that made write command use  
asynchronous URBs lowers CPU usage the other way.

-Jussi

[1] http://marc.info/?l=linux-wireless&m=129753620103065&w=2

