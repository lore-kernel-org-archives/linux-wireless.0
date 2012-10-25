Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620Ab2JYHwJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 03:52:09 -0400
Date: Thu, 25 Oct 2012 09:51:39 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Pavel Lucik <pavel.lucik@gmail.com>
Subject: [PATCH] rt2800: validate step value for temperature compensation
Message-ID: <20121025075138.GA2330@redhat.com> (sfid-20121025_095214_277751_9A0CBD6C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware has correct (!= 0xff) value of tssi_bounds[4] in the
EEPROM, but step is equal to 0xff. This results on ridiculous delta
calculations and completely broke TX power settings.

Reported-and-tested-by: Pavel Lucik <pavel.lucik@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3bc206d..c0441a7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2449,7 +2449,7 @@ static int rt2800_get_gain_calibration_delta(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Check if temperature compensation is supported.
 	 */
-	if (tssi_bounds[4] == 0xff)
+	if (tssi_bounds[4] == 0xff || step == 0xff)
 		return 0;
 
 	/*
-- 
1.7.1

