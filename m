Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:52582 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab0LZSho (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 13:37:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Sun, 26 Dec 2010 19:37:21 +0100
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com> <201012261245.29680.rjw@sisk.pl> <AANLkTinvBD6NhHY7PMw9NSJNBW77-Gah8Vcow6t1aiCT@mail.gmail.com>
In-Reply-To: <AANLkTinvBD6NhHY7PMw9NSJNBW77-Gah8Vcow6t1aiCT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012261937.21256.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, December 26, 2010, Ohad Ben-Cohen wrote:
> On Sun, Dec 26, 2010 at 1:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > (It still is not a race, though.)
> 
> Thread 1
> =======
> 
> suspend_handler_of_a_random_device()
> {
>     return failure;
> }
> 
> Thread 2
> =======
> 
> suspend_handler_of_our_mmc_host_controller()
> {
>     invoke our sdio suspend handler and power down the card (directly);
>     return success;
> }
> 
> If thread 2 wins => everything is cool
> If thread 1 wins => our driver will not be able to resume
> 
> The race begins after mac80211 invokes our driver's power off handler,
> which is using pm_runtime_put_sync().

So, it only happens during asynchronous suspend?  In other words, if suspend
is synchronous, everything should be fine, right?

Rafael
