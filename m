Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5674B34041B;
	Thu, 25 Jun 2026 14:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396631; cv=none; b=M/NdqyewwhZi+lOKD08ZU3UdFZkNMzN6hv3zmJAbhqhX/CQwCAYiWGgSuqiLbh4NfATs4uc+0c5wip+zzDxglst1J6nyyLR5GunATHn1NQLdWnG4I/BjNo+CppoJBme25+1wcM4NEyG1fshWfIDuQB7ZAFJUbvFo8kSxItPVmm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396631; c=relaxed/simple;
	bh=yrszS7W1eAEcg3XdaKP+FpRzs0RmFdVuiIWNio6sCbU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uXyalfcIfQgPHAmF2dP5QXk8ACjTEd52gZ6RtE5P5gqE5LIp4zrnhetxEq0cjqZW7NSyfzeOgrRYJGVHko40yPMUccdvVa8RWOk050H9s87fiKjtlMg7lPuQ3JLfa63j9L0ScPwxO//l6fke+wqV+TSErYrzaNQy/4P6Ubb7EtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAXpgrG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAXpgrG2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26FC6C2BD01;
	Thu, 25 Jun 2026 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782396631;
	bh=yrszS7W1eAEcg3XdaKP+FpRzs0RmFdVuiIWNio6sCbU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GAXpgrG2NVYwPd6ImSXWysygelBpW97fsLnnU6h4Y1Pb9F1znfK++OYj6e9qV/+HP
	 o3054yMGEZYWJJ2QwP4uGPbBkWZzHIJqfd3QlidmJICS0VPlLR3kEp+5DzOA4qHNUc
	 V1xurOspSyLctXQrlnVaBP7mzLGIUEqHwmLxzhn7q2rh7me+4K21MCGL4nT8T05cL5
	 UUC9vm/ctwFOKwM8R/3y7S1nejOB/O+h2jXYPECtUHeFXBV0DT2zraY3L4kgs+Qq6U
	 bNlvqYTs0+1Kyr8FDeM8TZx71o0bOg7cNsw2Z3InmYwdkwNukuhPp10j9eMXomy3Sp
	 SJ0ebhloPDxKA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA96CDE00B;
	Thu, 25 Jun 2026 14:10:31 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Thu, 25 Jun 2026 18:10:07 +0400
Subject: [PATCH 3/6] Bluetooth: btqca: Add IPQ5018 support
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-ipq5018-bluetooth-v1-3-d999be0e04f7@outlook.com>
References: <20260625-ipq5018-bluetooth-v1-0-d999be0e04f7@outlook.com>
In-Reply-To: <20260625-ipq5018-bluetooth-v1-0-d999be0e04f7@outlook.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782396628; l=3109;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=YfdZYTMB/SghkLi82xybv2Ru5WS6Sv6NKlsHcB3g49A=;
 b=Ut0ZStC7p267bavS0Dx+6BAKei2zMsIxNkSqi2oQsxKi69k1+hjGTj9dyQ5GRQOsTm5z/z/2R
 L5EedHT2+GUDUD27g2ip3OorJMJe045LjCmLbV6tVHinkKTcGm3YPOi
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

Add the IPQ5018 SoC type and support for loading its firmware.

The firmware tested has been taken from GPL sources of various router
boards. Firmware files needed are:
- qca/bt_fw_patch.mbn
- qca/mpnv10.bin

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 drivers/bluetooth/btqca.c | 16 ++++++++++++++++
 drivers/bluetooth/btqca.h |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 04ebe290bc78..e136e91976cf 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -380,6 +380,9 @@ static int qca_tlv_check_data(struct hci_dev *hdev,
 		break;
 
 	case TLV_TYPE_NVM:
+		if (soc_type == QCA_IPQ5018)
+			break;
+
 		if (fw_size < sizeof(struct tlv_type_hdr))
 			return -EINVAL;
 
@@ -794,6 +797,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	else
 		rom_ver = ((soc_ver & 0x00000f00) >> 0x04) | (soc_ver & 0x0000000f);
 
+	if (soc_type == QCA_IPQ5018)
+		goto download_nvm;
+
 	if (soc_type == QCA_WCN6750)
 		qca_send_patch_config_cmd(hdev);
 
@@ -881,6 +887,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	if (soc_type == QCA_QCA2066 || soc_type == QCA_WCN7850)
 		qca_read_fw_board_id(hdev, &boardid);
 
+download_nvm:
 	/* Download NVM configuration */
 	config.type = TLV_TYPE_NVM;
 	if (firmware_name) {
@@ -939,6 +946,10 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 			qca_get_nvm_name_by_board(config.fwname, sizeof(config.fwname),
 				 "hmtnv", soc_type, ver, rom_ver, boardid);
 			break;
+		case QCA_IPQ5018:
+			snprintf(config.fwname, sizeof(config.fwname),
+				 "qca/mpnv%02x.bin", rom_ver);
+			break;
 		default:
 			snprintf(config.fwname, sizeof(config.fwname),
 				 "qca/nvm_%08x.bin", soc_ver);
@@ -958,6 +969,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		return err;
 	}
 
+	if (soc_type == QCA_IPQ5018)
+		msleep(NVM_READY_DELAY_MS);
+
 	switch (soc_type) {
 	case QCA_QCA2066:
 	case QCA_QCA6390:
@@ -965,6 +979,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	case QCA_WCN6750:
 	case QCA_WCN6855:
 	case QCA_WCN7850:
+	case QCA_IPQ5018:
 		err = qca_disable_soc_logging(hdev);
 		if (err < 0)
 			return err;
@@ -1001,6 +1016,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	case QCA_WCN6750:
 	case QCA_WCN6855:
 	case QCA_WCN7850:
+	case QCA_IPQ5018:
 		/* get fw build info */
 		err = qca_read_fw_build_info(hdev);
 		if (err < 0)
diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index 8f3c1b1c77b3..343cd62d1137 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -54,6 +54,8 @@
 #define QCA_HSP_GF_SOC_ID		0x1200
 #define QCA_HSP_GF_SOC_MASK		0x0000ff00
 
+#define NVM_READY_DELAY_MS		1500
+
 enum qca_baudrate {
 	QCA_BAUDRATE_115200	= 0,
 	QCA_BAUDRATE_57600,
@@ -158,6 +160,7 @@ enum qca_btsoc_type {
 	QCA_WCN6750,
 	QCA_WCN6855,
 	QCA_WCN7850,
+	QCA_IPQ5018,
 };
 
 #if IS_ENABLED(CONFIG_BT_QCA)

-- 
2.53.0


