Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab1KXNFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 08:05:46 -0500
Subject: Re: [PATCH] mac80211: do not pass AP VLAN vif pointers to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1322057389-22421-1-git-send-email-nbd@openwrt.org>
References: <1322057389-22421-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 14:05:42 +0100
Message-ID: <1322139942.5366.3.camel@jlt3.sipsolutions.net> (sfid-20111124_140549_664489_7EBC9B9D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-23 at 21:09 +0700, Felix Fietkau wrote:
> This fixes frequent WARN_ONs when using AP VLAN + aggregation, as these vifs
> are virtual and not registered with drivers.
> Use sta_info_get_bss instead of sta_info_get in aggregation callbacks, so
> that these callbacks can find the station entry when called with the AP vif.

Looks fine to me. Goes to show what a little debugging code can
uncover ...

johannes

