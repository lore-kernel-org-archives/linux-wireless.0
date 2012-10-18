Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2JRPTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 11:19:03 -0400
Message-ID: <1350573572.10638.18.camel@jlt4.sipsolutions.net> (sfid-20121018_171912_246564_55661305)
Subject: Re: [PATCH v3 3.7 1/2] cfg80211: fix antenna gain handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Date: Thu, 18 Oct 2012 17:19:32 +0200
In-Reply-To: <1350474980-59623-1-git-send-email-nbd@openwrt.org>
References: <1350474980-59623-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-17 at 13:56 +0200, Felix Fietkau wrote:
> No driver initializes chan->max_antenna_gain to something sensible, and
> the only place where it is being used right now is inside ath9k. This
> leads to ath9k potentially using less tx power than it can use, which can
> decrease performance/range in some rare cases.
> 
> Rather than going through every single driver, this patch initializes
> chan->orig_mag in wiphy_register(), ignoring whatever value the driver
> left in there. If a driver for some reason wishes to limit it independent
> from regulatory rulesets, it can do so internally.

Applied both.

johannes

