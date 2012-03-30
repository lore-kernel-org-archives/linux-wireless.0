Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63696 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934570Ab2C3Unl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 16:43:41 -0400
Received: by iagz16 with SMTP id z16so1448517iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2012 13:43:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F75C634.1010400@gmail.com>
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net>
 <20341.39041.645223.592030@gargle.gargle.HOWL> <1333107022.3908.16.camel@jlt3.sipsolutions.net>
 <4F75C634.1010400@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 30 Mar 2012 13:43:20 -0700
Message-ID: <CAB=NE6XbYMo=or0QLKw3-w5rbnMkwvxRntaRPK6O=LeYT-nkeA@mail.gmail.com> (sfid-20120330_224353_212629_A4C12D2D)
Subject: Re: [PATCH 0/2] compat: fix extreme build slowdowns
To: Richard Farina <sidhayn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 30, 2012 at 7:41 AM, Richard Farina <sidhayn@gmail.com> wrote:
> On 03/30/12 07:30, Johannes Berg wrote:
>> On Fri, 2012-03-30 at 16:56 +0530, Sujith Manoharan wrote:
>>> Johannes Berg wrote:
>>>> Somehow exporting too many variables completely confuses the kernel's
>>>> Makefiles into trying to calculate the size of every file in a very slow
>>>> shell script ... this is causing EXTREME build slowdowns for me.
>>>>
>>>> These two patches fix it.
>>> Nice.
>>>
>>> Trying to build ath9k..
>>>
>>> Before:
>>>
>>> real    1m18.689s
>>> user    3m1.382s
>>> sys     0m6.833s
>>>
>>> After:
>>>
>>> real    0m42.091s
>>> user    1m30.024s
>>> sys     0m5.700s
> Please put this in stable as well, seems like a good thing ;-)

Johannes, kick ass patches, thanks!!! Richard, I will propagate to
stable, but first gotta figure why the patch, "compat: explicitly
export generated variables" broke builds for older kernels:

mcgrof@tux ~/compat (git::master)$ ckmake
Trying kernel                  3.3.0-030300rc2-generic	[OK]
Trying kernel                     3.2.2-030202-generic	[OK]
Trying kernel                    3.1.10-030110-generic	[OK]
Trying kernel                    3.0.18-030018-generic	[OK]
Trying kernel                  2.6.39-02063904-generic	[OK]
Trying kernel                        2.6.38-13-generic	[OK]
Trying kernel                  2.6.38-02063808-generic	[OK]
Trying kernel                  2.6.37-02063706-generic	[OK]
Trying kernel                  2.6.36-02063604-generic	[OK]
Trying kernel                  2.6.35-02063512-generic	[OK]
Trying kernel                  2.6.34-02063410-generic	[OK]
Trying kernel                  2.6.33-02063305-generic	[OK]
Trying kernel                  2.6.32-02063255-generic	[FAILED]
Trying kernel                        2.6.31-22-generic	[FAILED]
Trying kernel                  2.6.31-02063113-generic	[FAILED]
Trying kernel                  2.6.30-02063010-generic	[FAILED]
Trying kernel                  2.6.29-02062906-generic	[FAILED]
Trying kernel                  2.6.28-02062810-generic	[FAILED]
Trying kernel                    2.6.27-020627-generic	[FAILED]
Trying kernel                    2.6.26-020626-generic	[FAILED]
Trying kernel                    2.6.25-020625-generic	[FAILED]
Trying kernel                    2.6.24-020624-generic	[FAILED]

  Luis
