Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20103 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3CMMNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:12 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/14] wil6210: handle linkup/linkdown WMI events
Date: Wed, 13 Mar 2013 14:12:39 +0200
Message-ID: <1363176771-10082-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131318_145971_4A8A0EC0)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware indicates linkup/linkdown when data path becomes ready.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 0bb3b76..895ae9d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -528,6 +528,27 @@ static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
 	}
 }
 
+static void wmi_evt_linkup(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wmi_data_port_open_event *evt = d;
+
+	wil_dbg_wmi(wil, "Link UP for CID %d\n", evt->cid);
+
+	netif_carrier_on(ndev);
+}
+
+static void wmi_evt_linkdown(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wmi_wbe_link_down_event *evt = d;
+
+	wil_dbg_wmi(wil, "Link DOWN for CID %d, reason %d\n",
+		    evt->cid, le32_to_cpu(evt->reason));
+
+	netif_carrier_off(ndev);
+}
+
 static const struct {
 	int eventid;
 	void (*handler)(struct wil6210_priv *wil, int eventid,
@@ -541,6 +562,8 @@ static const struct {
 	{WMI_DISCONNECT_EVENTID,	wmi_evt_disconnect},
 	{WMI_NOTIFY_REQ_DONE_EVENTID,	wmi_evt_notify},
 	{WMI_EAPOL_RX_EVENTID,		wmi_evt_eapol_rx},
+	{WMI_DATA_PORT_OPEN_EVENTID,	wmi_evt_linkup},
+	{WMI_WBE_LINKDOWN_EVENTID,	wmi_evt_linkdown},
 };
 
 /*
-- 
1.7.10.4

