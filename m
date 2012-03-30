Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62682 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2C3EiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 00:38:21 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20341.14488.303053.16407@gargle.gargle.HOWL> (sfid-20120330_063851_806742_D5BF1F6B)
Date: Fri, 30 Mar 2012 10:07:44 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] mac80211: remove channel type argument from rate_update
In-Reply-To: <20120328085901.175434140@sipsolutions.net>
References: <20120328085835.902687300@sipsolutions.net>
	<20120328085901.175434140@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The channel type argument to the rate_update()
> callback isn't really the correct way to give
> the rate control algorithm about the desired
> RX bandwidth of the peer.
> 
> Remove this argument, and instead update the
> STA capabilities with 20/40 appropriately. The
> SMPS update done by this callback works in the
> same way, so this makes the callback cleaner.

I think that the HT capabilities cannot be changed dynamically.
The HT operating parameters along with ChannelSwitch frames are used to
notify bandwidth changes. Or that is my understanding of 11.14.4.2.

Sujith
