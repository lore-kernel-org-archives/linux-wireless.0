Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:52648 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbXHPBru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 21:47:50 -0400
Date: Wed, 15 Aug 2007 18:46:46 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: fix eloop warning
Message-ID: <20070816014646.GS1415@jm.kir.nu>
References: <1187176131.3998.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187176131.3998.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2007 at 01:08:51PM +0200, Johannes Berg wrote:
> This fixes a warning that occurs when turning off hostapd.

Thanks, applied.

> This is a slightly modified version of my original patch, please do test
> it as I've not been able to test it right now. The original was fine
> though, but it shut down the eloop in wireless_event_deinit instead of
> here.

I cannot currently even compile driver_devicescape.c successfully never
mind test it ;-), but anyway, this is in the category of obviously
correct fixes, so I have no problems including this without testing.
eloop_unregister_read_sock() did not exist when the code was originally
written and it just started showing up as a warning when I added
debugging code for reporting forgotten eloop entries at program
termination.

-- 
Jouni Malinen                                            PGP id EFC895FA
