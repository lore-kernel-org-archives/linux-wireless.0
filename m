Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbZGMWg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 18:36:56 -0400
Message-Id: <20090713223333.042733013@sipsolutions.net>
Date: Tue, 14 Jul 2009 00:33:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] wireless network namespace work
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This series implements most of the net namespace awareness
for wireless (well, those bits that davem doesn't already
have).

This depends on the following commits from net-next-2.6:

  commit 30ffee8480c13fbcf8ab6c28e31f79dfff683117
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Fri Jul 10 09:51:35 2009 +0000

      net: move and export get_net_ns_by_pid

  commit 134e63756d5f3d0f7604dfcca847b09d1b14fd66
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Fri Jul 10 09:51:34 2009 +0000

      genetlink: make netns aware

  commit 11a28d373ed2539a110d56419457e2e7db221ac7
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Fri Jul 10 09:51:33 2009 +0000

      net: make namespace iteration possible under RCU

  commit 6c04bb18ddd633b7feac2c8fe2ae0bf61d20ca7a
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Fri Jul 10 09:51:32 2009 +0000

      netlink: use call_rcu for netlink_change_ngroups

(well, it only depends on the first and second, but the second
in turn depends on the other two)

Not sure -- can you cherry-pick these and things just work?

johannes

