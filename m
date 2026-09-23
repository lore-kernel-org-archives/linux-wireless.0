Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4614195D2
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 05:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142346; cv=none; b=WQyLu+tU//v3MO2f4oEjtx+rewU44c7vbcYJWg+1qrupaotX8F5TcER65jKpt3Z9QUgufiq/PTAl3jnnLRHcoYf+LLwIDrX77+eBq6DAZvh9G/GxBltLOg9quyQ03AMVKdFVUZrPQ2/cQuiS6DNgndbd7BoJ2hzUJQU2+law++k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142346; c=relaxed/simple;
	bh=//2iWwKGB0zqzuGCnEB3pf6mfc56CfCW/ClbuLEPasA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cJ5XcykZ7FM9f3XJqekuBfVd+Ec3Z8yeFn27E+7VXw8X8bo6kI62N/VpFdZDdD3+y3Lem9/S+z08dx91obDMbmpJy10EnXZiNsB78N9eGe0A2VRaxjAI1SU3UZ6L+ed4hVcwvyay81d4WTQkebDBh1cKG+BhiHucrUlfjGdBvTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=PWo/J72c; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="PWo/J72c"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N5jfTM3097398, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790142342; bh=3P25/yDTd+YsgQewMP+8K9+ODvV99CIcjEW1VJbaAjw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=PWo/J72c8gr1vfNKzLgM283rYkDXMShSHBubw4lGcZlQvz+Z2eomU62dYfuI55f/x
	 GpN5Eknghk9jD4ixT7YysoRlSM+12/vPCDS47o2NVcoFLyUL4N0PqEWm8o/pf4UsgT
	 Gf28AlSiBDm3MXXxDWI50Zf/6AfVer0/+QHqoqMczh9cpzVukEKvOZfT6w4tMfU6G7
	 /4NyG8Q12Zf3Jg3WucU7qVVJuVJmlMqGEXdlslc9qkfJGhIKb23WQ7H1Vz6E1v2zoP
	 vvur9I993sSP8DPfiM8BwI1FQsTeRT0xYcayQmu7g/Rf3ybS26lwM0OgTlWEH65rdM
	 yo7Y1ppJMYfAA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N5jfTM3097398
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:45:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 13:45:41 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 13:45:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 0/6] wifi: rtw89: fw: reduce memory use of firmware, and support board file
Date: Wed, 23 Sep 2026 13:44:59 +0800
Message-ID: <20260923054505.43329-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The first three patches aim to reduce memory use of firmware, because
RTL8922D has many variants and each of them uses different firmware.
Therefore, firmware binary file becomes large, but actually only need
one copy to specific variant. Duplicate the necessary part and persistent
them, and free memory allocated by request_firmware() after device
probes done.

The other three patches are to define TX power values (for now) by an
external a board file corresponding to a specific board (with specific
VID/PID). This is necessary because TX power values depends on board
(module) design, not on chip only. Add this as a initial work to make it
possible to record settings for customized module (not standard PCIE
module).

Ping-Ke Shih (3):
  wifi: rtw89: fw: duplicate recognized firmware elements
  wifi: rtw89: fw: release firmware after recognizing firmware elements
  wifi: rtw89: fw: duplicate firmware suit data by vmalloc to reduce
    memory fragment

Zong-Zhe Yang (3):
  wifi: rtw89: led: check if board variant assigns led desc
  wifi: rtw89: support variants of FW elements
  wifi: rtw89: 8852cu: take board ID 1 for FW elements 28de/2432

 drivers/net/wireless/realtek/rtw89/core.c     |   6 +
 drivers/net/wireless/realtek/rtw89/core.h     |  19 ++
 drivers/net/wireless/realtek/rtw89/fw.c       | 252 +++++++++++++++---
 drivers/net/wireless/realtek/rtw89/fw.h       |  15 ++
 drivers/net/wireless/realtek/rtw89/led.c      |   2 +-
 .../net/wireless/realtek/rtw89/rtw8852cu.c    |   1 +
 6 files changed, 253 insertions(+), 42 deletions(-)


base-commit: 2f77c66694108785a1f6ae6c5de06453e7f7a91f
-- 
2.25.1

