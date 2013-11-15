Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42693 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560Ab3KODLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 22:11:04 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.13 1/6] mwifiex: use return value of mwifiex_add_virtual_intf() correctly
Date: Thu, 14 Nov 2013 19:10:37 -0800
Message-ID: <1384485042-7083-1-git-send-email-bzhao@marvell.com> (sfid-20131115_041109_171810_53377E85)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

mwifiex_add_virtual_intf() returns ERR_PTR values. So use IS_ERR()
macro instead of checking for NULL pointer.

Reported-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9d7c9d3..7c7da3e 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -418,6 +418,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	struct mwifiex_fw_image fw;
 	struct semaphore *sem = adapter->card_sem;
 	bool init_failed = false;
+	struct wireless_dev *wdev;
 
 	if (!firmware) {
 		dev_err(adapter->dev,
@@ -474,8 +475,9 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 
 	rtnl_lock();
 	/* Create station interface by default */
-	if (!mwifiex_add_virtual_intf(adapter->wiphy, "mlan%d",
-				      NL80211_IFTYPE_STATION, NULL, NULL)) {
+	wdev = mwifiex_add_virtual_intf(adapter->wiphy, "mlan%d",
+					NL80211_IFTYPE_STATION, NULL, NULL);
+	if (IS_ERR(wdev)) {
 		dev_err(adapter->dev, "cannot create default STA interface\n");
 		goto err_add_intf;
 	}
-- 
1.8.2.3

