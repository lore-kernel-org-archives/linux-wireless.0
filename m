Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:34454 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZHRSaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 14:30:23 -0400
Received: by gxk1 with SMTP id 1so5279641gxk.17
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 11:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250618853.7887.0.camel@johannes.local>
References: <200908181954.23419.IvDoorn@gmail.com> <1250618324.9886.25.camel@johannes.local>
	<200908182004.58584.IvDoorn@gmail.com> <1250618853.7887.0.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 18 Aug 2009 11:24:50 -0700
Message-ID: <43e72e890908181124v7e7731dei1b52806f6daccfb8@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: configure_filter() callback is allowed to sleep
To: Johannes Berg <johannes@sipsolutions.net>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 11:07 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-08-18 at 20:04 +0200, Ivo van Doorn wrote:
>
>> > Speaking of which -- bss_info_changed can sleep too, which means you can
>> > remove DRIVER_REQUIRE_SCHEDULED completely I think?
>>
>> Seriously, that would be great. Patch coming up in a few minutes. ;)
>
> Cool.
>
> Hey, sorry it took so long to make it possible :)
>
> I wonder if drivers now ever have a reason to queue work on the mac80211
> workqueue? Some periodic calibration tasks maybe?

ath9k just has the virtual wiphy stuff and that uses the mac80211
workqueue.  Maybe we can review this stuff at the summit in
consideration for how we may want this eventually on
mac80211/cfg80211.

  Luis
