Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58657 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759658AbZKZJCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 04:02:33 -0500
Subject: [PATCH 1/3] wl1251: remove false warning messages
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 10:55:55 +0200
Message-ID: <20091126085555.1564.9424.stgit@tikku>
In-Reply-To: <20091126085256.1564.77644.stgit@tikku>
References: <20091126085256.1564.77644.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

There was a warning from wl1251_op_bss_info_changed():

wl1251: WARNING Set ctsprotect failed 0

It was printed always, it's completely false and can be removed.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index ff4be7b..8353139 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1181,8 +1181,6 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 					  wl->beacon_int, wl->dtim_period);
 			if (ret < 0)
 				goto out_sleep;
-			wl1251_warning("Set ctsprotect failed %d", ret);
-			goto out_sleep;
 		}
 	}
 

