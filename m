Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65334 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYHDDc0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 23:32:26 -0400
Subject: Re: [IWL3945]Fix statistics in monitor mode
From: Zhu Yi <yi.zhu@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <4892E14A.4000203@gmail.com>
References: <4892E14A.4000203@gmail.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 11:32:17 +0800
Message-Id: <1217820737.3107.15.camel@debian.sh.intel.com> (sfid-20080804_053229_620779_28DBD6D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-08-01 at 13:11 +0300, Maxim Levitsky wrote:
> I guess it is time for me to add my .02 cents to iwlwifi driver.
> Recently I reported a bug about crazy statistics (> 100 quality for 
> example) when turning on the monitor interface (this bug actually is 
> triggered when card is put in monitor mode, thus shows up when promisc
> mode enabled as well)
> 
> It turns out that iwl3945_rx_reply_rx wasn't filling in the statistics
> when running in monitor on, instead a garbage was passed.

Good catch. I'd suggest change 3945 the same way as 4965. That is, move
the iwl_pass_packet_to_mac80211() for MNTR before setting
priv->last_beacon_time, et al. We don't need to update these fields in
monitor mode anyway.

Thanks,
-yi

