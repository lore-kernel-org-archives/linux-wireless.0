Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F50644838F
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543417; cv=none; b=bncwxNyjEhI/6bKLpHdp1BXpDg5KOYC+gdbwJd1SzdEuDnn4JIXZFOTPM7nXVxv53YC5V89+g2+tsQFr0InggZW+SJwHecRf6PCNrht95+LUhgmuPeYw6vWrvJ0uEQBB1Q5TkBGrjtkETH+t4LIopxERxLTOSUciNsgy1AqaUQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543417; c=relaxed/simple;
	bh=yzVH2y5dDvGKKHEJtgoG54Ko/cOpZR9z6q1MsfFlsKQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c0dwxXwdVdG0Me4rxrOoVVCZisJNmuF8CF9UcwJC7ivOa+p8G5AU4hemGYzrTmqax/y1DBauPsEBNVGpulFeSu+WMYdKuWjplLwPWOXsnUorVmdyqugB5oqMZMwuAFGlQbjnyNdIyKZebXnRzeWsw9J82CdwOIKAuK2Hhz6id/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MyKX1Z25; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MyKX1Z25"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7NDSA02168315, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543394; bh=LLBD+4ltTbwZQBY78aEkDAeifsmkYQRxWRRGw7qX77I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=MyKX1Z25Q7/Adh4l/TCDSvje+/6Buap+fYNEdEiPX+gDfX1OKTeKFq8PT0ys6hnHV
	 EKROaQXSfd0bg+FyV65j6g6Q9BS36eWMtj5ya7abeBEI1v5NHJnuUY1qF+LRxI0/2o
	 gm8X/X6FGFTZVHnWspq5QJQ47H3eHbF8auM7H39GtWbzlZSQWaXuY8qv/LFW51C/YF
	 VmejspQsw+NZDT2MzSlP1ZG21/x550ksXDAs3ut0BCrv+K1wrxwi1BS4u/tlRR0Amj
	 pA/xu94QWv7Mj3E5ygcPebnD6RmtuRGtyTgjZW0CktN4chAI29KUrGBJLJOJhBonYG
	 hBzVnzcVdvfbA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7NDSA02168315
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:13 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:13 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:12 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 01/15] wifi: rtw89: coex: fix SET_H2C_MACRO not sent for BTC_FEAT_H2C_MACRO chips
Date: Wed, 16 Sep 2026 15:22:24 +0800
Message-ID: <20260916072238.62574-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260916072238.62574-1-pkshih@realtek.com>
References: <20260916072238.62574-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

For chips with BTC_FEAT_H2C_MACRO (e.g. RTL8922D), _send_fw_cmd
buffers each BTC H2C command as a TLV entry into hbuf, then falls
through to the shared rtw89_fw_h2c_raw_with_hdr call. The else-
branch was missing the reassignment of h2c_func, buf, and len to
SET_H2C_MACRO and hbuf before that shared send, causing each
command to be delivered directly rather than through the MAC FW
macro mechanism 8922D requires. Add the three assignments and
reset hbuf after the macro is sent.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index b16af1291b93..3ef30bd962d9 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1102,6 +1102,10 @@ static int _send_fw_cmd(struct rtw89_dev *rtwdev, u8 h2c_class, u8 h2c_func,
 			    "[BTC], %s():Buffer H2C-MACRO cnt=%d/bt%d-func=%s/len=%d\n",
 			    __func__, btc->hbuf_cnt, bid,
 			    id_to_h2c(h2c_func_mask), len);
+
+		h2c_func = SET_H2C_MACRO;
+		buf = btc->hbuf;
+		len = btc->hbuf_len;
 	}
 
 	ret = rtw89_fw_h2c_raw_with_hdr(rtwdev, h2c_class, h2c_func, buf, len,
@@ -1111,6 +1115,9 @@ static int _send_fw_cmd(struct rtw89_dev *rtwdev, u8 h2c_class, u8 h2c_func,
 	else
 		pfwinfo->cnt_h2c++;
 
+	if (h2c_func == SET_H2C_MACRO)
+		_reset_h2c_macro(btc);
+
 	return ret;
 }
 
-- 
2.25.1

