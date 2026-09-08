Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CF83A75A7
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 07:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788853951; cv=none; b=JrGGXxZN6mi28FNmCAj4l8afPmTugydn6MrpVuyybFNLikCn2XrGDG9GBYfI4nBpf+ENOlJKdzlMXVcyHStNQ0TKPEvZNHKpHlRk9CXbcFEvNp7Pe4L6YAZH1+bO0dleC3x10PeD0WI0MAOJDwdUJ3K1QXBFFSUhBh8qvHORCDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788853951; c=relaxed/simple;
	bh=wGlFJb4g/X7H2EXvZz46M1rJ0kQ9woq9/W/Vy6WBvVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IbhMSthJ3M73vsGIDauAwfHwW3vxrbdaqPNOlqTg90SZvtl68RWcAG+Yjdk3KARoh58QYX5G5JlQMnJ11Ro/+tzxHjS1pBGclgkJVoB3lRGg+GJpcqVNRAAElURTDCNc1FUVjDAU3slkrsdu1sFcCMyGFT3asTn7AiVA6t3ptVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OCfde/wu; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCfde/wu"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc439aa0078so3503831a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 00:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788853949; x=1789458749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=quKfDvljNzEciB/HVPReMXhtrssQeCaSkFVE5hyLOpY=;
        b=OCfde/wukedCk3MkGO2kirzxihaZ/B+j0ATKK4GwgOz9DSWtgH2vJfBSWJoUi8DWu9
         Cs18eb/zxzTYPZk+aICDkifQCB7dqErWCxul7YlAtVJHIumrbhmziRwOmYzQxG5R8mrz
         xNXX6opcla2pMLvks2an5f5aXeyfXXDy1UsxqQktThH4TEWvcuASRWkaqqdeiUiL+L/Z
         Po0YYwXFJ0U5Oz63ClJcDF2tgrcPfUEYm9VKimfPJoAgI3sBHfs7cyj4cgaATIuY70WZ
         edugnO73sNuPyvVjjAoof2up8Uf/ze8lY6YBU+MEDvAh/Fcu8LGa9DISRY+xF8fyrChn
         oRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788853949; x=1789458749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=quKfDvljNzEciB/HVPReMXhtrssQeCaSkFVE5hyLOpY=;
        b=WYb0/lToFRAPLe5K63A0u3bmZol4OJe5FBBJMlN9mT9469vgXls/DSzFJcHsBMb71A
         BpkMTLYMR56V/hRJZZ2PE6xqG1/GE/+7cwh+J1KHQ+BBdyIDXyBAoEiZf4xSH22gUNWb
         pSEqKEfk4r0rK+/gRefFQ7tI/yPPOBAGkojggwRu5omSxKA0WezwAbBRjVS7dlPj4avT
         GOWMdltrJZERoJhviKSRGFFf5DjThIHDKIDV4ZbZ6xcw9B7ur/ItlHWj2eQ6Wlt4dIEO
         EpdIF/6XJS4oe3Rz+Ue7rhfRAF82feUT6PRRxvONsfFvgsFPaAwb5q13cU8uv68zS2HL
         KNNA==
X-Gm-Message-State: AFuF++nivA/NMmfJqoS9fHhmNj+82NTUq5wK7etf/81wCv3xLFdCaYvD
	h1COO+9JFkoh2PeBClnSW4+Wpda5jKDLxGr40SpBZWSxZ7ItkWLu9y9v
X-Gm-Gg: AYBFou2hvjKaZ9/qWEZjrYGkLYpK5ogBuMmibzf01UnWuzTyzREusJs/Jiz2lAocEAX
	5WKCDtgPLL4wUBp8YB99EKsfsV+nNOQdOtb5JsbYKsWnjIK6FjjFk2CSbnxI5FJtl9IHvvjbwmB
	+LI0vIHTubY4aMcSPRezMdKaWcwGIoyTSlpDniHV6r9rGgtCtNgExN63pzXZ7OudUu4ivp9VxVH
	Jghj2alEy+hCBZgT1L+kcUNRS1Y3JxpB1CFva6AZXQijkeiAd/IjQ/2MYe7BLXDkrwkqK7ensWA
	M9PG7z0ltEIlCOnsRUJH2brIirUwg1rahGeWiDWWUzJgCUmjMidyhppYVSxLimvowQ0bgjIvK/y
	C8XTm/3zy6YHP52dVhWEx1dcI0D25KhdnPtPxnX2mDTPBDW5dI7ghOLalwEWKtwl18tY2gMNvdJ
	uAVepluu3wGdHIrBbk5G9s47/3MXBTEil8b0OWSBs9UTDKuytj+rUO31HoIJZ3F6H6eWH26GL4v
	+RGN9tB56vsK8fubg==
X-Received: by 2002:a17:90b:2f87:b0:38e:250b:122f with SMTP id 98e67ed59e1d1-39b261e75femr41364790a91.16.1788853949242;
        Tue, 08 Sep 2026 00:52:29 -0700 (PDT)
Received: from adminex-ThinkPad-E14-Gen-7.. ([106.51.226.221])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339885d29esm37752419eec.2.2026.09.08.00.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 00:52:28 -0700 (PDT)
From: Mahantesh <mahantesh9789@gmail.com>
To: u.kleine-koenig@baylibre.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mahantesh <mahantesh9789@gmail.com>
Subject: [PATCH] wifi: wl18xx: Fix typo in comment
Date: Tue,  8 Sep 2026 13:20:37 +0530
Message-ID: <20260908075037.15797-1-mahantesh9789@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix spelling of "parameters" in a comment.

Signed-off-by: Mahantesh <mahantesh9789@gmail.com>
---
 drivers/net/wireless/ti/wl18xx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index d087d9c72f91..efb03f26de5a 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -38,7 +38,7 @@ static char *board_type_param = NULL;
 static bool checksum_param = false;
 static int num_rx_desc_param = -1;
 
-/* phy paramters */
+/* phy parameters */
 static int dc2dc_param = -1;
 static int n_antennas_2_param = -1;
 static int n_antennas_5_param = -1;
-- 
2.43.0

