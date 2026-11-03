Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675709;
	b=WL6DnM5OeAQ+0X4vCaB+G3wmBvkMWKJLGXnDDPw2rceGE7PJbdE2JIG8dCBsTE/p9gA0
	 ypHwZF9M1vFiCWUtUl6oJZu90f2XYa8fXrZ1XDrDk7C1280zi6UfEFMg8R3g/OKxiXZUg
	 8lB/0TyIsWRpgH9zMZnWmdYaFMp6wx1d64pX+4EbNeoVViqo2r6dCLsgSBf/kdZPPhjCT
	 upoL9e+laHyLum0pdsaRywZOgJT4t6uZ7pUt0mXPOcY6Sv9y8etLPysK5IWYfL7UZFfVa
	 hjO8uswQVya+recJh7ww6vZpK1+rcIzAypMTq5orVwW0m+/Qk0K+T0VZ7vA3EfazS3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675709;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YID1zHCHc/8I8+GdqG48jDJC2CXLkkHNB0CIfz+FMCI=;
	b=1W12m+R8lsa68M3FHOJVfZh6eyMOEkF77MCpX/wtoioGNc6vq3AszkCM1H+Bped4mbSk
	 +Bk7oag+ZqI2DKC5w4TF4CUYsUIXwD9RPva3hOVNp1hbkCfkXe04ZsdfePHet3A1W4e6m
	 DLp8pGFJcf0cazeu4o54seMsAFgcLqW/Rz9xgVta7nhH4WGXHw6i355fkx2m8nXJ9xk5U
	 nbedS2I0OlRBZ4l6c+VETY+UhrZObcaJ587xVEXgQcAhobaI2JilLpIOLO02B8WJqK04E
	 Z90HPfAx3P/RRAFzQpkWXbQHdnduo0aHT8jOC6MejamFb/7v/iRM9Y+nM/tSZ2aFrgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cUsSctaH;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DA5606A334
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 03:15:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04DA5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cUsSctaH
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-36a1947498bso3259644eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 19:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793675708; x=1794280508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YID1zHCHc/8I8+GdqG48jDJC2CXLkkHNB0CIfz+FMCI=;
        b=cUsSctaHMaPOlmnJzTscQ91XD7BGniQTf5aFSlwUhQY5B2Qf7bod9SniOfcOEKnVD3
         U7S/71NupBtTxfuqk4EASTFL3/2imlWTD58Y2cPp6Bp8INfSEsKaxTmxwSv7ZFUbOnBY
         019svzDWED0N1MmrYzyIErXHCQHKhuCkIEHzRrqwHZsimDiWVQSZOtZuPf36DR3vT9Bb
         d+ii2+6Mf6JRR2+huU55aZ1b2z/u0Hx7BfmF6IBfnJZ875b+dcZKpkOpMtRanP8kHF5n
         GIgmNmtMSFqTH2K+zjqP/P6reRxT1dslO1CL7mmTZganihDEBZfgfls3x4tTqXafze6V
         gz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793675708; x=1794280508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YID1zHCHc/8I8+GdqG48jDJC2CXLkkHNB0CIfz+FMCI=;
        b=YWLp25XGHuavxVFjZkOEmuD9QakyK3KzJy1VaOR06mA/O7OQeeOAFYmUZOy5VSq/KH
         9/py/1S3CaSWocofxS2Gyb0LaBsOiBXMLD/zwS26w5rWo+uoFnTeyAhxRNcULDHpFmCG
         aueamWzb0VoPVzLqC1+TTTUvpMCWh3prBXl6rlRDgY8MbY8DdI5mETHYPE2MF9kJbiBJ
         b+DG/0h5PktPRPr1rJE9YL4IddoEyNICAr1g8zsFiUJnc1o/kZSHcsZuyGtdyU0BUs7Q
         Yoin2G36t9DDFtv2HrETb9718WJr6I23l2/BalmpA3qIULQitZ8oQVho0NE7zhIIgMcy
         WVng==
