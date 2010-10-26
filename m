Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19600 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0JZW13 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 18:27:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 15:27:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <greearb@candelatech.com>,
	<kyungwan.nam@atheros.com>, <amod.bodas@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] ath9k: more PCU locking enhancements
Date: Tue, 26 Oct 2010 15:27:22 -0700
Message-ID: <1288132045-4718-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This addresses some more DMA / PCU locking. It simplifies the locking
and includes now TX control over the PCU. These patches help with the
overall realiability of RX and TX and conflicts between them and
resets. When you start/stop RX or TX or do resets it will all be
done atomically now. These all now go tested by Ben Greear over at
candelatech.com using a proprietary userspace applicatin which
creates 130 STAs associating to one AP that only accepts 30 STAs at
a time. Ben had never seen this test run more than about 10 minutes
without poison warnings and/or lockups.

This last series (first series addressed RX poison issues) addresses
the last bit of complaints on DMA that he got when testing with these
large amount of STAs on one 802.11 device.
    
For more details about this issue refer to this thread:

http://marc.info/?l=linux-wireless&m=128629803703756&w=2

Many thanks to Ben Greear @ candelatech.com for the testing, reports
and patience with this.

Luis R. Rodriguez (3):
  ath9k: simplify hw reset locking
  ath9k: move the PCU lock to the sc structure
  ath9k: content DMA start / stop through the PCU lock

 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +-
 drivers/net/wireless/ath/ath9k/init.c  |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |   70 ++++++++++++++------------------
 drivers/net/wireless/ath/ath9k/recv.c  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |    4 +-
 5 files changed, 34 insertions(+), 46 deletions(-)

-- 
1.7.3.2.90.gd4c43

