Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:37256 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108Ab1GMIwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:52:17 -0400
Message-ID: <4E1D5CB7.7070607@adurom.com> (sfid-20110713_105223_632412_78F88FA5)
Date: Wed, 13 Jul 2011 11:52:07 +0300
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [TODO] at76c50x: remove wext includes
References: <1310546836.3873.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1310546836.3873.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 11:47 AM, Johannes Berg wrote:
> Not possible right now:
> at76c50x-usb.h:404:11: error: ‘IW_ESSID_MAX_SIZE’ undeclared here (not in a function)
> at76c50x-usb.c: In function ‘at76_startup_device’:
> at76c50x-usb.c:1371:263: error: ‘IW_MODE_ADHOC’ undeclared (first use in this function)
> at76c50x-usb.c:1371:263: note: each undeclared identifier is reported only once for each function it appears in
> at76c50x-usb.c: In function ‘at76_add_interface’:
> at76c50x-usb.c:1863:19: error: ‘IW_MODE_INFRA’ undeclared (first use in this function)
> at76c50x-usb.c: In function ‘at76_init_new_device’:
> at76c50x-usb.c:2269:18: error: ‘IW_MODE_INFRA’ undeclared (first use in this function)
> 
> but none of those constants should be used in a mac80211 driver.
> 
> Also this driver is missing a MAINTAINERS entry.

The driver has been broken due to the mac80211 changes for a long time
and it's obvious that I can't maintain it anymore as I haven't touched
it for a long time. I would like to just remove it altogether. Any
objections?

If someone wants to step up and fix it, now is the time to do it.

Kalle
