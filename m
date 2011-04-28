Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64203 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab1D1SzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 14:55:21 -0400
Received: by qyg14 with SMTP id 14so1592982qyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 11:55:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878vuvt78l.wl@dns1.atmark-techno.com>
References: <201104181526.01722.IvDoorn@gmail.com>
	<201104181526.37747.IvDoorn@gmail.com>
	<201104181527.06956.IvDoorn@gmail.com>
	<201104181527.06956.IvDoorn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
	<201104181527.44542.IvDoorn@gmail.com>
	<878vuvt78l.wl@dns1.atmark-techno.com>
Date: Thu, 28 Apr 2011 20:55:20 +0200
Message-ID: <BANLkTimY0m+reba-DyPEM7kFWNSEKVyTAg@mail.gmail.com> (sfid-20110428_205524_783773_757FF0CA)
Subject: Re: [PATCH 04/23] rt2x00: Make rt2x00_queue_entry_for_each more flexible
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Yasushi SHOJI <yashi@atmark-techno.com>
Cc: helmut.schaa@googlemail.com, hanada@atmark-techno.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> My colleague just tested this patch set and found out that the in
> question makes our 400MHz ARM cpu board with ralink usb dongle non
> functional due to high cpu consumption.  it seems for us that exiting
> from function every time it finds an entry is too expensive on systems
> slower than PCs.

Interesting, I would suspected the patch to reduce the CPU consumption
rather then increasing it. I can do some testing regarding this looping
during the weekend, but I haven't seen high CPU consumption on my
system during my last test. However I wasn't testing on an embedded system...

> To verify our thought, we changed the source code as the patch below.
> What we intended to do with this change is to continue processing all
> entry without breaking semantics.
>
> With the patch below our board seem to work fine again, but not sure
> exactly why it takes so much time to check the list again.  We are not
> against the idea of the patch at all.  We just want to ask you guys
> how we should go to track this problem. it might be the slow usb?

Could you try use debugfs and see if some queue and packet counters
of mac80211/rt2x00 show excessive values?

Have you been running the test with powersaving enabled or disabled?

Ivo
