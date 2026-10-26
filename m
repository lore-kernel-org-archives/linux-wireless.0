Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993026;
	b=LkWVvS7mxLzrHLPnHpAp2bt9s7EoBm9AYEFlMuGPKvT+nax1EtWUgI2SicGxA0PxbnUC
	 VwyVrsu5rBbkmnRmBiUc38POlvfZWVUwWDd027uGYc8KvUkOrAmRkynHFOn5gZNtfoAKM
	 Ifgnn8Dtu+8JsfWUBZxI2YQhdjZgYe6Q+W8ofmUnVWnLU70NmbseZHWQ3xY1ZJYdA/O9d
	 +Wp0bOrm3WPngVcHgQhUsEYm91DdsVXw643+gur4ny+cedO/4DQtUcqAkWrEd62CGt0O0
	 3a2agBryWOa3FhWcearGs/QaJTQJP2Pm/yNkm2cQm2e75zMJg5NcZ5SThkCgq2OHLmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993026;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MS+SFJ9WWLq5oVbR7Ht5YirMH5w3cLZDi8sfy9s9yMk=;
	b=Y6dG5UmMqCrFRm6ECktiTh+39YGoas653a0U6PzAVUXOL0iETl6kZBDEjCLP7EGs7NYd
	 l0hyKPLvK/GJBkrRoaRigLyprtPhW7xVhJiJ5SdRQFH1FrmGf4759kCTUUO9aHNmGoBPl
	 hETowo0v3rDaSpd4U5NFArm4DwWEPXJzw7L3FbJQj/iHaV+TnzCNbXrdcaah3/UtSa13M
	 th3SGDFTfYs2HmMkbtYGujzw7HHe8jhGqw5fdlhkZRKpj1cC3uMtyKUcL4OfKaZPoSgCe
	 yzOuAlhI88eHCoqPscsKNZr3gDAD4pH5MTXAjLJS3/uTM9mCGbnbCAc4W3Qz3/qAPSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gDVOv7N5;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90814606A330
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90814606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gDVOv7N5
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a594d313a3so273197b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993026; x=1793597826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MS+SFJ9WWLq5oVbR7Ht5YirMH5w3cLZDi8sfy9s9yMk=;
        b=gDVOv7N53HqoJDhT8tdMUtuwx2qYbMQTTge7pU/49d8/OFSHq09knx94eX699zk1BP
         9d8vTqA/qctNmowvdHgmPlA8qgCfQ3GKqfeDTLm9auMR7fBkjrGv9DVhjhCAJCLJIX7j
         XYW4onGmyPUvn7Y7T6m8mktIY7BSlC33XuuHOJlISpq3UUoLCeFPOebIzzdeZaHdc8RQ
         utZJv76Frcg696M2BBO5kycGFX/CGucMOfzJbcKUOAanDoOWVI1+tQd2AcVc0I4PIRKV
         F+KQUhKC0xavn8QHJvGxrcHNEsyY4WhHoJCQKWuqw7Igc0EDIJc1Z0Ixoq9ALBS+UPeb
         GyzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993026; x=1793597826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MS+SFJ9WWLq5oVbR7Ht5YirMH5w3cLZDi8sfy9s9yMk=;
        b=EqqjVtOAk3Hk5V4tuqHrTfCBczgHqkvIrsP/IBotXa5Um0WaNblPaX2WEvhjS2N6OO
         3l1w2niEmOT0RQF8EoKlXWqUtEa4t1KpIugRUZ56embz0aJ23EY9UXnR+/AmSsZcXsLE
         ufpICP6977jUIJsOrujHPNDtqNYNET32eye1mGHliimMT7u9kvC7KoQ4EVg8AtnjA/50
         mSZnbxjQ9wqrx5iJkZjyY4qD/RIlqJFVgprFNbjNd9FvcSLuNYIWqurFJ5SWYRQpjnh9
         eWHPzca12WyhGtZsAzuOijvqdhLQSTWKP5qyPbO1cYg98rHOi5esHsrIn9XUHwvJK10b
         Le1A==
