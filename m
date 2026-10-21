Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601502;
	b=X/wEu4RCEA0GE7dQaAhlZTZTWd9BmVJcMk1C9CxEXMlC4rkX4wLPk4/Yz4/axt4Um45t
	 HOtUmtRbPoqo1BYEO2MWNlX7wz2eljudyNCKV8PZOfXi7IFkr5KYq0XSywVlFnoA1nt7d
	 3If3KpBM5srhOzna/+kGZgu1ySTyzHkpdPWXl+TFHDsIc/LYP5sGV5+86zkkFnd9Sn38q
	 A5UsMGe6rPEjfSTGUHjKTLalyqVcppbOgyi9lX7v46jBhS/pPUSmEmNKZ2Fvll2Fe4K/G
	 df7ipYhps0pQBv6OAi2SE1AMcMZoDKQMpkPWbQgDdA5aL0ybxze4t84z0MdcAOBm28g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601502;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iGiZR7+p414GrEXSM/2Y69GcPywVjK77Fx5SS5X50mI=;
	b=qQhtmZi3fXNvusMiECZ6wc1vLdtenOanZHlXNXYhBl/SSyjOlsCgclKiZZm6pDYl9Qv/
	 +9zC/FLbpl5IqnnzQ4LkPukEdxtSPkihCp6yu0hzSm4RoQNCr7/BFvRNeF2DFvMj9RInC
	 p+3ar5DW1Vro3SNTB99jugFCKxpwsGubbAOEmbaD67kmLeaaZphS5wsMgnLiJ7PofGYbu
	 6tfAnYrAmjqTHjSIBKd+wbsxAA08bpR7kLAmGJaCuksPlGofGGX2DrSDgdhWrygELgY4S
	 93IquTJvpODXflJi1QeTBUrQ6K5EsLxaA67N6P3gaoxmByf0loY/gDPJf/X7CaDecsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=XAVWhkbI;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C4D606A329
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:51:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09C4D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=XAVWhkbI
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2055573c8cso120914166b.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792601500; x=1793206300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iGiZR7+p414GrEXSM/2Y69GcPywVjK77Fx5SS5X50mI=;
        b=XAVWhkbIG8DJtpEJM3hrwOUxxovILWVV9K7Xi09Pt2GbbH/NqRfsjWtevS/UwF8UpR
         WvmTzHvu9XMTd/Kpu9TPWgM/kCploFYRXPJmSLynCjRi56+EnJPgkYac7WJIlP8PB1Jk
         tCuFfwGZOW1jf5bWRXMba4daEU45G2UE8msntxNKingwFbkEDNeVgTNIExwikzM/+LHG
         dXUUP7vJhzMyDFZglB8p+JV5v4CvYkMWr+GReGk1CBdNQOd9uesUQLU/TJOheFyNtLjH
         /UpJCl/97RS63KlvooB8gLXl0AkvIroWmv0TtJmsdrmCu4v4XKJBLox4SmUGjTdI8nm3
         3fjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792601500; x=1793206300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iGiZR7+p414GrEXSM/2Y69GcPywVjK77Fx5SS5X50mI=;
        b=g8XjtL4S9GUJFojmA9VfIGzPb/b5EYjQNLBDiWAR34kvZ6fNjB+E6Eg1lqLUqFYMSP
         gyXuwJenbaIywy5Yh2iMQIIFe/3wCrLGrlWEjKu9Id3xa3r8L45S4mO6g5/poCAkapGU
         /TSefwHb7fXhbevybJCKH3rF+cJBaTFqYfaaAlp10JAGVU75ynTc/koDl0YrDilQSgVq
         FWdAocySBkckx6NivPjQ1qofkSZt7htsE8XONNgUNLQ6vnxJq3JZ/kFoBAvAJRbWDdtQ
         C1Gl7XiZ7Vfq0IkdaJhL/JVv3QyHicWu/rslQaNGu6kEd4+EnxZ4N9+1jpv7y5L6gBUS
         FHvA==
X-Forwarded-Encrypted: i=1; AKwUvBzBuNsGiUUwdebtEAbNimmzoOAQFpy+0wb+2+DjPN9NUKkNAQJ8RZ8BDKv5XY5dfpT9XZQXZJVoOWt6frMFeA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLMqUJbvo8kiYb5S8qf4DrjYuU/SRQt2dTfoW9NgeAaPgcAn/8U
	Xf6yPjox39QBYGVnRnl3VghSUTpnOW2RueQ3jQPazSmi/RhMeFe09rKEo3ecAbK2rskJfsg73nh
	LbupEvriV
