Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38609 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877AbbIVOZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 10:25:09 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Johnny Kim <johnny.kim@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Glen Lee <glen.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH] staging: wicl1000: remove duplicated operand in OR operation
Date: Tue, 22 Sep 2015 16:24:58 +0200
Message-Id: <1442931898-7434-1-git-send-email-javier@osg.samsung.com> (sfid-20150922_162534_343417_8D97A20F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IEEE80211_STYPE_PROBE_REQ flag appears twice in the expression
and coccicheck complains with:

wilc_wfi_cfgoperations.h:80:3-38: duplicated argument to & or |

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 4d37c4e859e9..25490c2af1e9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -80,7 +80,6 @@ static const struct ieee80211_txrx_stypes
 			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
 			BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
 			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
-			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
 			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
 			BIT(IEEE80211_STYPE_AUTH >> 4) |
 			BIT(IEEE80211_STYPE_DEAUTH >> 4)
-- 
2.4.3

