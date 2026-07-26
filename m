Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6EF36894B
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785073246; cv=none; b=UVsw7CxP4dqvgf9fFjnrWyrqDJQ/N7LhJtyrwId8tFC9gk/B9vD1O/IQTX+LktTVEYmg5AGIC8qT2o78012JYloICdLjnQB/1DjH2paq1aGm0UvmoP6Yfy3kk7X0vqT9+TBaTiIyXcrAsjqh64NLaD4B5Gd9HCLrUjs/ZRlIdXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785073246; c=relaxed/simple;
	bh=XUlAB99EUPHGjfNDCkjkwUX6kHPjQ6HNWiYkPAgR9jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoF94JPeJsA+7ZK2s/yIupxa63zL6Y5C8y3AhSLK3NMwF36R5IQxrRIb98TzMH/gi9BYZt4Ca11lsyxgMGHMJgIKjSVQ8uyXQGSc2X1lB79QuOszH08aSXVj7UA3mdGxurYKsb6Z5lgmEvB72Nme6ZrlWl1OU+Ey7kQ1ulAL3Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoN6EhdZ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoN6EhdZ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8485b358552so1963251b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 06:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785073244; x=1785678044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4dRKslA0KH8ziQVxUICHViYTgpblUQ8JSWEDZ5wzIhI=;
        b=FoN6EhdZulSBoVVjQwOiRM2QpdTEBmtuL9hyWOYsYClOzmcF53KCZ0wvn+U8sWtqml
         uzluK5qPXI+P92zyy2do1uK0wxYYcRPENr3bj2Zcl/yzU/kPoOumzuPiO9tgW+/fg+aJ
         SWEm7aRVhslh6c29epMCi9U3m5UYh0UnwwT9oe014EAu7Vy8GkgkIgS2kJf1z9fbhi95
         JtCNdtHHwKvG7zMTTTil+ZgLvW5fq6V/ND5Ovaa0OXREMJwxd/0Hem++saLcuAeIAlPE
         qGDg6Ru8hFEN/Lis1saWMgZcIyZtVO4X/p+6P+OCY7k619IdCIb0k2Pol2wGhV6yjoJt
         QCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785073244; x=1785678044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4dRKslA0KH8ziQVxUICHViYTgpblUQ8JSWEDZ5wzIhI=;
        b=FpvC7xYdwuXE9Oi1RN8nAs/NwFXsoPeLpwjXSnepPngvndt2BXG11Vt8zyjYwXpCZZ
         aAq/9+0fCFJMnlnOoC5mA+3KKSsJ9Bb49CYBoJbvjD6wefpmcZGCVlBolLEXImSo+7zi
         bXaaZ92tq38xhKRKGzs2bY9X/t/4zdzQ4vj0mE2OHaNhxAtj2UO/dSgNd2mFa+K7WDFi
         jx+UJO2L/ydbp7JDUUbYzQPH39M3LIEbB9dA5eqp7rYk7LYOwx1gOEHkbraUyjtib1rR
         1CUezflzKBHlTO7sx9KwsmI+kVHC/6IZv3zYBh6iFuEXYHOPnNjid2H3Wm5kn8FtA+mg
         lCaA==
X-Forwarded-Encrypted: i=1; AHgh+RrhNAD/ZQVpn0JPTQREPlS+x0VZZ9AqQSBq05NKj9POc9dzNxY9L64bN8Ln8E7gxTGen1ug5kDS0pBEUngYhQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPto2N222mMnoKGlV+lWsQVSx0snjVcIux2hYUEFsjOuRIaq+r
	ndqKjP92DsqQN/sELPoikrh8pSs+IfcIVDmOK+MFqbjLeGlJKwZ5lU8b
X-Gm-Gg: AR+sD12m6b6Vi+lcy+5I6d4zLwV4aT+18Ws3rdIHUgNS9DlE1HRQo5kjGKY/3jIkBOx
	9qVyiNTBR6gPikuiTxZttYtPNur3ToV684gLEWbFnvgGN0qfrzhJUj2KLe9lLstuFeFSYxv30G+
	NkEn9EhtV/keq0ncTKg7bPNqCPYhw1bBBp/1rbAkTi3A1mJmM2tmC3rrmAubyJZbRFoMCOdYqjN
	tCqI4/2nAXhwxbzPT1Md+qT+xYI3FJHxx+2sE2/El5nVd7FHLutKIgxXCaUJCaoxBTIrR25BpaS
	noJn+lX7PwHqDgXpsYqyCpYDvVQbYoUtJfN+kFsCdLZqzakmZzurj5vkqfmMXzHNJXKaxtFT7uw
	9i4AZUks2QwZ3VP/gHayT7DPz+OuRuNjApntxuBYX/sPWLJO/GoeoEiRUorIFFW0lYXkI/zmH
X-Received: by 2002:a05:6a00:2288:b0:848:2f84:733 with SMTP id d2e1a72fcca58-84e5959cb20mr3933797b3a.70.1785073244483;
        Sun, 26 Jul 2026 06:40:44 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53254f57sm1873798b3a.1.2026.07.26.06.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 06:40:43 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH rtw-next v2 2/2] wifi: rtw89: remove conditional return with no effect
Date: Sun, 26 Jul 2026 22:40:31 +0900
Message-ID: <20260726134034.1385834-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260726134034.1385834-1-ekffu200098@gmail.com>
References: <20260726134034.1385834-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/mac.c    | 6 +-----
 drivers/net/wireless/realtek/rtw89/mac_be.c | 6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index db9fca828829..2cbff2be9bbb 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1710,11 +1710,7 @@ static int sys_init_ax(struct rtw89_dev *rtwdev)
 	if (ret)
 		return ret;
 
-	ret = chip_func_en_ax(rtwdev);
-	if (ret)
-		return ret;
-
-	return ret;
+	return chip_func_en_ax(rtwdev);
 }
 
 const struct rtw89_mac_size_set rtw89_mac_size = {
diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index 8de0fe5a3b1d..dfa0973e367c 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -929,11 +929,7 @@ static int sys_init_be(struct rtw89_dev *rtwdev)
 	if (ret)
 		return ret;
 
-	ret = chip_func_en_be(rtwdev);
-	if (ret)
-		return ret;
-
-	return ret;
+	return chip_func_en_be(rtwdev);
 }
 
 static int mac_func_en_be(struct rtw89_dev *rtwdev)
-- 
2.43.0

