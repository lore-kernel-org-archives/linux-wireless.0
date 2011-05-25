Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3374 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab1EYGtc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 02:49:32 -0400
Message-ID: <4DDCA66F.1080007@broadcom.com> (sfid-20110525_084958_305549_40A4DBD1)
Date: Wed, 25 May 2011 08:49:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "George Spelvin" <linux@horizon.com>
cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"error27@gmail.com" <error27@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
References: <20110525054634.5033.qmail@science.horizon.com>
In-Reply-To: <20110525054634.5033.qmail@science.horizon.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2011 07:46 AM, George Spelvin wrote:
> Since you are obviously being ironic in your phrasing, I hope I did not
> give serious offense.  What I wrote is a fairly accurate description of
> my reflex reaction, but I could have phrased it more diplomatically.

No offense. I am not keen on politics anyway so blunt in fine with me ;-)

>> If callers use the specific function they can not specify a bit order so
>> no compile-time error.
> What I meant was, the bit order is specified by the function name.
> An invalid bit order translates to an invalid function name, which the
> linker will complain about.

Than we mean the same thing.

> If you feel ambitious, you can fold the crc7 code into yours.  Its an
> msbit-first CRC.  The resultant table will be left-justified rather
> than the current right-justified, but if you look at all the call sites,
> you'll notice that they all shift the result left 1 bit!

We are ambitious, but the focus is on getting our wireless driver in 
shape. The crc8 library function is related to that. So folding the crc7 
will get a low priority for now.

I noticed the whole table changed in the patch you posted in the bug 
report. So that is because of the shift, right?

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


