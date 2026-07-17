Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0153B3BEC
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271547; cv=none; b=Pb3FBYI4mt+YBMSogVEh9LlKdHYNAJ3tGHKW0nIu7bDOTpQf78d+ScmNvwjsxtQNzVPpS4x0jHo7NYhecf1QOgE3zVVh4rHaTaDL603wlvK8K+z6nbVXac1kGSU0AhewjodyUQR+CqIkmyluQH/kKnSZC58vZdTPTLMn3l9Aydw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271547; c=relaxed/simple;
	bh=WEtCjNfKwj642LrZ4jB4tBTaa2HtqbNV4H9+34BDpnA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kq8IEAZIWCVmSJGP9bLpTuXKnnKTsW6YoxjRLjaCQZR77SYzFXylqUrXNlT5+hMBcFdaNx7ugbR3K5Vy6TXiZuBE7sCBlQSlVlzvcS2kTPJ3hASTNozCuvGM8ofNrccISzcYNrYR4hxY6d6SDKwrOloQx18kQEs/X/JkWIkmhYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=rfyNxp+/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="rfyNxp+/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6x3J714176467, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271543; bh=5GXmVXTnbwJS0oUvlaQJWAWqDdPp0zIy3Y0feD/eddU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=rfyNxp+/skxWuhhcsEpKO7FSprZ/N+La7kGzCwAPCP3jiBEnZkP9f6RXW2qIqggZ+
	 umiPjmTdJb/mEsXRPLMOFEqczoFY4cJoFQkXbLzCJrst1zbNIBrkd8Ki89Yl1MsJ0+
	 7DFTaFwjqPbnefa628xKI/QPVfosSgcSTPzBofG+3D0dsVtpHzsnPdkTfCJ2TWpWTO
	 clfN4HCPvf6p+SfyRheCNFgLtgYuq3OaP6q+KuSIYFIiutcu086zCefvM1HUm4DLac
	 1SHcVfF9ff5rypcd7l4NtVXhehE5U3qOI8dfO+/YVU+Xjm2/ws0YeoEx7vPzdDiDBL
	 TlsZEo38tegMg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6x3J714176467
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:59:03 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:03 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:59:03 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 04/13] wifi: rtw89: coex: Branch out version 105 firmware report map index
Date: Fri, 17 Jul 2026 14:57:30 +0800
Message-ID: <20260717065739.64124-5-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717065739.64124-1-pkshih@realtek.com>
References: <20260717065739.64124-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

RTL8852B in firmware 0.29.133.X do not support BT-TX-PWR report, re-index
and branch out to version 105.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 5f2658eb516c..b73040428c58 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -2707,6 +2707,7 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 		case 3:
 		case 4:
 		case 5:
+		case 105:
 			bit_map = BIT(5);
 			break;
 		default:
@@ -2723,6 +2724,7 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 		case 3:
 		case 4:
 		case 5:
+		case 105:
 			bit_map = BIT(6);
 			break;
 		default:
@@ -2737,6 +2739,7 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 		case 3:
 		case 4:
 		case 5:
+		case 105:
 			bit_map = BIT(7);
 			break;
 		default:
@@ -2749,6 +2752,7 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 		case 1:
 		case 2:
 		case 3:
+		case 105:
 			break;
 		case 4:
 		case 5:
@@ -2765,6 +2769,7 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 			bit_map = BIT(7);
 			break;
 		case 3:
+		case 105:
 			bit_map = BIT(8);
 			break;
 		case 4:
@@ -2778,6 +2783,8 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 	case RPT_EN_TEST:
 		if (ver->frptmap == 5)
 			bit_map = BIT(10);
+		else if (ver->frptmap == 105)
+			bit_map = BIT(9);
 		else
 			bit_map = BIT(31);
 		break;
@@ -2789,6 +2796,7 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 			bit_map = GENMASK(2, 0);
 			break;
 		case 3:
+		case 105:
 			bit_map = GENMASK(2, 0) | BIT(8);
 			break;
 		case 4:
@@ -2809,6 +2817,7 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 			bit_map = GENMASK(6, 3) | BIT(8);
 			break;
 		case 3:
+		case 105:
 			bit_map = GENMASK(7, 3);
 			break;
 		case 4:
@@ -2833,6 +2842,7 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 			break;
 		case 4:
 		case 5:
+		case 105:
 			bit_map = GENMASK(9, 0);
 			break;
 		default:
@@ -2849,6 +2859,7 @@ static u32 rtw89_btc_fw_rpt_ver(struct rtw89_dev *rtwdev, u32 rpt_map)
 			bit_map = GENMASK(6, 2) | BIT(8);
 			break;
 		case 3:
+		case 105:
 			bit_map = GENMASK(8, 2);
 			break;
 		case 4:
-- 
2.25.1

