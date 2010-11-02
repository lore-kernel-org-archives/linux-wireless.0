Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:47849 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab0KBBAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 21:00:14 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	seno <senada@t-online.de>
Subject: [PATCH 9/9] rtl8187: restore anaparam registers after reset with 8187B
Date: Mon,  1 Nov 2010 22:59:39 -0200
Message-Id: <1288659579-4986-10-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current 8187B initialization misses anaparam registers restore after
8187 reset. This causes ANAPARAM register to stay zeroed out (ANAPARAM2
kept its value on my tests). To avoid this, call rtl8187_set_anaparam
right after chip reset (to be on the safe side, as it makes sure we
restore all ANAPARAM registers).

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: seno <senada@t-online.de>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 4448647..eeee244 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -771,6 +771,8 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	if (res)
 		return res;
 
+	rtl8187_set_anaparam(priv, true);
+
 	/* BRSR (Basic Rate Set Register) on 8187B looks to be the same as
 	 * RESP_RATE on 8187L in Realtek sources: each bit should be each
 	 * one of the 12 rates, all are enabled */
-- 
1.7.3.2

