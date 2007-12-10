Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:19456 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbXLJJav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 04:30:51 -0500
Received: by an-out-0708.google.com with SMTP id d31so372477and
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 01:30:50 -0800 (PST)
Message-ID: <475D0747.7010701@gmail.com> (sfid-20071210_093055_469377_DC5998F7)
Date: Mon, 10 Dec 2007 10:30:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bruno Randolf <bruno@thinktube.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, mickflemm@gmail.com
Subject: Re: [PATCH] ath5k: add debugfs entries for registers, tsf, beacon,
 reset
References: <200712101822.43487.bruno@thinktube.com> <1197278831-17030-1-git-send-email-bruno@thinktube.com>
In-Reply-To: <1197278831-17030-1-git-send-email-bruno@thinktube.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2007 10:27 AM, Bruno Randolf wrote:
 > 'registers' prints the name and value of some registers. this should be adapted
> to what we actually need later and is supposed to replace the hwdump facility i
> removed in my earlier debugging changes.
> 
> 'tsf' prints the current HW TSF. writing "reset" into the file will reset the
> TSF.
> 
> 'beacon' shows beacon relevant registers.  it is good for watching the beacon
> timers with something like "watch -n0 cat /dbg/ath5k/phy0/beacon". writing
> "enable" into the file will try to enable beacons by setting the flag
> AR5K_BEACON_ENABLE, "disable" will disable that bit.
> 
> 'reset' can be used to trigger a HW reset, by writing "reset" into it.
> 
> Changes-licensed-under: GPL
> 
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> Acked-by: Luis R. Rodriguez <mgrof@winlab.rutgers.edu>

Acked-by: Jiri Slaby <jirislaby@gmail.com>

> ---
>  drivers/net/wireless/ath5k/debug.c |  269 ++++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath5k/debug.h |    4 +
>  2 files changed, 273 insertions(+), 0 deletions(-)
