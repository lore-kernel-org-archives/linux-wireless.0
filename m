Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48218 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab1A3MYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:54 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so2118506ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:53 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/21] rt2x00: Copy the MAC address to the WCID entry properly.
Date: Sun, 30 Jan 2011 13:23:03 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301322.23247.IvDoorn@gmail.com> <201101301322.42545.IvDoorn@gmail.com>
In-Reply-To: <201101301322.42545.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301323.04342.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Use the specific mac field of the wcid_entry structure to copy the MAC
address to, instead of just overwriting the structure.
Previous code resulted in the same, but this form is cleaner.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 4c34fce..c9bf074 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1030,7 +1030,7 @@ static void rt2800_config_wcid_attr(struct rt2x00_dev *rt2x00dev,
 
 	memset(&wcid_entry, 0, sizeof(wcid_entry));
 	if (crypto->cmd == SET_KEY)
-		memcpy(&wcid_entry, crypto->address, ETH_ALEN);
+		memcpy(wcid_entry.mac, crypto->address, ETH_ALEN);
 	rt2800_register_multiwrite(rt2x00dev, offset,
 				      &wcid_entry, sizeof(wcid_entry));
 }
-- 
1.7.2.3

