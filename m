Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197332;
	b=tYd0+Vnqj5sonlbDejKbnvknof01cDYuhc5rZyuB+Mbff6QWi7hr+lgC0BvnACikWVcD
	 hqfH8vWxRjIElKns5XCF+V9434UGjW5h+Ds4gh7yUJ6SV+OYgYqzOCzWWHqUIjQD/bBp5
	 u4IcqxKeDQuwaZz/OZRI0NHA04Ewj5NsORyfTQQRlRWfTa/ZmEf9N5km/1WLf+e2ZqOu7
	 4t1DChE2nZd3TF/JKyOp+31uUAELC0/Kr71GogxG1i+DwGQghdRxPYxVUZ1aTTyhz2pIG
	 NIOI45i5Wv8Ut8L07v3zW9Gg9JC32/qjVtSn9cQ7/fnj40rNqbWYREwCFZFNyFbsBqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197332;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gqJ0WlZJEjY1WtT7hIbPxHW5FniZwK8mIH2WvTpStXU=;
	b=DmnruNwu6hSL+P8YwDcBF38A+gS+fs4spzoBeq+7vHZNZUa0XakkTstPxAaNlS2kBA2g
	 YcZCS6ArlKrq4y2oQB/1Gb6L1ad7FjyTgiy0WVpqOGwlE3+VeV0WhkPHUTHSa/gSAolaA
	 NQj3thvX/A4d0GcZ/fSvXo82PFL/nut9/UFLiV+cVoiz+tWfLAsznH4hADezw2wSvAEOk
	 /Gy+nP4LDNOVEbj/tdwkyj0P4eFbfGzWdB55mXpwPZ2fvQbYgHtLUFssUkAUr7238erZO
	 w9xC5Aoab4t1vVtUkVUXOgwrHtHiepD/IBpCzTFPRO4hBvYqm8NSnBWUdrkQh3H7/gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zGN7imdB;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CEB606A31C
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87CEB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zGN7imdB
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a05e3f0d23so626033b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197332; x=1793802132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gqJ0WlZJEjY1WtT7hIbPxHW5FniZwK8mIH2WvTpStXU=;
        b=zGN7imdB9l7Z90ZT96iLtDTKw947mg/cpOB45lxUfEVaDUFTM15+26LDyBrTG8G/N4
         XdVAT1Gs/9WdN8gWJ+tJhsk83hT4Z2zuFu5GxOpwxbEEv8vai3TPJ77IJDNnqhYiOGEm
         WfREZDMWnLsKTdRZwPndWNaF36kJQW4qMKwndesuARyGbx/qSejFAi2ia7Mqo2+2ABKI
         Q2aZbDqsQflidZ2Q5vMYfILZBubAtIBuouRLnYoVZm8n7CbgZe0V2JUrjwTOMREL9zFh
         kHuJfmhVMhFC169xRuIhdGd/JPQFGpG72OrE7XC0fvWEMuvDwaIKlkDODQjzWxs6FmK/
         vqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197332; x=1793802132;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gqJ0WlZJEjY1WtT7hIbPxHW5FniZwK8mIH2WvTpStXU=;
        b=kVMGfcWr2WZU3d0yX7IW3rrbMKYSy6kCttRQlNHPddG0bD/vWIBDKEQ8FUnVzDjENo
         jCc6I/hy03na8XlJPfaCpLZCrnRzL/OVlvj4n+AXOYX1/GjAtxsBnbrkTc9bsc7sZeNe
         PtrYSlb4togQ101pgdjIpJc5S1rrK1+1IQA8BD+qAMpg4qtmlNmRAI4PlzBybpHc7wDZ
         /iQEme6+acTX4wG7ld/YmirrsFh4aej6Mh0oCDD+/r46do+faHs68ISmfYV+evuhsMdH
         Wd37PveAnlaOwow5k4vy0MZlIbeK/wW3i/PwbHic4CcgNd6o7NCV6ws0g18WP+rSRedf
         1xFg==
X-Forwarded-Encrypted: i=1; AKwUvBw1x/mYWQrb5VPu42g/vKSmL+lOY9KfBidukZ8aXPkaVppXvsqJAaOmjX3HJJ0ewcprzkuzSW799dAmTmDp/g==@vger.kernel.org
X-Gm-Message-State: AFq9FYLquQfzpnMtDXDNmACUVNTTadF1qdRzxEh2y+iq6Kp6Mu4nzWni
	HLUev/pLFIO7ULIPSMDUAF6bqExxQYjiN4YvWczJYwbuycfQENUPzvHO
