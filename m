Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53350 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab1JZRkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 13:40:11 -0400
Received: by iaby12 with SMTP id y12so1963547iab.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 10:40:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA7D8B5.5060306@sipsolutions.net>
References: <1319531194-26839-1-git-send-email-eliad@wizery.com>
	<4EA7D8B5.5060306@sipsolutions.net>
Date: Wed, 26 Oct 2011 19:40:11 +0200
Message-ID: <CAB3XZEfHsdsHEwPyvB7pxiLyCsFgq2WZofL_V116q9EFuDXX1A@mail.gmail.com> (sfid-20111026_194016_443318_D21F648C)
Subject: Re: [PATCH] mac80211: use min rate as basic rate for buggy APs
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2011 at 11:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On 10/25/2011 10:26 AM, Eliad Peller wrote:
>>
>> Some buggy APs (and even P2P_GO) don't advertise their
>> basic rates in the association response.
>>
>> In such case, use the min supported rate as the
>> basic rate.
>
> I seem to vaguely remember discussing using mandatory rates, did we?
>
yes.
the problem with the mandatory rates is that we shouldn't use CCK
rates when working as p2p_cli (there *shouldn't* be such GO, but this
was an actual case...)

> Also this seems like a last resort fallback, I'd really also try using the
> probe response information -- we should have that information still at this
> point. But maybe that doesn't make sense -- fix the APs instead!
>
right.

> I'd really like a (debug?) message here though. This is a stupid AP, and I
> will need to know if I'm debugging some throughput issues etc.
sure. i'll add it.

thanks for the review.
Eliad.