X-Gm-Message-State: AFq9FYK2xoY6tHC/wyJqspNFrFnCqnsK9c8pJGWZEoXObjo369UOl8tP
	GOy5grydUB1C7QdkodMO5GIrCyoUKGFxuju8pqu7WUbFzf+GESvKcbHmRXGuBCng/VOfHw==
X-Gm-Gg: AYBFou1u5vshsJtesJ1gEzugIaPNy/ecC7K8Gc74/km4AJ3KffKbJj8WmBpUwo0+/Ku
	VcE/fUosd1n8qhcD6IEs7ogGjCX0Qy5/qkzSnaM8YMsUAmVvN1P2PE00ld8c3F5c3FZR5K54+y5
	cYrnxQrudxHFVMGN7HL5tGtxlN7CfIlSY3tdtSmBjruaI+Xba27RWzp46W0Fjo1rnod2SvXfQ+S
	Ar7WSfGUjjEfViR5ID2zDt6SrkhzO4Q7BBKrz0zZJxqp4wnPKgpbVn/pARGFTK0ITUKxXvjbWMN
	lfQVOk7A0Xq1kRPcmGlkMARMelEPPl57+NVdzHJjTJRb+heMFFvzxUqiKVjhxEJ/xdx6DoLQXWa
	qUXJ6/hU2+eVFAsKJ52r1FExzKQIZfVGB5prTEMqjE3dtH4phj36/uiW+xvaJ3db8kc74YA/Mx6
	DQ0MeHYKt1GFLeukVkMhVYBF+jEMeAuTGIEXWUUaNcjsAKyK7+3BLdhhtpuESx28E8W9oNWuqhi
	0pPUwhkzSW61mrV4I8IP7htB7lGjLB24w8lh7if7ZdjOfhgNNtMrtfFqb1B6GCdwVDF6TNxE5Uo
	B0sG
X-Received: by 2002:a05:6a00:ad89:b0:89f:ed19:f093 with SMTP id d2e1a72fcca58-8a36734e9c2mr4408014b3a.34.1792993025897;
        Sun, 25 Oct 2026 22:37:05 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:05 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH wireless-next 05/17] wifi: brcmsmac: round short-GI L-SIG lengths up to whole symbols
Date: Mon, 26 Oct 2026 13:36:11 +0800
Message-ID: <20261026053633.361454-6-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
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

The L-SIG length of a mixed-mode frame covers its HT part in 4 us
legacy symbols.  For a short guard interval, the HT PHY's TXTIME counts
the data symbols at the guard-independent bits per symbol, then rounds
their 3.6 us each up to 4 us units.

brcms_c_calc_lsig_len() instead divides the bits by the short-GI rate,
which rounds the symbols down before scaling them and uses the rounded-
up rates of the MCS table, so it can count one symbol less than the
frame takes.  Count the symbols at the long-GI rate and scale them.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 3a383b0d1..c9a5877c1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -7119,9 +7119,8 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 		 * the payload duration calculation matches that
 		 * of regular ofdm
 		 */
-		/* 1000Ndbps = kbps * 4 */
-		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
-				   rspec_issgi(ratespec)) * 4;
+		/* 1000Ndbps = kbps * 4, at the long-GI rate */
+		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec), false) * 4;
 
 		if (rspec_stc(ratespec) == 0)
 			nsyms =
@@ -7134,6 +7133,9 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
 				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
 
+		/* short-GI symbols (3.6 us) in 4 us units, rounded up */
+		if (rspec_issgi(ratespec))
+			nsyms = CEIL(nsyms * 9, 10);
 		/* (+3) account for HT-SIG(2) and HT-STF(1) */
 		nsyms += (tot_streams + 3);
 		/*
-- 
2.53.0