X-Gm-Gg: AYBFou1oTP83QN7b0hV9rKgYbl48CzzeF/oVADBXSf6blrun8vyN/5xQhmo4EWrj314
	oCmbDT0gq95iugS05Fhjnc2oIgp3socqWqmgVkYz4duu/gsMjM5vYcjm5VLLLeyRIY/Jvla4p1e
	Us3FZXTNS/WJIACWewX463n02refgdyuIU33EftDSariQ5pnhZVz8etAnRmNR7XMvVtjUk+5QRm
	+mLbvJ7Annbs174bo9wuClgLxAsvHPzpx8rhref9dFHmBVFxr1ZSAUwkk+k8u5qTqe0lMECuBkd
	2y1uZWSmVdsXffYPwtVW3vh4LOowDi/zEi5ozhPtqzXGi7VZjbdPazHiSg9A1Ca0aTV+Rny66xW
	7PzoS0KqOTo0km3ONHmeq/Zt3hDJH1QjdPN/4jCwMZAWU67L/t612riPEkPYNR81gstnKsEkkxh
	AZJ4LMmenZOGS2FjqjREoXNUAm/D324ucMhcNvmwmlkQ4/wixrqQkpW6Uq4tx6UXcr6VBYT/RoB
	MUS2X8G5FLc/MD5Ep7h9s4q4bp6hVgedus+JEYEZP4YMeOkedcG6GGzwgc/jtssz7Fz/CMb26n7
	9iW+394yXWL0Zn035uxLN2YI5sfqAsOe9J8DkGMeXVB92WHeTUsucRmOxc6qNyVtNz6iesQH9WH
	Cign57kdPN0h7yA==
X-Received: by 2002:a05:6a21:4784:b0:3e2:26fc:2e06 with SMTP id adf61e73a8af0-3e9023072ffmr1926419637.26.1793197331584;
        Wed, 28 Oct 2026 07:22:11 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a7b786b4sm1271966b3a.57.2026.10.28.07.22.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:22:11 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@nbd.name>,
	Ryder Lee <ryder.lee@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: cfg80211: preserve mesh A-MSDU lengths when adding mesh headers
Date: Wed, 28 Oct 2026 22:21:49 +0800
Message-ID: <20261028142149.13834-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
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

A malformed mesh A-MSDU subframe with a declared payload length near
65535 bytes can pass validation against a much shorter aggregate.

ieee80211_amsdu_subframe_length() adds the mesh control length to the
declared length in a u16, and ieee80211_is_valid_amsdu() stores the
result in a u16 local. The sum therefore wraps before either walker
compares it with the remaining aggregate length. The decomposer then
splits and delivers the malformed aggregate instead of rejecting it.

Keep the computed length in unsigned int in both the helper and the
validator so oversized subframes cannot wrap.

LLM assistance was used to find the bug and review.

Fixes: 6e4c0d0460bd ("wifi: mac80211: add a workaround for receiving non-standard mesh A-MSDU")
Fixes: fe4a6d2db3ba ("wifi: mac80211: implement support for yet another mesh A-MSDU format")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. A QEMU
guest using the real validator and decomposer accepted both malformed
mesh formats and emitted two frames before the change; both formats were
rejected and no frames were emitted after it. No KASAN report is expected
or claimed.
A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 net/wireless/util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index f2464d2ce0d5..c510fc62d819 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -822,12 +822,12 @@ __ieee80211_amsdu_copy(struct sk_buff *skb, unsigned int hlen,
 	return frame;
 }
 
-static u16
+static unsigned int
 ieee80211_amsdu_subframe_length(void *field, u8 mesh_flags, u8 hdr_type)
 {
 	__le16 *field_le = field;
 	__be16 *field_be = field;
-	u16 len;
+	unsigned int len;
 
 	if (hdr_type >= 2)
 		len = le16_to_cpu(*field_le);
@@ -849,7 +849,7 @@ bool ieee80211_is_valid_amsdu(struct sk_buff *skb, u8 mesh_hdr)
 		    __be16 len;
 		    u8 mesh_flags;
 		} hdr;
-		u16 len;
+		unsigned int len;
 
 		if (sizeof(hdr) > remaining)
 			return false;

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

