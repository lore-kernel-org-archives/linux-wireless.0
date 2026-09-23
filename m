Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CC638A725
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 05:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142382; cv=none; b=oKIKh2zqoakerhWeNBhgPVOKjX8v/hDm4fJ+sjBRUQdHFe1YNncI/LVQ+3vKMxRdGIbuBs3fckFGtKZUTl4hw95AQZTIJjimPD5jKp2QIPG44WTjqIQEed9TtORSPrHD/iGUVwkLyR+gW2g7fTz4y2/hl9M9Fp5ArnCth69xlnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142382; c=relaxed/simple;
	bh=gLYKpy0lY3oRVCH1F/Ipajlhlj80pfc7gj5Atse9TdI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQdr5It5n7+o8YXEyGa28hKUCjWdfbnIsGdT2rvhWrtQhN/mz0ZQaOa94t9hV4QHU1wUnY6TakjOHsdrqoRuI9wZUxHzY7ZQiSWnykQFpZ6AlIPHwwC8HKwvcfhWAtf26SNdM4qWaSb4HUqyk9HekkkZxrfzIoYuj8RaAR9ThUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OU+i6gUm; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OU+i6gUm"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N5kI7Q1097544, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790142378; bh=eqzLGD/+q4xSUr7gOH/rJzw2e9T3GZae73GzeP25yH0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=OU+i6gUmudo7r+mCvnWi9ZcpE5oUeaEalMznZHVZqlIPl+wjDmHxneuxYes5H1Om8
	 m38Q3lfuMZ8rJfNAYIfugvgfWsiQ/XRvqZwSJdLMUAXLkT3TcclD3uWiPaDJsl8h+r
	 JHCFfa8aIFzRYiRHYmIojgJlr4hn6ywcKm0F8GOjtbSur3rCNOCCW0WQIWlYSKPxfm
	 rQIjvbDnF5N3arTjciE842hzJqUxe8pu7Y3//Pv/Kr/W45Hv6xeoWVOaq0bR4XeRKN
	 E30uA+tzYB0QQ1fB4lXPQS9/6VIiz18lwZvv5XV10CGxJCAsipfcoyCRK2rh2x8/Bi
	 9lkfaMx/lt9dA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N5kI7Q1097544
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:46:18 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 13:46:17 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 13:46:17 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 6/6] wifi: rtw89: 8852cu: take board ID 1 for FW elements 28de/2432
Date: Wed, 23 Sep 2026 13:45:05 +0800
Message-ID: <20260923054505.43329-7-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923054505.43329-1-pkshih@realtek.com>
References: <20260923054505.43329-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

RTL8852CU with 28de/2432 prefers to use variant of some FW elements.
Use board ID 1 for these FW elements. And, configure board ID to it
correspondingly to try to load the variant.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h      | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8852cu.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index bcb58a9392cc..5b26ea33f329 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5901,6 +5901,7 @@ struct rtw89_chip_variant {
 
 enum rtw89_board_id {
 	RTW89_BOARD_ID(0000, 0000) = 0, /* reserve 0 for non-variant */
+	RTW89_BOARD_ID(28de, 2432) = 1,
 
 	NUM_OF_RTW89_BOARD_IDS,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
index 6f852f4a713e..2e46b05b05ee 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
@@ -89,6 +89,7 @@ static const struct rtw89_led_desc rtw8852cu_valve_led_desc = {
 };
 
 static const struct rtw89_board_variant rtw89_8852cu_valve_board = {
+	.id = RTW89_BOARD_ID(28de, 2432),
 	.led_desc = &rtw8852cu_valve_led_desc,
 };
 
-- 
2.25.1

