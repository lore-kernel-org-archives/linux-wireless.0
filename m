Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58096 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZCFFNv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:13:51 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:13:50 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <j@w1.fi>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211_hwsim: add regulatory_hint support
Date: Thu, 5 Mar 2009 21:13:07 -0800
Message-ID: <1236316387-9718-2-git-send-email-lrodriguez@atheros.com> (sfid-20090306_061402_995415_05AEAE08)
In-Reply-To: <1236316387-9718-1-git-send-email-lrodriguez@atheros.com>
References: <1236316387-9718-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ACME Inc. only sells these in Finland.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d8716be..395f13d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -878,6 +878,12 @@ static int __init init_mac80211_hwsim(void)
 			goto failed_hw;
 		}
 
+		/*
+		 * We have no EEPROM but we know ACME Inc. only sells
+		 * these in Finland.
+		 */
+		regulatory_hint(hw->wiphy, "FI");
+
 		printk(KERN_DEBUG "%s: hwaddr %pM registered\n",
 		       wiphy_name(hw->wiphy),
 		       hw->wiphy->perm_addr);
-- 
1.6.1.2.253.ga34a

