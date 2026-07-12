Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7F92571DA
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 03:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783825569; cv=none; b=fkD3FLAWJA5HDGVWtG/cUF+3T+Vcf8T8lhMrr7ke/PVSWB4/O3+/YwZHl/D1Rc2mDBdAJWP3GIQgGFrHLVkPVkd8UMC9dEomkCAgHpIPTEl2xXnOy1t5zRfpoFUbJmWz++9CocLxm8khL8hICGQn/52hsx2198cZMbhM9NIPk3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783825569; c=relaxed/simple;
	bh=LHLvnyoNTKHEg737ORuG1S643CmZ1pQBMbvo0Uz88ho=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EUXZgS7Q09TDKDcNnxlh3GWKp5vl/yJhIltwAb9PhB3fW55IDcmz4C6sP3VV7aequb5OEnO6/3WY0bV8PbrTz4n1NHTNvT6vzYSnIYJldLhn+eeTmsMoUKd6f1U7rKI8ceXHL/zVHQSYsj+G1nFNkAy+SmaJYTF7xaFZeavhcIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=kjgMcqUS; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="kjgMcqUS"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66C3646Z0525806, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783825564; bh=i3gK5Ul1N6b7uCwmRcwzrXtA2od8xsnU7tAIjGT2Kpg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=kjgMcqUS4UjC0aCv+x0S6tZc1WWgpjTMO2s7mnz5AvSZ6XocOVfFRCd1U2jwlPuWH
	 bwVDT90ibJEWc972a+j/tRcqm7q+FY9NlS3BWSRjWChtosJlYane1aAMMFA+6wFQ4t
	 UbWgsiTDJZDcRIQgOZqzDoAYszwbymfEjvj9ie4lfCTbBWcVVTbMcaAP4nzE7iE6xL
	 d8eudBDysZx6Q5mjZCsCEtMBxbz/DMb8qCf2EfBe9w52ZuQc4tUXheV+59ChSX1vTx
	 QV7HTvrNZvSL4x2YLWRLBXHHQlv0N4Wm3d+sIxe5enjbeIDq+KPrxN6fahdudxsMal
	 SHiw9aodGR7Sg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66C3646Z0525806
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 11:06:04 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 12 Jul 2026 11:06:04 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Sun, 12 Jul 2026 11:06:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 00/11] wifi: rtw89: coex: implement coex for RTL8922D
Date: Sun, 12 Jul 2026 11:04:55 +0800
Message-ID: <20260712030506.43438-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The BT-coexistence introduce many new formats and features for RTL8922D,
including dual-BT support, offload features to firmware and etc. Update
them accordingly and add a tag version for reference.

Ching-Te Ku (11):
  wifi: rtw89: coex: Add Wi-Fi role info version 10
  wifi: rtw89: coex: Rearrange coexistence control structure
  wifi: rtw89: coex: Update driver outsource info to firmware version 6
  wifi: rtw89: ceox: Update antenna & grant signal setting
  wifi: rtw89: coex: Rearrange Bluetooth firmware report entry
  wifi: rtw89: coex: Refine send firmware command function
  wifi: rtw89: coex: Refine _reset_btc_var()
  wifi: rtw89: coex: Correct SET_RFE settings
  wifi: rtw89: coex: Add firmware report control report v11
  wifi: rtw89: coex: update external control length by case
  wifi: rtw89: coex: Update coexistence version to 9.24.0

 drivers/net/wireless/realtek/rtw89/coex.c     | 3781 ++++++++---------
 drivers/net/wireless/realtek/rtw89/coex.h     |   73 +
 drivers/net/wireless/realtek/rtw89/core.c     |   11 +-
 drivers/net/wireless/realtek/rtw89/core.h     |  486 ++-
 drivers/net/wireless/realtek/rtw89/debug.c    |    6 +-
 drivers/net/wireless/realtek/rtw89/fw.c       |  556 ++-
 drivers/net/wireless/realtek/rtw89/fw.h       |   60 +-
 drivers/net/wireless/realtek/rtw89/mac.c      |   27 +-
 drivers/net/wireless/realtek/rtw89/mac_be.c   |   21 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b.c |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c |    1 +
 .../net/wireless/realtek/rtw89/rtw8852bt.c    |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8922a.c |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |  214 +-
 16 files changed, 2954 insertions(+), 2287 deletions(-)


base-commit: 56d32cdc6040440b08edfd5d7262250a721233f8
-- 
2.25.1

