Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B17B2E040D
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 08:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789807713; cv=none; b=tMmg7xDk6TPRDBriAG9rXrR4C6rA++nk2sKKqQSv/zT0V6s357Fyvn2/FuhWdTVPvgTpgXsTPx8Bj54uI8Bq0bzn3taDhS9hDo7xEzbs03/c9KPaLgHiKkdbmmDP3EBmbDMHp1tyumE8MnLRXDxcxtzMO3Au+ughtjfNSPWSfRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789807713; c=relaxed/simple;
	bh=yBoG2rJMJKT+Oj/XtmYc5L2ukMyrQZUEjAYXo1F4XRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqxFoEq9BwlI7ynIBiaminykcra9XCkqpyTfBrjc0xw19L75Y9t9HBn+6JS6/VJrv5ApgLf81EnOvlK++LkU269QgoY9vgAr/bp1oOHzRlkCuF4GCEXGx21k9ICkw2kc3K9O1L5SORKNK1Ps24QjX8qx37mIJdB+1V2EQn5Cit8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KwZiFXvu; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KwZiFXvu"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccafb752so1291411a91.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 01:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789807712; x=1790412512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qk4mWGpiI1Ntb6GqWAdlmOOpCK9T/mDj+iXbOld1WtI=;
        b=KwZiFXvuVamy8O1pcavcCX5Qs8mmBG9J2C93WWRNx7xpcEYcGrfnIpL4GhSosi4YZ6
         tZx0zeGZizSrHSsUHzpB466cz/lkN9vT/dCBEe6w+6S+QlFLCDoCDyAMbK1kG5KprHM5
         9h0EP4R0XAGVJb8U3WifttftIullFKrV6Ifj60BoJ39rzlgfywKDU9BiUKHYIYLDdMMH
         oJeQMN8zK7zsq6B4OCUPYKNm+jmeaYbUnre4v1Tl9LifosKBYtlVvCvr9VmPsB8VEq6q
         FYZmBpkzAShD/xnlMKOQwkgzcu4SxJcBtR5g6mmu9MFn96MJvF9zPZZBlgG/PzQe+NMZ
         CywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789807712; x=1790412512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qk4mWGpiI1Ntb6GqWAdlmOOpCK9T/mDj+iXbOld1WtI=;
        b=Q00GISspK2yv0chg2M7gD5jtz92dvY7AYNnotbMTejOI1iERNz7sRxE53ZDpIg4smk
         T0s09ZI0p7WXbe8LNrNkqDpn9f2upnpGsSVbk2LKX0FHy8ArXFCFktfWlMXNK2rB9eNV
         IviEmM3KGZdhGZ1RxZVfbnX2SGFC24jvOLigYrMeBAyD1vnr4D4d/5vY+NIgDT7J8LO1
         jMhgHBzBTf/mvoaqicLQRjTpaGy4KmA6dJIEULcortRWkyxsq9afsgUDywixoLxrf3iG
         Pe+S7rYClxXTb2EM6HkBfb6/5OC66Zw5ufA0a2limJ0emJS1ySrYJ2i8OjhvMwgVvB55
         kBJA==
X-Gm-Message-State: AFuF++k6mRHl/BD+8PeFJn+mWXbvD0h+QB0PdV9CWQ+Qs/HC9m1jTm+k
	vLzVuXEnOY38t8lclXAS3dcAUSR6BvtKiLO7kQKuOnxkhW4Cq8pOFlm+Ipmh/Q==
X-Gm-Gg: AYBFou3yOehGORFqsSMcASmLUK2UCThROSPrp2ViklaL8qZpLtSmNFICUFfGTF6WJKV
	p2u8/9s2dufHNr9MySy89LZUHmEd7QTuhTQ9MCS2UF4H9fMQ6U6UZPpnZ+PFlZUmLk+Azdvs9U4
	bRupOVfsKVpHNmvm0su5O5CG/xPiSkSL+uhgsYT2LLdn3JN+ZRa/xNCxd7i9DMff9VcTn0A8Gx+
	sMC5U7JNwrtnZTdwcfdi9Doeo13TMTGsSCs4k9KYtFRy+pJlOe1E/1y0gah4pq2uGcNOg3snA8A
	f0ab/8fYm7DZ271LRIE8Jz3sT4NKE5n1exnt3qKUYDvcZ9L41iT//Bm6QMtOlBa/KHWLmsU+F8h
	6XRv6Bd1axk4I7A9/ULDZArzVg4iOyZ+YfWC9gzhp5NNK+YnFLV+oQ15Fqys4mOXH2ug00J56uN
	metU65bASC0wxJzVm5xiI7nvz02p2J1qJEDTA6y8Tc62vDa2AjS+DXXUUkNnab+1LuHlceZn2iq
	yOWwyOSmXQaAUtqqZx8tDR6oHq140HwO3ATaQ4u3UMKeegM3ZeE5bUG0yeKGIF7qpEPtpE=
X-Received: by 2002:a17:90b:1647:b0:39e:4498:4863 with SMTP id 98e67ed59e1d1-39e54f4187emr13651417a91.10.1789807711949;
        Sat, 19 Sep 2026 01:48:31 -0700 (PDT)
Received: from lenovo-thinkbook (42-2-127-248.static.netvigator.com. [42.2.127.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cb3607csm3566816a91.16.2026.09.19.01.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 01:48:30 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: [PATCH 1/1] wifi: mac80211: handle empty FILS association request payload
Date: Sat, 19 Sep 2026 16:48:12 +0800
Message-ID: <325c048982d637a3af80d74ac5b36e9369b93f1e.1789751126.git.xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789751126.git.xuyuqiabc@gmail.com>
References: <cover.1789751126.git.xuyuqiabc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fils_encrypt_assoc_req() accepts a (Re)Association Request frame whose
last element is the FILS Session element.  crypt_len is then zero and
aes_siv_encrypt() is called with an empty plaintext.

kmemdup() returns ZERO_SIZE_PTR for a zero-length allocation, so the
unconditional sg_init_one() puts an invalid page into the scatterlist.
With CONFIG_DEBUG_SG this triggers a kernel BUG in sg_set_buf();
without the debug check the bogus page is handed to the crypto backend.

AES-SIV is defined for empty plaintext and the S2V result is then the
complete output, so handle this case before the CTR step, which has
nothing to encrypt.

Fixes: 39404feee691 ("mac80211: FILS AEAD protection for station mode association frames")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
---
 net/mac80211/fils_aead.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index 293590976489..9c4f00d61981 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -89,6 +89,14 @@ static int aes_siv_encrypt(const u8 *key, size_t key_len,
 	if (res)
 		return res;
 
+	/* With an empty plaintext there is no ciphertext to produce and
+	 * the S2V result is the complete output.
+	 */
+	if (!plain_len) {
+		memcpy(out, v, AES_BLOCK_SIZE);
+		return 0;
+	}
+
 	/* Use a temporary buffer of the plaintext to handle need for
 	 * overwriting this during AES-CTR.
 	 */
-- 
2.55.0

