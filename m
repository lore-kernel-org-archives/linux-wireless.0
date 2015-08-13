Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47038 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbbHMJRv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 05:17:51 -0400
Message-ID: <1439457468.2114.9.camel@sipsolutions.net> (sfid-20150813_111813_495437_8768F473)
Subject: Re: [PATCH] mac80211: make local->tx_headroom a multiple of 4
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Thu, 13 Aug 2015 11:17:48 +0200
In-Reply-To: <1438258487-74594-1-git-send-email-nbd@openwrt.org>
References: <1438258487-74594-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-30 at 14:14 +0200, Felix Fietkau wrote:
> This ensures that mac80211 generated management frames and beacons 
> are aligned before being passed to the driver
> 
I'm not convinced this is appropriate. Drivers may or may not require
alignment, so I don't really see why we should in general enforce that?
Having less headroom requirement is better in general.

johannes
