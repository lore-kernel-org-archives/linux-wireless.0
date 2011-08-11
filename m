Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:44725 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab1HKF5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 01:57:19 -0400
Received: by mail-bw0-f45.google.com with SMTP id zv3so774967bkb.4
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 22:57:17 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: Remove obsolete testmode NVS push command
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
In-Reply-To: <1312269858-30434-1-git-send-email-ido@wizery.com>
References: <1312269858-30434-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 08:57:14 +0300
Message-ID: <1313042234.2407.758.camel@cumari> (sfid-20110811_075722_764342_BAB37A00)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-02 at 10:24 +0300, Ido Yariv wrote: 
> The testmode NVS push command is no longer in use. In addition, it has
> several implementation issues that prevent it from working correctly:
> 
> 1. wl1271_tm_cmd_configure relies on wl->chip.id being set. However,
>    since the device was not necessarily booted by the time the function
>    is called, wl->chip.id will be initialized to 0.
> 2. The NVS file is fetched by calling request_firmware() before it is
>    possible to push an NVS file.
> 3. The maximum allowed size of nl binary payloads is not sufficient for
>    pushing NVS files.
> 4. Pushing 128x NVS files will always fail due to a bug in the
>    validation code.
> 5. In case the pushed NVS file is found invalid, the mutex will be kept
>    locked and the nvs member will become a dangling pointer.
> 
> Since this feature is not being used, remove it completely instead of
> fixing it.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Acked-by: Luciano Coelho <coelho@ti.com>

John, could you please take these two patches into 3.1?

The first one is removing an obsolete feature that was badly broken
(causing security risks) and the second one is a power management bug
fix, without which suspend doesn't work properly with the wl12xx driver.

Thanks!

-- 
Cheers,
Luca.

