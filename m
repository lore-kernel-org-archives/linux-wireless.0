Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85D73ACA70
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785073244; cv=none; b=Mkknp5EJsMeTmczYgcw5mnCJy9c/iWPtOYqy9wZgPIZoDEjWpxkIM/jZCjUYXk24+K28uMLbojVVH7dsA0T+525IEukP53mwIjt2e5wZM+F7Xl5rUf0elkh4sgeeccePARfBl36U2TbcR8FkFVQV0OL4R692QhrDENMlGqWJm8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785073244; c=relaxed/simple;
	bh=7pcPrZVLzaaonILlJUItu0/WzDn+i8ookeUlXWLSvsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjdxM58lg9wpKGZXIkgK8v3TYWrrws9AdgIcKf3bfktXsBKXgIJTJj4vR526lJkUdmUIncD4YdV1yTWzyVfuoz7Pkxe0VClq+V3KbVSUZToKsiLsrmYAalyVAcAsGukiVB6S3Vpd0XYLutGft00dfOoo1Gch+IL4V7W2kj9ytDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nir4YvJ3; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nir4YvJ3"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84e682b30ecso337052b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 06:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785073242; x=1785678042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oPSzZ0K6bRbQDA9byOe6Dw1cw7TopfACKSgbYoeabtw=;
        b=Nir4YvJ34FwZeubZpMoNdKGVcU6SRSO/f1NGnCQ4Rs03yJ5ejSC0ZYd2tLl+j5GXg/
         3TaAJ3qDrt1N/9jt1KpV4VTj42yCaYd1TfnOtofXi1GmEBzx5hfyvFLbPuAfxlKra+I/
         3XxPrPpJ2pRJSFlk7hKTIy+ODQf3HU3MNeYzf3UJDQeDX5cZdN8LsoSMb8xrVjCqZ7M/
         7f5sGSRrD7njVi5T2IjoCn+LISGTnNa+QZYsUBH5fcDjAEG0l45i++CUEAQ75B1p4+Ew
         VE0ijnwCIlxqgBr6ewnEnQE13zz+XRmLU5Tqlyj6qyK9B2QpxBmR/MvaXDddq5y+JE88
         8fYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785073242; x=1785678042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oPSzZ0K6bRbQDA9byOe6Dw1cw7TopfACKSgbYoeabtw=;
        b=bM5a3uSULIEIq0UVXdB5agZNFT84DPAnBC4gs07F5j4l8OlN8lTkfFR5vSVcPvAOno
         KhID9RytWOoiAAA4Q4QWYG/lU77Mm51ZldtbgR+1Y4uRORNq5E+OFpejtaJ9A+R8FmWt
         Y9ND93Y/n08WgPw8iGLVrEalIV+oPTgPFRIyy+F/GLtBJtkssuwsm4KZ7AI9FcN2kgBt
         +vFc5UM4YHE4Or6UQ8xIDkemk5DnUPDoWfNXBwtkY9lDvpo2m9TCsj7r4k7StZPLMfz5
         IriS2uzdbExxHnsoAMQLrU424Ii/5lsrTZ5gFoieRhcwtM35N7EqErIJxYRSIxD8j7Nm
         P5Uw==
X-Forwarded-Encrypted: i=1; AHgh+RqmiGFZgGHuS1KM9Ehns3IkE0pajxrIqIYQPwK9d4xQeiZFfN0L17SFHpn81c4FbTrCbgPE4pmk84UbIPY77A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvNpfqH+aTPB9HXv1GWLg4v4IIHLzUbQ9VLDSuE6fS9JJD1X/9
	xNVqShbnza5gYKlgL48F5MV/ld1FAAna7WD9j/pImMstxzxp+lMRRZuu
X-Gm-Gg: AR+sD10Wo7YlQ5aX6DvJ0oIRM5aGF0327s9icRXpxt8yu+A55V8xB8/56OAk6KwS+Kn
	VKcg76XOeHMj/K5FGRZuX8cnBL4EM/A/6cpSV7rniH3gqWVmFrpHDcA7+VLIb+dCy111mQPpYKH
	loyujkS5pjh1kVqHxAgVawTNKEhsF/DALDOOafYkzEHXu9rEhe+Mp9kaYbvzP+3O7B0EonFFDCQ
	G2WKqE87NXaRxhqIpqGXgbEwaFf4gjuhV2lduuNdS/IKUKTgotYFtlz51RgOF0OuSBKQ7gPR4wu
	UOqt+mbORrKw0trQjBYPDhtCZgZrggI5ocIdA0OgDdzfhvH/qSKE16Jm7h0pJmuah1I3CptrGNK
	WSXEOcxhKLFHbuh0agvBLYsJom+NSCsp+w8zUMRGL8iLkKo6e1twenNLrDkeBGC6mt9BXgHN2
X-Received: by 2002:a05:6a00:852:b0:847:9919:e772 with SMTP id d2e1a72fcca58-84e595426f1mr3619240b3a.21.1785073242004;
        Sun, 26 Jul 2026 06:40:42 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53254f57sm1873798b3a.1.2026.07.26.06.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 06:40:41 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH rtw-next v2 1/2] wifi: rtlwifi: rtl8821ae: remove conditional return with no effect
Date: Sun, 26 Jul 2026 22:40:30 +0900
Message-ID: <20260726134034.1385834-2-ekffu200098@gmail.com>
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
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 9b119a51bc30..1ba53e671207 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1462,12 +1462,7 @@ static bool _rtl8821ae_init_llt_table(struct ieee80211_hw *hw, u32 boundary)
 			return status;
 	}
 
-	status = _rtl8821ae_llt_write(hw, last_entry_of_txpktbuf,
-				      txpktbuf_bndy);
-	if (!status)
-		return status;
-
-	return status;
+	return _rtl8821ae_llt_write(hw, last_entry_of_txpktbuf, txpktbuf_bndy);
 }
 
 static bool _rtl8821ae_dynamic_rqpn(struct ieee80211_hw *hw, u32 boundary,
-- 
2.43.0

