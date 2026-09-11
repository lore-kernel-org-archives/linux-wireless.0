Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D47944A72C
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 06:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109684; cv=none; b=YcmWHew/eahRlfruHt/U0dGtNJCuIBtGH73PQEKvA9RfbvtODwJ6ujd4BOmI9MJ2mW4j4Kzp/2+NalX8+dOgB2L9TmGbS0v6AtHFdtNzs+Ktaf7Ytk0MKtw47hQpGXmgqfAAd8umiXbSQdxpfA0BlgqPQFwkcPQ6p0DHYgPfbPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109684; c=relaxed/simple;
	bh=783xz523/9RE3H/6s5vBSzgJ6/TKreE2mQb896FOjU0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DE8tCcqS0A7QShv1drlThHheabzbtRQmsYn087e3d37BS1++zznSVX5nJtQhzSAxNt2M73kdiOkXHceR/aiUqAyoClXCS0VGsWY3pzR/J0EmL0jkHoxkM9kAPDuZ4t9MtLeU56JHj6oEee/k3ZB/SrnfVseQX2PausSeLnJ4Mf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=pz4PqoBG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="pz4PqoBG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68B6sNbQ52185742, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789109664; bh=J7hfaaa77oA/xThK8BU7JQ/Q7fYTZQJmHW/cUH2NWWg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=pz4PqoBGA2gtdtohY65oCwdaLE7hiakaDaK/cASyk+bGgeiONnrKFoHb9o9cvRozl
	 R9xBlLHqdBdFLAUql9YcmscUoXV+P1hg8NzOA1aicvyvnaHWmblTr2/ZYGKxisOz5M
	 dRPumKK/1+8tI/8PLFn4IsCoLjKBKIqSRaOiDQgD4XqVmHTQFOPrXUQfaT+g0nbmv3
	 daZFTw3+mkCk/ZYuJjEmzRT5O8RyRaBoRCqULPdDRJAynD2NsW9sHlFQKaqL2Dn16b
	 rniHVQbVv7iDExz+TWJ6GXwuqthOzgG1w/OPEhlDfa0wKKKdQ8kC3d1rpvbcVeiZtQ
	 8skmsBXGtzUWw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68B6sNbQ52185742
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 14:54:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 11 Sep 2026 14:54:23 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Fri, 11 Sep 2026 14:54:23 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>
Subject: [PATCH rtw-next] wifi: rtw89: pci: disable D3cold on ASUS ExpertBook B3/P3 series
Date: Fri, 11 Sep 2026 14:53:58 +0800
Message-ID: <20260911065358.34375-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chin-Yen Lee <timlee@realtek.com>

ASUS ExpertBook models (B3406CMA, B3606CMA, P3406CMA, and P3606CMA) may
encounter PCIe link loss or recovery issues after entering the L2 low-power
state associated with D3cold.

Prevent these affected platforms from entering D3cold to avoid the
problematic PCIe L2 state transition.

Add a DMI quirk match table so that other non-affected platforms can
continue utilizing D3cold power saving.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 44 ++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 8c3f4eb52cc5..941fb5ca15b6 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -4766,6 +4766,49 @@ static const struct rtw89_hci_ops rtw89_pci_ops = {
 	.rst_bdram	= rtw89_pci_reset_bdram,
 };
 
+static void rtw89_pci_d3cold_quirks(struct rtw89_dev *rtwdev, struct pci_dev *pdev)
+{
+	static const struct dmi_system_id d3cold_quirks[] = {
+		{
+			.ident = "ASUS EXPERTBOOK B3406CMA",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR, "ASUS"),
+				DMI_MATCH(DMI_BOARD_NAME, "B3406CMA"),
+			},
+		},
+		{
+			.ident = "ASUS EXPERTBOOK B3606CMA",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR, "ASUS"),
+				DMI_MATCH(DMI_BOARD_NAME, "B3606CMA"),
+			},
+		},
+		{
+			.ident = "ASUS EXPERTBOOK P3406CMA",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR, "ASUS"),
+				DMI_MATCH(DMI_BOARD_NAME, "P3406CMA"),
+			},
+		},
+		{
+			.ident = "ASUS EXPERTBOOK P3606CMA",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR, "ASUS"),
+				DMI_MATCH(DMI_BOARD_NAME, "P3606CMA"),
+			},
+		},
+		{},
+	};
+	const struct dmi_system_id *match;
+
+	match = dmi_first_match(d3cold_quirks);
+	if (!match)
+		return;
+
+	rtw89_debug(rtwdev, RTW89_DBG_STATE, "Disable D3Cold on %s\n", match->ident);
+	pci_d3cold_disable(pdev);
+}
+
 int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct rtw89_dev *rtwdev;
@@ -4791,6 +4834,7 @@ int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rtwdev->hci.rpwm_addr = pci_info->rpwm_addr;
 	rtwdev->hci.cpwm_addr = pci_info->cpwm_addr;
 
+	rtw89_pci_d3cold_quirks(rtwdev, pdev);
 	rtw89_check_quirks(rtwdev, info->quirks);
 	rtw89_check_pci_ssid_quirks(rtwdev, pdev, pci_info->ssid_quirks);
 

base-commit: f71dd599a98182d6bc34dce39977f928068ecd64
-- 
2.25.1

