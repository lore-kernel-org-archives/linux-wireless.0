Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:60632 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161498Ab3DEDET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 23:04:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	<daniel@zonque.org>, Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 0/4] Andreas Fenkart's patches to fix a dead loop
Date: Thu, 4 Apr 2013 20:03:49 -0700
Message-ID: <1365131033-7417-1-git-send-email-bzhao@marvell.com> (sfid-20130405_050430_778100_FFE9AF57)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v3: minor cleanups for coding style; shorten lines in commit logs.
v2: split 6 patches into 2 patchsets. This is the set 1.

Andreas Fenkart (4):
  mwifiex: correct wrong list in list_empty check
  mwifiex: remove unused tid_tbl_lock from mwifiex_tid_tbl
  mwifiex: fix infinite loop by removing NO_PKT_PRIO_TID
  mwifiex: hold proper locks when accessing ra_list / bss_prio lists

 drivers/net/wireless/mwifiex/init.c |    4 +-
 drivers/net/wireless/mwifiex/main.h |    3 -
 drivers/net/wireless/mwifiex/wmm.c  |   71 ++++++++++++++++++-----------------
 3 files changed, 37 insertions(+), 41 deletions(-)

