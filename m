Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:62256 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0L1TPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 14:15:48 -0500
MIME-Version: 1.0
In-Reply-To: <201012261937.21256.rjw@sisk.pl>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com>
 <201012261245.29680.rjw@sisk.pl> <AANLkTinvBD6NhHY7PMw9NSJNBW77-Gah8Vcow6t1aiCT@mail.gmail.com>
 <201012261937.21256.rjw@sisk.pl>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 28 Dec 2010 21:15:27 +0200
Message-ID: <AANLkTinewad6YxXvn5gnJQ+HJn41Sg96319GQn9KRKWj@mail.gmail.com>
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

On Sun, Dec 26, 2010 at 8:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> So, it only happens during asynchronous suspend?  In other words, if suspend
> is synchronous, everything should be fine, right?

Not necessarily.

Consider this simple scenario, where a device was added after the mmc
host controller, but before mac80211. In this case its suspend handler
will have the chance to abort system suspend after mac80211 already
told our driver to power down the device (but the device wasn't
powered down yet, because the driver used pm_runtime_put_sync() which
is disabled).

Thanks,
Ohad.
