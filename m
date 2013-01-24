Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3AXKpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 05:45:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: backports@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] compat: make hid_match_id static
Date: Thu, 24 Jan 2013 11:46:13 +0100
Message-Id: <1359024373-21365-1-git-send-email-johannes@sipsolutions.net> (sfid-20130124_114553_865444_8E08B51E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Otherwise sparse complains.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 compat/compat-3.8.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/compat/compat-3.8.c b/compat/compat-3.8.c
index 36f3c50..70b004c 100644
--- a/compat/compat-3.8.c
+++ b/compat/compat-3.8.c
@@ -289,8 +289,8 @@ static bool hid_match_one_id(struct hid_device *hdev,
 		(id->product == HID_ANY_ID || id->product == hdev->product);
 }
 
-const struct hid_device_id *hid_match_id(struct hid_device *hdev,
-		const struct hid_device_id *id)
+static const struct hid_device_id *hid_match_id(struct hid_device *hdev,
+						const struct hid_device_id *id)
 {
 	for (; id->bus; id++)
 		if (hid_match_one_id(hdev, id))
-- 
1.8.0

