Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36998 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYLCTfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 14:35:19 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 11:35:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 0/2] ath9k: few memory fixes
Date: Wed, 3 Dec 2008 03:35:28 -0800
Message-ID: <1228304130-11337-1-git-send-email-lrodriguez@atheros.com> (sfid-20081203_203524_585146_0FE0D144)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series addresses some memory issues present on ath9k
regarding allocation and not handling failed DMA maps.

This v3 gets the txq from the txctl and sprinkles some more
unlikely()s where appropriate.

  Luis

Luis R. Rodriguez (2):
  ath9k: Check for pci_map_single() errors
  ath9k: Use GFP_ATOMIC when allocating TX private area

 drivers/net/wireless/ath9k/beacon.c |   16 ++++++++++++-
 drivers/net/wireless/ath9k/recv.c   |   17 +++++++++++++
 drivers/net/wireless/ath9k/xmit.c   |   43 ++++++++++++++++++++++++++++++++--
 3 files changed, 72 insertions(+), 4 deletions(-)

