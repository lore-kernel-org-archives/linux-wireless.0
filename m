Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([66.92.66.146]:35130 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbcCDBQb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 20:16:31 -0500
From: Tim Shepard <shep@alum.mit.edu>
To: linux-wireless@vger.kernel.org
cc: michal.kazior@tieto.com, johannes@sipsolutions.net,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	dave.taht@gmail.com, emmanuel.grumbach@intel.com, nbd@openwrt.org,
	andrewmcgr@google.com, apenwarr@google.com
Subject: [PATCH RFC/RFT 0/2] ath9k: use mac80211 intermediate software queues
Date: Thu, 03 Mar 2016 20:06:12 -0500
Message-Id: <E1abeC4-0007p7-00@www.xplot.org> (sfid-20160304_021637_711644_BE45A9EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Here is a patch in two parts to have ath9k make use the new
intermediate queues in mac80211.   It seems to work for me, but it
clearly needs more testing.

This should be useful to anyone who wants to try Michal's patch from
last week "mac80211: implement fq_codel for software queuing" as that
patch will not do anything unless you have a mac80211 driver that uses
the new mac80211 intermediate queues and indicates to mac80211 that
it does so by having a non-zero .wake_tx_queue method.

The first patch just renames the struct ath_txq in ath9k to be
struct ath_hwq and the renames the variables and fields holding a
pointer to it to be hwq  (instead of txq).

This first patch is IMHO needed because I had an earlier version of
this without renaming ath_txq and it was too mind bending to try and
keep straight which was ath9k's txq (which is per hardware queue)
and what was mac80211 txq (which is per station per tid).

The second patch changes ath9k to use the new mac80211 intermediate
software queues.

I left the existing ath9k software queue mechanisms in place. They
are used by the channel context code in some cases even for non-data
frames, and in any case it seemed like a safer first step to get this
working before removing code.  Yes, we should eventually clean this
up once this is tested and we figure out what the right way to do
the clean up.   I see little harm in leaving it stay for awhile.

I have not tried any testing with CONFIG_ATH9K_CHANNEL_CONTEXT=y and
I am not even sure what I would need to do to properly exercise that.

Please comment and/or test.

			-Tim Shepard
			 shep@alum.mit.edu
