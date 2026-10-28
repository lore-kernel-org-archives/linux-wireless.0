Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197098;
	b=Lda9wwXQ4e6bFYBWzL8dDoNYdbnmTFJaFk3A4T/roOSnqDWyY4YKr/5fT/JcMgK4vfq8
	 vknpVhyvqwaRoJPqghxUovt77MKGmszI9YAuqldtLIujB8GHeJ9MKVK9Wtx1mIJDvqkQ5
	 tJ+So1JKjuaJwj2wenAVePlsmyNKZ8DYE8Wgi1bpP3bb6woU2np+Aj/9SaQ1QMJrDgfEA
	 hr1H+jqrOTXThebrNeQybUUmpP850xlZUZVT3Oxj+oZpiQkbBD7AtqqYIGqoXff7IVBTj
	 vVggKb4+OgCMtmmX2aaLT770XhvhqiarRQTm3E1o79Yd4ZYrgMhbm0z2o8Da7knmjow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197098;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hVBdoLW9fkr5VdAnACGjL9+bMh3fHpmpbhIVBqSJe08=;
	b=FIZod2QvGVaesk3FjD3W8fB+7ekA5/gV0y5dYCDCyBueSbxOe4+hAHdl/eDPREC5cIyV
	 bFJr2CetNSaQbLOggaWkyRX5gK0/Y56/P0/+uLWxDq//k0RwBg/17G165du9FjwyXdcMI
	 ABfnYQ2d4Dz6AgvnWX81e8XNVjBW2qR4aCEY23qrVO4g8GygSURthgq2S7Jzk7WS4EXWx
	 GMaDGXMcOjkE7B8IVeH9U3FaWJQCMupYfgEnanNN38OV+y6ZtLdHJYvm+2ToKzQp5skjy
	 /bHo+1XEqO/s5BvptSXTU6gx8eFFdBLpWFp7uil3VyACQH0pc/yfq11VpDPP44AHWTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T9ktbbCo;
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973C9606A331
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:18:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 973C9606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T9ktbbCo
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a60f90a924so471729b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197096; x=1793801896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hVBdoLW9fkr5VdAnACGjL9+bMh3fHpmpbhIVBqSJe08=;
        b=T9ktbbCo5Z9/1NKk27IFpSLUNx4pqAmx3YUBiyXrp1gSRwpZggwfBaFje0lTEEPq2q
         iL3ErvfMZqAiObyLvDQjeFEW/h26o94H5RTglDTfEcJ7vVebSor1ZW1j7vmOwwRVWCIo
         dcN/L3S3r5e3R+0DauINd/us37UOm0/Z6GRAe/hcGl8f7rXmtHtt12/+Ff76GtuJvrbA
         QX64UBX4ryNzG+zlGssnzbtmnOxrIJZgGtNKD1V67qDQsB+1TPLJG/lGVY+wW0eHjUit
         7xFRbh0ql0lbEPLtSQkufQaMdpnIpKAN3q3mH6PPPh+nZOLsz5dsf2W0eeyk8bp/Pizr
         kTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197096; x=1793801896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hVBdoLW9fkr5VdAnACGjL9+bMh3fHpmpbhIVBqSJe08=;
        b=bkoKhKlDdT6K3GejkGY9rzgPErBlIFks9V4SgYO5yeKyu7r7f1ms4fMVQ1aAr/nBfJ
         15RKPbFYecXyscV4V1CdntRvScmkhc8pmIAPeoLBdLwXq0KHZuhQuOb2sfFaO+CwnzJ/
         ODhFsBwWKyq/AjmCHizkdUgdlgd61BUHlyMfRVhNxPE0fdOTCVPAvW7NXz86TtIT2+Sv
         IQyawkaBRucOVDdJxPy8AEcOdYL+Wg9FwT0YMAFKS4jVJON/TlyDPrFceRf5tUDGjRP3
         D3JyKRBMv1xWggpWTfHbWHXPR1GfwQy9WRvfE8cRVtvkVFKxga7rAf7FLBegXxIDz7F8
         A+gA==
