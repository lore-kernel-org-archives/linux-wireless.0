Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:45936 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYBCO4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:56:51 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1587903fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:56:50 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/19] rt2x00: Fix rate initialization
Date: Sun, 3 Feb 2008 15:54:34 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031554.34724.IvDoorn@gmail.com> (sfid-20080203_145656_137047_1C78589C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix typo in rate initialization. This fixes the WARN_ON()
in net/wireless/util.cpp:83

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 3ba1f37..84f0441 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -873,7 +873,7 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Initialize Rate list.
 	 */
 	for (i = 0; i < spec->num_rates; i++)
-		rt2x00lib_rate(&rates[0], i, rt2x00_get_rate(i));
+		rt2x00lib_rate(&rates[i], i, rt2x00_get_rate(i));
 
 	/*
 	 * Initialize Channel list.
-- 
1.5.3.8

