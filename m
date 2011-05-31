Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57249 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab1EaGfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 02:35:25 -0400
Subject: Re: [PATCH 6/6] mac80211: stop queues before rate control updation
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1305894135-14036-6-git-send-email-rmanoharan@atheros.com> (sfid-20110520_142300_320315_15BD860C)
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
	 <1305894135-14036-6-git-send-email-rmanoharan@atheros.com>
	 (sfid-20110520_142300_320315_15BD860C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 08:35:17 +0200
Message-ID: <1306823717.9366.3.camel@jlt3.sipsolutions.net> (sfid-20110531_083530_915981_6933326C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-20 at 17:52 +0530, Rajkumar Manoharan wrote:
> Stop tx queues before updating rate control to ensure
> proper rate selection. Otherwise packets can be transmitted
> in 40 Mhz whereas hw is configured in HT20.

Looks like I completely missed this since you hid it in an ath9k
patchset. DON'T DO THAT.

Anyway, John, please revert. This is completely useless. Not only is
abusing the CSA stop reason a show-stopper, the whole patch is also just
not right, it seems like a workaround around a rate control algorithm
that isn't able to do an atomic HT change by itself. Also, it won't even
do what you want, there may be packets being processed concurrently
while stopping the queue -- calling stop_queues() is no guarantee that
no packet will be processed afterwards.

johannes

