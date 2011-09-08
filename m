Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38572 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1IHMjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 08:39:35 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so268175ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 05:39:34 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/7] rt2x00: Forbid aggregation for STAs not programmed into the hw
Date: Thu, 8 Sep 2011 14:38:36 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201109081434.23635.IvDoorn@gmail.com> <201109081437.20667.IvDoorn@gmail.com> <201109081438.02330.IvDoorn@gmail.com>
In-Reply-To: <201109081438.02330.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109081438.37130.IvDoorn@gmail.com> (sfid-20110908_143941_262382_E649553B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

If a STA is not known by the hw (i.e. has no WCID assigned) don't allow
aggregation since this might mess up tx status reports and we won't be
able to distinguish the reports of multiple WCID-less STAs.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7edd487..2f4d51a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4489,8 +4489,19 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 			u8 buf_size)
 {
+	struct rt2x00_sta *sta_priv = (struct rt2x00_sta *)sta->drv_priv;
 	int ret = 0;
 
+	/*
+	 * Don't allow aggregation for stations the hardware isn't aware
+	 * of because tx status reports for frames to an unknown station
+	 * always contain wcid=255 and thus we can't distinguish between
+	 * multiple stations which leads to unwanted situations when the
+	 * hw reorders frames due to aggregation.
+	 */
+	if (sta_priv->wcid < 0)
+		return 1;
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 	case IEEE80211_AMPDU_RX_STOP:
-- 
1.7.3.4
