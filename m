Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33795 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbKIJBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 04:01:37 -0500
Received: by padhx2 with SMTP id hx2so184710487pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 01:01:36 -0800 (PST)
From: "Yin, Fengwei" <fengwei.yin@linaro.org>
To: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org
Subject: [PATCH 3/5] wcn36xx: handle new hal response format
Date: Mon,  9 Nov 2015 05:02:40 -0500
Message-Id: <1447063362-27322-4-git-send-email-fengwei.yin@linaro.org> (sfid-20151109_100139_971744_7578E028)
In-Reply-To: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy.green@linaro.org>

From: Andy Green <andy.green@linaro.org>

wcn3620 has a new message structure for the reply to some hal
commands.  This patch adds the struct and helper routine that
uses it if the chip is wcn3620, or falls back to the old
helper routine.

We don't know what to do with the candidate list he sends back,
but we can at least accept and ignore it nicely instead of dying.

Signed-off-by: Andy Green <andy.green@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 17 +++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/smd.h |  9 +++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index be317f4..a84c2cc 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -302,6 +302,23 @@ static int wcn36xx_smd_rsp_status_check(void *buf, size_t len)
 	return 0;
 }
 
+static int wcn36xx_smd_rsp_status_check_v2(struct wcn36xx *wcn, void *buf,
+					     size_t len)
+{
+	struct wcn36xx_fw_msg_status_rsp_v2 *rsp;
+
+	if (wcn->chip_version != WCN36XX_CHIP_3620 ||
+	    len < sizeof(struct wcn36xx_hal_msg_header) + sizeof(*rsp))
+		return wcn36xx_smd_rsp_status_check(buf, len);
+
+	rsp = buf + sizeof(struct wcn36xx_hal_msg_header);
+
+	if (WCN36XX_FW_MSG_RESULT_SUCCESS != rsp->status)
+		return rsp->status;
+
+	return 0;
+}
+
 int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
 {
 	struct nv_data *nv_d;
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
index 008d034..8361f9e 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.h
+++ b/drivers/net/wireless/ath/wcn36xx/smd.h
@@ -44,6 +44,15 @@ struct wcn36xx_fw_msg_status_rsp {
 	u32	status;
 } __packed;
 
+/* wcn3620 returns this for tigger_ba */
+
+struct wcn36xx_fw_msg_status_rsp_v2 {
+	u8	bss_id[6];
+	u32	status __packed;
+	u16	count_following_candidates __packed;
+	/* candidate list follows */
+};
+
 struct wcn36xx_hal_ind_msg {
 	struct list_head list;
 	u8 *msg;
-- 
2.1.4

