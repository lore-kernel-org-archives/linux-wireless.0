Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37962 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752408AbeBHWIc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 17:08:32 -0500
Received: by mail-wm0-f66.google.com with SMTP id 141so12708491wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2018 14:08:32 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt7601u: set device mac address in mt7601u_add_interface()
Date: Thu,  8 Feb 2018 23:08:09 +0100
Message-Id: <c2fe73b04dac0827adf135e669ed441f9ed1d13c.1518126991.git.lorenzo.bianconi@redhat.com> (sfid-20180208_230835_653566_853C3B23)
In-Reply-To: <cover.1518126991.git.lorenzo.bianconi@redhat.com>
References: <cover.1518126991.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If mac80211 adds a vif with a different mac address respect to
the eeprom one, the device will not be able to connect to the ap
since the hw address has not been updated.
Fix the issue updating hw mac address in mt7601u_add_interface routine

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1516935
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
index 43ebd460ba86..3c9ea40d9584 100644
--- a/drivers/net/wireless/mediatek/mt7601u/main.c
+++ b/drivers/net/wireless/mediatek/mt7601u/main.c
@@ -64,6 +64,9 @@ static int mt7601u_add_interface(struct ieee80211_hw *hw,
 	 */
 	mvif->idx = idx;
 
+	if (!ether_addr_equal(dev->macaddr, vif->addr))
+		mt7601u_set_macaddr(dev, vif->addr);
+
 	if (dev->wcid_mask[wcid / BITS_PER_LONG] & BIT(wcid % BITS_PER_LONG))
 		return -ENOSPC;
 	dev->wcid_mask[wcid / BITS_PER_LONG] |= BIT(wcid % BITS_PER_LONG);
-- 
2.14.3