X-Gm-Gg: AYBFou0r+FEAkjfRRUUcYjcQldCOMoWAJRBpa9OdAn8ZX1B0klW2lw7mlWZJRvDMLI7
	q+iqJ4IAs7Asv/u4zyqcy2te43CHp+RJM9DGFWMIOc+ZmkM7QAFhiE2eFQFokwbgvIbnv7WMmgI
	zWYh05aT7Us2hBSVEmlc+FxR6BcelyYIwCDw7c2DV7dYM5AvSdRYJ72Tn471bNxnvMP1reO0Pjt
	rfDavbDHUFIdJDv4ZfeD1LxThzsd84bQ85iaTDoHDocgGRuVji0w3q+itcy5n3VydyFKZfBiIM1
	IOW+9TbjaM8PtqivD5pTGDU9tHEBbKkKk32gYjrUuLJhCVL4PMwb5AMa1OUCOX0bs7LGvJFt/8J
	9fVMrvwgH4ic+xZDfB4IRVpY9nVNTjB9Cdbk5jA5wr08byfJgpw5DnHNBirmk4g4LOzNrhExM98
	fviHdtiTbpQUcxgPuWP2VkaALoUSoCybL/I2Dysuot3cWb9hbdeK9SLrtH+hChlOCUsWKpr0QOk
	fYKTucPkv/ygqtvtiJ6EnsLiOhJr70/K5SFjdZdbdivxNvXLP4i1xr+yZqiNvkpchH6hL77fey2
	qAPd95BgbkZ5uayN1BZBoDTYzDRvJWZQ/ATfdu+W58y4jdbEVBEElfOfPasi/8RuFQUc58zLnGR
	aoF+5SU978Mktb/ICZh22ebqL2HJrnnNuMmFGtpkL4FZOU+5NERWUQsduugIcm/qVGjDupFQzNV
	IilCRQBROL4ilE2gxajDtSwBi32DEQkOuKB4hvlQxcPdbCnFTJTGwbJp3oJ1RlMsj8
X-Received: by 2002:a17:907:3e89:b0:c31:8c48:e18b with SMTP id a640c23a62f3a-c46795e8833mr224387366b.14.1792601500405;
        Wed, 21 Oct 2026 09:51:40 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.223.169])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a5de48esm20782466b.66.2026.10.21.09.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:51:39 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: rameshkumar.sundaram@oss.qualcomm.com,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/2] wifi: ath12k: apply the 160 MHz NSS ratio to the radio for VHT
Date: Wed, 21 Oct 2026 18:51:38 +0200
Message-ID: <20261021165138.388593-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021165138.388593-1-julius@bairaktaris.de>
References: <20261021165138.388593-1-julius@bairaktaris.de>
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

The firmware reports the NSS a radio supports at 160 MHz as a ratio of
its 80 MHz NSS. VHT peer assoc applies that ratio to the peer's NSS, so
on a radio with a 1:2 ratio a two-stream VHT peer is sent one stream at
160 MHz. Commit a82ce08775bc ("wifi: ath12k: add extended NSS bandwidth
support for 160 MHz") fixed the HE path; take the VHT 160 MHz NSS from
the radio's TX chains the same way.

Compile tested only.

Fixes: 18ab9d038fad ("wifi: ath12k: add support for 160 MHz bandwidth")
Assisted-by: LLM
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath12k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 01f8c6572f657..2c2753ce5df0c 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -2510,7 +2510,7 @@ static void ath12k_peer_assoc_h_vht(struct ath12k *ar,
 	arg->tx_max_mcs_nss = 0xFF;
 
 	if (arg->peer_phymode == MODE_11AC_VHT160) {
-		tx_nss = ath12k_get_nss_160mhz(ar, max_nss);
+		tx_nss = ath12k_get_nss_160mhz(ar, ar->num_tx_chains);
 		rx_nss = min(arg->peer_nss, tx_nss);
 		arg->peer_bw_rxnss_override = ATH12K_BW_NSS_MAP_ENABLE;
 
-- 
2.53.0

