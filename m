Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44709 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbaGMPCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 11:02:34 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: GFP flags for cfg80211_rx_mgmt
Date: Sun, 13 Jul 2014 08:02:30 -0700
Message-ID: <2433125.jSlKTrms1X@lx-wigig-72> (sfid-20140713_170240_313288_84D74654)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In the cfg80211_rx_mgmt(), there is parameter 'gfp_t gfp' that is
passed to the nl80211_send_mgmt() and then to alloc_skb().
In fact, nl80211_send_mgmt() called under spinlock, so
one can't use GFP_KERNEL. However, documentation for
cfg80211_rx_mgmt does not restrict GFP flags.

I suggest to document this, and enforce in some way (WARN_ONCE?),
or just remove this parameter - everywhere in the kernel
GFP_ATOMIC is used.

Thanks, Vladimir
