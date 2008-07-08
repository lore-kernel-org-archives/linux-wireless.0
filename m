Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:27552 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYGHO0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 10:26:51 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1383929fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 07:26:49 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: Daniel Drake <dsd@gentoo.org>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Tue, 8 Jul 2008 16:19:21 +0200
Subject: [PATCH] zd1211rw: stop beacons on remove_interface
Message-ID: <48737927.1b5c4e0a.40bc.ffff9c90@mx.google.com> (sfid-20080708_162657_782297_B9F1A5DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a mesh or ad-hoc interface is brought up and later it is replaced by managed
interface, the managed interface will keep transmitting the beacons that were
configured for the former interface. This patch fixes that behaviour.
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 317c5e2..b8873e6 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -684,6 +684,7 @@ static void zd_op_remove_interface(struct ieee80211_hw *hw,
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	mac->type = IEEE80211_IF_TYPE_INVALID;
+	zd_set_beacon_interval(&mac->chip, 0);
 	zd_write_mac_addr(&mac->chip, NULL);
 }
 
-- 
1.5.4.3



