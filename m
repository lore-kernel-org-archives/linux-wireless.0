Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4624846AA8A
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428526; cv=none; b=S2it4nm2Xed+9b4xojcgUniFfn5apJrza8MMS0z5EyOp9CsKPNTq8zcvs9+sfu7sQpy1T/TN9+IagQ1FBEfZHQxnwpRBYPa8bRqPdm/oM+LMA+a6ZuQfTUAEvbflbzPU88Lk3LjPER29NwTrQriXSDn50pvBkJQtK71+l3CNBy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428526; c=relaxed/simple;
	bh=/RZ3/Y/ZlOJg5G1yVeQGiGHh8zDUuB5gPSaN4Pn9iwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxytgeA/7Pqn+H29e/bPso1LGp8waxrcszt7A+9W/hghcvERjjW/jfpigv/htxGZ6vXLToBYi3GroYIFjwrd1s19JsWXHumxajmnVBUj3JLwZVgAR4kB7xHAwhuSV14gFqRBYxcQCwZak3yYqWEt7wmSZVlDgTXr4SAFsIfCGkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dph8ZKDY; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dph8ZKDY"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-385b78b4f9bso7127a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785428524; x=1786033324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rtE+fcyTa/nEHTvbkkFzvfqX94g1NeErZWdBjlXHpz8=;
        b=dph8ZKDYRaGxNX4AQpz2GGas0vgBCvSOq8+T8Y6s6sEGL58/XO43vSRpenRzgn24Lc
         mj0BTFfnxvTIMcynhWneU5JmSc8NIfoyZ0v9fvrn4HKDk+0ot7o7Gt3TY+eV89G+74Hf
         dnwRJRrnN4MJxqzc4S0Ix9mkAMk8O79096GnjZKhUPdVooVJ4cao6IqQizsZJF66mLjd
         HrRriGn2Jp7Ovt4ChK+rLZ+rxC7lUW1ik42iOXMcxA9uZ9la2L5bqDfxhcAmMM2g/0rY
         HhnW96TB+3IXMXxNA07nDtCDovHSK2jMytXi4k2wpLXADkadCUu1OLeZ1TNDL0RNZR8+
         z9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428524; x=1786033324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rtE+fcyTa/nEHTvbkkFzvfqX94g1NeErZWdBjlXHpz8=;
        b=gTo8T8bTXdo5S7ycpNPnVZdNnVoYMVOorhHNw+22j9kZXsFEx04dpJS4TxgnS/WHU5
         RpfJVW7JouIZWzdxBZxbqjbeE9wGZywx4150d6nIVTS/UqJq3xmsQDGf5IrXNICDf0EQ
         KDu0w2C8PBNLXSZkFhz9wLyKzxkpuSkOlecA01feARln0/l4/4ip3ZdI4Ivb6Q0laTib
         E6cVfZFFiZ+TLblEse7698jcG1btXy9VCdPxVMjyon7Gpa9iRgrrsxgH4A1pr1sDU4Ke
         LY1/Remlye5euL1h91VNWzAzfBHPWIwk5GJFJaC+pRKYjV/+q/J9zjU1tuba2fPgEPI8
         ZkVA==
X-Gm-Message-State: AOJu0YxmKm8tr+o63MUXJQmMooFU96h2dfbOR2ihe3iOZk/DNAGw9zrf
	iH2T9TEH2Fjzjt63fBsznBD9OAh10nTFlizPqSE0xuRfe8XE9XynEKXr
X-Gm-Gg: AR+sD10Y8snaIqhTVcPzyqr1gE9ZypG0e1m7yRwbtKxYN04zU+i/b0KEgMw0ieIrJZF
	vMloexgUuzhwzg5ZddboSFnFmM1h3bWZZ4Ym2afgsOUpt7aSzJvZy3+k59R1Gr+g1EjQ6w0OuQu
	hko1MlyE6AdZ/UKP62ezxyU/LN4IwGT5v2UxZxjVoiwnDZL39XjBy4UaL6CF2Ye+8hbD6dDQCyQ
	e9rj4vGzj1puh8za1/yecwdarNVA/Mv1z/AJJnpfd/TH/TKuvSYR9q84b29Bl5rdl4VqRrAogPH
	ay4H1iLCo3kv0Yh5ACPWxUVGZoq6vL8ZY5FgRUlZLuWRDZkvoFOmNfvTNo/4Vtwn83TYS0Yzagd
	4bzMYj6EhRFUscmkdj3wVJIjw9/OsCG/wMsemO+DbujEh3F5WRZS8iTrfMeI4gIujwniMYMvZdh
	TNRBwdDQLDxSeJDxNft9URhrvNyixA1Ugr/Ns5xcFAb+BBXhTsM9P0v/NBHKM9QG1JUnpAP8LMN
	pI=
X-Received: by 2002:a17:90b:3c50:b0:38e:549:9e04 with SMTP id 98e67ed59e1d1-38fa7f28d64mr893861a91.1.1785428524560;
        Thu, 30 Jul 2026 09:22:04 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7275973dsm19964269c88.15.2026.07.30.09.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:22:04 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v2 8/8] wifi: brcmsmac: ampdu: clarify standard compliance on QoS change
Date: Thu, 30 Jul 2026 16:21:11 +0000
Message-ID: <20260730162135.12278-8-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730162135.12278-1-shivesh@example.com>
References: <20260730162135.12278-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

Updates XXX comment to properly reference IEEE 802.11n requirements
that all MPDUs in an A-MPDU must share the same TID.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c  | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
index fc7a5dd2e5d8..3fd8bdbd35e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
@@ -516,12 +516,11 @@ int brcms_c_ampdu_add_frame(struct brcms_ampdu_session *session,
 			return -ENOSPC;
 
 		/*
-		 * We aren't really out of space if the new frame is of
-		 * a different priority, but we want the same behaviour
-		 * so return -ENOSPC anyway.
-		 *
-		 * XXX: The old AMPDU code did this, but is it really
-		 * necessary?
+		 * IEEE 802.11n standard requires that all MPDUs within an
+		 * A-MPDU belong to the same TID (Traffic Identifier).
+		 * Since priority maps to TID, a different priority means
+		 * we must close the current aggregate and start a new one,
+		 * so we return -ENOSPC here.
 		 */
 		first = skb_peek(&session->skb_list);
 		if (p->priority != first->priority)
-- 
2.53.0

