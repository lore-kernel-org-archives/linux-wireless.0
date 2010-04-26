Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48344 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0DZTtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:49:05 -0400
Received: by wwb22 with SMTP id 22so724414wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 12:49:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100426190911.GH2387@tuxdriver.com>
References: <p2ub170af451004152320y64c4615ub3d7186d936cdc62@mail.gmail.com>
	 <20100416133711.GB8554@tuxdriver.com>
	 <m2wb170af451004160851veaed6df6r2e8ec0528f66685e@mail.gmail.com>
	 <4BC88EC4.5000606@lwfinger.net> <20100426182655.GE2387@tuxdriver.com>
	 <y2nb170af451004261133qe1e0dfaand43c190b6f7f8d3@mail.gmail.com>
	 <4BD5E3A3.4050907@lwfinger.net> <20100426190911.GH2387@tuxdriver.com>
Date: Mon, 26 Apr 2010 21:49:02 +0200
Message-ID: <h2vb170af451004261249k43377e65n9d85f6dc7c377e67@mail.gmail.com>
Subject: Re: [PATCH PING] ssb patches for SPROM location
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/26 John W. Linville <linville@tuxdriver.com>:
> On Mon, Apr 26, 2010 at 02:04:03PM -0500, Larry Finger wrote:
>> On 04/26/2010 01:33 PM, Rafał Miłecki wrote:
>> > 2010/4/26 John W. Linville <linville@tuxdriver.com>:
>
>> >> FWIW, this patch series also still results in a hang on my problematic
>> >> netbook.  I'm going to merge them anyway, in hopes that they make
>> >> things better for someone (or at least get us closer to it).  I'll try
>> >> to pinpoint this hang as well.
>> >
>> > Did it actually pick another (newly discovered) offset for SPROM
>> > location in your case? Could you add some single printk to check this?
>>
>> My suggestion is that for now we only implement John's patch for no
>> SPROM. I am hoping that we try to fix the failures for boxes with the
>> SPROM in a normal location. Once we do that, there will be a simpler fix
>> for testing at the alternate location. The patch will all be contained
>> in sprom_do_read().
>
> Hmmm...well, I just pushed (just to my public trees, not to Dave)
> Rafał's trio of patches on top of mine.  Should I revert them?

AFAIU so far we didn't have any confirmation that it actually fixes
anything. Don't know... maybe it would be better to wait for any
successful feedback? I don't 100% know patches rules, let you decide.
In case we decide to implement that letter, it should be easy to
rebase patches.


> P.S.  With those patches, this box (soon to be Larry's) still uses
> an sprom_offset value of 0x1000.

Hm, so it looks like you device doesn't match our "if (version)"
condition... It's just a blind guess, but maybe it would be worth to
*force* other SPROM location on your machine? It seems quite proven
that reading some incorrect registers (in this case incorrect SPROM
location) can cause lock up. Of course it's just my guess, assuming
you have other SPROM location, lock up is caused by reading wrong
register and that Larry's condition in incorrect/not full. However if
you're gonna to send whole machine to Larry, it sounds worthy to check
this trick.


-- 
Rafał
