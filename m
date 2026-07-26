Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD0226F289
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785073242; cv=none; b=S2+XDpn9IawR5AWKdsV4QLh6kLgyO3XQlkGHoy5v04E+xdPugnTCMYKlSuT5aB3geI0sSlyx4zs4uVifbJevD0HqCDOF5qc4VTRBs9CqLwl88zN2xEyz6W5WsxWBAte84RMU6eNkRXP3g5IQUbIBKNXt1dEUZIpqIjdzzGJPyNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785073242; c=relaxed/simple;
	bh=+x9dfl5BMRUblFe94QidqxPrRoQN38AkIRlYaDG6ce0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tn1M3/KPluvBz1fUCG7TtrjC2b2JKZeeTovDP7XUl4kOsY2Yv/vgxCncvZTEvK89fNK+dvDmQLKhvKd8lEt6yViRUux1rFNuc7aji11q7cbH0eNlN4UXuzKT28kJW7yt9t+gQoGCluS3hhalbAiQvrqPOggIn2omaR8QBqoAyoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfFS5Oow; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfFS5Oow"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8484f229529so1177403b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 06:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785073240; x=1785678040; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v5y76mI0GXtTrD14n1ANgSXKYbxhTYhSR1yFltOM6hc=;
        b=GfFS5Oowt9+REQ4FZpgIvrFqoTzq3DvYGTYUVc7rS5PqV0htd/+ILC8JlZk4xiAKlU
         MqR6jBbgn+vF3ZWPOXnElIliWI1eO5gIiQU0+aBpFoPpo6jYwoouRDimwndDRD73LJWZ
         hwwRduUcFG0pV2vaneu4C6AkgtVJpFPeO+v049NU2POcWzVO/gR4W3s+vP3eUC2Be58y
         /1R0VTDNnH3IhfKxAHjCpvE7YhiEk1Eq+Uyd4KoxyGChGXDH/g+RGy26AJm/z9Oo9N2E
         6hRqKVIzAhXhJpXdZotG/PVv3NWSrt6+LH/Oy6t0ac/CNibQIQSUeCJn57dW17gJC0sH
         1nyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785073240; x=1785678040;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v5y76mI0GXtTrD14n1ANgSXKYbxhTYhSR1yFltOM6hc=;
        b=FCRXtjjRfM4cJO3ohTEBjyi5nDPur7gyzrWIraGcczqGnqLCEmaS0Z0uVA/XoC3eUi
         /UdEUlncdbAM0i1T2FH6xHwGkKbuPLr5MsRyf7Or1LaCoOLSimDQYnrMqZ57hoJtaBNc
         prUnbXZFkLLl3Af4ZnsXR+YjTNc93vrqWsOkKJmwKhmv96V2pbuCM1vXJZGOJAZJ3QCH
         tKYmHf6r12OgbgUcIm5DAHyW1/pIxYP7taToKr72XWdVf+86oCQG1F6fcn3wANsGBpO6
         2amBUsurzOrIMHBojRybV+DA3zIGOb3xCHi+1TLQywYW2Z+vft8IO+OAC/x9S6fhsgE8
         t+0w==
X-Forwarded-Encrypted: i=1; AHgh+RqBeNtM8VTpI1mYQea3rQxeLPzzSSGDqk+fhpAi+2i08yBNLcxhpkYANWK1SR4tNhgsEyEaHHDOL/9JBQCPvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfI+9FZTEbozYZzbOX8OGJdiHnM4/xkAM7GjrSMjauswDuXRdR
	P6w5zvdB0/aIQfXDem8uuykJ7YnAZ4HE/vAavf/30mKsisPO9K8C6t6gB2iGqOuc
X-Gm-Gg: AR+sD12n0UwVsENBRAk1aB4wsQU2awj1IFderoapcEcZcZBn9WxrpgUBNgiOUKU1GOw
	A6ygw9nLGhKsRJxV4yghyK/H0cgMcVIrOYCkBRwowXZ3Gao3K3SeXYJjmXF/kJDEu9oKvI5aVuH
	Q3sb1gFnDTNf+yffnbCEyBiPipW3Xs1fG2YVFe+x6p7T0B68UxQUL4EnXn54dXif5idYNnShkWE
	Lski5em/g2tzhDxyQGTnukK0HerynOTxL0LLMC/zw5PLCU+d7fI0fUVwyjPmWXEBSTXgDekIx48
	rD6eUa7k840yv2lEKnIWZ6H3jguG1xINGiYyn0+nWC5V7T9zotG/0C0o4pwqxAys1amP/Eom+iJ
	lIyRAPMmrmEkucuO9r5hwhL3lm0bMXC1+IAd+mnL9Act3QxEll1Lzm/EG2bLOnDNBn0vUMM+W
X-Received: by 2002:a05:6a00:4395:b0:848:3e03:bfdf with SMTP id d2e1a72fcca58-84e59564a42mr4184727b3a.46.1785073239826;
        Sun, 26 Jul 2026 06:40:39 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53254f57sm1873798b3a.1.2026.07.26.06.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 06:40:39 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH rtw-next v2 0/2] wifi: rtlwifi/rtw89: remove conditional returns with no effect
Date: Sun, 26 Jul 2026 22:40:29 +0900
Message-ID: <20260726134034.1385834-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

This series removes conditional returns where both branches return
the same value, so the check has no effect. As suggested by Ping-Ke,
the wifi patch of the treewide v1 series [1] is split per driver and
posted separately.

Both patches are generated by the Coccinelle script, which you can
find in v1.

---
Changes from v1 [1]
- Split the wifi patch per driver
- Change base to rtw/rtw-next
- Filter only rtlwifi and rtw89 changes

[1] https://lore.kernel.org/all/20260723184538.3888637-1-ekffu200098@gmail.com/
---

Sang-Heon Jeon (2):
  wifi: rtlwifi: rtl8821ae: remove conditional return with no effect
  wifi: rtw89: remove conditional return with no effect

 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 7 +------
 drivers/net/wireless/realtek/rtw89/mac.c            | 6 +-----
 drivers/net/wireless/realtek/rtw89/mac_be.c         | 6 +-----
 3 files changed, 3 insertions(+), 16 deletions(-)

--
2.43.0

