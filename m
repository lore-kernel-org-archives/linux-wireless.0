Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2CRKSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 06:18:05 -0400
Subject: Re: [PATCH 3/3] mac80211: optimize aggregation session timeout
 handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1332025254-5048-3-git-send-email-nbd@openwrt.org>
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org>
	 <1332025254-5048-2-git-send-email-nbd@openwrt.org>
	 <1332025254-5048-3-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Mar 2012 11:17:55 +0100
Message-ID: <1332065875.3609.3.camel@jlt3.sipsolutions.net> (sfid-20120318_111836_625165_78E08EAB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-03-18 at 00:00 +0100, Felix Fietkau wrote:
> Calling mod_timer from the rx/tx hotpath is somewhat expensive, and the
> timeout doesn't need to be so precise.
> 
> Switch to a different strategy: Schedule the timer initially, store jiffies
> of all last rx/tx activity which would previously modify the timer, and
> let the timer re-arm itself after checking the last rx/tx timestamp.

I don't like this. It's not the optimisation you think it is on other
("embedded") systems where firing a timer is more expensive.

You're trading power consumption against CPU utilisation by causing the
timer to wake up.

johannes

