Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:40415 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab1CCPmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 10:42:31 -0500
Received: by wwj40 with SMTP id 40so1273048wwj.30
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 07:42:21 -0800 (PST)
Subject: Re: [PATCH] wl12xx: Don't rely on runtime PM for toggling power
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <1298844838-11845-1-git-send-email-ido@wizery.com>
References: <1298844838-11845-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 17:42:21 +0200
Message-ID: <1299166941.7039.4.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 00:13 +0200, Ido Yariv wrote:
> Runtime PM might not always be enabled. Even if it is enabled in the
> running kernel, it can still be temporarily disabled, for instance
> during suspend. Runtime PM is opportunistic in nature, and should not be
> relied on for toggling power.
> 
> In case the interface is removed and re-added while runtime PM is
> disabled, the FW will fail to boot, as it is mandatory to toggle power
> between boots. For instance, this can happen during suspend in case one
> of the devices fails to suspend before the MMC host suspends, but after
> mac80211 was suspended. The interface will be removed and reactivated
> without toggling the power.
> 
> Fix this by calling mmc_power_save_host/mmc_power_restore_host in
> wl1271_sdio_power_on/off functions. It will toggle the power to the chip
> even if runtime PM is disabled. The runtime PM functions should still be
> called to make sure runtime PM does not opportunistically power the chip
> off (e.g. after resuming from system suspend).
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

