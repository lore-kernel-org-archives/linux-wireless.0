Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50961 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1CPIo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 04:44:58 -0400
Received: by iyb26 with SMTP id 26so1437484iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 01:44:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300263716.3761.1.camel@jlt3.sipsolutions.net>
References: <507B31BE-2066-4434-870D-108F7DF912A6@cs.washington.edu> <1300263716.3761.1.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 16 Mar 2011 01:44:38 -0700
Message-ID: <AANLkTikir41uU_fG91w68D4JyFMPcFYKW4QFg-Ag_EUK@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix aggregation frame release during timeout
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 1:21 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-03-15 at 16:49 -0700, Daniel Halperin wrote:
>
>> x-T-R1-y-R2,
>
>>                       if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
>> -                                     HT_RX_REORDER_BUF_TIMEOUT))
>> +                                     HT_RX_REORDER_BUF_TIMEOUT) && skipped)
>
> Wait, your previous example of xT---R worked fine, but if you say x-T-
> this patch won't work I think? Basically you're saying if we received
> frames 2 and 4 after 3, and 3 times out, we can release 2 through 4. I
> agree, but your code won't do that since skipped starts out at 1 due to
> the first x. Or am I misreading this?
>

The syntax I used in our private mail was confusing and I tried to
simplify. Here, hyphens are just separators between frames (since R1,
R2 have two-letter identifiers). Does that clear it up?

Dan
