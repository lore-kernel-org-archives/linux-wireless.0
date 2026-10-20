Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792457439;
	b=mVueQZVpkxcyDoZBukQIygp5goBCMTY791RMIw8v0EMj/D85cXGjuhglzuQK1hNr6njU
	 0y9yUn9ioC2XUMzafTWcQua2daW5QovZfZq2fo41XczIR2BDOiozp2udHPmb4DWzaX+bh
	 AGKpF/yr60PKLamIBoB0x5krykhcPna+fweDRqegE2MwNY/9dl1agZS4PEjcAcqwO6+jY
	 7WHs4skp51Jmhi6t+wd3AZhqrh5p99ndmV0JHfukQEssFLEcYyCCglt8WMZ/t9vKK64Od
	 J31vbArNHRt8/uWsiLxzeWJrdq63ZqG2gqQLBWPnnTxFVYsHZMqaz9WY8Rnf4I3eX9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792457439;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xzXprnWZsrl8hInvox3fTlIBkQxfMeeuam1opijn6BM=;
	b=k85xE72ytjR5e0jN2xt88cNNuNuawcvuid10P99/xOE3IqSEuGmXXKUy7yD+EiTbeclV
	 +OF4QXFXvQS9/GTbJxBSm/vxqUzlxWchVmnNZKb0Xrd/2fj6IqMRQrmZME0EsqueO7Eo4
	 NNnq4BQ713K3eM6O6ejB8qwlDWqOqRY0wgaMPWOvuZeB80cDUMAqfainyYOKsdN6tpT4J
	 wky8UtZZGc1dnzf4vPLzg7VYdhTiR0/gqySZ/Q3njtObFXK28U+lffLot+1KROQspfPCI
	 MwLBYUHC2XtcRwaKWfwiLJp1JLZORdRjnC9PixmbQYc0ezxgdQAtz2bMkU1qqWIgbuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=gHIFt8h2;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D39606A330
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:50:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88D39606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=gHIFt8h2
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ab9268d90eso1564910a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 17:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792457438; x=1793062238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xzXprnWZsrl8hInvox3fTlIBkQxfMeeuam1opijn6BM=;
        b=gHIFt8h2LONsrypiXfLyADfT94rkd3ScfVZkrc9yn7dEoF+vVt6HdUSRu6eXCd6QQy
         2l7jm6lNGfscVObFnTr1LxC9lu6KRRjUmjAPrrT34nMoqCRR5Hhndvl7UJ3lq0ICancP
         RLQUvOVoXIDIMueoOkjf7MBRlNllTmrmkreswF9/7QHMAupw1p1PQfkYz30iK5B/9Ex+
         TiX2tvDArGeI4SqKCnGugTY/Otih0cT5L6ikZnpyXanBv8inA3TuXWhqyHI7SMXqdpys
         XT+rv1eZ84+AJi8jgvITukF3dJ7ZKr3uz3OUV54ZBHjtrdl4j3dWMrPh02BFX5RJ+ZUG
         z/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792457438; x=1793062238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xzXprnWZsrl8hInvox3fTlIBkQxfMeeuam1opijn6BM=;
        b=FWhAQe+1kicjDCZ+iULC0eMJNDwQucUQPkcshuF3Ttn4TljQ97Vb+xLtHpWyG9GUM5
         m3N1cufY8DrxZaUuVBQVnMakcPQPAiVWPgRX7sPo0RejmEIHnANuroVabcnTBxM66iL9
         MvpOUGH/P5IhwRdySY6nGwSMfChBqv+pqXc0QX6yp0j1289MpNzlV9cmq+P8tJqkte8P
         DZOpzOon+mrs6InlxhmwGmO+UiN/G6EGSILkFLxfn8RRL8dOllhzdnMhu/gBVfZlqaVV
         Owyd6M3SBtNcB0IwWHCvJ2Mzj607b1DVoUUBeWO+HtmyJXYYfiGh32yDhoe4JsTt3kHz
         qWrw==
X-Forwarded-Encrypted: i=1; AKwUvBw9sHBGy3nvFlMBNU+v42nJ8Pydytr8cbV30gouhqEtXyeHkMBxbDrhNaE32gSwhmtdeuA699ag17GvWXR7UA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLxtdOPyb6Osz0gGnlQE8lP5TpY5Mn/4OlZ9BKOP5ofd1SiiXFU
	Z1UAWOWxpQ1aaXUwNO6v3ECiMYVyqvZ5XOZeGz9XQAXrUmFoJUZv8X9Tq262Ychttbc=
