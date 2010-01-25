Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34521 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0AYSAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:00:01 -0500
Received: by ewy19 with SMTP id 19so12782ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 09:59:59 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/4] more N-PHY, cordic stuff
Date: Mon, 25 Jan 2010 18:59:57 +0100
Message-Id: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds more N-PHY code and modifies cordic function that is currently used
by LP-PHY code. Larry checked this and it still works fine on his LP-PHY card.

Rafał Miłecki (4):
  b43: N-PHY: fix one bit off in parsing RF Ctrl Override arguments
  b43: make cordic common (LP-PHY and N-PHY need it)
  b43: update cordic code to match current specs
  b43: N-PHY: use cordic to generate samples

 drivers/net/wireless/b43/phy_common.c |   45 ++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_common.h |    7 ++++
 drivers/net/wireless/b43/phy_lp.c     |   52 ++++-----------------------------
 drivers/net/wireless/b43/phy_n.c      |   23 ++++++++------
 4 files changed, 71 insertions(+), 56 deletions(-)

