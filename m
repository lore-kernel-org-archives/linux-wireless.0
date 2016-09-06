Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35458 "EHLO
        mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934061AbcIFWSk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 18:18:40 -0400
Received: by mail-pa0-f44.google.com with SMTP id b2so6346788pat.2
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2016 15:18:39 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andy Gross <andy.gross@linaro.org>,
        Nicolas Dechesne <ndec@linaro.org>
Subject: [PATCH v4 4/4] wcn36xx: Implement print_reg indication
Date: Tue,  6 Sep 2016 15:18:32 -0700
Message-Id: <1473200312-22438-4-git-send-email-bjorn.andersson@linaro.org> (sfid-20160907_001859_913933_2F75775A)
In-Reply-To: <1473200312-22438-1-git-send-email-bjorn.andersson@linaro.org>
References: <1473200312-22438-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some firmware versions sends a "print register indication", handle this
by printing out the content.

Cc: Nicolas Dechesne <ndec@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v3:
- Rebased separate patch onto this series

 drivers/net/wireless/ath/wcn36xx/hal.h | 16 ++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/smd.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 4f87ef1e1eb8..b765c647319d 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -350,6 +350,8 @@ enum wcn36xx_hal_host_msg_type {
 
 	WCN36XX_HAL_AVOID_FREQ_RANGE_IND = 233,
 
+	WCN36XX_HAL_PRINT_REG_INFO_IND = 259,
+
 	WCN36XX_HAL_MSG_MAX = WCN36XX_HAL_MSG_TYPE_MAX_ENUM_SIZE
 };
 
@@ -4703,4 +4705,18 @@ struct stats_class_b_ind {
 	u32 rx_time_total;
 };
 
+/* WCN36XX_HAL_PRINT_REG_INFO_IND */
+struct wcn36xx_hal_print_reg_info_ind {
+	struct wcn36xx_hal_msg_header header;
+
+	u32 count;
+	u32 scenario;
+	u32 reason;
+
+	struct {
+		u32 addr;
+		u32 value;
+	} regs[];
+} __packed;
+
 #endif /* _HAL_H_ */
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index be5e5ea1e5c3..1c2966f7db7a 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2109,6 +2109,30 @@ static int wcn36xx_smd_delete_sta_context_ind(struct wcn36xx *wcn,
 	return -ENOENT;
 }
 
+static int wcn36xx_smd_print_reg_info_ind(struct wcn36xx *wcn,
+					  void *buf,
+					  size_t len)
+{
+	struct wcn36xx_hal_print_reg_info_ind *rsp = buf;
+	int i;
+
+	if (len < sizeof(*rsp)) {
+		wcn36xx_warn("Corrupted print reg info indication\n");
+		return -EIO;
+	}
+
+	wcn36xx_dbg(WCN36XX_DBG_HAL,
+		    "reginfo indication, scenario: 0x%x reason: 0x%x\n",
+		    rsp->scenario, rsp->reason);
+
+	for (i = 0; i < rsp->count; i++) {
+		wcn36xx_dbg(WCN36XX_DBG_HAL, "\t0x%x: 0x%x\n",
+			    rsp->regs[i].addr, rsp->regs[i].value);
+	}
+
+	return 0;
+}
+
 int wcn36xx_smd_update_cfg(struct wcn36xx *wcn, u32 cfg_id, u32 value)
 {
 	struct wcn36xx_hal_update_cfg_req_msg msg_body, *body;
@@ -2237,6 +2261,7 @@ int wcn36xx_smd_rsp_process(struct qcom_smd_channel *channel,
 	case WCN36XX_HAL_OTA_TX_COMPL_IND:
 	case WCN36XX_HAL_MISSED_BEACON_IND:
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
+	case WCN36XX_HAL_PRINT_REG_INFO_IND:
 		msg_ind = kmalloc(sizeof(*msg_ind) + len, GFP_ATOMIC);
 		if (!msg_ind) {
 			wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
@@ -2296,6 +2321,11 @@ static void wcn36xx_ind_smd_work(struct work_struct *work)
 						   hal_ind_msg->msg,
 						   hal_ind_msg->msg_len);
 		break;
+	case WCN36XX_HAL_PRINT_REG_INFO_IND:
+		wcn36xx_smd_print_reg_info_ind(wcn,
+					       hal_ind_msg->msg,
+					       hal_ind_msg->msg_len);
+		break;
 	default:
 		wcn36xx_err("SMD_EVENT (%d) not supported\n",
 			      msg_header->msg_type);
-- 
2.5.0
