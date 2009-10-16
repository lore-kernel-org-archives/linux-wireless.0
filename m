Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:39070 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759380AbZJPOMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 10:12:44 -0400
Received: by qw-out-2122.google.com with SMTP id 9so606965qwb.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 07:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zl7rbyl2.fsf@nokia.com>
References: <1255575825.10636.17.camel@laptop> <20091015031138.GB16633@kroah.com>
	<87zl7rbyl2.fsf@nokia.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Fri, 16 Oct 2009 10:11:22 -0400
Message-ID: <390803460910160711i5f7edcc3ue737c05a8b1495b1@mail.gmail.com>
Subject: Re: [PATCH 1/1] staging/stlc45xx: Fix compile error
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Greg KH <greg@kroah.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you agree I could take the task to mantain stlc45xx. I have the
time, the motivation and I think the skills to do it.

At least I could make it compile when the API changes and work on bugs
reported until you are confident that p54spi driver is good enough and
there is no need anymore for stlc45xx.

The only thing I dont have it is the hardware but I think I could get one N800.

Best regards,

-----------------------------------------
Javier Martínez Canillas
+595 981 88 66 58



On Fri, Oct 16, 2009 at 3:13 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Greg KH <greg@kroah.com> writes:
>
>> On Wed, Oct 14, 2009 at 11:03:45PM -0400, Javier Martinez Canillas wrote:
>>> I got the following compile error with today linux-next tree.
>>>
>>> drivers/staging/stlc45xx/stlc45xx.c: In function ‘stlc45xx_reset’:
>>> drivers/staging/stlc45xx/stlc45xx.c:1061: error: ‘struct ieee80211_hw’ has no member named ‘workqueue’
>>> drivers/staging/stlc45xx/stlc45xx.c: In function ‘stlc45xx_interrupt’:
>>> drivers/staging/stlc45xx/stlc45xx.c:1492: error: ‘struct ieee80211_hw’ has no member named ‘workqueue’
>>> drivers/staging/stlc45xx/stlc45xx.c: In function ‘stlc45xx_wq_tx’:
>>> drivers/staging/stlc45xx/stlc45xx.c:1571: error: ‘struct ieee80211_hw’ has no member named ‘workqueue’
>>> drivers/staging/stlc45xx/stlc45xx.c: In function ‘stlc45xx_op_tx’:
>>> drivers/staging/stlc45xx/stlc45xx.c:2135: error: ‘struct ieee80211_hw’ has no member named ‘workqueue’
>>> drivers/staging/stlc45xx/stlc45xx.c: At top level:
>>> drivers/staging/stlc45xx/stlc45xx.c:2351: warning: initialization from incompatible pointer type
>>>
>>> The driver was trying to access directly to mac80211 workqueue. Use the helper functions instead.
>>>
>>> I think this patch solves the issue. Also fix a compile warning due a change in configure_filter() handler params.
>>
>> ah, good catch, I had that driver disabled in my builds for some stupid
>> reason.  I'll queue this up in my tree.
>
> I think it's better to drop stlc45xx. As I haven't sent any patches for
> few months is obvious that I don't have time to work on it anymore. And
> p54spi should work now, at least I have seen positive reports on mailing
> lists.
>
> Greg, if you want I can send a patch removing stlc45xx.
>
> --
> Kalle Valo
>