X-Gm-Message-State: APuU4Z/10Bxrd/XlMI0v6S9QqXzAQKhdR3zi3gpoMglhriCjv+8atFIv
	44Xqf0YEnaP1BnSfhUOSENKiJez+Jh+iOaE6g4hoofZQSME6DZ6KgFEy
X-Gm-Gg: AYBFou1JDDBMETolGnhwGdEYH0gBxBnw+ls/28KYUCNMmGGFj+5HouBGMRlZ2s4PwxT
	AFSyxm0aAb3YjkMjHtwfE+RSCAl7ba8UkrDruj6cdyE2SK7zkMaV83RN2v2hrg+I3PSCcaDEtxO
	zBUiUrvcqu/9xxNm4rRPlkV8HuwOTKwhTrf663V1KI1M/V0zTCfY+xNexzTUjQqOEvg/Xs+Ig5O
	tKwXpXdAqYhOY7Lju6A7zPQ5hJvaq+neaY5lRtJpzfvqZFgPVMKztqaL2gBVChhe62wq21YU/wt
	cYbUW8Oh+qHSJK46+P6Wy0KQv1y5KfIPd9TzbEBooSdFR/L4VOFbVWfOzLdCAZ4fwrnb3tSYNDW
	G8XxDLlCZYDoz9epM7tGCM4SPe+csvb01S4kRVdpiscPKyt6YFwWWWmMuIcNSi3ciBfsMuVcnwt
	wiNHG3sU0K8SxU2WjznNQJdhgQU0r++xEcOuBA6vIl8PVFHTPMOhCmHnpFN+rDJ5hCTKDx/oZNa
	v1JRKB1GFZl/ZoGtwS74AMrNuVeRO3zMF8ZQLSSemLfZs3XTdvVjrbLFsDTds5XIIzowzelwDIP
	LavJG3bp9pUM5K0v84KHJJvZL3JbD6T6CuVh
X-Received: by 2002:a05:693c:6092:b0:369:f3b8:2c54 with SMTP id 5a478bee46e88-36a423f0f70mr19413284eec.30.1793675707809;
        Mon, 02 Nov 2026 19:15:07 -0800 (PST)
Received: from xploitoverload ([2406:b400:f11:1bac:4040:640b:8a1:8629])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428c17bdsm41090051eec.6.2026.11.02.19.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 19:15:07 -0800 (PST)
From: Kalpesh Solanki <skalpesh942@gmail.com>
To: pkshih@realtek.com,
	kvalo@kernel.org
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kalpesh Solanki <skalpesh942@gmail.com>
Subject: [PATCH v2 2/2] wifi: rtw88: ps: Trigger firmware recovery when failing to leave LPS state
Date: Tue,  3 Nov 2026 08:44:34 +0530
Message-ID: <20261103031434.14449-2-skalpesh942@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103031434.14449-1-skalpesh942@gmail.com>
References: <20261103031434.14449-1-skalpesh942@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When rtw_fw_leave_lps_check() fails, the firmware has locked up or
failed to exit its low power state. Currently, the driver only logs
'firmware failed to leave lps state' and clears REG_TCR, leaving the
hardware in an unresponsive state where subsequent H2C commands fail
and TX traffic hangs indefinitely.

Call rtw_fw_recovery() when rtw_fw_leave_lps_check() fails so the driver
can automatically reset the hardware and re-sync without requiring manual
user intervention.

Signed-off-by: Kalpesh Solanki <skalpesh942@gmail.com>
---
v2:
 - Rebase onto rtw-next.

 drivers/net/wireless/realtek/rtw88/ps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
index add5a20b843..8dba60f3464 100644
--- a/drivers/net/wireless/realtek/rtw88/ps.c
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -166,6 +166,7 @@ static void rtw_fw_leave_lps_check(struct rtw_dev *rtwdev)
 		rtw_write32_clr(rtwdev, REG_TCR, BIT_PWRMGT_HWDATA_EN);
 		rtw_warn(rtwdev, "firmware failed to leave lps state\n");
 		rtw_fw_dump_dbg_info(rtwdev);
+		rtw_fw_recovery(rtwdev);
 	}
 }
 
-- 
2.53.0

