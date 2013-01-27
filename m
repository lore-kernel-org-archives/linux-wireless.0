Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.active-venture.com ([67.228.131.205]:65278 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab3A0C0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 21:26:00 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	netdev@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] net: wireless/ath: Fix compile error seen with W=1
Date: Sat, 26 Jan 2013 18:26:08 -0800
Message-Id: <1359253568-15762-1-git-send-email-linux@roeck-us.net> (sfid-20130127_032614_002276_102C1067)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

make W=1 for x86_64 fails with

drivers/net/wireless/ath/wil6210/txrx.c: In function ‘wil_rx_fini’:
drivers/net/wireless/ath/wil6210/txrx.c:550:7: error: variable ‘rc’ set but not
used [-Werror=unused-but-set-variable]

Fix by dropping the variable.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/wireless/ath/wil6210/txrx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index f29c294..b6e8042 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -547,7 +547,6 @@ void wil_rx_fini(struct wil6210_priv *wil)
 	struct vring *vring = &wil->vring_rx;
 
 	if (vring->va) {
-		int rc;
 		struct wmi_cfg_rx_chain_cmd cmd = {
 			.action = cpu_to_le32(WMI_RX_CHAIN_DEL),
 			.rx_sw_ring = {
@@ -559,7 +558,7 @@ void wil_rx_fini(struct wil6210_priv *wil)
 			struct wmi_cfg_rx_chain_done_event cfg;
 		} __packed wmi_rx_cfg_reply;
 
-		rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
+		(void)wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
 			      WMI_CFG_RX_CHAIN_DONE_EVENTID,
 			      &wmi_rx_cfg_reply, sizeof(wmi_rx_cfg_reply),
 			      100);
-- 
1.7.9.7

