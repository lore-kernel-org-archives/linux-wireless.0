Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:58197 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab3ERMC3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:29 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:26 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 03/32] rt2800: add rt2800_init_bbp_305x_soc subroutine
Date: Sat, 18 May 2013 14:03:26 +0200
Message-Id: <1368878635-4455-4-git-send-email-stf_xl@wp.pl> (sfid-20130518_140232_805328_2283E90A)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

New routine for SOC specific BBP initialization, empty for now.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e04b1fa..697e38b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3953,6 +3953,10 @@ static void rt2800_init_bbp_early(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 }
 
+static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
+{
+}
+
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 {
 }
@@ -4062,6 +4066,9 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	u8 reg_id;
 	u8 value;
 
+	if (rt2800_is_305x_soc(rt2x00dev))
+		rt2800_init_bbp_305x_soc(rt2x00dev);
+
 	switch (rt2x00dev->chip.rt) {
 	case RT2860:
 	case RT2872:
-- 
1.7.4.4