X-Gm-Gg: AYBFou02xte0ZnCgvfdGyF1y3dlv86dT7y8J83oJYmh4iw5Lb2snxV94ywg+TahvYmo
	0mUn6E8BX7Nqvk2UusEk4yUIQ4cOfnN1neqO95xUnRoJA5PrD8tU2vcBBvKX9HAuWIthWvQcc/h
	CbMqJxlwxd1y4rvliqa93SfKUKAs8WViOxLWtZQUbqhd/rNJ8+UIeGKYoJAH1ENLLeTcxLX40Jg
	AoVksyYlAEykAjgUybuOsxmIBs81dvF2WHS9Mi9+dGlF68305DBEm71V/1n6ZhYO85FCchuS5rQ
	dRG+PKO4yRSBIkk5kc03I7S80fdNEgRbsCmWckiHT3KNYwn3P1ScsSjU6UgzUqnD3fYPipD2EfJ
	g4oY1WEyFAKg/wttOGrMxARDPtmLpMK+S06XOQXRz6PRZjVTGv3whp1bVYB8Lcq0EOSQLVnwA5y
	C3OOGlQirXIak6Iw0afMHnL00goaoiK82vbH4oHq2W5qR4K4RXRKSbUaGMocNdrixv037od5zKQ
	l85YKL8MUVoCpnBGIy/MEQDOOit3xhJoXci1o9t4JoTs23B0xOTnpSF3SDgJH8=
X-Received: by 2002:a17:90b:57c7:b0:3ac:a139:1b13 with SMTP id 98e67ed59e1d1-3aceed9ff39mr7697793a91.29.1792457437781;
        Mon, 19 Oct 2026 17:50:37 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3b16c2asm8520499a91.2.2026.10.19.17.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 17:50:37 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 1/3] wifi: nxpwifi: guard the 11ax response handlers against a detached command buffer
Date: Tue, 20 Oct 2026 09:50:25 +0900
Message-ID: <20261020005027.1105121-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261020005027.1105121-1-yhlee@isslab.korea.ac.kr>
References: <20261020005027.1105121-1-yhlee@isslab.korea.ac.kr>
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

nxpwifi_wait_queue_complete() clears curr_cmd->data_buf when a
synchronous command is interrupted, but nxpwifi_process_cmdresp() still
hands that field to the response handler. The three handlers in 11ax.c
store through it without checking, so a late response oopses.

Check the buffer first and return 0 when it is NULL, as the sta_cmd.c
handlers that commit 068986fd6f2a5 ("wifi: nxpwifi: detach sync command
buffer on interrupted wait") covers already do.

This is a local denial of service: it needs an interrupted synchronous
command and a late response, both on the local host.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index dc1e747383eca..7e9127ae2f421 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -205,9 +205,13 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 	struct host_cmd_11ax_cfg *he_cfg = &resp->params.ax_cfg;
 	struct nxpwifi_ie_types_header *header;
 	u16 left_len, tlv_type, tlv_len;
+	struct nxpwifi_11ax_he_cap_cfg *he_cap;
 	u8 ext_id;
-	struct nxpwifi_11ax_he_cap_cfg *he_cap = &ax_cfg->he_cap_cfg;
 
+	if (!ax_cfg)
+		return 0;
+
+	he_cap = &ax_cfg->he_cap_cfg;
 	left_len = le16_to_cpu(resp->size) - sizeof(*he_cfg) - S_DS_GEN;
 	header = (struct nxpwifi_ie_types_header *)he_cfg->tlv;
 
@@ -346,6 +350,9 @@ int nxpwifi_ret_11ax_cmd(struct nxpwifi_private *priv,
 	struct host_cmd_11ax_cmd *he_cmd = &resp->params.ax_cmd;
 	struct nxpwifi_ie_types_data *tlv;
 
+	if (!ax_cmd)
+		return 0;
+
 	ax_cmd->sub_id = le16_to_cpu(he_cmd->sub_id);
 
 	switch (ax_cmd->sub_command) {
@@ -584,6 +591,9 @@ int nxpwifi_ret_twt_cfg(struct nxpwifi_private *priv,
 	struct host_cmd_twt_cfg *twt_cfg_cmd = &resp->params.twt_cfg;
 	u16 action;
 
+	if (!twt_cfg)
+		return 0;
+
 	action = le16_to_cpu(twt_cfg_cmd->action);
 	twt_cfg->sub_id = le16_to_cpu(twt_cfg_cmd->sub_id);
 
-- 
2.43.0

