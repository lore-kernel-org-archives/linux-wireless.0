Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30272AE68
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937244; cv=none; b=RzIQ6XFweCcggabuTKPoWlCId114rjxxEEzpX3FvOAL4dNXUsP1GYClOZfseOMNT5GZ0AgL+VoXSjrClO/vhsVKf+vS/9VZ7QGaJicoHG6ECzX0nnhWEBQ0TMbazhl7Wn+pxm3erz7VFg3gjnwy8EJSQK4yFkTpZcNgsjGkMCBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937244; c=relaxed/simple;
	bh=tHt4Rnh7IRGxqoyqpxGVUpFCmyufau2JZGOz2i5E9QM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZpNik3lIbe52AKWXBNeEbY6cXONGdB1aov/c57YesF7PEMfZ4ow4tkCpHYnV3Sd59cwdJ4ljhAtDpv5itTYzzoI1PUgOrRfffzJ5myjG0h5i9WQ+bzMLjb/bPDfI9pPcNjeaDFRxuBKWx5eRFjru5JE/oWG523W+GBx3PMTP020=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mWeEKafd; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mWeEKafd"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68970dWT2355996, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937240; bh=7tdXY65ssUvCVD+Y80+yNo13HiIKbI9xwiLsfZApF20=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=mWeEKafd5nLeBmEZiHAn0Jf3yXcb60W3iYSoYeaYL05P4uC6tiX7cXVcFZyTfvvpy
	 2ikAguAgReLhNIOvTK+gvs/SxTCMrav0xUZk/c4bIdiLsvBsoEI7M5Lo9i9cv3QkU9
	 wvxmqOrfqo8bUpbrdJbs3is9vxeS9O4AHF2ntmXmfK/OH2+N1zBw+J6HUpC8PF7y9Z
	 UXYtEvwPibkIwFdSB7qVvlLOCQR2e/u7PBFl+4zCWKeJGXgSS7k0yEFen1fxhhYTl1
	 dHKfcpk2XwOgmA3KQtol1JqRRLYCe8OVGxUxBRprwG6f/1KkRDHZ30GBUpyDXfZO8v
	 4GwB7ycABbS9Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68970dWT2355996
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:00:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:00:40 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:00:40 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:00:39 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 02/15] wifi: rtw89: mlo: update link id to FW upon connection
Date: Wed, 9 Sep 2026 14:59:51 +0800
Message-ID: <20260909070004.35353-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Po-Hao Huang <phhuang@realtek.com>

Update link id to firmware so correct information can be referenced.
This is required for the new power save firmware feature.
Without this FW could try to maintain power state of a not existing
link and leads to unexpected errors.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 6 +++---
 drivers/net/wireless/realtek/rtw89/fw.h | 5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 6760e0053665..86db025afd7f 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -5193,10 +5193,10 @@ int rtw89_fw_h2c_join_info(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rtwv
 				      RTW89_H2C_JOININFO_W1_EMLSR_PADDING) |
 		     le32_encode_bits(IEEE80211_EML_CAP_EMLSR_TRANSITION_DELAY_256US,
 				      RTW89_H2C_JOININFO_W1_EMLSR_TRANS_DELAY) |
-		     le32_encode_bits(0, RTW89_H2C_JOININFO_W2_MACID_EXT) |
-		     le32_encode_bits(0, RTW89_H2C_JOININFO_W2_MAIN_MACID_EXT);
+		     le32_encode_bits(rtwvif_link->link_id, RTW89_H2C_JOININFO_W1_LINK_ID);
 
-	h2c_v1->w2 = 0;
+	h2c_v1->w2 = le32_encode_bits(0, RTW89_H2C_JOININFO_W2_MACID_EXT) |
+		     le32_encode_bits(0, RTW89_H2C_JOININFO_W2_MAIN_MACID_EXT);
 
 done:
 	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index f7d017d3ced0..6cb1f6dfb650 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -1858,6 +1858,11 @@ struct rtw89_h2c_join_v1 {
 #define RTW89_H2C_JOININFO_W1_INIT_PWR_STATE BIT(15)
 #define RTW89_H2C_JOININFO_W1_EMLSR_PADDING GENMASK(18, 16)
 #define RTW89_H2C_JOININFO_W1_EMLSR_TRANS_DELAY GENMASK(21, 19)
+#define RTW89_H2C_JOININFO_W1_IS_MLD_EXT BIT(22)
+#define RTW89_H2C_JOININFO_W1_SUPPORT_3LINKS BIT(23)
+#define RTW89_H2C_JOININFO_W1_IS_3RD_LINK BIT(24)
+#define RTW89_H2C_JOININFO_W1_LINK_ID GENMASK(28, 25)
+#define RTW89_H2C_JOININFO_W1_UPDATE_MODE GENMASK(31, 29)
 #define RTW89_H2C_JOININFO_W2_MACID_EXT GENMASK(7, 0)
 #define RTW89_H2C_JOININFO_W2_MAIN_MACID_EXT GENMASK(15, 8)
 
-- 
2.25.1

