Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:44269 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbZKFRpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 12:45:44 -0500
Received: by iwn10 with SMTP id 10so962899iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 09:45:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0911060929w78d16192o6c48e432e8e8c830@mail.gmail.com>
References: <43e72e890911060857l6e383578nc1c7d0f2ba63529f@mail.gmail.com>
	<b6c5339f0911060929w78d16192o6c48e432e8e8c830@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Nov 2009 09:45:29 -0800
Message-ID: <43e72e890911060945s3b00e056u1efe483bd88ebd30@mail.gmail.com>
Subject: Re: Changing the way we handle region codes on Linux (public thread)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Vivek Natarajan <vivek.natraj@gmail.com>,
	Jeffrey Baker <jwbaker@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 9:29 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Nov 6, 2009 at 11:57 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>
>> I think that sums it up.
>
> I personally still like the idea of pushing the vendor-specific
> codes out to user space and having psuedo-country codes for
> those (e.g. "ATH_37").  Then the driver doesn't need all of the
> static rules loaded all the time and it would drop a lot of
> policy code from the driver.  CRDA could be enhanced to load
> multiple databases, one for pure iso-3166 codes, one with
> Atheros codes, one with Intel, etc.

There is obviously an added complexity added to userspace for this,
but it seems that having that complexity in userspace is better than
in kernel space. Only reason for not doing this I think would be
perhaps if we can really avoid such custom region codes.

Ultimately what makes more sense to me is to see more trust on the
user's location based on alternative inputs like geoclue but since
this year the Google Summer of Code project failed miserly even by the
midterm who knows when we'll be able to get proper feeds we can use in
the kernel.

But with that said -- I think the region-code scheme is overly complex
and am not sure if aiding it is something we should focus energy and
resources on. It would seem better to me to focus on more cleaner
solutions and leave that old stuff as legacy solutions.

  Luis
