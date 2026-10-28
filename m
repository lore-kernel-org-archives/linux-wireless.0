Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197308;
	b=HckgmvgnR34uT2IKepPQT/jikHxIPd+68tsWAaY9Hl6EddhCuaxw+Oz0UQ0SQoITH8Ff
	 lFXMYV02MmlmpzWQMLZwTALUGACiMnLcVtOoHsOomjDYZVMKw2T/uCRNp3Apa6xyA6T+M
	 OYNMi2k+l2oEyGsN0rU2UZDckClfYPj1hUoYEI6pceJuq5EKYIIFdtDgrlGKJ6aRAsenN
	 3rtnRdEBzGTTaNbYwdSHGgg2UyRYgCsTLbj+xJqW5RxzPZbvI8+CkIlaJ4TPo9djizI6U
	 H/ze8hG0BX2GSbdpBh1/ghYjHflsJ5nOIp4322OjKr7B1F6MtqtoDNQ3JRiskPAm0og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197308;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jvqlznIRpcb2r5A+1FTqthWVZHsxJDeKaLsBSLtvHm8=;
	b=KxaodCKGTo+fR4+vMNLylDqst8cCxdAkfkZLKJtQgGeH0joNmfovktSxF1YTxIPsYOu9
	 UnsQHfQOLZnvA7ZgUy0h5lcobxHuW5/sUN7kcIpl6kztMR/ENoZtdGkMjTJG3DY2cp8Am
	 2rreI7SUXU1sMj9VQ6o+QPKTinSYtm3n01mmZV9fAQFIxA7eemY993BdsWy4JBnGeRn3m
	 MJBnoX/B4sRq8sQ8tB64+ek6juECAo6Kl0k1TFs0+/pQX5Nw4OQLd4nhgvf0PDj2h57cv
	 AUhC1ExuF1WJUAx14dP1z5GeN84xU+/MAd3swEpWm8XvPIsD4yioPLH9sXqf5KgJqGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jYDFN1gn;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A775606A31C
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A775606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jYDFN1gn
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a06c60065fso867015b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197308; x=1793802108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvqlznIRpcb2r5A+1FTqthWVZHsxJDeKaLsBSLtvHm8=;
        b=jYDFN1gnQmqyKqhr+ZvFYypHYGS5CGWfK+IGEporq5BRKI79QFfQPwxrSI6sn79FMo
         NO5OBYMvH2hBAFmofJBmQZKPOTl/QGmZH3eWlx24JpmZxKYdfVx+VNXV07z1Yo9QqgN2
         7RUn/Nm1ftPgCKZkFpIyQLYuOC8et0CqmF+P49yzbn8qCmKlS3i1oZfe2HIx6K8qR3ao
         FTiVis+YTHzyBLz1++CfEyz80BOrOXOE4dgJZwfgDbowaAsgPzgqSPx9BwsO2Mw66ijJ
         kOEpn+3lIWTs+yuKxKXkhf/7N/EhRCmLsdeDMRn87H48PHQfF133PmrY1IZoAOFIbpFg
         uEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197308; x=1793802108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvqlznIRpcb2r5A+1FTqthWVZHsxJDeKaLsBSLtvHm8=;
        b=aXTd4jliJpthih7ErKaKJIB8s+3knL8rUb1ytK0t0jOGxbBMXcWEI910zRH9JVSG2w
         IuEVYOpyY3BAcROwmlKCrK2Z7wu7AF9CbS8eqTPEo0GaQ3KEWQyL9YUglBFpTUp65RaS
         ogwirdJc/UklJ3lwesGFvrknFpVSN0zeSuvS8bt9HLNVkKEKTrAZJ0cUCvtbqCEbHQfE
         UUCA3EECMfMqpywy764N5w7fvbdhcrYLlDEpf9GCvzAf/4lV/gAsMLLzPpctcBDUfvWF
         2AaZ9k15W7hdxY8yYU43DgbBRUzdM/RJo4An6RQOzmEoYhK+oKJXdvrgXgwobhWQPZNL
         5frQ==
X-Forwarded-Encrypted: i=1; AKwUvBwmelW++CRfOYq4h1mxTnbpx2fo3UwX5sV6pejt0HExkqJWCS+Zm1ZOqmuqY3tHQAdxGMtAcl55JN+czzoMyg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIF30AapY5Gjqt822Jo5z3/kfTVYCmegE7Gjm+4oXoqlYfiszvu
	xftnjhaGsDQwjxBHobfBuzWuQO8kwMuRvu1ap6xBT6SlCE8jS7eKdBrF
