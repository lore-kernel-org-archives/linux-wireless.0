Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DE53BB124
	for <linux-wireless@vger.kernel.org>; Mon, 25 May 2026 07:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779692879; cv=none; b=GzOZxbAnjaF14PvJ1+a7i7goa6ya8gVyfgAFnzUR7p9PiyB5z9bp+7wFYP0cm4obChiQf0BBOOro0VDWPUy+5/wOtx+qKo/YE970LUujEnB9MUo3cUBYs8C/wrUvSnkCfRY76/drnsrrbaugEGg3FAZijhcoEkp+4rDtitZDtBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779692879; c=relaxed/simple;
	bh=31Ph13s7FzkZXvrwo3lowL40Gg9Yovb8GkSKH4tPu8g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KsJPOI5Ault8vXo9LTN5Hmy/V3TO2b88EtHJKT7XLREEvAZSw7VpHfo6hOsddhxH8AGIkCfkS5TYwGmwOtHDV+eCDN8qq9e4Azj0iGnzlX9BX/pUY2hLcc0cQVYEYA/9E5Y7a9QCylDrH3HxQ8p2FGlgl+HgmsSWGwL3wzq/73g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=meNFOrg0; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="meNFOrg0"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64P77p6L2875707, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1779692871; bh=IPCi1dTSHnE19cgBhFxUw2pvxM/8De+kdSVWfeK3clI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=meNFOrg0jbmgc4APJNtY0QEjUos+vddSbBAQVgZ0XylCBIF0Te8Y8iAkgvefywb25
	 ChWdgBTCpgi62+N/80H/o4Bdw5F9VL8O+5shpoBIC+HIkk6QnkdwEuezNmn13zN5tE
	 DqtgTZVLNY5rmaMukLajkRbFEgArEi8D7iEdkJUrr5mEZz/bLWpoMJFuDw01+WhoZY
	 fYRLM5+v/btn9dPBqQY1uebr9qIaBm3cqhQbcCp+/Kq4IpnyeJq8Y13myTE/eS+adK
	 McpOY3+K7gD82JQBiWSNeZNSTajqjppy7eoy6MOiavriMvD1tJOpXtEe/kWYx0fSz4
	 XG3HEbcZuGjsg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.28/5.94) with ESMTPS id 64P77p6L2875707
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 25 May 2026 15:07:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 May 2026 15:07:52 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 May 2026 15:07:52 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Mon, 25 May 2026 15:07:52 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH rtw-next 0/2] wifi: rtw89: support scan offload format v2
Date: Mon, 25 May 2026 15:07:33 +0800
Message-ID: <20260525070735.27659-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The first patch is to define supported firmware features of RTL8922D that
second patch will also add one entry for RTL8922D.

The second patch is to support new scan format v2, which considers channel
noise. Currently we don't collect channel noise yet, so leave new fields
as empty for now.

Ping-Ke Shih (2):
  wifi: rtw89: fw: add first set of firmware features by version for
    RTL8922D
  wifi: rtw89: fw: support scan offload v2 for WiFi 7 chips

 drivers/net/wireless/realtek/rtw89/core.h |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c   | 22 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw89/fw.h   |  2 ++
 3 files changed, 23 insertions(+), 2 deletions(-)


base-commit: 6b964941bbfe6e0f18b1a5e008486dbb62df440a
-- 
2.25.1

