Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51309 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2KLSrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 13:47:45 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so4478273pad.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 10:47:45 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: ath9k-devel@lists.ath9k.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 0/2] RX timestamp is reported at end of frame
Date: Mon, 12 Nov 2012 10:47:30 -0800
Message-Id: <1352746052-1828-1-git-send-email-thomas@cozybit.com> (sfid-20121112_194750_761750_62AF28D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At least this is true for the chips tested. Verified by bringing up two mesh
nodes and checking their reported TSF offset is symmetrical within 5us. Before
this patch there was a difference of 1.3ms or so.

Thomas Pedersen (2):
  ath9k: RX timestamp is reported at end of frame
  ath9k_htc: RX timestamp is reported at end of frame

 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.10.4

