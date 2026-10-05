Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FC3318EC9
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 05:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791178785; cv=none; b=kx4cE0QlENLoNso/BRDvq5rLcaF3wlv9p29NulRy5YclQDu2dGp2LX/wInxmEb6IaMIO/X2RjEW9xm36hE7yG45WpEK9ac5NKJrYeoq8FHwT/SobRasb0EsIw4LpoygK98j+tsbhIGwCqlLmaWDdIWZbp94egS0yBklewH0np8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791178785; c=relaxed/simple;
	bh=PYiLXhyXCZ2IHN3OANTXb6+3EvOdLRYjhPl751Ognow=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jEhxwWG2xhzXOtzxvNPbXl9Q3bvIgy4/cFBGwkOsZOcTrBCV0zYC/jFFdE/SbEitxNdw6MY0YO71yaALcvg9GcCAjhxvCqNmSVOQ7f76YRTt1adDHTePYgDLifApSbnn7gZQNhoiNNa9rcynd3a7S0x1cGqHe8efmIpD9GfVQqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jH/q05NY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jH/q05NY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6955dfr571694268, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791178781; bh=NdwmB0u0mn4AZvfpzcLqpbXZojLrU1CZwGZ0JOW+JHc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=jH/q05NYYBnA4ASd28Na5Lu6TPODOVKXxsX29Vs8u5OCqbGRks2PzhCRXfFtL9F0t
	 M7a4LQUZpGxFwWeEHvdILXZcU7OP/9vnL/wetxLregDcRaNQFtBETr96NzntI1auTO
	 5FO/gHY32J110bRbUnuRN87AtU/Ql9RH4BEFk97TYmJfrSjFzS2bkJnfz2+yLtMQY8
	 stpZSPYG/wvaN8kDcL7J3KEa0s1aZysCOImcsLu2mS2kFrS8v+jLX6GXNJ0BV2qGAs
	 H5S9VLXiJAGI5eB29zbsJzWeQLMrco3pWJjJU6T31u+l2Ma9JNB/w5RK0psCRballG
	 UIl1UuNre5tIw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6955dfr571694268
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 13:39:41 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 13:39:41 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 13:39:41 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Mon, 5 Oct 2026 13:39:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next] wifi: rtw89: coex: fix off-by-one in H2C macro buffer full check
Date: Mon, 5 Oct 2026 13:38:55 +0800
Message-ID: <20261005053855.17740-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The buffer full check used >=, which rejects a command that would
exactly fill the buffer even though it still fits. Change to > so a
command is only rejected when it would actually overflow hbuf.

Also drop the duplicate BTC_H2C_MAXLENC definition in core.h and keep
BTC_H2C_MAXLEN from coex.h as the single source of truth for the H2C
macro buffer size.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 drivers/net/wireless/realtek/rtw89/coex.h | 1 -
 drivers/net/wireless/realtek/rtw89/core.h | 4 ++--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 6b72e2c80d14..19e6decd0761 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1092,7 +1092,7 @@ static int _send_fw_cmd(struct rtw89_dev *rtwdev, u8 h2c_class, u8 h2c_func,
 			_reset_h2c_macro(btc);
 
 		/* Type:1 byte, Length:2 Bytes, Data:len bytes */
-		if (btc->hbuf_len + len + 3 >= BTC_H2C_MAXLEN) {
+		if (btc->hbuf_len + len + 3 > BTC_H2C_MAXLEN) {
 			rtw89_debug(rtwdev, RTW89_DBG_BTC,
 				    "[BTC], %s():return by MACRO buf full(%d)\n",
 				    __func__, btc->hbuf_len + len + 3);
diff --git a/drivers/net/wireless/realtek/rtw89/coex.h b/drivers/net/wireless/realtek/rtw89/coex.h
index 3e9e1510c44f..38ffd0eff2c3 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.h
+++ b/drivers/net/wireless/realtek/rtw89/coex.h
@@ -7,7 +7,6 @@
 
 #include "core.h"
 
-#define BTC_H2C_MAXLEN 2020
 #define BTC_TLV_SLOT_ID_LEN_V7 1
 #define BTC_SLOT_REQ_TH 2
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 7e74b5c9ed49..e31e708e0533 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4434,7 +4434,7 @@ struct rtw89_btc_btf_fwinfo {
 };
 
 #define RTW89_BTC_POLICY_MAXLEN 512
-#define BTC_H2C_MAXLENC 2020
+#define BTC_H2C_MAXLEN 2020
 
 struct rtw89_btc {
 	const struct rtw89_btc_ver *ver;
@@ -4455,7 +4455,7 @@ struct rtw89_btc {
 	u32 bt_req_len[RTW89_PHY_NUM];
 
 	u8 policy[RTW89_BTC_POLICY_MAXLEN];
-	u8 hbuf[BTC_H2C_MAXLENC]; /* H2C Macro buffer */
+	u8 hbuf[BTC_H2C_MAXLEN]; /* H2C Macro buffer */
 	u8 hbuf_cnt; /* H2C cmd count in buffer */
 	u8 ant_type;
 	u8 btg_pos;

base-commit: 7cde94dab0e74434ccc0a387d7ad373fb3becda0
-- 
2.25.1

