Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8A2411A1A
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 16:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785341130; cv=none; b=kKuOYWLSTJDjEA/TuyOJhWdmMrhiTaUG229MxJcW+vuAyIRzvjgAtmPfxZ4K/lSIbYEawwCSr1MAvnz5EoV/rtSJwQSvXoSBJlrqtpxpfBjYgYc6bY+0/UUsvYPQ6SyPte3inh4PmcMlO1BIqLK9/ukG3Tq9dmLJ+UfoaNxwSl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785341130; c=relaxed/simple;
	bh=Y6zf47MQu4MutNvWufbBivpJEhsQhTwf2MpB3wOLWy4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J1ajrrJBb5ikKszoQn/eQCtaBkp5iDd7o8WtQVO6ogrYIIDDheWZH2/lX0XUFt6pq+wMOfR2Omlz/Wtax9pFRmK79lmKamKEiI9pEW7WAqKPpWyOObo3I4U0d/ugswlz+upnqZ1SNJP+giUSn27g6NMk43s4kVWHy3UHMmMnpPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWKdM8vv; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWKdM8vv"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-848643382fcso1293599b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785341128; x=1785945928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Smpy96X0tEAss5JxrfwQoopQYd93Kwph1V6sND3FISE=;
        b=mWKdM8vvCPIyhG1BirGNvZd+hXxSfgOXLAk3M5ciSLBPSBALe8i+pjNC9Go8iowubz
         GzVVibBtH+fh6ti0E/cCaxGq1J+IsdsxDqfnzucJfa59mW16QYaRhfkr4YmHP4aN7RTi
         zttc9KDWjFDKMwWH8VTkOw1pCV6hpJBJNV5dEkIeAGb3OY253nIaNbVbytOnJt05QhMU
         HxYKJyc+guffRNb/2wz4g8y1OvDSsxGSVeGnwyao+delUEGjS711Kx9H2xyhBt/MgS46
         fE2cqkHpCg2ZJ0bRi/Kn4zicNyyJz3zw3i4gjIB0UAeD/jm8vWlY2aaL/Oa6M0n/9eS6
         lRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785341128; x=1785945928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Smpy96X0tEAss5JxrfwQoopQYd93Kwph1V6sND3FISE=;
        b=slL3SugZ6yuCuJ0z/A2u3HHxEFoXujTUlBEljoGXEhVAKx5QiudmgwpOGY3kmY/ric
         KRzwUML13V2rheggjB2qgfTCjClqGHw1kGhfYJHwnNMqTVATAAk6VfJZfrITKo0655Pu
         CaIFZaUQyRKQ0XlebfJf/Gv1oPeBC5AvqoPN9P9KcEXavfI7gO7PXgXXN365KQWon05U
         cOvowy+Rh1/mTFDZl36Jpt+ATV8F1BHaYO1mmSi3ths5J3OsyC5tMQeGfvOtBCzo0QZb
         mnzU3416PYg1BzChlJRSzv9iXn1MSDFZRtbqEZVSczH6eENrUN9JQrAktErmfJfWmQ/1
         dx0Q==
X-Gm-Message-State: AOJu0YxAJaXPpW9O3KAvSovWX2dZZrO0xCEJ6I4YZelmnD2y3o1G+6dn
	/XJr9RTwMO+ybbQgDmHun5YbEDjqsRI1TlUg2mKKrosNn+fjmUI+mzmfZnB4y/D2
X-Gm-Gg: AR+sD11Bo1oxleXY3eL6EWH5PV+tKJ/K1PWYdumCTzjATCobG0YtRwLpjkJTAYCqjxV
	To9GfmGSyaF5ob5GEn6+Go16pbTAAM510E4R091wsFUfBxpGlq8PTHZT2Konh4jnwtv/kFquEVX
	6umnNQC/AhdcgFPOZq+yv2H7lh3COsHiF1TDliVYcanv9nV6xpO9n4FEqNimfMGmfX64KlQL8ah
	lDGVrL7L+9qmy1z1zxGnLVFPPkf+fRajdhpG4StvOcF3GdWColxDWyJFd2GT+ElCE9ZYAh8KU3j
	XjEjVHqQIiBFQ9wK4k0xVi02lpQ2CUtgUTTZxyZdxgwQqWpMNsDP7cNkX69pmgrm1fvAAI1io5E
	B1By/yIgLgEswlp2e8suQBzSglY/1ugU5V/Sd+nCHt0nCKXuJbo9ji+B3lc7NT3jlRNX2it2/Bw
	rZ4FGVUnqu4r3W3oA+Zc7XQ+sh7zfFc4NEKCSaYwhi20tp0oAchauND68=
X-Received: by 2002:a05:6a00:1248:b0:847:df4c:40c9 with SMTP id d2e1a72fcca58-84e9331b006mr7738929b3a.46.1785341128315;
        Wed, 29 Jul 2026 09:05:28 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23120sm1697841b3a.11.2026.07.29.09.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 09:05:27 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next v3] wifi: ath6kl: return 0 explicitly in ath6kl_init_upload()
Date: Thu, 30 Jul 2026 01:04:56 +0900
Message-ID: <20260729160458.201962-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

status is always zero at the last return in ath6kl_init_upload().
Explicitly return 0 on the success path instead of returning status.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v2 [2]
- Return 0 instead of removing the check, as suggested by Jeff
- Update the subject

Changes from v1 [1]
- Split the wifi patch per driver
- Change base to ath/for-next
- Filter only ath6kl changes

[1] https://lore.kernel.org/all/20260723184538.3888637-1-ekffu200098@gmail.com/
[2] https://lore.kernel.org/all/20260726133851.1382095-1-ekffu200098@gmail.com/
---
 drivers/net/wireless/ath/ath6kl/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 782209dcb782..6481da4c1991 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1570,7 +1570,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 	if (status)
 		return status;
 
-	return status;
+	return 0;
 }
 
 int ath6kl_init_hw_params(struct ath6kl *ar)
-- 
2.43.0

