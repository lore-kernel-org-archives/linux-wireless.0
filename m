Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:42027 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab1HKF5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 01:57:49 -0400
Received: by mail-bw0-f44.google.com with SMTP id r4so898156bka.31
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 22:57:47 -0700 (PDT)
Subject: Re: [PATCH 2/2] wl12xx: Fix validation of pm_runtime_get_sync
 return value
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312269858-30434-2-git-send-email-ido@wizery.com>
References: <1312269858-30434-1-git-send-email-ido@wizery.com>
	 <1312269858-30434-2-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 08:57:44 +0300
Message-ID: <1313042264.2407.759.camel@cumari> (sfid-20110811_075751_314639_5754CC45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-02 at 10:24 +0300, Ido Yariv wrote: 
> wl1271_sdio_power_on checks if the return value of pm_runtime_get_sync
> is non-zero, and if so bails out.
> However, pm_runtime_get_sync can return a positive number which does not
> suggest an error has occurred. This is problematic for two reasons:
> 
> 1. The function will needlessly bail out without decrementing back the
>    runtime PM reference counter.
> 2. wl1271_power_on only checks if wl1271_power_on return value is
>    negative. This means that wl1271_power_on will continue even if
>    wl1271_sdio_power_on bailed out. As a result, sdio transactions will
>    be initiated without properly enabling the sdio function and claiming
>    the host. This could even lead to a kernel panic.
> 
> Fix this by only checking that the return value of pm_runtime_get_sync
> is non-negative.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.

