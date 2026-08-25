Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC3138838F
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 16:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787675630; cv=none; b=mcs9Zv9PdGUCdy44GtouHAsyAjhUSHH67BMClQaTvtrGW8mC2K8RwS3S5AD3lsVGa/rx+3kHy8eXiUnr/WKY8mj0NmycKiKbqqwHKPdK4pk7jDCXbvHCVn8JBVFsvfpMn0bgBF09sE5puSXUm+bcBfT3RMc53Ka9HX9SuZXIwWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787675630; c=relaxed/simple;
	bh=p7YrBwgvxsduLNj/FW2v0dCiwxe4AwgOy5IOCUsCOvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfidswvxgIWs7CmxnqxXC7gFjCVGTDojdmdPWlVQApjgWjD+vC7vsfeMK9SB1YFVOpJhOfSkpm/nnh/wiTplKgq3BP9v7ztiF9N1xvfXNOv3lE3v4HOv9vM8ZRaMULi1NqscBWc3jHv5sgatOPfzhwbqNg7JDQj+DAJYVX9LNTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SiUThWuF; arc=none smtp.client-ip=91.218.175.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SiUThWuF"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=p7YrBwgvxsduLNj/FW2v0dCiwxe4AwgOy5IOCUsCOvs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787675616; v=1; x=1788280416;
 b=SiUThWuF+DaK6IV0ApTCgCx92FYbp3AtjXFHth+DjinQLWThIQXUEFdl0s5RVZVS3pEndh7v
 kcYhfZmk6fdf+R4m0mRQJ2bQIbe1ebMHIiR/M0gMCsm3GvvNZ3df76apTCVdNs65Ttar+yvBQ9W
 ufz990pR8bDqcUyX5g9lvjoU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (109.165.152.75)
	by smtp.migadu.com with ESMTPS id c17add7c374d967d;
	Tue, 25 Aug 2026 16:33:36 +0000
X-Mizu-Trace-ID: c17add7c374d967d
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v8 1/6] wifi: rtw88: add the RTL8723B chip type and SDIO helper
Date: Tue, 25 Aug 2026 16:33:09 +0000
Message-ID: <20260825163314.1590-2-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825163314.1590-1-luka.gejak@linux.dev>
References: <20260825163314.1590-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luka Gejak <luka.gejak@linux.dev>

The RTL8723B is a 802.11n combo chip whose SDIO variant, RTL8723BS, runs
a Realtek vendor firmware that differs from the firmware used by the
other rtw88 8723 family devices. Supporting it needs a number of small
adjustments spread across the shared core, all of which have to be
restricted to this one chip and bus combination.

Add the chip type and a helper that tests for it, so the changes that
follow can be gated without repeating the chip and bus comparison.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---

Notes:
    Changes in v8: none.
    Changes in v7: none.
    Changes in v6: none.
    Changes in v5: none.

 drivers/net/wireless/realtek/rtw88/main.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index c6e981ba7986..8f86f7c12de5 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -194,6 +194,7 @@ enum rtw_chip_type {
 	RTW_CHIP_TYPE_8723D,
 	RTW_CHIP_TYPE_8821C,
 	RTW_CHIP_TYPE_8703B,
+	RTW_CHIP_TYPE_8723B,
 	RTW_CHIP_TYPE_8821A,
 	RTW_CHIP_TYPE_8812A,
 	RTW_CHIP_TYPE_8814A,
@@ -2194,6 +2195,12 @@ static inline bool rtw_chip_has_tx_stbc(struct rtw_dev *rtwdev)
 	return rtwdev->chip->tx_stbc;
 }
 
+static inline bool rtw_is_8723bs(struct rtw_dev *rtwdev)
+{
+	return rtwdev->chip->id == RTW_CHIP_TYPE_8723B &&
+	       rtwdev->hci.type == RTW_HCI_TYPE_SDIO;
+}
+
 static inline u8 rtw_acquire_macid(struct rtw_dev *rtwdev)
 {
 	unsigned long mac_id;
-- 
2.53.0

