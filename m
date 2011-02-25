Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64371 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab1BYS10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 13:27:26 -0500
Received: by bwz15 with SMTP id 15so2189507bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 10:27:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimahYNo0ZHr9PU217CWJQP6ssuhaxguYVz7dX_-@mail.gmail.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
	<1298064074-8108-1-git-send-email-linville@tuxdriver.com>
	<AANLkTikJeN=CG20PAj-n1ZoaiJLbsiG=jfZnbu4Or3KS@mail.gmail.com>
	<20110221184716.GD9650@tuxdriver.com>
	<AANLkTi=LnpFLzKbtaPxSjg9TRU_pY2oRi6tsFg5GkaGK@mail.gmail.com>
	<20110223222842.GA20039@tuxdriver.com>
	<AANLkTimahYNo0ZHr9PU217CWJQP6ssuhaxguYVz7dX_-@mail.gmail.com>
Date: Fri, 25 Feb 2011 10:27:24 -0800
Message-ID: <AANLkTinOPNNi8e3NHpFw0ABtF5GBU_NfuMmOxnKKdo1f@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
From: Nathaniel Smith <njs@pobox.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	johannes@sipsolutions.net, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 25, 2011 at 10:21 AM, Nathaniel Smith <njs@pobox.com> wrote:
> static u64 _ktime_diff_to_now_and_unstash(ktime_t then, int * enqueued) {
>
>        timespec ts_then = ktime_to_timespec(then);
>        timespec ts_now = ktime_to_timespec(ktime_get());
>        *enqueued = ts_then.tv_sec >> LATENCY_BITS;
>        ts_then.tv_sec &= (1 << LATENCY_BITS) - 1;
>        ts_now.tv_sec &= (1 << LATENCY_BITS) - 1;
>        if (ts_now.tv_sec < ts_then.tv_sec)
>                ts_now.tv_sec += (1 << LATENCY_BITS);
>         timespec_sub(ts_now, ts_then);
> }

Err, plus the 'return timespec_to_ns(...)' on the last line, that I
was trying to add when my computer suddenly decided I wanted to send
the message. How embarrassing.

Anyway, not sure this is a *good* idea, but it should work. Hopefully
we don't actually need to measure latencies > 256 seconds in this
context...

-- Nathaniel
