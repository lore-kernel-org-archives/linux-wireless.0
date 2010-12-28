Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:37884 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0L1Teb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 14:34:31 -0500
MIME-Version: 1.0
In-Reply-To: <201012282021.31695.rjw@sisk.pl>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com>
 <201012261935.13238.rjw@sisk.pl> <AANLkTimHHN+GesyhR6Jjnm771XLhn=inn=vrSk=mT6Mh@mail.gmail.com>
 <201012282021.31695.rjw@sisk.pl>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 28 Dec 2010 21:34:09 +0200
Message-ID: <AANLkTinPrUbaFsNMmoZJtOaF6dutLaXXQ7Uws5826n4=@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 28, 2010 at 9:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> It looks like you could simply do a power down-power up cycle before trying to
> load new firmware, just in case.  I guess that's suboptimal for some reason?

It would work, but we will not be able to unconditionally disable the
radios (e.g. airplane mode comes to mind).

> Please pretend that the runtime PM framework doesn't exist for a while.  How
> would you design things in that case?

Duplicate most of runtime-PM's plumbing into the MMC/SDIO subsystem.
Off the top of my hat:
- We need the device hierarchy and the suspend/resume dependencies (a
single SDIO card has several logical sub-devices, a.k.a SDIO
functions)
- We need to maintain usage_count for each device, and expose the same
API to handle it
- We need autosuspend for MMC cards (power them off on inactivity)
- We need the same, or similar, locking plumbing
- We probably need the same sysfs ABI as well: autosuspend_delay_ms,
and even  /sys/devices/.../power/control itself is useful (not for our
device, but for others, sure)
- ...

Thanks,
Ohad.
