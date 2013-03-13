Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20103 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3CMMNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:14 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/14] wil6210: handle WMI_BA_STATUS_EVENTID
Date: Wed, 13 Mar 2013 14:12:40 +0200
Message-ID: <1363176771-10082-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131321_530133_06F5D6B4)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware indicated block ack agreement status change.
For now, just log it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 895ae9d..d636ff4 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -549,6 +549,16 @@ static void wmi_evt_linkdown(struct wil6210_priv *wil, int id, void *d, int len)
 	netif_carrier_off(ndev);
 }
 
+static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
+			      int len)
+{
+	struct wmi_vring_ba_status_event *evt = d;
+
+	wil_dbg_wmi(wil, "BACK[%d] %s {%d} timeout %d\n",
+		    evt->ringid, evt->status ? "N/A" : "OK", evt->agg_wsize,
+		    __le16_to_cpu(evt->ba_timeout));
+}
+
 static const struct {
 	int eventid;
 	void (*handler)(struct wil6210_priv *wil, int eventid,
@@ -564,6 +574,7 @@ static const struct {
 	{WMI_EAPOL_RX_EVENTID,		wmi_evt_eapol_rx},
 	{WMI_DATA_PORT_OPEN_EVENTID,	wmi_evt_linkup},
 	{WMI_WBE_LINKDOWN_EVENTID,	wmi_evt_linkdown},
+	{WMI_BA_STATUS_EVENTID,		wmi_evt_ba_status},
 };
 
 /*
-- 
1.7.10.4

