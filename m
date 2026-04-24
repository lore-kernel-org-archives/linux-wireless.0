Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C4C27FD74
	for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2026 07:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777015579; cv=none; b=Tds+C72J4v/EV1KRuF9aDdGVE/xr6A/YayWcGt/o1LkczyHKpPs8eI2HhmnKlmnavkl7nBPfP73QWP70Vqhvjte0Aiqc1QkFME7pTJDkjOkJAyP8Ru38v6/BezBSACn+Mtk3MMe2DdSAVNg+gtJk/7ELUw+e36MFwZ96uU7Boxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777015579; c=relaxed/simple;
	bh=Hbe2dv7d3MFtm5jIpIa1+IsFBNX5SPfCZlXR4QKBVGg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nen2yo/rqAwtI2rp/m+1s9GU4ADzBCTvL0TCAu0J+tLCRwdAF2WFZwshgc7mbFEjrGVhbddqN6SuaDP1vnT+KkIM0bkNtT8TBbbcU4cwHkqJ7s+Uqpv6/CPcVOndJb4Bt1N9FtvBqSuqWYI9HOcnpOKZhZbdLuYlm74kSxKKtMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=PAm3PQGZ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="PAm3PQGZ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63O7QDktC417305, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1777015573; bh=mmkQsXqUJ2pmudRqzusOI+sr68PRxd76zteurZLnhjE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=PAm3PQGZRmkTelki5p9Ofa56Rhl+voa+eRxpWHQrHLA4q5fb8lWxm2AELtT6/+oEm
	 4XpihOTSvNoSnlrm9TxP6ukr7LcZX0XowpBdr2QjF9MueWKNkqstYRfvi3fZ/Yg8uR
	 yTmA/nwbURHYN4j+ydovwybwBsXFfh2gtIXadh14BhOSJBkqWMOnTC3wGp4V/lv3TE
	 ecv77xU/e0hTsACtFL3Z1E8stXNFn1Q9wzr/2oNTcD359RaW4SlcmiiofEMmm9UgA5
	 md0zlFgptCpJ6IYf1JlRURinhQJzew5d2P5zOugLT3QqmD6LDKjjj+HCqaTgcqx1I0
	 9Vc/K9s5qlE+A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63O7QDktC417305
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2026 15:26:13 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 24 Apr 2026 15:26:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Fri, 24 Apr 2026 15:26:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>
Subject: [PATCH rtw-next 0/3] wifi: rtw89: update hardware settings to fix interoperability
Date: Fri, 24 Apr 2026 15:25:49 +0800
Message-ID: <20260424072552.59220-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

First is to clear CLK ready bit to prevent unstable for certain platforms.
The second one is to fix low throughput problem in AP mode. The last one
is related beamforming that CSI can't reply on 160MHz bandwidth for WiFi
6 chips.

Dian-Syuan Yang (2):
  wifi: rtw89: disable HTC field in AP mode
  wifi: rtw89: disable CSI STBC for VHT 160MHz

Ping-Ke Shih (1):
  wifi: rtw89: pci: no need to wait CLK ready for RTL8922DE

 drivers/net/wireless/realtek/rtw89/core.c   |  4 ++++
 drivers/net/wireless/realtek/rtw89/mac_be.c |  4 ++++
 drivers/net/wireless/realtek/rtw89/pci.h    |  2 ++
 drivers/net/wireless/realtek/rtw89/pci_be.c | 12 ++++++++++++
 4 files changed, 22 insertions(+)


base-commit: fa489a77e3267e05df95db96ba98e141ec07cbd9
-- 
2.25.1

