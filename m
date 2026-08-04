Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A31D40EBB0
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 10:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785837626; cv=none; b=IBSS9SEqjzlZz1EmuzjH2h6AGXNgZAteGs2DXe1om9YBTx7Pa+tV/1JoS/+XQUHdqsDug0zJwC4YYPrgTylDU0gG4taE6if2EEhU0JWa9HzMp0Dv5K4ei0hYWFLw61m9iqlIkyBSrMB6Px0Ggtq4LspOQGyyYyFUiRzIbHlCohY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785837626; c=relaxed/simple;
	bh=AgJcqgW8tzD2mrEE54OJEywkDJ8ikvUc9koyQr7arf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l/xX3KZx029X1meEol6A6RpsOhyufO29iuWp62Rw6uhMNubcBl+ie32ujwWZKwi15txqVxkQ3fVEi10xV//30OaANF3BXkJENDMWfsXrdn8A1woOz6OVUH1els6AP3IgrWgqeWmyT8A4ifVJ1+kpncRRi3wZ1vgZmV0EvPGLE84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FpxoHkiR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FpxoHkiR"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso19942895e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 03:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785837623; x=1786442423; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZwR6eRQbLkyxYsbYNOQVC8KMkpYtEup1Txp4q+ZaTDQ=;
        b=FpxoHkiR4wFKaa5VFbmCjw5ve2Lvbb36i/GJTrzzXyw+GbGyT3fzWzV1oLEPF/Fkcg
         RinQEAdsvS79Ba9598i+se2Aw10IlXuVUc4NdYf7vCPPAGFE6/wa2tNFGGhEaRudDWn4
         BfHml/EHhS0U/ON6WvgfWv04UWwEbjXGCG3lIcTs0HkkPJksMnPhmVwZVAdBJKGezO3R
         eIu9J3ncrkQBL0+t9IZNtdTGb9k3+4BsdI0DPCB8JgSHOxGMjZjpyjVFNSAG9AWhG3cO
         /LfQ4uHdJC8MQLnuKh9KIPJuFtLWW7k2MNHPe1DL3DfsJz+CIcnQCEoO9sSvO2jwD60F
         ORLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785837623; x=1786442423;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZwR6eRQbLkyxYsbYNOQVC8KMkpYtEup1Txp4q+ZaTDQ=;
        b=GrwL0+cMHNsDGngvDxpFXVosSMt2xnUjlCzcvU1G/bFTTATUqLT0xyxK3dyBF9ZN+G
         j5z7fpzZ04L1vvlmjC0d7UHMIlyenS5+1wDeVXMy+0dvC5G4HoEDvG2oNmTvxL1xCWDu
         jt/O2HPdzo/JmtVnrgGvyhIUOHz6NeD7+RCMpsteekvzGxr5VQhA7pixDbMepSq1FesN
         2UXSSaY0To97KrzyB2tCKsKqIgwHaxcbv27wrXdg9yg3d18dopXM+Ftf1NYjzQ17a7B2
         YdlZYJJDXLaepJWl64FKdNaW02srYtB/LDFOs3BnK6KMhIvFWwgpXUk0ZRj1Jnf7NN9V
         yFMA==
X-Forwarded-Encrypted: i=1; AHgh+RqiFeuvtjwyy3K4ZnOsqP9eV1xaUYl3HVdB4zAmsHXSc/m//fRaAagQ+HV+VYYYyQgmOxHpOAo+HeJ78VRfPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqjwir4lubv1vsKRN8F5gnwFBULyQh2hxSxxNLKJRk1e++/uar
	CkIvczj7EegbiLyRB97a9XdB6xQypu6YTvnWdrnEmSS+OKmPq25xuzTgDDLasSUh
X-Gm-Gg: AR+sD11gyaAansuumhvopJwNP+Y6UTVvCHajh7I0Ao4AgaotBQsR5oJc9gHkWXT9E1M
	UOw5Vsuezpg9dthkA4dMsourrXZdCoaiCoWPuE0bhI+oukN4SZHuZQgFB1mz/V0sJFkkKvZYd1v
	PZyN8gOms3ilx6fr1EoyEsgBZfCQN87ksozOetos3uAKuaCInxiahoAEJbj2hexvDOB7VcK9IaN
	bq1eIMNfaOkwGaAumk6edoLs8uSSvw2YHF7LuEgmti3Pehvd5LhM8l+uygqhYjVzqKwlfHgPQz4
	7A5NFoWsb5GxnBN6Ls12HsOcFfW0w/x6fHuDdRYvT2ckww7eCXmx4zTwzmIg9MuyDMpUl4zK2fh
	3azrVC4Xgf4/Jn53n/MZDAxkqdrQgSsUJeAUXtzSdaODNHZht4sqKRC3r72Xsi9edhcBBZUCejr
	5ueEInGEKApNKZdHDMcnBpWG5RYtxzkUIWqX8xN0dd6eYDWxahA9XUvEDgHrAB
X-Received: by 2002:a05:600c:1d29:b0:493:e451:a9e1 with SMTP id 5b1f17b1804b1-4980c66c867mr318775455e9.2.1785837623196;
        Tue, 04 Aug 2026 03:00:23 -0700 (PDT)
Received: from localhost ([5.83.201.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49949fef72esm87460135e9.15.2026.08.04.03.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 03:00:22 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] wifi: rtw89: coex: Fix spelling mistake "verseion" -> "version"
Date: Tue,  4 Aug 2026 10:58:32 +0100
Message-ID: <20260804095832.784121-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a rtw89_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 5a9dc4d8a00b..84ae14f993e6 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -4086,7 +4086,7 @@ static void _set_rf_trx_para(struct rtw89_dev *rtwdev)
 		ul_para_num = chip->rf_para_ulink_num_v0;
 		dl_para_num = chip->rf_para_dlink_num_v0;
 	} else {
-		rtw89_warn(rtwdev, "[BTC]%s(), No rf_para for verseion %d\n",
+		rtw89_warn(rtwdev, "[BTC]%s(), No rf_para for version %d\n",
 			   __func__, ver->fcxtrx);
 		goto next;
 	}
-- 
2.53.0

