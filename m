Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:4750 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYJGHSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 03:18:32 -0400
Received: by yw-out-2324.google.com with SMTP id 9so508124ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 00:18:30 -0700 (PDT)
Message-ID: <43e72e890810070018p2028da6bua2287bed6d8ea16@mail.gmail.com> (sfid-20081007_091839_170266_CDF23030)
Date: Tue, 7 Oct 2008 00:18:30 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Temporary aggregation patches for 2.6.27 and wireless-testing
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK so I'm done with some patches that don't oops, at least
immediately, and its nothing pretty. I have patchsets for 2.6.27-rc8
and for wireless-testing as of today. I only tested the patchset for
2.6.27-rc8 but remember -- this is just for distributions who want
some 11n throughput on 2.6.27 or developers who want to test/hack on
aggregation. This is in no way shape or form should be considered to
be merged as its not up to upstream merge inclusion standards:

 * The patch does too much rework
 * I think ieee80211_reque() is requeuing onto the the same queue upon
removal of a queue, could be wrong
 * I see no point in using ieee80211_requeue() being called upon rmmod path
 * I just uncommented ieee80211_ht_agg_queue_remove() out which fixes
rmmod panic on scheduling while atomic -- this path only gets hit upon
ieee80211_stop_tx_ba_cb() which so far I've seen happen upon rmmod,
but I'm sure there are some other code paths it hits somewhere I
guess.

If indeed ignoring ieee80211_ht_agg_queue_remove() is OK under
ieee80211_stop_tx_ba_cb() I'd feel more comfortable on recommending
this strongly but at this point I am just not sure.

Anyway at this point I'm going to stop looking at 2.6.27 as we just
need to give aggregation a good cleaning and this needs to happen on
wireless-testing. First priority is to get it working, and if I get to
it first I plan on doing that by removing the whole tid to queue
mapping, and simply mapping skbs to ACs. Then the driver can do what
it needs for scheduling. Let me know what you think.

Use at your own risk.

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/mac80211/aggrv9-2.6.27.tar
http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/mac80211/aggrv9-wl.tar

  Luis
