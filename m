Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37031 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab3C0QQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:16:09 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] b43: make struct b2056_inittabs_pts const
Date: Wed, 27 Mar 2013 17:15:51 +0100
Message-Id: <1364400951-25488-2-git-send-email-hauke@hauke-m.de> (sfid-20130327_171731_744940_5ABF13DC)
In-Reply-To: <1364400951-25488-1-git-send-email-hauke@hauke-m.de>
References: <1364400951-25488-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/radio_2056.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
index ab1f55f..b4fd934 100644
--- a/drivers/net/wireless/b43/radio_2056.c
+++ b/drivers/net/wireless/b43/radio_2056.c
@@ -2980,7 +2980,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev8_rx[] = {
 	.rx		= prefix##_rx,			\
 	.rx_length	= ARRAY_SIZE(prefix##_rx)
 
-static struct b2056_inittabs_pts b2056_inittabs[] = {
+static const struct b2056_inittabs_pts b2056_inittabs[] = {
 	[3] = { INITTABSPTS(b2056_inittab_rev3) },
 	[4] = { INITTABSPTS(b2056_inittab_rev4) },
 	[5] = { INITTABSPTS(b2056_inittab_rev5) },
@@ -9035,7 +9035,7 @@ static void b2056_upload_inittab(struct b43_wldev *dev, bool ghz5,
 void b2056_upload_inittabs(struct b43_wldev *dev,
 			   bool ghz5, bool ignore_uploadflag)
 {
-	struct b2056_inittabs_pts *pts;
+	const struct b2056_inittabs_pts *pts;
 
 	if (dev->phy.rev >= ARRAY_SIZE(b2056_inittabs)) {
 		B43_WARN_ON(1);
@@ -9057,7 +9057,7 @@ void b2056_upload_inittabs(struct b43_wldev *dev,
 
 void b2056_upload_syn_pll_cp2(struct b43_wldev *dev, bool ghz5)
 {
-	struct b2056_inittabs_pts *pts;
+	const struct b2056_inittabs_pts *pts;
 	const struct b2056_inittab_entry *e;
 
 	if (dev->phy.rev >= ARRAY_SIZE(b2056_inittabs)) {
-- 
1.7.10.4

