Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29191 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbaKGKQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 05:16:01 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: fix version display problem on big endian platforms
Date: Fri, 7 Nov 2014 02:14:52 -0800
Message-ID: <1415355292-1929-1-git-send-email-akarwar@marvell.com> (sfid-20141107_111611_204094_A420B5BE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been observed that wrong firmware version (ex. 66.14.96.p9
instead of 14.66.9.p96) is displayed on big endian platforms.

The problem is fixed here.

Reported-by: Daniel Mosquera <daniel.mosquera@ctag.com>
Tested-by: Daniel Mosquera <daniel.mosquera@ctag.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 92f3eb8..1626868 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1026,12 +1026,12 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 			       int max_len)
 {
 	union {
-		u32 l;
+		__le32 l;
 		u8 c[4];
 	} ver;
 	char fw_ver[32];
 
-	ver.l = adapter->fw_release_number;
+	ver.l = cpu_to_le32(adapter->fw_release_number);
 	sprintf(fw_ver, "%u.%u.%u.p%u", ver.c[2], ver.c[1], ver.c[0], ver.c[3]);
 
 	snprintf(version, max_len, driver_version, fw_ver);
-- 
1.8.1.4

