Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24076 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXLYDbh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 22:31:37 -0500
Subject: Re: [PATCH] mac80211: Restore rx.fc before every invocation of
	ieee80211_invoke_rx_handlers
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <hschaa@suse.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1198491831.4103.17.camel@johannes.berg>
References: <200712211516.35731.hschaa@suse.de>
	 (sfid-20071221_141215_108356_0F4BE6F7) <1198401880.4116.6.camel@johannes.berg>
	 <20071223123517.17ds9zttxc4goo00@imap.suse.de>
	 <1198417706.4000.1.camel@johannes.berg>
	 <1198467294.3065.180.camel@debian.sh.intel.com>
	 <1198491831.4103.17.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 25 Dec 2007 11:31:37 +0800
Message-Id: <1198553497.3065.237.camel@debian.sh.intel.com> (sfid-20071225_033147_428859_4C7D63E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-24 at 11:23 +0100, Johannes Berg wrote:
> I don't think it does, does it? In prepare_for_handlers frames aren't
> sent to the master device while not scanning.

Should we also discard frames to mdev if ((rx->fc &
IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)?

Thanks,
-yi

