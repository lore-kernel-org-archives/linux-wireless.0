Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42573 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXLXDew (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 22:34:52 -0500
Subject: Re: [PATCH] mac80211: Restore rx.fc before every invocation of
	ieee80211_invoke_rx_handlers
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <hschaa@suse.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1198417706.4000.1.camel@johannes.berg>
References: <200712211516.35731.hschaa@suse.de>
	 (sfid-20071221_141215_108356_0F4BE6F7) <1198401880.4116.6.camel@johannes.berg>
	 <20071223123517.17ds9zttxc4goo00@imap.suse.de>
	 <1198417706.4000.1.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 24 Dec 2007 11:34:54 +0800
Message-Id: <1198467294.3065.180.camel@debian.sh.intel.com> (sfid-20071224_033500_476146_C2FA1472)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 2007-12-23 at 14:48 +0100, Johannes Berg wrote:
> Ah, that must be because of the stuff Zhu Yi did wrt. hw scanning.
> Could you take a look too please? The patch looks pretty much ok to me
> and I think it'd be required with say VLAN interfaces as well.

The patch looks fine to me. Hardware scanning is a trigger that makes
the condition more likely to happen, the patch itself fixes the more
general problem for multiple interfaces.

An off-topic question: should wmaster0 continue to execute more rx
handlers (i.e ieee80211_rx_h_remove_qos_control) even if it knows it
will drop them finially?

Thanks,
-yi

