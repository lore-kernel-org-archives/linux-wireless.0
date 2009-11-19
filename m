Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:59240 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZKSPtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 10:49:03 -0500
Received: by qyk32 with SMTP id 32so1201374qyk.4
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2009 07:49:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258628197.7094.3.camel@johannes.local>
References: <8999a3120911181742y364c763j3b5b88e50890332c@mail.gmail.com>
	 <1258628197.7094.3.camel@johannes.local>
Date: Thu, 19 Nov 2009 07:49:08 -0800
Message-ID: <8999a3120911190749q3b12a712yd88b4f5aeb521291@mail.gmail.com>
Subject: Re: scanning question
From: Chuck Tuffli <ctuffli@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 19, 2009 at 2:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-11-18 at 17:42 -0800, Chuck Tuffli wrote:
>> I'm implementing a mac80211 driver and have a question about the
>> expected behavior during software based scanning. Can the driver
>> assume that mac80211 won't start a scan until all previous TX
>> complete? If not, what is the expected behavior of the driver? Finish
>> current TX before starting the scan? Drop current TX? Something else?
>> TIA!
>
> No, you can't assume that right now, unfortunately. We've been wanting
> to implement a flush_tx() callback for a long time now but nobody did so
> far. Some drivers might flush in the pre_scan() callback, but I think
> that isn't actually correct because the nullfunc frame we might send
> might pass other frames on the hw queues/fifos.

OK. I agree that flushing isn't ideal, so the alternative is for
someone to wait until IO finishes.

Can the driver sleep until it is ready to scan (I'm guessing no)?

Alternatively, could we modify scan.c such that if a driver returned
EAGAIN in sw_scan_start, the scan would wait in a similar way to what
happens if something is on the work_list?
