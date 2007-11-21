Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXKUDUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 22:20:07 -0500
Subject: Re: [PATCH] mac80211: free ifsta->extra_ie in ieee80211_stop
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1195565876.10920.29.camel@johannes.berg>
References: <11955417361539-git-send-email-yi.zhu@intel.com>
	 <1195565876.10920.29.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 21 Nov 2007 11:17:19 +0800
Message-Id: <1195615039.3250.453.camel@debian.sh.intel.com> (sfid-20071121_032014_546431_38745C38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-11-20 at 14:37 +0100, Johannes Berg wrote:
> Yes. But if you do that, the interface won't be down either. 

Indeed. But at least user has a way to let mac80211 forget the previous
setting (ifconfig wlan0 down and up). Otherwise, user has to reload the
modules to achieve this.

> Maybe this should also be done when removing keys?

I agree there are more places we need to clear the setting. Putting it
to ieee80211_stop() is a good start. Should we have a "reset" like
ioctl? So the second config tool can call it to let mac80211 forget all
the previous setting.

Thanks,
-yi
