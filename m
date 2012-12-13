Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2LMW7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:59:19 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Eliad Peller <eliad@wizery.com>
Subject: [PATCH 0/5] mac80211: fix station cleanup/destruction
Date: Thu, 13 Dec 2012 23:59:28 +0100
Message-Id: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net> (sfid-20121213_235922_790374_BA80AD0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Turns out that not only was flush_workqueue() slow as reported
by Ben, it was also broken because this is way too late to
finish the station destruction in AP mode.

Fixing this with keeping the roaming semantics (no RCU barrier
or synchronize in there) is a bit tricky so the first patch just
fixes the problem, and the last patch puts back the optimisation.

The patches inbetween are just padding ;-)

johannes

