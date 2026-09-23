Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD7F4F93A4;
	Wed, 23 Sep 2026 12:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165123; cv=none; b=O4Q0r9zC/bC4c9yvbk59n5IzZPm5m9nW5tOou8tXeZEgFakOv+UxOnKT+tcyyqRjn4Wvgp8r0rOBtULTbfqxmdOcyNIUV1LpG+ZzMDiwqFuA2KClZTkoVhDw2ZAigKvKHncuE8C8wWyvXgc4a6U5tYvycRCkU3Fl1BUVTQrzwDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165123; c=relaxed/simple;
	bh=U65tT/XuausYcSGRR+nBv1qFV7Ddpj0lJkZ4vH1copM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pUWWLZR/yOzXL3+V3MU9N+GVs5aCulK8tRLYNVnk0qW3NDVYXR8hVK0hl1DrWdmp+xMhaogZYcErfdtgTqsmU87YX5F4w7+061Mif8QkD2wI7PP7T8ZGyR3kalOPzduMpLSG3qVgvojb2cw4IgVYUITbW973SNebI0m+aWXS+qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pS9WqHms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pS9WqHms"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1626AC4AF14;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790165121;
	bh=U65tT/XuausYcSGRR+nBv1qFV7Ddpj0lJkZ4vH1copM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pS9WqHmsxjiQz6raHXOxBZg/V2RhegwdP0S/q/wzVJDNaiOB/0dlgRWy5CCIxddvt
	 w6YdYiDspFb3gX/o2VQGxelLJf1cC0twNci7qRnzLxMyBFG1fUQwMAojoCwiMFPa9z
	 BRwQJUPatSlb9Kg4LkTTfYTs0HcoweWty05fuumO3pcYESQPlpnSV5LTr6Qqeq1Ht6
	 9CWzbePnZg0SkQR7j1Y11jyWu27FTWZUJ5C4Xed+SQhSvIvdK6n9ghgR0Ej1PHQj59
	 wrY0ZDS+GVjo/i1pgyRxsMNobMG/y0s2arbeDkyUnl6GA/VzcKz7gtn35Mxrh/t6g2
	 w56pBik4EbSJg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027A3C98307;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Wed, 23 Sep 2026 16:05:12 +0400
Subject: [PATCH ath-next 06/16] firmware: qcom: scm: Add support for
 setting internal WiFi power mode
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-ipq5018-qcn6122-mpd-v1-6-86729521a75c@outlook.com>
References: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
In-Reply-To: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
To: Johannes Berg <johannes@sipsolutions.net>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 ath11k@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com>, 
 Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>, 
 linux-arm-msm@vger.kernel.org, 
 George Moussalem <george.moussalem@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790165117; l=3732;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=S3tayyPPojcv8MgCJKPIjYb3bobuwrtC6mchI6StDhA=;
 b=yEeCFoFH8MkwAgM7jDcHmtMYntNrocu/jD5KcO5zp83+wJabLj9r+0QEamATBQeJh3sWOsb7U
 Gd89W0Ww3VbAn0Yd3d30H9ILQQwoC4ZLMpo77DHPMN3Ne66bDVp30YL
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

Add SCM call to power up / down the SoC's internal WiFi radio.
The SoC's internal WiFi radio needs to be powered up/down through a SCM
call when MPD firmware is loaded by the rproc driver. Multi-PD firmware
only loads the root PD and provides services and resources to one or
multiple user PDs which are firmware segments required for each WiFi
radio (for ex. in the case of the MPD firmware for IPQ5018 which
contains the firmware binaries for the SoC's internal WiFi radio and one
or two IPQ5018-specific QCN6122 WiFi companion chips).

For non-MPD firmware, this call is not required.

Not all Trusted Execution Environment (QSEE) images support this call,
so first check if the call is available.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 drivers/firmware/qcom/qcom_scm.c       | 43 ++++++++++++++++++++++++++++++++++
 drivers/firmware/qcom/qcom_scm.h       |  2 ++
 include/linux/firmware/qcom/qcom_scm.h |  1 +
 3 files changed, 46 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 3eaa4c9ccf3c..8e5f5c235cb7 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1084,6 +1084,49 @@ static bool qcom_scm_is_pas_available(void)
 	return true;
 }
 
+/**
+ * qcom_scm_pas_set_wifi_power_mode() - Power on/off internal wifi
+ * @peripheral:	peripheral id
+ * @enable:	true to power up, false to power down
+ *
+ * Return 0 on success.
+ */
+int qcom_scm_pas_set_wifi_power_mode(u32 peripheral, bool enable)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_PIL,
+		.cmd = enable ? QCOM_SCM_PIL_PAS_WIFI_PWR_EN :
+		       QCOM_SCM_PIL_PAS_WIFI_PWR_DIS,
+		.arginfo = QCOM_SCM_ARGS(1),
+		.args[0] = peripheral,
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+	struct qcom_scm_res res;
+	int ret;
+
+	if (!__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_PIL,
+					  enable ? QCOM_SCM_PIL_PAS_WIFI_PWR_EN :
+					  QCOM_SCM_PIL_PAS_WIFI_PWR_DIS))
+		return -EOPNOTSUPP;
+
+	ret = qcom_scm_clk_enable();
+	if (ret)
+		return ret;
+
+	ret = qcom_scm_bw_enable();
+	if (ret)
+		goto disable_clk;
+
+	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	qcom_scm_bw_disable();
+
+disable_clk:
+	qcom_scm_clk_disable();
+
+	return ret ? : res.result[0];
+}
+EXPORT_SYMBOL_GPL(qcom_scm_pas_set_wifi_power_mode);
+
 static int __qcom_scm_pas_mss_reset(struct device *dev, bool reset)
 {
 	struct qcom_scm_desc desc = {
diff --git a/drivers/firmware/qcom/qcom_scm.h b/drivers/firmware/qcom/qcom_scm.h
index cf90a565fdfb..e1554997ca08 100644
--- a/drivers/firmware/qcom/qcom_scm.h
+++ b/drivers/firmware/qcom/qcom_scm.h
@@ -105,6 +105,8 @@ int qcom_scm_shm_bridge_enable(struct device *scm_dev);
 #define QCOM_SCM_PIL_PAS_SHUTDOWN	0x06
 #define QCOM_SCM_PIL_PAS_IS_SUPPORTED	0x07
 #define QCOM_SCM_PIL_PAS_MSS_RESET	0x0a
+#define QCOM_SCM_PIL_PAS_WIFI_PWR_EN	0x17
+#define QCOM_SCM_PIL_PAS_WIFI_PWR_DIS	0x18
 #define QCOM_SCM_PIL_PAS_GET_RSCTABLE	0x21
 
 #define QCOM_SCM_SVC_IO			0x05
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index 5747bd191bf1..9258839ae746 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -93,6 +93,7 @@ struct resource_table *qcom_scm_pas_get_rsc_table(struct qcom_scm_pas_context *c
 						  size_t *output_rt_size);
 
 int qcom_scm_pas_prepare_and_auth_reset(struct qcom_scm_pas_context *ctx);
+int qcom_scm_pas_set_wifi_power_mode(u32 peripheral, bool enable);
 
 int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val);
 int qcom_scm_io_writel(phys_addr_t addr, unsigned int val);

-- 
2.53.0


