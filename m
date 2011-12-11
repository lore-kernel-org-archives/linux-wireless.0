Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54431 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1LKBOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 20:14:36 -0500
Received: by eaak14 with SMTP id k14so2316533eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 17:14:35 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/7] b43: N-PHY fixes, check dependency before applying
Date: Sun, 11 Dec 2011 02:55:28 +0100
Message-Id: <1323568535-2816-1-git-send-email-zajec5@gmail.com> (sfid-20111211_021444_870753_BAA300E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some N-PHY fixes coming from wl observations and specs changes.

Please note this patchset depends on following patches:
[PATCH 1/2] ssb: extract FEM info from SPROM
[PATCH 2/2] bcma: extract FEM info from SPROM
send 3 days ago.

Rafał Miłecki (7):
  b43: N-PHY: random trivial fixes for typos, missing writes
  b43: N-PHY: update some init values
  b43: N-PHY: workaround BCM43224 hw bug in writing table id 9
  b43: N-PHY: add table for antenna software control
  b43: N-PHY: determine various PHY params
  b43: N-PHY: finish 2.4GHz 0x2056 radio setup
  b43: N-PHY: implement spurious tone avoidance

 drivers/net/wireless/b43/phy_n.c       |  262 +++++++++++++++++++++++++++++---
 drivers/net/wireless/b43/phy_n.h       |    8 +
 drivers/net/wireless/b43/radio_2056.c  |   25 +++-
 drivers/net/wireless/b43/radio_2056.h  |    1 +
 drivers/net/wireless/b43/tables_nphy.c |   59 +++++++-
 drivers/net/wireless/b43/tables_nphy.h |   31 ++--
 6 files changed, 342 insertions(+), 44 deletions(-)

-- 
1.7.3.4

