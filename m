Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35810 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbZCMIFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 04:05:17 -0400
Date: Fri, 13 Mar 2009 10:03:59 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Which APs to disregards from in inputting into the bss list
Message-ID: <20090313080359.GA13826@jm.kir.nu> (sfid-20090313_090524_021011_0E3904F4)
References: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2009 at 08:09:53PM -0700, Luis R. Rodriguez wrote:
> Do we want to ignore certain APs if we determine they are bogus?

Only if we can be sure that there is no chance of that AP working (e.g.,
someone running a program that sends random Beacon frames just to annoy
people). Even in the case of apparently bogus AP, I'm not sure I would
like to remove it from the scan results in any other case than the
attack with huge number of random beacons/probe response frames.

> An
> example is 11n APs with WEP/TKIP. Would we rather not even store then
> in our bss list so that way we wont' get reports from users not being
> able to connect to such APs.

That is not an example of an AP we would not be able to talk to (with
legacy rates; and as far as HT-only configuration is concerned, we would
likely only learn about that after having tried to associate).

> Other examples might be if 11n APs have
> HT IEs but their lengths are not right, or if the AP is HT40 and our
> regulatory domain does now allow HT40.

I would be careful about IE lengths since many IEs can be extended in
the future. As far as HT40 is concerned, we could try to associate with
HT20 and anyway, I would like to see that AP in the scan results.

> The benefit I see with these early checks we won't get complaints
> about not being able to connect to bogus APs or APs you shouldn't be
> connected to anyway.

Those would be replaced with complaints about not seeing APs, scan
being broken, and not being able to connect to APs that we should be
able to connect to..

-- 
Jouni Malinen                                            PGP id EFC895FA
