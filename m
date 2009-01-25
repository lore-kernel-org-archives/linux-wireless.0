Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13964 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZAYSVq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 13:21:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 10:21:46 -0800
Date: Sun, 25 Jan 2009 10:21:07 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Michael Buesch <mb@bu3sch.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: regulatory: Operation already in progress
Message-ID: <20090125182107.GG22475@tesla> (sfid-20090125_192159_941292_CC4AD31C)
References: <200901251422.42616.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200901251422.42616.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 25, 2009 at 05:22:42AM -0800, Michael Buesch wrote:
> mb@quimby:~/kernel$ sudo iw reg set DE
> command failed: Operation already in progress (-114)
> 
> I wonder why this happens.
> What I just did was install 2.6.28.2 and install today's compat-wireless.
> 
> In dmesg I can see it succeeded once but it doesn't work anymore now.
> [  973.992710] cfg80211: Calling CRDA for country: DE
> [  973.998576] cfg80211: Regulatory domain changed to country: DE
> [  973.998630]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [  973.998691]  (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  973.998738]  (5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
> [  973.998785]  (5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)

Had you called twice? If so we now tell userspace when its there by -EALREADY,
we were just silently accepting two consecutive calls before.

  Luis
