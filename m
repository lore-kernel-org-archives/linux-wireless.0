Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:43309 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0L2ICB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 03:02:01 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1012281541580.22998-100000@netrider.rowland.org>
References: <AANLkTim7pGtO=vjKmA_3O74Kwvio124cgoaMeUSB70dW@mail.gmail.com> <Pine.LNX.4.44L0.1012281541580.22998-100000@netrider.rowland.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Dec 2010 10:01:40 +0200
Message-ID: <AANLkTi=QT1thWxy94=imJhbbcXQ1CD36=PnkAyaaA6Hj@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 28, 2010 at 11:46 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> Similarly, during system suspend mmc_suspend_host() should be
> responsible for doing all the necessary power-down operations.  Runtime
> PM is completely out of the picture at this time.  And this should be
> independent of mac80211 -- in fact, the card should be powered down
> appropriately even if the kernel doesn't have a mac80211 layer.

And it is.

But in order to boot the firmware on resume, we need to reset the
device. And if system suspend has been cancelled before
mmc_power_off() was invoked, we will not be able to. So, in this case
too, the driver will have to power the device off.

It all really boils down to the same solution - we will always have to
bypass runtime PM and directly control the power of the device.
