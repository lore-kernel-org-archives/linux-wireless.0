Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49005 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbbLQK3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 05:29:48 -0500
Message-ID: <1450348183.8247.24.camel@sipsolutions.net> (sfid-20151217_112951_247767_0EC28DDF)
Subject: Re: [RFC/RFT 1/2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org
Date: Thu, 17 Dec 2015 11:29:43 +0100
In-Reply-To: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151217_102050_152022_7DD1C619)
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20151217_102050_152022_7DD1C619)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-17 at 10:20 +0100, Janusz Dziedzic wrote:
> HW/driver should set NEED_ALIGNED4_SKBS flag in case require
> aligned skbs to four-byte boundaries.
> 
> Before we have to do memmove() in the driver before
> pass this to HW and memmove() back in tx completion.
> This patch allow to save CPU and skip such memmoves.

Can you quantify that btw? It shouldn't be that expensive since it's
all in the cache for read, so just has to be written out to RAM before
the DMA can happen... And on status it will be pulled into the cache
anyway, and you don't even need the write to happen before you can
continue.

johannes
