Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793526594;
	b=ws9Y/UTje36S4PR0TEjMlWr0ksVQCIFTgdNB2g6X/7h3P297XjP1dHNL1uLoUNvbB9RK
	 HLA1rxK4YrSqqHresjXOcDvWjC/sWmbb57HczeCfE35svvmAtFq6Wjw/9OzKn56bSOWMF
	 6kh8GRBkbp0iWGMTdOFeMakECSGVWXq5ZeZj6fyM47hK6KIBJFQSo0HigJ+oy/by5REQY
	 9QFvWorhQGa60W6i73GwtRQUGFFTx/2GixFIyfoVG7ET5CfIJbZrFK0mq19ZXD3oMS6rv
	 xgLVyUL2z6wEArGbxfeaImi1mRHGD2hwfRsa/KlMXdnI3qBvPba/Mccoo4CMgPlqFlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793526594;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+Rb04uYyCDNp0kza9eq/3plAgmK27vrtoG1ucV5UIxs=;
	b=y2FN3ViK9sqMBoaxYkwBfkQhtfc5cSoMocebxGpcUIXX8RWT9KcTEn4fuyjiSu3njUDZ
	 d04TYmYsFmvUFRsIuySrener+h/J7NR4Yn4liCRC36Ib7uB83zfbHfmzANFvSRyHyEKlv
	 fToPm/coiEQB9yIXbzSZmx4Gsa5CsWjY3jAfnEpkjCG3F7EaspmKnXWPjzrqhrDMEbJG1
	 pcaupkiqxD3MpefyVj+0dIOSGOxlHSB7tILf8cECAPoyGUbQq6DmyqHWep/Vkqge8KKfn
	 uz8AbGdla+IIF7K6/7JQNFu9lZY97LwLwOG7FvGI5NJGPUYLQIYgbYCuronlLABEPCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iyvGeBl3;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ABE606A325
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 09:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1ABE606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iyvGeBl3
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-14394530ec6so2579458c88.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 01:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793526593; x=1794131393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Rb04uYyCDNp0kza9eq/3plAgmK27vrtoG1ucV5UIxs=;
        b=iyvGeBl3S3puAIuFJakyY8LXFh7fn8zIaZ/gULfcqHwZo4H9w6fl7LXkTQxcA2wp4r
         OBVqgnqPtZQ4cvoVCZ3M4OD3VgckKFEEErxpFFua2gU4w0u5oiy1hlwGOXUiLte3eUpy
         JgqDzvAhpQGBkd/s1SJcFMVwbqG4lpVuFX+cDXJhf1S1nWOgq4IM3XR+6KstvBP8EMM0
         nx5IAIMSysH7NZW27+t68bn11LChgQDomqs2eHxBd1e5lnCFkdJAID9GmOYaamX4dNCo
         8vPIulKKyHAyM8CMuzncj+D3QS3YXGcUCB3wPjcL3BYR2PiETonSkIqd5kCwSe0uKEYX
         U68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793526593; x=1794131393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Rb04uYyCDNp0kza9eq/3plAgmK27vrtoG1ucV5UIxs=;
        b=NC9aYpghEPSQoQfeikrb2H0JMJAaWcPQu/BZUUEvxbtnasmg2nfeUTA6pfqiVX2z+4
         jWbinS6i5axWHYoH2gSMaMNyIb7XaoxajeIbtn68tmcjJbdSHbv3RPaefSehvuvZwytJ
         CAZQKGoeuoaxtPTl55KiYmO32yDnHkb4d2fwwF2DNuHfc6PYZsGJJ6VbcNWyv5bJSKiT
         c78G6D3/wmCsSv7Ts42OCVH4TdLxDJeAg/bSzypi3QbpVc4/RBnnwWNY7/A72MoYEwz1
         ahrKh1ddoVAd4jL3/pEXeM1/RpoMZaPbv4G+hCBb59S3x/h98E5JkKYpr3kjh134zEBF
         PFMQ==
X-Gm-Message-State: AFq9FYKiuKhloh1D41Csh5RoAs83HI6aJdRJczuf9Zpq1J9mjkQh/JTp
	j/vD8WVhOrVO/LVJA6WAXqTLUgmyWNLm3MCINOfeLgowk6ZktD2IUrA6
X-Gm-Gg: AYBFou3moz51jr8lQu9O8nqKGppbCKKmnLaWPLaqGmncc+bOC77LtmF7xRdkWj9uJE/
	L8hH9YIb+GcO9UnGekUnw7XErjlmcVUXz9sFaQiTmClkghD6D2fMkEL3utZgiItqX9q5X8fr2iO
	p0JQRXX3SsHkAqogeHjNa+xuSm7yu8Pg4mxQ//Q0UTAjGjzGzKAw2vyYhAGirhIM1sot/qUAZyA
	hDttlTUpSd4L+JZAe5OKsmdYcTyFfwsuZ8QnWNhA943YjfufdLsFJ/2Lo7BfqKQzBHqQ+4clGHl
	hVWZNT5AW22I/s/5Z+SngJ6TFGfh8YZlGWXrtUVhiVSExHespkbafJph/GUuLNKnka6lbJKg9zA
	CTF3DctiDEMFSF9nkX71IeLGCjpNSmuNR8tW9ylYhUeZamcGdj58GvE8xSB49UxGTHaUFY/PHt8
	m8kvRuapanW2/F8bcz/oOyLYX9lWBK3TND00hkozPGIT9w4AdrnJFvFmIRqZOel/RUKgqWzPJ2U
	0BJLjJzLBrc5C1fsTjaV1H/A8WLBaDczbotOOVzFac2Ug402X7KENyp8mSVN9p5Y4hKY80JgNZd
	FWYFmUJL5GRBTb5pbj0tEK3aht6DagKbPcxuNHPBm1L+F/BuVUFit2CEoA==
X-Received: by 2002:a05:7022:3c87:b0:1ad:4ef5:ffed with SMTP id a92af1059eb24-1aea05f4bcfmr5416974c88.38.1793526593023;
        Sun, 01 Nov 2026 01:49:53 -0800 (PST)
Received: from xploitoverload ([2406:b400:f11:1bac:4040:640b:8a1:8629])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac192c27cdsm40740627c88.10.2026.11.01.01.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 01:49:52 -0800 (PST)
From: Kalpesh Solanki <skalpesh942@gmail.com>
To: pkshih@realtek.com,
	kvalo@kernel.org
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kalpesh Solanki <skalpesh942@gmail.com>
Subject: [PATCH 2/2] wifi: rtw88: ps: Trigger firmware recovery when failing to leave LPS state
Date: Sun,  1 Nov 2026 15:19:05 +0530
Message-ID: <20261101094905.1299638-2-skalpesh942@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261101094905.1299638-1-skalpesh942@gmail.com>
References: <20261101094905.1299638-1-skalpesh942@gmail.com>
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
 drivers/net/wireless/realtek/rtw88/ps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
index c6360cf..db1e9e7 100644
--- a/drivers/net/wireless/realtek/rtw88/ps.c
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -166,6 +166,7 @@ static void rtw_fw_leave_lps_check(struct rtw_dev *rtwdev)
 		rtw_write32_clr(rtwdev, REG_TCR, BIT_PWRMGT_HWDATA_EN);
 		rtw_warn_once(rtwdev, "firmware failed to leave lps state\n");
 		rtw_fw_dump_dbg_info(rtwdev);
+		rtw_fw_recovery(rtwdev);
 	}
 }
 
-- 
2.53.0

