Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68EA446BE0
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543469; cv=none; b=VRoqn0RSYXZxW28WEJQyFrDOjylVpkcAm/Z52YVLn8etLWiQotD62pIyPF6yoj4Xr/jL2o24MHEYR3JhGbfnk9e0wU1hsdgwfarxFZDg9X7OIasTE+vj0w7bA8p97w9I8+Rl9GSGQNxUbjIPsdbOEUS84KOmeodG1ZXTTk34KKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543469; c=relaxed/simple;
	bh=7PIhpzUqJGBCfP+L4qVfh29boZ6UZGoa6qc37rhA0oo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QbxThnsACgNQpaa0NENsKxYQPVk4TJazEKBlaTifAJpxTBCr71p1IS1wVHr8vQbGOH0fWTM5vNy7T5/hvX8WWCVReZzBdF9b9T9GsXChoozTU+DyK0AoChII8c28eaYqwoBTJWSKUcoQnR4gvnYw430515hz9Rc1pQpNhbphwIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Pbi/o4QU; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Pbi/o4QU"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7O5LT02168535, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543446; bh=y0B41RRSipV+wgN0El1UUBofkGYpukaHeZRUsysC688=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Pbi/o4QUNRNU42T3Dp1vxZsYYQEbgRJVVB1uf8Zkpwaw8aY1UfhCvkUIciL3qq0fr
	 LtQm+KJmNqYxsCAmyktavMkTTbKm0rpSlgT8WsE8Qx5wdaUsAYmaix8l/zfDumlUcj
	 +scFEv8g/Dz5E6PkLJF4TgUxIFMEmqv7yQhixa9utIlUin6QmwysHD7wZH1rF1pvV6
	 8CqnSC+pnei/8FFYX6pblaG64f0WweeGIFNNxQIut/dr1lLqQK4/7uJG19KmZQit+t
	 FdInVqerItEj6jCimLiBZ1y1IH8M885NMOS+3sm00yWoWWGjw5iSkhqcsqJWZN+T8m
	 /PYVmzSeKBTfQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7O5LT02168535
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:24:06 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:05 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:04 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:24:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 10/15] wifi: rtw89: coex: set dbcc_en for dual-band-active MLO modes
Date: Wed, 16 Sep 2026 15:22:33 +0800
Message-ID: <20260916072238.62574-11-pkshih@realtek.com>
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

The 1+1, 2+2 and legacy DBCC link modes are inherently active on both
hardware bands, but the multi-link update path left dbcc_en untouched
for these modes, so it retained a stale value from a previous update
and the coexistence logic could act on the wrong DBCC state.

Set dbcc_en directly in that branch, matching the single-band-active
modes that already clear it explicitly.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 1fb4a7176179..7ee0bd441f7a 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -7454,6 +7454,8 @@ static void _update_wl_mlo_info(struct rtw89_dev *rtwdev, u8 hw_band)
 			wl_rinfo->pta_req_band = RTW89_MAC_0;
 			wl_rinfo->dbcc_2g_phy = RTW89_PHY_0;
 		}
+
+		wl_rinfo->dbcc_en = 1; /* two HW-band both active */
 		break;
 	}
 
-- 
2.25.1

