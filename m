Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20023 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYJXBdg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 21:33:36 -0400
Message-ID: <20081023213333.4t4427vw5ws8ccck-cebfxv@webmail.spamcop.net> (sfid-20081024_033341_943142_82F6805A)
Date: Thu, 23 Oct 2008 21:33:33 -0400
From: Pavel Roskin <proski@gnu.org>
To: ath5k-devel@lists.ath5k.org,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] ath5k: badness at net/mac80211/rx.c:2200,
	status->rate_idx = 255
References: <1224799927.22806.15.camel@dv>
In-Reply-To: <1224799927.22806.15.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Adding a printk before that line shows:
> status->rate_idx = 255, sband->n_bitrates = 12
...
> While rxs.rate_idx has type int, the rate_idx array has type u8.
> Perhaps it should be s8, or the value of 255 should be handled specially
> if valid indices can exceed 127.
>
> This patch is compile-tested only.  I'm leaving it overnight for
> testing.

Oh well, I still get the same badness:
status->rate_idx = -1, sband->n_bitrates = 12

Not much better.

-- 
Regards,
Pavel Roskin
