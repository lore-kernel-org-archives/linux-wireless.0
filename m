Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25872319617
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 01:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335515; cv=none; b=dzndpQ1RODM+zv+LoMXYuSCt9aLGgkFRGloumiUYNzSu5fUbGx9y5GQboSkRE1ntADjs5chHeI2PSPLLsxsY+wtmxsWpHG9VpEvWnjRR8a5zpxQmt6IrxspUeRRIKaV1jnRDhwR9HlbnhzSI3MBqN2lD4OpmJjvRubQJhKKuUnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335515; c=relaxed/simple;
	bh=tfwpSf6cK/7wgZO3SI0caT3dlHz31BCetoXzCNKgNeU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iX9K6vaFKVLU9SpYeeKSuluGtMAi5LQEuGJWgOttiqI6+/jtjGjQ/dRIfHMxQFmbUwh7xircLWv3Yn3S3IkGg1lz0rGIYeJ8GmbU02dz39yC6eaQb4LoUqwNfdCQcG9ZbmLPAs/IZjtUZB8wpl9gTNHYIXctvXbLKzA/uwqvmt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=hpnKXVPj; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="hpnKXVPj"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6971BiJkA3403750, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791335504; bh=4YBOqUiyEuuL2113i28MhGcrE93n6FqthBzVub8O+DI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=hpnKXVPjv9qKwDA1IxzgIPrvLvyZHBeZy9Y4eRrgztdEaomwrX1smSLs0bvVJoBrY
	 NPN9tocMzALcu1b0cMi91T0DzQOt8HJINxoU2TSbflnkN89S8McWFKotsKqESvak8x
	 boV+svFfDJ0FGu8RGxDKLVy+T76vUY+fbEaAZvUpxCPvMk5WOx2lzbu952ldUHRBdM
	 QZ7emgxoguGKKvfbs6fyoq1teVFpxgtBPCuzBrOE0mt4Ws4ArWzdef/WrW6fGcwrcv
	 6ojpu/G+0AEUy8KC6qm2+7WjUefuBgyAduVH3sf8CZp6Xx0MdwWyaNy2bTvIVWw+ao
	 u2H4Jw7GLJJQg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6971BiJkA3403750
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 09:11:44 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 09:11:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 09:11:45 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 7 Oct 2026 09:11:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH v2 rtw-next 0/3] wifi: rtw89: 8922d: increase firmware format to 1
Date: Wed, 7 Oct 2026 09:10:54 +0800
Message-ID: <20261007011057.12125-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The firmware commands/events formats are changed since 0.35.119.0, and
BT-coxistence has much changes needed implementation in driver side.
Update the firmware format version to support newer formats and features.

v2:
 - add patch 2/3 to support NZ/BR/AR specific regulation.
 - in patch 3/3, mention the changes of patch 2/3 is one of reason
   to increase the fw version.

Ching-Te Ku (1):
  wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to
    9.24.2

Ping-Ke Shih (1):
  wifi: rtw89: 8922d: update supported firmware format to 1

Zong-Zhe Yang (1):
  wifi: rtw89: regd: add NZ/BR/AR for individual TX power settings

 drivers/net/wireless/realtek/rtw89/coex.c     | 2 +-
 drivers/net/wireless/realtek/rtw89/core.h     | 3 +++
 drivers/net/wireless/realtek/rtw89/regd.c     | 3 +++
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 4 ++--
 4 files changed, 9 insertions(+), 3 deletions(-)


base-commit: 7cde94dab0e74434ccc0a387d7ad373fb3becda0
-- 
2.25.1

