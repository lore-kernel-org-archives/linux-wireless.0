Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbcB2WF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:58 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 103/113] rtl8xxxu: Process C2H RA_REPORT events for 8723bu
Date: Mon, 29 Feb 2016 17:05:41 -0500
Message-Id: <1456783551-28315-104-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232949_969809_E68CBF75)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Handle RA_REPORTS events for 8723bu to not have them show up as
unhandled.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c |  6 ++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3985903..253de87 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7445,6 +7445,12 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 		dev_dbg(dev, "C2H_MP_INFO ext ID %02x, status %02x\n",
 			c2h->bt_mp_info.ext_id, c2h->bt_mp_info.status);
 		break;
+	case C2H_8723B_RA_REPORT:
+		dev_dbg(dev,
+			"C2H RA RPT: rate %02x, unk %i, macid %02x, noise %i\n",
+			c2h->ra_report.rate, c2h->ra_report.dummy0_0,
+			c2h->ra_report.macid, c2h->ra_report.noisy_state);
+		break;
 	default:
 		dev_info(dev, "Unhandled C2H event %02x seq %02x\n",
 			 c2h->id, c2h->seq);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 2191b6b..b44cb59 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1033,6 +1033,7 @@ enum c2h_evt_8723b {
 	C2H_8723B_BT_INFO = 9,
 	C2H_8723B_HW_INFO_EXCH = 0x0a,
 	C2H_8723B_BT_MP_INFO = 0x0b,
+	C2H_8723B_RA_REPORT = 0x0c,
 	C2H_8723B_FW_DEBUG = 0xff,
 };
 
@@ -1121,6 +1122,16 @@ struct rtl8723bu_c2h {
 			u8 a4;
 			u8 a5;
 		} __packed bt_info;
+		struct {
+			u8 rate:7;
+			u8 dummy0_0:1;
+			u8 macid;
+			u8 ldpc:1;
+			u8 txbf:1;
+			u8 noisy_state:1;
+			u8 dummy2_0:5;
+			u8 dummy3_0;
+		} __packed ra_report;
 	};
 };
 
-- 
2.5.0

