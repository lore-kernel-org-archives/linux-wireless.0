Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:60761 "HELO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932980AbZLMBT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 20:19:29 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>, stable@kernel.org
Subject: [PATCH 2.6.33] rt2x00: Disable powersaving for rt61pci.
Date: Sun, 13 Dec 2009 00:39:40 +0100
Message-Id: <1260661180-2300-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1260661180-2300-1-git-send-email-gwingerde@gmail.com>
References: <1260661180-2300-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've had many reports of rt61pci failures with powersaving enabled.
Therefore, as a stop-gap measure, disable powersaving of the rt61pci
until we have found a proper solution.

Cc: stable@kernel.org
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---

John, this is an urgent fix for 2.6.33 (and stable).

---
 drivers/net/wireless/rt2x00/rt61pci.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 687e17d..2b43a2e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2543,9 +2543,7 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_SIGNAL_DBM |
-	    IEEE80211_HW_SUPPORTS_PS |
-	    IEEE80211_HW_PS_NULLFUNC_STACK;
+	    IEEE80211_HW_SIGNAL_DBM;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
-- 
1.6.5.5

