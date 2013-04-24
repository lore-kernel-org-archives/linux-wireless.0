Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52476 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590Ab3DXWsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 18:48:54 -0400
Received: by mail-qc0-f174.google.com with SMTP id z24so1251654qcq.33
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 15:48:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
Date: Wed, 24 Apr 2013 16:48:53 -0600
Message-ID: <CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com> (sfid-20130425_004907_197914_9F6A9358)
Subject: Re: Memory leak in mwifiex_cfg80211_scan
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Apr 22, 2013 at 7:50 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Thanks for reporting this issue.
> Please find attached the patch and try it on your XO4.
>
> I will resend the patch to the list if it works for you.

This does seem to make the kmemleak report go away.

However, strangely, it seems to make a whole bunch of kmemleak reports
*appear*, as if the struct netdev is not being destroyed, and more. I
guess this could just be a kmemleak oddity but it is strange that it
did not appear before this patch.

Trying to look for possible causes (memory corruption?), I can't see
any code that serializes scan_delay_timer_fn with mwifiex_close(), so
mwifiex_close freeing the scan data while scan_delay_timer_fn is using
it could cause badness to happen. However I haven't yet figured out
how to trigger scan_delay_timer_fn to execute even once (any tips?).

The fact that scan_delay_timer_fn isn't executing at all means that
its not related to the kmemleak oddness, which must have another cause
or explanation.

I will investigate more tomorrow.

Thanks
Daniel
