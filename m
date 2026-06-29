Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770CD4048B1;
	Mon, 29 Jun 2026 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782738120; cv=none; b=tU0mvuBrSzqJT+ElQ7dGigsInw3j64UJSVUlBZ1fjmirkwgOq6ABItZMqbvwWvFWcN6cE+/ekN1BT1B0Neq0j3cCQzLHSxo2XceU8lbN5g5ojlVh7ym3EH4ewcaXXSLUhJ8+V39KUbMu6AW/Yv5bbLsOfpcClzbm6vjgxermnDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782738120; c=relaxed/simple;
	bh=xx4TGRoHeCiwJHWjQM49gAjDXE32Br0YcWA3bhIo3Wg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=guUVnLioC+aBsHS39eJIx3fpvyeMWwfw0XygsEAJGeQep2nwn4iK2mype/19jmcKwSKwpYrFZG+Jqwj9juUPiMrBCG6hh9SNlqTcn0qCV0RPZIyuyMpC2ejbOxvPAag3UwBeo7Zq7Nwbkwp/szvtJN9oNgti7Gcl9Rf179Q7Iyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qm7ceUTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qm7ceUTz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24256C2BCF5;
	Mon, 29 Jun 2026 13:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782738120;
	bh=xx4TGRoHeCiwJHWjQM49gAjDXE32Br0YcWA3bhIo3Wg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qm7ceUTzXHlN8SIptoMoUyBKbb0JVzonYKJT6BiWguaGtgJw8hKot/5o+MNAOhWxx
	 XPNo2G9lGBBB5WYfhF1+6Cnsj3oM97zWYguQ/jj5BduIxoIvlle95C8z4NUdcXHyZH
	 45K0eb0MLxu0vbfaYYNjWXH8v5k3mJ6tGguS8BEJJfB6tsPEjszQZjp4P0+3sWVkjH
	 X74G66ubGswXJWjesQJMl+EI3DjSSop3nc8LfDNM7cVO/xVoMlR+H94Vz64P+ogsLO
	 +ibVsCXEh3we3cjKEUrmGuQeKI/p0K0LTji0nvwtPVo1ZBXGb7Qa2G441UETXPTPqT
	 H98drubut+w6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FB4C43458;
	Mon, 29 Jun 2026 13:02:00 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Mon, 29 Jun 2026 17:01:46 +0400
Subject: [PATCH v2 3/6] firmware: qcom: scm: Add support for setting
 Bluetooth power modes
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-ipq5018-bluetooth-v2-3-02770f03b6bb@outlook.com>
References: <20260629-ipq5018-bluetooth-v2-0-02770f03b6bb@outlook.com>
In-Reply-To: <20260629-ipq5018-bluetooth-v2-0-02770f03b6bb@outlook.com>
To: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulfh@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
 Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, 
 Rocky Liao <quic_rjliao@quicinc.com>, 
 Saravana Kannan <saravanak@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
 Heiner Kallweit <hkallweit1@gmail.com>, 
 Russell King <linux@armlinux.org.uk>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
 linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
 George Moussalem <george.moussalem@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782738117; l=3544;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=XS/86bbAZYqgGIBLjxmoRBNcmPWUtnPMjtvIgqx2KuM=;
 b=wUQZ3Vjvc6iPxxNUzz+rvmhYBaO+O/qsxfLVoxKq+VJ5nkc9TxIFALHvjEiiOdoldIIKETc7E
 8CfZYM4NXI1CERADEKuTVyBMNCsHzzwcxmzdgyWgE9cD481G+zfNhgX
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

The Bluetooth subsystem (BTSS) on the IPQ5018 SoC supports setting power
modes which are required to be configured through a Secure Channel
Manager (SCM) call to TrustZone. However, not all Trusted Execution
Environment (QSEE) images support this call, so first check if the call
is available.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 drivers/firmware/qcom/qcom_scm.c       | 49 ++++++++++++++++++++++++++++++++++
 drivers/firmware/qcom/qcom_scm.h       |  1 +
 include/linux/firmware/qcom/qcom_scm.h |  1 +
 3 files changed, 51 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 6b601a4b89db..e26f54e5033b 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1094,6 +1094,55 @@ bool qcom_scm_pas_supported(u32 pas_id)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_supported);
 
+static int __qcom_scm_pas_set_bluetooth_power_mode(u32 pas_id, u32 val)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_PIL,
+		.cmd = QCOM_SCM_PIL_PAS_BT_PWR_MODE,
+		.arginfo = QCOM_SCM_ARGS(2),
+		.args[0] = pas_id,
+		.args[1] = val,
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+	struct qcom_scm_res res;
+	int ret;
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
+
+/**
+ * qcom_scm_pas_set_bluetooth_power_mode() - Configure power optimization mode
+ *					     for the Bluetooth subsystem (BTSS)
+ * @pas_id:	peripheral authentication service id
+ * @val:	0x0 for normal operation, 0x4 for ECO mode
+ *
+ * Return: 0 on success, negative errno on failure.
+ * Returns -EOPNOTSUPP if the firmware configuration call is unavailable.
+ */
+int qcom_scm_pas_set_bluetooth_power_mode(u32 pas_id, u32 val)
+{
+	if (!__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_PIL,
+					  QCOM_SCM_PIL_PAS_BT_PWR_MODE))
+		return -EOPNOTSUPP;
+
+	return __qcom_scm_pas_set_bluetooth_power_mode(pas_id, val);
+}
+EXPORT_SYMBOL_GPL(qcom_scm_pas_set_bluetooth_power_mode);
+
 static int __qcom_scm_pas_mss_reset(struct device *dev, bool reset)
 {
 	struct qcom_scm_desc desc = {
diff --git a/drivers/firmware/qcom/qcom_scm.h b/drivers/firmware/qcom/qcom_scm.h
index caab80a73e17..5579df5a2aca 100644
--- a/drivers/firmware/qcom/qcom_scm.h
+++ b/drivers/firmware/qcom/qcom_scm.h
@@ -105,6 +105,7 @@ int qcom_scm_shm_bridge_enable(struct device *scm_dev);
 #define QCOM_SCM_PIL_PAS_SHUTDOWN	0x06
 #define QCOM_SCM_PIL_PAS_IS_SUPPORTED	0x07
 #define QCOM_SCM_PIL_PAS_MSS_RESET	0x0a
+#define QCOM_SCM_PIL_PAS_BT_PWR_MODE	0x21
 #define QCOM_SCM_PIL_PAS_GET_RSCTABLE	0x21
 
 #define QCOM_SCM_SVC_IO			0x05
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index 5747bd191bf1..76de4b69580b 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -93,6 +93,7 @@ struct resource_table *qcom_scm_pas_get_rsc_table(struct qcom_scm_pas_context *c
 						  size_t *output_rt_size);
 
 int qcom_scm_pas_prepare_and_auth_reset(struct qcom_scm_pas_context *ctx);
+int qcom_scm_pas_set_bluetooth_power_mode(u32 pas_id, u32 val);
 
 int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val);
 int qcom_scm_io_writel(phys_addr_t addr, unsigned int val);

-- 
2.53.0


