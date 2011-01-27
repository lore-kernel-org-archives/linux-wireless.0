Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34460 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1A0WS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 17:18:28 -0500
MIME-Version: 1.0
In-Reply-To: <87tyguje7j.fsf@ti.com>
References: <Pine.LNX.4.44L0.1101271439020.2090-100000@iolanthe.rowland.org>
	<87tyguje7j.fsf@ti.com>
Date: Thu, 27 Jan 2011 23:18:27 +0100
Message-ID: <AANLkTinbHx1XtxpWDr+UCUBo6xRCs=zT1AD_y2kXo0cL@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
From: Vitaly Wool <vitalywool@gmail.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 27, 2011 at 9:15 PM, Kevin Hilman <khilman@ti.com> wrote:
>
>> If it is, then you can call omap_pm_runtime_suspend() directly instead
>> of calling dev->bus->pm->runtime_suspend().
>
> Personally, I prefer going through dev->bus as we try to avoid SoC
> specific calls in the driver.
>
> This same HW block might be re-used on non-OMAP SoCs (e.g. TI DaVinci)
> that would have different PM at the susbystem level.
>
> So, to summarize, as long as folks are OK with drivers directly calling
> the subsystem runtime PM callbacks, I'll go this route.

I personally think it's okay for the moment. Generally speaking, SD
bus driver might not have runtime PM support so it's better to have
this explicitly called and not compiling for other platforms rather
than have it compiling but working not the way it's expected to.

~Vitaly
