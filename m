Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63856 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbZFLLPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:15:41 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 09/33] wl12xx: removed chipset interrupt source configuration
	from fw wakeup
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:15:13 +0300
Message-ID: <20090612111513.8877.35317.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The chipset source interrupt source configuration during fw wakeup was
blocking interrupts on the wl1271. The configuration is effectively
unused here as it is used to trigger an interrupt for the chipset
wake-up event, which is not handled, or waited for, in the fw wakeup
anyway on either wl1251 or wl1271.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3c6cd77..950c425 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -157,8 +157,6 @@ static void wl12xx_fw_wakeup(struct wl12xx *wl)
 
 	if (!(elp_reg & ELPCTRL_WLAN_READY)) {
 		wl12xx_warning("WLAN not ready");
-		elp_reg = ELPCTRL_WAKE_UP_WLAN_READY;
-		wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
 	}
 }
 

