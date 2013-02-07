Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46169 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab3BGJBP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 04:01:15 -0500
Message-ID: <1360227613.12095.59.camel@cumari.coelho.fi> (sfid-20130207_100119_164565_7DD9DB1A)
Subject: Re: [PATCH] mac80211: remove IEEE80211_HW_SCAN_WHILE_IDLE
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Date: Thu, 7 Feb 2013 11:00:13 +0200
In-Reply-To: <1360227489-11145-1-git-send-email-johannes@sipsolutions.net>
References: <1360227489-11145-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 09:58 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are only a few drivers that use HW scan, and
> all of those don't need a non-idle transition before
> starting the scan -- some don't even care about idle
> at all. Remove the flag and code associated with it.
> 
> The only driver that really actually needed this is
> wl1251 and it can just do it itself in the hw_scan
> callback -- implement that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

For the WiLink drivers:

>  drivers/net/wireless/ti/wl1251/event.c      |  6 +++++-
>  drivers/net/wireless/ti/wl1251/main.c       | 24 +++++++++++++++++++-----
>  drivers/net/wireless/ti/wlcore/main.c       |  1 -

Acked-by: Luciano Coelho <coelho@ti.com>

I'll (hopefully) be able to test the wl1251 change next week.

--
Luca.

