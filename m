Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:35898 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbXHPCGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 22:06:08 -0400
Date: Wed, 15 Aug 2007 19:05:05 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: don't reference ieee80211_msg_sta_not_assoc if it's unused anyway
Message-ID: <20070816020505.GV1415@jm.kir.nu>
References: <1186781881.17351.15.camel@johannes.berg> <20070815034019.GJ1415@jm.kir.nu> <1187174924.3998.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187174924.3998.11.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2007 at 12:48:44PM +0200, Johannes Berg wrote:

> The reason for removing all the ieee80211_msg_* constants is that I'd
> really love to be able to get rid of the prism2 header hack in there. By
> removing it from both sides I've only slightly extended the TODO from
> "fix this in hostapd" to "add API to the kernel and use it in hostapd"
> which I thought appropriate.

OK. I applied both this and the ieee80211_msg_key_threshold_notification
changes. I'm not really fond of that extra header hack either, it just
seemed to be only reasonable option at the time. As far the management
interface itself is concerned, I haven't been convinced of its badness,
but anyway, as far as these two notification events are concerned, there
is not much need for providing the full frame to user space and another
API would be perfectly fine for them.

-- 
Jouni Malinen                                            PGP id EFC895FA
