Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16698 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbXK2JHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 04:07:04 -0500
Subject: Re: [PATCH 1/2] mac80211: set interface MAC address after driver's
	start() is called
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1196326174.6058.173.camel@johannes.berg>
References: <1196300047-6201-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20071129_013615_457152_DDE3939F)  <1196326174.6058.173.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 17:06:48 +0800
Message-Id: <1196327209.7614.113.camel@debian.sh.intel.com> (sfid-20071129_090711_353246_6BFB8DD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-11-29 at 09:49 +0100, Johannes Berg wrote:
> This cannot possibly work We do a lot of MAC address sanity checking
> at _open() time *before* the place where you inserted the MAC address
> copy.

I tested the patch. It works.

> Deferring MAC address setting to open() time is also *very* bad for
> the user experience because they no longer have the guarantee the the
> MAC address they see is the one that will be used when the interface
> is brought up.

Users see 00:00:00:00:00:00 address before up.

Anyway, Tomas pointed my assert for "iwlwifi cannot get MAC address
without firmware being loaded first" is not true. So I don't need to
change mac80211 to adapt this any more (not sure if other driver
requires). An updated patch for iwlwifi will be sent shortly.

Thanks,
-yi
