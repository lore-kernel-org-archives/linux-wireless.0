Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F0931E84E
	for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2026 07:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777015595; cv=none; b=u0PE/CQtAWNTJA2WfkdgwdCb8Q71GzdgJQXG06cJU9Pe7yeulxDz9Lbg1StEPiCSEB0eE+wXm0vDdKz8v22E3wYdW8QNDcUqwI3PMHk2tGcLz/DUMnV4NWw2uXMPXFAyTphaAEcSXjgew9ePh83ibtvq77alXNs7ifu3L25yB9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777015595; c=relaxed/simple;
	bh=QuB99XcM8GWxWW1KzdQqBkheu5GGGIiH4+IbRy6v1/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qOQG6gkekmztfWcGuPbJB/3Gj3yxFdJ2CO7Qt3mKXPYJi4n9RDVaVeDik0f9EPg4ve5p+TWtkib5wjBLA+cL2jKygnGZNaqSxUIJWSKwEHnAgffbR+03imlg4H/CnCeVdb+kOVCy4/xcwzOop2M+N8iF+io/7z/fgshrNCz3/9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iQK3d2O6; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iQK3d2O6"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63O7QUrE4417404, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1777015591; bh=5o5CPl3NaZB5hBx5ar16M5ItgewbV/jTjPxHph/VFNI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=iQK3d2O6aGtvBOxJDlQ5BbBg6a49+9Nilz9eC/OwFwHa3NELYTF8m5HDDBchh0qDj
	 90GDEQ6Ju0Rupo3l/l1kb7rKyb6fxQ1u+Uu/Ducfzmt6TTRGEkXziQduhnGyvXzM7s
	 h+1aOtKh/zZCwLyoaug7tXuH0XQrBJLfagE0wfen3PjtOjHMVXwSd8nk6rdG7VFmb8
	 1I5gGaiGJtgVnbs8n7OLQkncr5CXQ0FlZTstJD/ccPiGrOOcCIN0gtVdrDY4KhOFZ8
	 XQL8dkW5oyhAxdig/GnifGneuh0/7TZbuDvsf2GcMuxOSdOCrsGXws9sTy/aq65Iyf
	 U4r/rJPBDzzQw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63O7QUrE4417404
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2026 15:26:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 24 Apr 2026 15:26:31 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Fri, 24 Apr 2026 15:26:31 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>
Subject: [PATCH rtw-next 3/3] wifi: rtw89: disable CSI STBC for VHT 160MHz
Date: Fri, 24 Apr 2026 15:25:52 +0800
Message-ID: <20260424072552.59220-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260424072552.59220-1-pkshih@realtek.com>
References: <20260424072552.59220-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

Fix interoperability problem where CSI feedback with STBC enabled at
VHT 160MHz BW cannot be properly decoded by certain APs, causing CSI
reports to be rejected. This problem is specific to Wi-Fi 7 chips,
as Wi-Fi 6 defaults to 20MHz CSI BW. Therefore, disable STBC encoding
for CSI transmission in VHT 160MHz mode to ensure CSI feedback is
accepted by these APs and maintain smooth throughput.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/mac_be.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index 39a28fd27412..4d61313a2a84 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -2750,6 +2750,10 @@ static int rtw89_mac_set_csi_para_reg_be(struct rtw89_dev *rtwdev,
 		sound_dim = min(sound_dim, t);
 	}
 
+	/* Disable stbc_en in VHT 160MHz to avoid IOT issues with certain APs */
+	if (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ)
+		stbc_en = 0;
+
 	nc = min(nc, sound_dim);
 	nr = min(nr, sound_dim);
 
-- 
2.25.1