X-Gm-Gg: AYBFou1Qp4o2006Lf7Xsgsir6cvgPPc8vjLCnyp2OunTCLv4f1qtX/0iNsJVUCCgUC8
	a1hhfMG0Un+1nAAAWuX9pbGwSMlJLakg0uS3Q55CwHBzdSEegSGL24PVOfFqH0OTWBE3JiiCbfO
	+jO62o3BvmOWd/JGCTOXzn0K5yJr3h5T+KxaNjIfUpKKX+JUeEH0Wo+GpxZ6hzwjLMsRRtT6KHC
	oV9N9OSPKMjSjBldd/+ZcgBTXjQ1nkeFi2gJjuiQUKw7scxxTfOjWc4CQOTVHDeMl8g/sqey1qa
	cRwtw0jnfLjszQaJ+1icEjGtykHWEVO0/O3NQakjXLK6LAPKq6BJCYPZ97GB9hniZS5CdLGOpTt
	UQZDOXfG1CjEhlKSAmIrvNDUlp1Oi4F4/MM2GmCm5h3mWRnqhtBjBvCNfLK7/CZra1fyIPDb6Q3
	PUyweZwsVGVG5VKe3w8NMBO4UFRjX4UU+bZXIY3FIFzyeVxlq8+Ya6C9MU4ogtJEB+i2otftF/c
	ky3G2KBmcrtGyyZEI47qGbRMpsh6MmVYWbhVldQNcHhHGHYSKzyk6CpCT+Uqw12pLad8xATQ/65
	THMiBI/OeZccZwyMZSzBwGdQnWbvcjDPgq09EyPdNYWtt7ID/Tk6crzOYitFGYCZ01ka
X-Received: by 2002:a05:6a20:6a0c:b0:3e0:e400:3fd with SMTP id adf61e73a8af0-3e9023a4ca2mr2024572637.43.1793197307457;
        Wed, 28 Oct 2026 07:21:47 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a6cfc292sm1224768b3a.42.2026.10.28.07.21.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:21:47 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mac80211: restore dormant links when link updates fail
Date: Wed, 28 Oct 2026 22:21:23 +0800
Message-ID: <20261028142123.13072-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026152654.80697-1-enderaoelyther@gmail.com>
References: <20261026152654.80697-1-enderaoelyther@gmail.com>
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

A failed MLO link update can leave the interface with the requested
dormant-links bitmap instead of its previous one. This can disable active
links or trigger a bitmap warning during rollback.

The error path restores the old valid-links bitmap but passes the new
dormant_links argument to ieee80211_set_vif_links_bitmaps().

Save the old dormant bitmap before changing link state and use it when
restoring the old configuration.

LLM assistance was used to find the bug and review.

Fixes: 6d543b34dbcf ("wifi: mac80211: Support disabled links during association")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed on top of
the prerequisite patch. A QEMU guest forced duplicate-address rollback: the
old code cleared dormant and active links, while this change preserved
dormant=0x2 and active=0x1 without a warning. The driver-failure path was
not run. A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

Depends on "wifi: mac80211: fix use-after-free when MLO link setup is
rolled back", Message-ID <20261026152654.80697-1-enderaoelyther@gmail.com>.

 net/mac80211/link.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index fac5a8c22596..41c1ae52e097 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -290,6 +290,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 {
 	u16 old_links = sdata->vif.valid_links;
 	u16 old_active = sdata->vif.active_links;
+	u16 old_dormant = sdata->vif.dormant_links;
 	unsigned long add = new_links & ~old_links;
 	unsigned long rem = old_links & ~new_links;
 	unsigned long sta_rem = rem;
@@ -399,7 +400,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		/* restore config */
 		memcpy(sdata->link, old_data, sizeof(old_data));
 		memcpy(sdata->vif.link_conf, old, sizeof(old));
-		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
+		ieee80211_set_vif_links_bitmaps(sdata, old_links, old_dormant);
 		/* drain RCU readers before cancelling work they may queue */
 		synchronize_rcu();
 		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
prerequisite-patch-id: f3df0cde74cce63ac37decd81c2613cdb13f49ff
-- 
2.56.0

