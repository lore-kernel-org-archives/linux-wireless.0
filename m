Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35289 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752752AbcLNKH2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 05:07:28 -0500
Received: by mail-pg0-f44.google.com with SMTP id p66so6746026pga.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2016 02:07:28 -0800 (PST)
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [RFC V3 04/11] nl80211: add driver api for gscan notifications
To: Johannes Berg <johannes@sipsolutions.net>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
 <1481543997-24624-5-git-send-email-arend.vanspriel@broadcom.com>
 <1481646049.20412.43.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <69ec7e9f-cd46-c46d-140c-0b30343cc0f7@broadcom.com> (sfid-20161214_110732_496364_994CEB1B)
Date: Wed, 14 Dec 2016 11:07:24 +0100
MIME-Version: 1.0
In-Reply-To: <1481646049.20412.43.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-12-2016 17:20, Johannes Berg wrote:
> On Mon, 2016-12-12 at 11:59 +0000, Arend van Spriel wrote:
>> The driver can indicate gscan results are available or gscan
>> operation has stopped.
> 
> This patch is renumbering the previous patches' nl80211 API, which is
> best avoided, even if I do realize it doesn't matter now. :)

Indeed. Will be more careful in upcoming revision(s).

> Even here it's not clear how things are reported though. Somehow I
> thought that gscan was reporting only partial information through the
> buckets, or is that not true?

Not sure what is meant by "through the buckets". Referring to your
remark/question in the "Unversal scan proposal" thread:

"""
I'm much more worried about the "bucket reporting" since that doesn't
fit into the current full BSS reporting model at all. What's your
suggestion for this?
"""

So this is exactly the dilemma I considered so I decided to stick with
the full BSS reporting model for gscan as well merely to get it
discussed so glad you brought it up ;-). The problem here is that
gscan is a vehicle that serves a number of use-cases. So ignoring
hotlists, ePNO, etc. the gscan configuration still hold several
notification types:

- report after completing M scans capturing N best APs or a
  percentage of (M * N).
- report after completing a scan include a specific bucket.
- report full scan results.

The first two notification trigger retrieval of gscan results which are
historic, ie. partial scan results for max M scans.

As said earlier the universal scan proposal has some similarities to
gscan. Guess you share that as you are using the term "bucket reporting"
in that discussion ;-). The historic results are needed for location (if
I am not mistaken) so the full BSS reporting model does not fit that.
Question is what particular attribute in the historic results is needed
for location (suspecting only rssi and possibly the timestamp, but would
like to see that confirmed). I was thinking about have historic storage
in cfg80211 so we do not need a per-driver solution.

Regards,
Arend