X-Forwarded-Encrypted: i=1; AKwUvByUYF6mYjj89SgMJxD6EjmYXtKXFJOAn/pbOewMwKlh7aBeSjOJKaIptRby7skE5zjBPTN/E02gEtkLRDuhBw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLwxRgkH+Nkq0NjdA/9QKAXF72OYL3aNWoXeL1uwNLRonbZ9R1s
	xRKBzQqcwVLbEcygEe8AumOaImQZNh6WDd62iYoChdm6llbylyoOdbzR
X-Gm-Gg: AYBFou1P+gzTLdGDcWmDfA5n5HWU4pLhHFGkbvkRLvWD7G8PhOZhdXUqqvgiK9QfCNG
	CgIavZzAX5/lo8er1bDvUuUAyq+za/w4GCPO5+P1y1jERm5cQQJRey4mKlvrWT/6BP1isT+7YKl
	RHie3LnZjQY+mTdKBW/wM5JZZOaQmFW6M2SMPxITTtxD3wy5aBcQ8YOSkHhAfph2fkMrdDQ4i1n
	teSb1B/UmOttWfCyhNQjJjVJRo75ECMoj/jYBbIyQ2Y/AxR342Flvk20ucD0fAobSa446fLtS2r
	benJoRad/ZbKCn8RnzGz2PDp612rXkb2nmf11G3Tlm+f2wXicRpAmjJ2uJBIwUI65kw1EO/14a1
	p1ClfdxSaSPVspBZ11Uq0RFWVZw6pq8s16CGGpqnzdvou/EHHLVQqog9rQJ/mM0Hlk6Sa4I4uYR
	aitjnlmXqMiijFBcRkSwzvRdaPoLKzTnSXQMoHrsvXt6mNRXWR6IlifEIKWmyFRfyT+IKS7BDEP
	ZQ9mTHMQ8dUdMe4La2mgYON/ts6rYGYuC3QInYGXZS+YU7wNqvqHVNGyEzXR81ldAblhk1I/pfo
	ghUXI/t5b6EOYVkF+aw7UgPRnRnU5AZD0qwe/DaehIFw/h1YwrReOyaQdUxwxkvKQAa6gkAjeq7
	alqvJkBTN9N0thg==
X-Received: by 2002:a05:6a00:2e88:b0:886:84c7:72b3 with SMTP id d2e1a72fcca58-8a6e81b3743mr2158463b3a.26.1793197095477;
        Wed, 28 Oct 2026 07:18:15 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5e302sm1284996b3a.7.2026.10.28.07.18.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:18:15 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Javier Lopez <jlopex@gmail.com>,
	Jukka Rissanen <jukka.rissanen@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] wifi: mac80211_hwsim: ignore non-generic netlink releases
Date: Wed, 28 Oct 2026 22:17:50 +0800
Message-ID: <20261028141751.6728-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028141751.6728-1-enderaoelyther@gmail.com>
References: <20261028141751.6728-1-enderaoelyther@gmail.com>
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

Closing an unrelated netlink socket can remove mac80211_hwsim radios or
clear the active wmediumd registration when its port ID matches a generic
netlink socket.

mac80211_hwsim_netlink_notify() handles every NETLINK_URELEASE event,
but netlink port IDs are scoped by protocol. The notifier therefore treats
a release from another protocol as a MAC80211_HWSIM socket release.

Ignore release notifications unless they come from NETLINK_GENERIC.

LLM assistance was used to find the bug and review.

Fixes: 7882513bacb1 ("mac80211_hwsim driver support userspace frame tx/rx")
Fixes: e9ed49bf4c2c ("mac80211-hwsim: Add support for HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. Not
reproduced; source review confirmed that netlink port IDs are scoped by
protocol.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index b9446577ff49..fcbc7f4355bd 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -7197,7 +7197,7 @@ static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
 {
 	struct netlink_notify *notify = _notify;
 
-	if (state != NETLINK_URELEASE)
+	if (state != NETLINK_URELEASE || notify->protocol != NETLINK_GENERIC)
 		return NOTIFY_DONE;
 
 	remove_user_radios(notify->portid, hwsim_net_get_netgroup(notify->net));
-- 
2.56.0

