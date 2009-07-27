Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31578 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZG0S42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:56:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 11:56:29 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 1/2] ar76c50x-usb: cancel promisc work during mac80211 stop
Date: Mon, 27 Jul 2009 11:56:23 -0700
Message-ID: <1248720984-15922-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248720984-15922-1-git-send-email-lrodriguez@atheros.com>
References: <1248720984-15922-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We weren't ever cancelling this.

Cc: Kalle Valo <kalle.valo@iki.fi>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/at76c50x-usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 13303fa..bbf5277 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1773,6 +1773,8 @@ static void at76_mac80211_stop(struct ieee80211_hw *hw)
 
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
 
+	cancel_work_sync(&priv->work_set_promisc);
+
 	mutex_lock(&priv->mtx);
 
 	if (!priv->device_unplugged) {
-- 
1.6.0.4

