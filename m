Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E73B3EB809
	for <linux-wireless@vger.kernel.org>; Wed, 20 May 2026 12:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280711; cv=none; b=f9zWbzvmKczK+7OTGfL9OCO4VfS8LBcCc8vV+IWatBSHihFPeuvaU5AA0BBh8ub0cXRmEqumsiv9Hu+jU/cbnIBnJMZfoOhpIVWul+unXFbK77IyXDXBVyB4n6Q6n6xugsIe9GQxWaEoOfhTcVzTQPGAbG2jMjWGJijzjMdgT6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280711; c=relaxed/simple;
	bh=NB0B3wbOpEcNBMhAOPylsSP7itwVxoHYOKw9vqsmP7c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Kwm0e5j90AiyxmVA6zPCBHGJIVKihrbEZUcqBt6izLmg4ke4HYhuJ7JkhAqlLtYGDslPK0zBcOPy5ro6VlGf5Ozk+zxzJxUuX64COz0QEEOLmwhnczUE1Lt3iGYNpyBkIG2zmP7PqT9S3CEfPBRk7nZx64WcqOEe9ZAthwhJymQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=A+lm0snf; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="A+lm0snf"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64KCcNmaD095436, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1779280703; bh=8xt3brWBP10nGsnoa6JhylbXI9KMwptxRBWbOHfIm4Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=A+lm0snfzlnf9mcfjX7pMh7+BKk1xpQYdCG4jFwsfbS6iSVaykL6aYoOkavRsEKOx
	 LvWGxjvAtdLqPuoOO0rj/NH9uFbZx7RWrAHjzzKqx9K0UqCVPb5GT8prJ7cbDKXGOL
	 Eh2l3ACbnkj0pjxJ0ntQ1hAzKRkLwa+0Bp+yfDd/81tNojdmF2GxS33GdgJhZ4Jjqk
	 Tut4uEL9l6p8NG+NKa0XKUEyeJS2D8ChMGMdLEGCuA7R70+3aYo2Hp77Avs82mGKyQ
	 /wiNueEHHpZhEB3oTgHTdnxYmjyPNoHVyfszYm9jwXk2gcUMbn7/3nxS9M/jfI6fVQ
	 p8avn5V3u7XMQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.28/5.94) with ESMTPS id 64KCcNmaD095436
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 20 May 2026 20:38:23 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 May 2026 20:38:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 May 2026 20:38:23 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 20 May 2026 20:38:23 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 0/7] wifi: rtw89: update firmware elements formats of power track, compensation and MRU
Date: Wed, 20 May 2026 20:38:16 +0800
Message-ID: <20260520123823.1792954-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

First patch is to load power track table according to chip AID.

Patches 2-4 are related to power compensation, which format is changed to
share common part for sub-tables corresponding to operating bands. And
change to load table by RFE type instead of AID.

Patches 5-7 are power table of MRU, which driver load it from file and
write to registers accordingly.

Ping-Ke Shih (3):
  wifi: rtw89: 8922d: refactor digital power compensation to support new
    format
  wifi: rtw89: 8922d: support new digital power compensation format
  wifi: rtw89: fw: load TX compensation element by RFE type

Zong-Zhe Yang (4):
  wifi: rtw89: fw: load TX power track element according to AID
  wifi: rtw89: Wi-Fi 7 configure TX power limit for large MRU
  wifi: rtw89: debug: show large MRU in txpwr_table dbgfs
  wifi: rtw89: 8922d: configure TX shape settings

 drivers/net/wireless/realtek/rtw89/core.h     |   3 +
 drivers/net/wireless/realtek/rtw89/debug.c    |  76 ++++++++
 drivers/net/wireless/realtek/rtw89/fw.c       |  11 ++
 drivers/net/wireless/realtek/rtw89/fw.h       |   5 +
 drivers/net/wireless/realtek/rtw89/phy.h      |  10 ++
 drivers/net/wireless/realtek/rtw89/phy_be.c   | 163 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/reg.h      |  13 ++
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 102 ++++++++++-
 8 files changed, 374 insertions(+), 9 deletions(-)


base-commit: 7076af642955693935e60bc94546d105fb0395ca
-- 
2.25.1

