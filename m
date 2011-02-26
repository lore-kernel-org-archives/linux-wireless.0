Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1BZJVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 04:21:22 -0500
Subject: Re: [PATCH v2] at76c50x-usb: fix warning caused by
 at76_mac80211_tx now returning void
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, kalle.valo@iki.fi, kvalo@adurom.com
In-Reply-To: <1298671436-2052-1-git-send-email-linville@tuxdriver.com>
References: <1298666834.4329.20.camel@jlt3.sipsolutions.net>
	 <1298671436-2052-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Feb 2011 10:21:18 +0100
Message-ID: <1298712078.3922.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-25 at 17:03 -0500, John W. Linville wrote:
> CC [M]  drivers/net/wireless/at76c50x-usb.o
> drivers/net/wireless/at76c50x-usb.c: In function ‘at76_mac80211_tx’:
> drivers/net/wireless/at76c50x-usb.c:1759:4: warning: ‘return’ with a value, in function returning void
> 
> This is fallout from commit 7bb4568372856688bc070917265bce0b88bb7d4d
> ("mac80211: make tx() operation return void").
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> v2 drop the frame and return...duh!
> 
> Will this hack still work if we drop the frame?  Did it ever work?

I'm not sure it ever worked, Kalle did mention that this driver never
really worked well.

johannes

