Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405D5341ABB
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786903742; cv=none; b=jbsctEpl4CR9RsgR7W5s9E1jWdleetsO0c6mCWrw36rQevernhoJXqI47w+pMUh6jvNCz4c8ex0So2BguAP2h8U6ImCrPqiAZBWwkPbxIZBTIzFhl/UEtWnMaey+kYlteIuAtEhQlQtybX8rNQskGwWtJ9l2mE97sAks6TBBRNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786903742; c=relaxed/simple;
	bh=2zDKyRHyPhf2oWHRp/v5V7KNotfVnYHRtnbVYp4Q9mM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G3Ne7SiNbAZiB86oE8xgbKxqOzL/MHVuhsccc0cd1D8UQbfRwzt+IMwO5AuFhp5pOELXk9q1W9jjDSCGXbvqEb7YDFTOsVQqGI/dqzoKlcKLFxjSLygHcm5st+nuLKx01u1JX414NA9QAz/YyqeKGWEsD4Z4SAbzsgyrAK0A9tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XA1dWl5v; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XA1dWl5v"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so3750761a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 11:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786903740; x=1787508540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3TtdL/NkN+keGAqKB6jyYtSlIZFOb4dN0M54o1F+xnc=;
        b=XA1dWl5vrbKBFfwa4QiLojWKDvudSh1v3PvBD/K3dC5Blxn2IvazG6auKG8fyor37B
         5GoIH0zQuGBzj9bzllWOj7+9LCMEHNkJDGaVfVw6KB4V7RRekpXMzdJzz2b5kII19Gt4
         M2jC6FEM3Mc7XkkOx6iFONCY1yLhAFaknVJPhAhtRC3izGDORTtPbGAGVEkX6+roM/t+
         h0h6HwOstsiOOcwhhMgXqC4S7PQn6RxHnfJnzEkjie+/2igAajEFCBzma9WnkryEOb02
         3E+8s4VlecqgH95U7o4Us+AP4jR1ed6pAhcsNvmTAX4/M/Bc4AE6aN5EcID1gLH0amt4
         5ijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786903740; x=1787508540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3TtdL/NkN+keGAqKB6jyYtSlIZFOb4dN0M54o1F+xnc=;
        b=JOSuRViR63sCd8sUoII0hsB6oZ5JF8geH9jPOlBjiw1EfZTgi1F+bq2GcrRewSjlZI
         OUPm8S9hqsHuUjl+UpKXv07pJmIRIVypWaIE82Ub/ZCMwGHja6WSGN6M5EdI6+MMyict
         jR653SUq5Lkpec2g0qU47OmppwBmSDJu3wT0LQH2Uifw720h9rp1t8gRYqAtD566u+Ef
         faKwTQ+ZdR8+nv911dktdEyhG1r/nKDhGxdld7Uf+VUy3UgVOuZlRyVfgnU2eUAs7RJl
         IbeQwOj/3UK9+3KlgJNnHw0gSx+KVn+7JQAv/cQ7ksv+ptnxsvmo5At/tzDp9Zw0ENsX
         NbDA==
X-Forwarded-Encrypted: i=1; AHgh+Rre0nZJ8/9s6qiZ2mf71QdU01aAZvQAskPKvo/ni5iJJgehBjNea3baAL7Lg0xkTAWhNZCrYeflDEwJ26MM3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoAMxawc1wxuMV+cUW19S3S4B6GiBhXnX26670Vks99aY96jmK
	YlwFq4vMmzNp5LQvVbeMlQ2+PKJem4oxoa1qzovWztXROm2WL5lTt+Qs
X-Gm-Gg: AR+sD10W+Kv1qsiyi2oJFmUExZ9xpmGoi6ewYPFNCcbOJoDrTl48fnhNeLtMWNZEkYo
	ltN2kWbEPS9XQo4nc6r04GC6vkVzGLlEwEIfoknugj6h63DaSjSSjRjtQruOIuxOV6zGOC1xEvA
	38ltvx5bdeySe3Q/smp9V61WlBzodR8IuX/1QXpI2t17qZ2TTuilvjE4tdyxNKH95BieuXtaeIy
	8cRK/PuQMYcYd6mnG/ugrbZTkI2d3fj/9gN9dcMpOiX8GUbYdIGk3KhD+Rr5u+71Ehm+2DJuu6W
	roMNokNVSHykgs7Ouyq61dOX2sqfZNHv5rgSdfXARzSb/1Y0CdUBKxIwJbYvHqOiN6dgzq+CmGg
	mV6Pb2pBtNqAK+wJ+57XFanhb4grhevWQWC68Qkl8w70hnwyzD5FvFSTpUQohPm4Q+3/f+l7lbq
	eo4HEKdRvFGCO6LkzqqYQGgpbbH7g3LTBiD+OFrQSEeejemMoiTWYCl6/h8N8X
X-Received: by 2002:a17:90b:4b90:b0:37f:e177:f58 with SMTP id 98e67ed59e1d1-3933b874ba2mr19766676a91.9.1786903740556;
        Sun, 16 Aug 2026 11:09:00 -0700 (PDT)
Received: from tradnomic.. ([2601:646:8300:7570:9ea5:8cd4:8836:4621])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141387ac9b1sm36444686c88.2.2026.08.16.11.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 11:09:00 -0700 (PDT)
From: rafad900 <rafad900@gmail.com>
To: Jes.Sorensen@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: rafad900 <rafad900@gmail.com>
Subject: [PATCH] wifi: rtl8xxxu: Adjust logging pattern
Date: Sun, 16 Aug 2026 11:08:57 -0700
Message-ID: <20260816180857.4122090-1-rafad900@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To ensure consistent patterns, the device struct was
defined and used when dev_warn() is called within
rtl8188eu_rx_iqk_path_a().
This follows the logging pattern used by all the
other functions defined in the file.

Signed-off-by: rafad900 <rafad900@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/8188e.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
index fea5aec9ced9..4a64633b2da3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
@@ -643,6 +643,7 @@ static int rtl8188eu_iqk_path_a(struct rtl8xxxu_priv *priv)
 
 static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
 	int result = 0;
 
@@ -740,7 +741,7 @@ static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 	    ((reg_eac & 0x03ff0000) != 0x00360000))
 		result |= 0x02;
 	else
-		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
+		dev_warn(dev, "%s: Path A RX IQK failed!\n",
 			 __func__);
 
 out:
-- 
2.43.0

