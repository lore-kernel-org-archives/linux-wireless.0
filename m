Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53841 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560Ab3KODKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 22:10:53 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.13 3/6] mwifiex: fix NULL pointer dereference in mwifiex_fw_dpc
Date: Thu, 14 Nov 2013 19:10:39 -0800
Message-ID: <1384485042-7083-3-git-send-email-bzhao@marvell.com> (sfid-20131115_041055_770789_292CF6DA)
In-Reply-To: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
References: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We don't need to free/unregister wiphy when
mwifiex_register_cfg80211() fails. The routine internally takes
care of it. This redundant code can cause NULL pointer dereference,
for adapter->wiphy.

Reported-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9236b42..42d9a68 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -470,7 +470,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	priv = adapter->priv[MWIFIEX_BSS_ROLE_STA];
 	if (mwifiex_register_cfg80211(adapter)) {
 		dev_err(adapter->dev, "cannot register with cfg80211\n");
-		goto err_register_cfg80211;
+		goto err_init_fw;
 	}
 
 	rtnl_lock();
@@ -489,7 +489,6 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	goto done;
 
 err_add_intf:
-err_register_cfg80211:
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
 err_init_fw:
-- 
1.8.2.3

