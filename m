Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2A93E92BB
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 21:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788557043; cv=none; b=bj+mMFe0zSNTMH1MFC/l54WKntkffPIhuxbVTodCDBb8mItqaL1fE2uD5qtLymhCrlP6K+Y3IvsO17TpQjt/HFYlrM1crtP/7sH3LIcYOCv4xIvW7vKeDQJ5WpOYx5BSx9Txx8nCZs8HM1V8tuWmfooNYMpZAsbuEbNHEksa4+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788557043; c=relaxed/simple;
	bh=3e74kbxsHUlzHuDQNs2xZxFXfPJyrE7viXZKobuCuW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G8+TVhG4QWgE27jae81BNhIAJQqcX2MB0IYa1jWMbMPsax5kzZiOVc8wydc8DBJMidrevHuxY0RXVs4ub4lojYLDdmlV4/5FDEKeTHi443zW0bRWLh0qr8VowBjwh3bAIue51/CNdDYXSTxlsj5WCGQ0Z/aeiFHL1GD6q28yyo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NUhLSYYs; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUhLSYYs"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-862815e2683so633024b3a.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 14:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788557040; x=1789161840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y8w5On1qTNLM11WhcuegpCfcpBER+s9xNoM1vyHsy4c=;
        b=NUhLSYYsydimH9ceNJlM/66kmNa7CwwBgEpKjLgyMAr15UNCtE+6zrf7Do34hiKZZl
         12iInjxsQE/q6VyzfRVnzXkzNyK72ekmIobHA0wtBOiyOsJo1EweW+d3lL5AO6Fh1WR/
         yEp7KXeuRTlL6BZ84dUbqooptQuqZwNP0KD2s5YyJ6fzin8AXJwjSI6aLrViUb9xbtaQ
         Bg6jVYMRHN3dDwx/2BbUFfq0E08B0dkLfVBzKsDPaxEHj9fLPUp5Vn31EBq+ZJABHOMJ
         F0coKY5S/0BtA8TpUdgY7aSI4hitUlOzqAAr1ofVKZiqx2S5ZXelH4f9mMQ8rdxlIBKY
         j7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788557040; x=1789161840;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y8w5On1qTNLM11WhcuegpCfcpBER+s9xNoM1vyHsy4c=;
        b=X7/++cX63p0bgnUG3CtPU5JI/JxndHkZ2FuA2z2HdVnwP0M1scSKd6WkY1hLh0hITq
         SF3+fEBFmRlz19krdyh/wkA8njREmM5jVK0Is3Shw2On874o2BnpMNo4tXujcrff7iQx
         7JIdUnT5lwJOGvYd/WZIAC5W6d1Y4HMNwn64nwwyUtG8BSsg0+EInJwBlAFr4meKLAIh
         jPUZjrvt/f2HCvkH3C7WllkzK21X+sqXFIeDi9iIuDN59EXXwbgW1D5vH92sYCB0OSA2
         q10uwStTTTGWOugOnr5cENuL0+/Jp3DS4NoVlwGIf15jBq96V5ZMSMsAoDNm70GKUGAP
         AknA==
X-Gm-Message-State: AFuF++k/jCICqDy/7TdM4moBRaF/+gIodHLpsVDmde/5dgvqwR3gF3W/
	Yi5V79IGTNg5iJSFfAILoO4aQUzHDmIKZHaUDRXlTh3rZQlu1Ub4b3nQRyTgbQ==
X-Gm-Gg: AYBFou0k/xiN60E5iYNZ2Pe1qsw27lfSvJsiVmSo5YT5qS5HphHynFnGkhPZZeEvkMx
	qm2F85osTNZU9TMgtSim8JQHQfJXpT2MvzmneCUClRlAbcR451Bcm8LyJUVKLaGb+5pl0/sKr/M
	ciH7Q01r8vwFEiZEXh6awrZxpx8775Yzows+OLGP2YhgHA0vXOqKWtg8idtqPrjAhxwXIBlBFVJ
	jiAqevi2EJkFBU/nXc2IrbFciFXdpcbUqssCB7SZ24JTDmRJZUVMlsOQ7MYCpcQrlkfWt3MPO7A
	mfl6YymnmW2rEd8dqkg8enN2x+WnHFsy/K1NwEqXnAZHegrdXO0i+gEwwMs/CwFB4ifiIzUazo+
	7Q+MlRvNcjKgW4BwsUKzHn383zurW5/HiAyv/JC1e5++epoF6duXAafMu4RujpRFH74StysCIhx
	6Dy+1C3R5kHkuVr20OCgyR84qEJP2AHms9SuLU3DafRiX+NJH8+MRPgvLfubnmzsw4QE32OV7Uw
	waU718PEmolxSY9G4qLQKvHqVPrU+seYYUPuzGAYeElG/jWs9ao6U99Aq3nhkWSCVGxLwvrOCki
	5jom8yJN+Oq8sXyg6pQUKLmwfIciWPIWlR+RQA==
X-Received: by 2002:a05:6a00:b94:b0:84e:2382:f4f0 with SMTP id d2e1a72fcca58-861660e2f8amr11904703b3a.4.1788557039953;
        Fri, 04 Sep 2026 14:23:59 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86207a4d602sm989020b3a.22.2026.09.04.14.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 14:23:59 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH ath-next] wifi: ath9k: free clone buffer on fi->bf overwrite in ath_tx_setup_buffer
Date: Fri,  4 Sep 2026 14:23:57 -0700
Message-ID: <20260904212357.85611-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath_clone_txbuf allocates an ath_buf for the last stale subframe of an
A-MPDU and stores it in fi->bf. On retransmission, ath_tx_setup_buffer
overwrites fi->bf with the newly allocated buffer without freeing the
clone, leaking one ath_buf per aggregate retry that enters the clone
path.

Clear the clone's references and return it to the free pool before
overwriting fi->bf.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 89930eaf1fd3..b12eb878d5e7 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2264,6 +2264,11 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 		return NULL;
 	}
 
+	if (fi->bf) {
+		fi->bf->bf_mpdu = NULL;
+		fi->bf->bf_buf_addr = 0;
+		ath_tx_return_buffer(sc, fi->bf);
+	}
 	fi->bf = bf;
 
 	return bf;
-- 
2.55.0

