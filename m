Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD40474258
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786120671; cv=none; b=qtGJk/MnTsvuV6iYvsBe0ZqxXbBceIwSfM6gxiRsxo+ftasSDIhRKGjga9V+RTPrIWaXpODlTvcIVRMP83EpEja4rOfQbmOg/T6/lxBILgNQpTsEjwMAP6ZEhNyKzn0+ZwllscthZy3/7r/NyAxnYKz5b8kEbRi4+g5xThcohAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786120671; c=relaxed/simple;
	bh=W2vPaAvbBFaEnI5PS+wWp9fGPFM0lRF90ZCyeiQzTGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HgKfTEl63qDpRhksAi26AOnnFF/ep83WKnU9SfYpD0CPxdUEk/NinAb7V3z7ZERJiLp1T+rTdC/lOwPeJe38T6APi75GIO28w5BRzVbhsDA9BeX6OveclA4mlgdJA5ZFc1COtJivGJJgX5SLXfyz5B9GfieS3/89KHJ4fYw2CEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DHt8Ax+q; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DHt8Ax+q"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-4960a66d36dso878358b6e.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 09:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786120668; x=1786725468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RYnU/CjNnSldiurArBMef+rqNUycTmCsidAIhbgMp9k=;
        b=DHt8Ax+qYqOHOoWvUdhpnMRIVBkxqKnIdxQ7tdmDFFySm92vEYggSVFloJb/tidux3
         ihfnuTzADaYMF8ARHfD7yLJQc/zGABeW9XSe3wqDRjJYcNWtxc0sg2YOl/NIeQXQX//j
         xpL5dtDkGx30iuT1TqxEBqSBC7BmTHNaUssGxVHSGdgEArDQmwxPWSXvwkFI1iXwkExX
         46imgyIpN6Ydo4Qcl5JGxO1kYfg4wqkU5tivfMIvvaUj1/R9lgBKiv6Acc/sfwY0v1Dz
         FxJQV3pioqK1KMH1eQaV1WaNp6oDUD55dxqSYz5njHMeZfzpr7JsdjxwH4owbGWpiT4w
         Jdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786120668; x=1786725468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RYnU/CjNnSldiurArBMef+rqNUycTmCsidAIhbgMp9k=;
        b=OcpM1y7X5ZogP+Y5Kglm+s02miLVWLFHRYADKe3enixTcgtLyLii5HdjWPLK2nZ1Jz
         VDM+W6xlyUr6BQIzzx1NayRzrVgdwguVO1wR1XMNmTPkSi8FSfIhoHegllId2xcZ4ML6
         kKBqAUFYxYW9GZIO2PH5SBkxXJsV7OHNNZfo6yV23R5pVtOCQd+YZngjnkJhFwoa1jrk
         ylPUndfIgar3a7HC3pEbDazYk2wArB2OjtOuEbrA6L2QETT4zZpAWH4uve+Qv0sp89bb
         mOA1wfOqPPq9vleBGN6nh+HtctVidNi196/EsDYPS9/tjTxVQZU8uN3B02ArxPW2YgFO
         q3lQ==
X-Gm-Message-State: AOJu0YyGXoaOMzyOAvaJlww3i8XaJNo/B8L4pngVO7/1WaI06CSZ+grN
	Sn77L6RcfYPd7pRHJcMXucs0dx40RqtmzO8MC+4MQ254ZLZYL5L/Y1/X
X-Gm-Gg: AR+sD10hQJqV3n3P5T0/FFt/cdnrmvXxP16vJCm8zFZHNNMOw/uPoqwB+3iQjRDtp2l
	pwzFRWa9W3zhF7br8NOIg6YVsqgdK9oNsvn2M8lQHZiXkEmk3+bQhZ9gKkDic8WhVov2E0dzfdf
	pJewB/yoCqOt6GVy+a3EWYKQxvMt4TS1sQsaVYhl1xJ7ACjSL1xwwqPEDkqb/6+8WKnFUKNCzAD
	NI//1wd4YVEX1mQwFclnHnjs6FlBazmMgf1YF/JPtInin4KqRSTSqS5pE87Jjfub2JcX+BHWZhy
	SxpQqFsugDRUFTorqoiq643LgbkFOuBnCis8Vouedy9/vjdFoxfwvtNKJP5jL2EJ/X8vojk1sO4
	twFOeU8HO4pkXKjZeViHGqeQalS9/jVwNjVvHN33Q+iSyAs1rnd6DZExJ1wBaUfqrAdEWYSR2LW
	0WaYyWEM5wssJ7QACKlrLtqC2eTDXFJJAvcn+02o1epw13tW2a2APRlh74FqcUNCGs3KbQGCyAH
	yUqBCtZs6xwTldcmbTjYQUaS+gJ9y4gnjPk2Gl2e9sAODZ7tzEAoMFLRrIy3no=
X-Received: by 2002:a05:6808:13c2:b0:495:d9fc:238a with SMTP id 5614622812f47-4afae30e48cmr8312577b6e.3.1786120667910;
        Fri, 07 Aug 2026 09:37:47 -0700 (PDT)
Received: from antares ([149.88.25.215])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4afae769393sm7731773b6e.16.2026.08.07.09.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:37:47 -0700 (PDT)
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v6] wifi: brcmfmac: cyw: pass PMKID to firmware if present
Date: Fri,  7 Aug 2026 11:34:18 -0500
Message-ID: <20260807163418.487508-1-bogdan.nicolae@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zero out auth_status on initialization. Otherwise, garbage will
leak from the stack to the firmware (when ssid is less than 32 bytes
and/or when params->pmkid is set). Then, pass the params->pmkid to the
firmware (without it, the firmware caches a garbage PMKID on successful
authentication and denies a subsequent association request that includes
the PMKID).

Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")
Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
v6: Fixed diff line number
v5: Fixed line length > 80 chars
v4: Fixed indentation
v3: Added Fixes, Cc: stable, and Acked-by tags
v2: Split into a separate patch

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 873754be5..2c59b5e57 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -200,7 +200,7 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct brcmf_if *ifp;
 	struct brcmf_pub *drvr;
-	struct brcmf_auth_req_status_le auth_status;
+	struct brcmf_auth_req_status_le auth_status = {};
 	int ret = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -208,6 +208,9 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 	ifp = netdev_priv(dev);
 	drvr = ifp->drvr;
 	if (params->status == WLAN_STATUS_SUCCESS) {
+		if (params->pmkid)
+			memcpy(auth_status.pmkid, params->pmkid,
+			       WLAN_PMKID_LEN);
 		auth_status.flags = cpu_to_le16(BRCMF_EXTAUTH_SUCCESS);
 	} else {
 		bphy_err(drvr, "External authentication failed: status=%d\n",
--
2.55.0
