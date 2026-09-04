Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FDA36C0C8
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 08:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788511785; cv=none; b=lX5QJCnMwu4jHAovzpParj3l1aFuMBe1621oDpCg8iAkzwoe+YTE1gKoRipYO3yD6vERaC5WEImhXjxwIuQ5lXKOKMxn71pTZ4FGFFhfFPnBFnef/WaweC9uFwuqRc7kqnhlKLb5HbQ5aPZdKX7UEgBNZpqwc/cXt9VyfUX4GYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788511785; c=relaxed/simple;
	bh=Z8mPENNWcv1eq8P/28+Mi9OOdfEllu2+UZehW5EHxFU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ltNjbP0Pnlqfq72nJws2ApiQ4kypJXvZZJSAIIxTW7o8RpZZXI+Qfy+8PTf7rHLPB3yZaciCw7YmZgLgQO1E47BCjeQ9uXlRb3G903emgwHS6l/cGuy7OniQ8H47Qv/q5cA2BsnwdfFQnfd60dmAqTgfawQ2HWIh3iOkQWXWApI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n1lOqSst; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n1lOqSst"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso13483075e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 01:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788511782; x=1789116582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jfu2EemlakeU3G/i0hecUm1qkaXQeHbKJFBtMpImgJw=;
        b=n1lOqSstD3Dli/+SNwFHxQkCrAzROyLT0LInxHbSTlaMF0/lRvLfiJpIxgX+7hbYxa
         /FlJ3YmqBSEo+VxK84raVUghIeROORfFY5MZZT3NHfd1ZaJteHxBQPTHIanHnI8tviaQ
         QNLki2uYxRCTN/eCwzZBxG+e+JXQW+0GHuKcRbcuGlAhrlpGkIIKPdMlOVQD/8XS8kXZ
         sfD+675CKJwXrkdNElNqXfssQ2KCGkaxKfW45HBZPYV722n+h4hx63IV+d8aWGqjA+bO
         zmMfBOxmN64pMUVW7UtGcsj5yjA0sxlkStC9l0jhcUQphIm6JjWNmkF+DrBD51a7DY5t
         AwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788511782; x=1789116582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jfu2EemlakeU3G/i0hecUm1qkaXQeHbKJFBtMpImgJw=;
        b=VeCFiwyNOIPDneEc1ryAhT56Kr8lDETduXOCMrKk3O9i9PEyWKxzYSzuVCTy4GDCIy
         MfQDGLg7cnU1tdfG2nSiS1YnvrhxUW4LWz7BibGbioZ2SGR+9Ljj1iZ8yiIV6qzfsumG
         4HuP70VThI59LVHjeuXI4rUol5UoEgv2DCEVO6abz3FNPXkgD8TN2FzO8cJx0jpggVV+
         M0gIBzyNM8PaNPAoJdk7bFOcZDk6KC7b7r7EzBONXCX+ZSva9sMlCBbB2KJ6q6tJ6dNl
         OdFOBExhCMKg/6nfTJexpYL/PRjeoRSHBwpCSH8vZoz2Y1bFxZA+gIOFDyIPklggx3Nd
         SMqw==
X-Gm-Message-State: AFuF++lIHJXunjdXq1lNG7nAx3Cp7E1auuqCAMFXRbkI45Lnn0NHZLCB
	m8xHRJrVR3m6U3a8LxS7MB79PDc5ROO3XSIIG+ZbuUO5eEimR+6aHpk=
X-Gm-Gg: AYBFou1hNhgGwQoJ48MYJhUz+iDRV1+R96fuOZcyjJN2HHucE8vulyeG7/phYlwsnZQ
	UxygWWiJFoA/3m+WVoVeJgePfRrzSIRe/gwpNgoUkJwSTlzHNDwypMwk/6R18BHpB/k6HFB6JlF
	yj/okyXLL3xBJ1iv182+eiHAWYTXkS0cDAnZ6hXC6xVdKG2zojWhgHdbX4zL3zI+tXHMxM+rRRP
	Zoki2U7cYg+plKIkVxyTPfWMNY806O9/IhborierRjfSNEgVGZmbqPfoyoCbWFfpVpMIzsGFLZT
	9KPCYMG2/Y2XVdNcJB90K+kaaBsM0XoY28e+vO4MYYOHZEH/YpDDrM/4b0PP8AxKtr1+svxUngt
	+DDX43jzVMOxicqO1qPdgzeGShsy7BDZWYmVbaSP5CVhvLTUHNc8nGNZKKIZUiG51qHfczi3PJx
	O3Mat9XuKTN9L+v10bHfZStfWt/hRHYQ==
X-Received: by 2002:a05:600c:8b8c:b0:49c:f13e:e52 with SMTP id 5b1f17b1804b1-49cf893b58bmr31193105e9.15.1788511782473;
        Fri, 04 Sep 2026 01:49:42 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5941cb4sm83963155e9.4.2026.09.04.01.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 01:49:41 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>,
	stable@vger.kernel.org
Subject: [PATCH wireless] wifi: rtlwifi: fix OOB reads in IE parsing functions
Date: Fri,  4 Sep 2026 08:49:40 +0000
Message-ID: <20260904084940.3885379-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

rtl_find_ie() and rtl_find_221_ie() iterate over information elements
in beacon frames using a loop condition of `while (pos < end)`.  When
only one byte remains (pos == end - 1), the loop body accesses pos[1]
which reads one byte beyond the validated buffer boundary.

In rtl_find_ie(), pos[1] is read in the bounds check expression
`pos + 2 + pos[1] > end` before the result of that check can prevent
the access.

In rtl_find_221_ie(), the situation is worse: when the last byte
happens to be 0xDD (221, vendor-specific IE), the code accesses
pos[1] for the length, pos[2] for the data pointer, and passes both to
rtl_chk_vendor_ouisub() which performs memcmp() on the out-of-bounds
data.  The bounds check `pos + 2 + pos[1] > end` only appears after the
vendor IE has already been fully processed.

Fix both functions by tightening the loop condition to
`while (pos + 2 <= end)`, which ensures that at least the IE id (pos[0])
and length (pos[1]) bytes are within bounds before any access.
Additionally, in rtl_find_221_ie(), move the full IE bounds check before
the vendor-specific processing to prevent accessing IE data that extends
past the buffer.

Fixes: acd48572c396 ("rtlwifi: Change base routines for addition of rtl8192se and rtl8192de")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 9e98c01bb90e6..9671b9247b571 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2373,7 +2373,7 @@ u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie)
 
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = data + len;
-	while (pos < end) {
+	while (pos + 2 <= end) {
 		if (pos + 2 + pos[1] > end)
 			return NULL;
 
@@ -2597,17 +2597,17 @@ static bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
 
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = data + len;
-	while (pos < end) {
-		if (pos[0] == 221) {
+	while (pos + 2 <= end) {
+		if (pos + 2 + pos[1] > end)
+			return false;
+
+		if (pos[0] == 221 && pos[1] >= 3) {
 			vendor_ie.length = pos[1];
 			vendor_ie.octet = &pos[2];
 			if (rtl_chk_vendor_ouisub(hw, vendor_ie))
 				return true;
 		}
 
-		if (pos + 2 + pos[1] > end)
-			return false;
-
 		pos += 2 + pos[1];
 	}
 	return false;
-- 
2.47.3

