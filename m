Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:59458 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113Ab1IVHfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:35:32 -0400
Received: by mail-bw0-f49.google.com with SMTP id t2so3344985bka.22
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:35:31 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Set the correct min&max dwell time setting on
 passive scan
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315142938-26665-1-git-send-email-shahar_levi@ti.com>
References: <1315142938-26665-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 10:35:27 +0300
Message-ID: <1316676927.2157.571.camel@cumari> (sfid-20110922_093535_312349_96C86A21)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-04 at 16:28 +0300, Shahar Levi wrote: 
> In case of forced passive scan (n_ssids = 0), active permission
> channels have been set with active min&max dwell time and
> selected for passive scan.
> 
> That patch includes the following fixes:
> 1) Skip scan in case of active scan request and forced passive
>    scan (n_ssids = 0) indication
> 2) all channels that not selected before in active scan should
>    be selected in passive scan (including active channels)
> 3) Improve scan SM by calling only passive states in case of
>    forced passive scan (n_ssids = 0)
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Dropped in favor of my "wl12xx: fix forced passive scans".  No need to
change the state-machine at the same time as this bug is fixed.  The
state-machine was just over-complicating things.

I also wanted to do some clean-ups, and the fix is so simple that I
decided to make a new patch from scratch altogether.

-- 
Cheers,
Luca.

