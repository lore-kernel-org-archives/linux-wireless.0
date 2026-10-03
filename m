Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685A23A4F59
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 19:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791055385; cv=none; b=kZB2QaL7Q8BwikZazDYUhFMJ7cZ6hTtooKOns2oG3A+yPDT3m+ZN8wHFnTG5Ba3S6DEbjTBJ2+E57dYRCJEYLpRmHlu1fYtBuPX/r5N+nCq4pDRqYRdgoLm4BdedWoIX+fyhcASusHdyTZqmMwIWc0C+AWyE1mp81Nj4MmfKPBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791055385; c=relaxed/simple;
	bh=XHE6A5BN8v6Dp+xVYIMHhiMfFNUVP0eMVpusbjehULs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U2ED4RnMNrik6WLh25tSHiievRUu/csjdY+R7lC+ob1acaibE1a471oS/E0UpIKlx9czldWR8woa0lL0epsQbBEaWxjxuv/nUgQulK8zD8nVOIzR+1Auytd6WVj3y80m7dBp6W8SP4SEz850V/P06Pa7BPjWVEQRUMteUytJ6e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Odq6H+qt; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Odq6H+qt"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-482f635552aso363853f8f.2
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 12:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791055382; x=1791660182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N87SDrTNrT62RbYNdy57gjkPfRU5M8XA+xJLqbWkO+w=;
        b=Odq6H+qtr0Ov9UDCNWQA0fHAbNpUBcCpeacWspyyYjR++fp9e2Bn6ql1ivTIvSANTO
         wkTcM/PrbLTHXKQZY1Kzvx9npoSwaAl81DQhVa+oXyPlRPASrcJ7pVW4NMhDKid9GNoo
         H9akM3ckJQxVcsqLlWWQIW5vKoLtaS9cmtcffQL/bUwGVTAFb7/0u4e4GyuKYrXjAYVr
         2DcSLUFqnoVwTzr4qjqt4OWaf1JZvgr2h8QVUK67zN5ZXfv8qwEwt0ctT+UDwrYYA2ad
         RVqrb2EFkNZZzqptQSqqt1RL+X7/JtasTEqK2NG45FltiTZ2qZvIbee22j9GxVxpbOYG
         zvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791055382; x=1791660182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N87SDrTNrT62RbYNdy57gjkPfRU5M8XA+xJLqbWkO+w=;
        b=x7sgI7GUVgPlvv0roo30hVUsv+9QD1wHNo5nJXn+yAsApL28BFO/YK/CSwWtlVJLA/
         Lxy/rZsSvz9EGKxOPd5peVk5rQ3ydVkE3nXKXZDHRx1Ik72Zd58zDFPLMm0pPz6GrSEg
         xWsKA/I//ymjhNBaI8XSxsHAwdM5lsaWLm1TZCRosx3TGx33WlPP9e25uFvtV35C7w9w
         EhZ8BcfjlFmii+oXBDLCNs3gnzZkhtaGoFe4Df5AW2zU3qwosKevz+XtlRPornGI8V/G
         DlgmHaiiAQF+QaAo8GFhoIfyWOOmjqBdFLV7ALWwDnr+2SJQlUj5/CSq9MqIyUEz533K
         2sng==
X-Forwarded-Encrypted: i=1; AKwUvBwNxQOa9aLTSlhnq+VPrs5C/O6mhTVtLkeM21Y5qj/k6WU3PVLDg9Fk6Y/p+eIJ3bPhmz9tbwDYPCVWCvUVnw==@vger.kernel.org
X-Gm-Message-State: AFuF++nfhxO9mcRIgsFA24aj3IP/3Sbs8xOAg3cScSxT49OEz/1pkzAY
	YLzx3Bd2/7KjV9kHyRGebFpyGRUkHmr9hlsqOHr3Qfb1facZ8rILNfwQ
X-Gm-Gg: AYBFou2g9bc/kts1qczysZ2MMmLi6EqRWkRVdbasjOcuysKssabRkUiWfNdalydD1yc
	OfyExqO+Zfwib3Y2bUwPymkIfPmsiRqxBdAPy14FIDkbCcd7wWTxkwQI5f/op4h9lAWSsMp7LXw
	tq6B+2ZaxHKyeAj+J4yDVb7wXE96qeZain54g3DGHaz8q9Fwwtw1nCjx6s6jbm51W+G4c2+QtD1
	3SKqsqjrZMJZCV8Xoe5Rf2heG3ypPZHDotZnBBgMjIgvsGwA1NfwmAw2nks0ozxNda2Fwpya2UE
	VDqjFRs0H5ke+A9G86Uxz9IhvT8XatYRFgCM7nyy5X5zW2zq23F7oFrKjlB/C+VntQhy87bsqBA
	edjyC/qj2tY+TY4D9fYU0BDUC745LxIef0NcpqsxHbhFDaAuPZP+7dvzKxWGRkS/bT1jzlg0wzt
	I1im0Q6HQRinh9a7ovcmZJ+c30MsPMXX2e07BHVhsFPsYOFMuOTWYRh+kheYYfoXqUOJtNPnKHQ
	tqDkaqfVFecciL2jSZUgkq7Htv/XNvpWF0kojQSs5ot9ztfgvg/3G0niwfkhUmej+xYDFn6akkd
	DwVSsN6g8iHhDWI6aIa+tyw2fY5urjzu1HI5cF5uEVV+F+a230k3xkdAm9dcuEqKjSv3N4Zjzkw
	avw==
X-Received: by 2002:a05:600c:4e87:b0:4a0:3a3:33e2 with SMTP id 5b1f17b1804b1-4a027567702mr115370855e9.5.1791055382292;
        Sat, 03 Oct 2026 12:23:02 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b2e2-2001-c47f-5a89-3d9a-cd2d.310.pool.telefonica.de. [2a02:3100:b2e2:2001:c47f:5a89:3d9a:cd2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0394e6c5asm150040485e9.2.2026.10.03.12.23.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 03 Oct 2026 12:23:01 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: nxpwifi: fail the firmware download on a poll timeout
Date: Sat,  3 Oct 2026 21:22:56 +0200
Message-Id: <20261003192256.78255-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_sdio_poll_card_status() returns the result of the last register
read when the requested status bits never show up. That read succeeded,
so a timeout is reported as success.

nxpwifi_prog_fw_w_helper() therefore skips its "poll status timeout"
branch on a timeout. With an emulated SDIO card that never gets ready,
the driver logs "FW download complete (0 bytes)" and gives up 30 seconds
later with "FW failed to be active in time".

Return -ETIMEDOUT when the poll runs out of tries. mwifiex, which this
function was derived from, returns an error in the same place.

Noticed while looking at a clang -Wconditional-uninitialized warning on
this return statement. Tested only in QEMU with an SDIO card model
written for this test, not on real hardware.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 drivers/net/wireless/nxp/nxpwifi/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/sdio.c b/drivers/net/wireless/nxp/nxpwifi/sdio.c
index 8ef0f6eb49e2..a0d7196c13a2 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sdio.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sdio.c
@@ -665,7 +665,7 @@ nxpwifi_sdio_poll_card_status(struct nxpwifi_adapter *adapter, u8 bits)
 
 	nxpwifi_dbg(adapter, ERROR, "poll card status failed, tries = %d\n", tries);
 
-	return ret;
+	return ret ?: -ETIMEDOUT;
 }
 
 /* Disable SDIO host interrupt and release IRQ. */

base-commit: e767a4ea70a3992c37ed604157d32f0dfbf9b1e3
-- 
2.53.0

