Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36024 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbcBWSnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 13:43:53 -0500
MIME-Version: 1.0
In-Reply-To: <1456222441.2041.10.camel@sipsolutions.net>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
 <1455658091-28262-1-git-send-email-apenwarr@gmail.com> <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
 <1456222441.2041.10.camel@sipsolutions.net>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 23 Feb 2016 13:43:33 -0500
Message-ID: <CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com> (sfid-20160223_194356_287187_46B4A5B0)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation timeout.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2016 at 5:14 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2016-02-16 at 16:28 -0500, Avery Pennarun wrote:
>> Since around the beginning of time, ath9k aggregates have timed out
>> after
>> 5000 TU (around 5000ms) of inactivity, but nobody seems to be quite
>> sure
>> why, and this magic number seems to have migrated around from one
>> place to
>> another.  An openbsd mailing list recently had a patch to disable the
>> timeout completely, which they say matches some commercial routers:
>> https://www.mail-archive.com/tech@openbsd.org/msg29456.html
>>
>> Even in Linux, several non-ath9k drivers default to no timeout
>> already.  I
>> think changing it directly to zero would be safe, but to allow a more
>> structured investigation, let's make it configurable for now.
>>
> Since we just made it zero, perhaps we don't need this?
>
> Although perhaps we still want it to be able to debug it?

We're putting my version of the patch into our devices in order to be
able to try different values and see how it changes the percentage of
devices with nonzero 'pending' field in agg_status.  I'm hoping using
zero here will result in total elimination of the pending problem, but
we'll see.

It probably makes sense not to apply this upstream if the default
value is zero now anyway.

> Anyway - you shouldn't create a debugfs file and play with the extern
> stuff etc., let minstrel create the debugfs file in minstrel_ht_alloc()

Good point.  I had a feeling I was doing that in the wrong place :)

If people think this is important, I can respin the patch, otherwise
feel free to discard.

Have fun,

Avery
