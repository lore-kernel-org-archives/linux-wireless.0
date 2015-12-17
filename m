Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49081 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbbLQKpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 05:45:24 -0500
Message-ID: <1450349121.8247.26.camel@sipsolutions.net> (sfid-20151217_114527_950182_FA677E0D)
Subject: Re: [RFC/RFT 1/2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 17 Dec 2015 11:45:21 +0100
In-Reply-To: <56728FE7.4090006@openwrt.org>
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1450348183.8247.24.camel@sipsolutions.net> <56728FE7.4090006@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-17 at 11:35 +0100, Felix Fietkau wrote:
> 
> On many devices that I'm using, the data path is definitely too
> bloated
> for the packet to still be in cache, so I do think this will help.
> Remember, having only 32 KiB Dcache (no L2) is not uncommon on
> devices
> running ath9k.

Hm, ok :)

> > And on status it will be pulled into the cache
> > anyway, and you don't even need the write to happen before you can
> > continue.
> This doesn't make sense to me. The write needs to happen before the
> device can do DMA...
> 

On *status* :)

johannes
