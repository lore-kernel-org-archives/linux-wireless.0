Received: from mta0.migadu.com (out-130.mta0.migadu.com [91.218.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCB144AB6B
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 10:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786704851; cv=none; b=CvI0LSu3Da1B3cw0L/FSxMcT8TaihzOqb5rkRnXdlV4DeWZfe/o3/b+Q6MV7NZFeMnhBcOMEC5nlgAh8+X8m2yWUD01G1WiE7OSwkAGuH4ssSvl3RT7+hJBMAXfMPC5bW58wvZ6MBOIsgmEk+/Jn3M0PB6fxtVqKbe726XBoFa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786704851; c=relaxed/simple;
	bh=kZDJOvLYT2nsEkel50ckM+8l9eH/aA0F3RgRJztrk3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is3owTrBzcL+LLkxUJ3s6sLhr/k2jskwahhyTZhtaISc+NxfFGztAl9XkYxlEGS0xK1STgmfqO357Sc0VSq8nkkRYgU1QaN0LTcq9NUr/Tg0w0KtdUPrcRMs9WYuZ+cHpn/qdxrnOzC/Y6vHqQx/PEP5BQ6o266zLvAuP4AewCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i0RRTGJm; arc=none smtp.client-ip=91.218.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i0RRTGJm"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kZDJOvLYT2nsEkel50ckM+8l9eH/aA0F3RgRJztrk3U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786704836; v=1; x=1787309636;
 b=i0RRTGJmkW5+TT+i8kG7KJVO9CPDNUxj+voy+LH54QtGCJdGDUu1qkOJ/DB7p9AG82uggEhV
 X0uOeW4/T3xRO9GcabzVQGjKoJ/xveN5PWJyrshT/zHyenEB0CIzOlfFwwpK/PsdWlVUvCO4MTm
 iqPYXf/nbiiiLYeFxO1sUfqk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (46.239.4.165)
	by smtp.migadu.com with ESMTPS id 591582e075d66969;
	Fri, 14 Aug 2026 10:53:56 +0000
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
Subject: [PATCH v5 1/6] wifi: rtw88: add the RTL8723B chip type and SDIO helper
Date: Fri, 14 Aug 2026 10:53:21 +0000
Message-ID: <20260814105327.6687-2-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260814105327.6687-1-luka.gejak@linux.dev>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
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

