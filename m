Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344A747884C
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786718459; cv=none; b=N1uILiF9rZKrQr9VN7cRxoT3gfpiV+886pLzTQ8Co24KuP2rZqV32X3N+Oew750cAotfmoN24VUu14lFpM/qEMMsye1/5h8B1i2KwJ/2EN7GK8I4x9IZO18qIw7xRsJJIpa55MYcccMgHhVtJivIysFE7OV6azDmlfViXxRDXgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786718459; c=relaxed/simple;
	bh=Yl5uiFFHOp2PyXi4gYfnS3yjeJG3bLm74K6yWesuz/4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gCphMAty8JgcGYNV8RhEGyfAXmYOOPb7y+7JKYXzITHYZYA4cotDJZYhpMMMX8td9QlQYafbfb3lbKJFetDZZ0b5CFSyfSEK80k592h1Y86iSsp2OALtwZUYk8+bWRcvKTCAix78SSX07fYuD/kSPy3JPwAJQl8Jy5gKvt65nMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l1HDr342; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1HDr342"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38deea72eebso1111560a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 07:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786718454; x=1787323254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rzvR50quFRSKXQACja47gJ2tPaACguFd0a1yLD/bk+I=;
        b=l1HDr342ugJctZVDeYXP/zUMimTgtsW9m6puhsduFpzd20wbcSK2mJi5hqy5qCATYj
         jKiYRC2ri6EhfO3R+IV7KVmInJo5a/bchz+e+36Fk4pD7XdiEEKGbgGv8q2mVw/Hi18a
         NQJH/nSf/vMAdoQPzvSRhG9gHp/kb11v0pqogxVPb9M/h1RLmEL9swnIS+fBcaJjWbDJ
         wMw1qGEF+zPsxNY1lkUJmYnzXIOJh1mZlDShRO36pjrmv8k2EdNuzJ4q7Xs6fgJhbHZo
         C3mkV//8yx9Wbqfx9luTgb7J+gEGby3dMMAEEDcQ7QFeCicYYiCNFRdqL4yNtxNWVRp4
         ci6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786718454; x=1787323254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rzvR50quFRSKXQACja47gJ2tPaACguFd0a1yLD/bk+I=;
        b=UPtZ4loGt6R3duDv2HttnsUhC7yVh8OSKbBGw9+JZ91m0ofX624qZ1JO5mxEC0UvWh
         gxDNvwTKZXVg4GnJuLcpq1KmSClCHkt7XKRATvJixnig0EPRddwDFfglskmaKCrg4R8G
         /yYdiRhghU1Nd+YX3Jid9oZKAjdEmTIw88fOm92s9tNDoYAP6EcUoyIQU+B82wQ4Fu/a
         5CF2sM+hs8ndB8yz06v9gtVOr2yPQyvExbfTJbuA+veFF5cwhVvs6L+xUkWB6KLZBnlM
         tKkADmq5Nwnsr217k0LhJtBNZ5NvfXbFpvLdYlbwJUxXFtJ5JbxEC6uUFuln/kZ5u6Fx
         KRoA==
X-Gm-Message-State: AOJu0YwnRT5DsMVQa5F3G+N8oaEjhBct3/jpECGCtB6MwHJWxxJO+WsU
	ZcNn9veV/InK9Vh9NTwAiYMerQZ4LCAYTnSFoO7N+z9q5YAUqM6kZqoFE0n+mA==
X-Gm-Gg: AR+sD128X3bQ2cNPqzbjhdHCDh7udA0u7X1xwiL6yz5j7tA4Ce2hoMKpI9G61MmYcn8
	mfWTL4URtntCFJklGlyWFwArTsaApqHqw9nlZ4dZuP23tHijDraa3rObCSNvHV7uUDDK+KEr9qe
	sftlkgijgzpVp60tmXV4XRZEOfViqZ9x1c46mzJG0QXbbD+/H8AoPPnHTYYaLY3oITSISgjI8Qn
	jekJJSgTmZY2D0/Bf4c/vBXeegHcrpoXBM6M3QnAbCUD1tezvwHNA9645oGLW2QCZva6WvQtQyH
	rQdeenTgH4E1AAMQ5xBbXeKalyP+hpDglxK72PUsUDj3keDehenXWH4n5Gl85NJpnTCcYHL4355
	GvXorwDHGdvibzlrqcLX3HJwWXIFhqFT/cLJtU/Z9PwBD+BPvmRG4Vbvb4U2gg8v/uGoCiBzl4N
	OvFfKqKPuGlh3ib1efFF859oIu1nl5IYIu4xbXRp+eYWTyQhB2TCpreuHDiZJgHpwwDUvR1DWdQ
	M4GzM+9+ejjf8obAc7Qx8SuiuuVHaFZxMk=
X-Received: by 2002:a17:90b:17c5:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-3933b874ad6mr6546913a91.10.1786718453590;
        Fri, 14 Aug 2026 07:40:53 -0700 (PDT)
Received: from fedora.fibertel.com.ar ([200.55.79.212])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ea8fe4c2sm5021125eec.29.2026.08.14.07.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 07:40:52 -0700 (PDT)
Sender: Mariano Baragiola <mariano.ignacio.baragiola@gmail.com>
From: Mariano Baragiola <mbaragiola@linux.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211_hwsim: require exact alpha2 attribute length
Date: Fri, 14 Aug 2026 11:40:47 -0300
Message-ID: <20260814144047.1130527-1-mbaragiola@linux.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The HWSIM_ATTR_REG_HINT_ALPHA2 policy accepts one-byte strings.
mac80211_hwsim_new_radio() later copies two bytes from the attribute into
data->alpha2, so a short value reads beyond the attribute payload.

Require the exact two-byte payload used by build_radio_msg(). This rejects
malformed requests before hwsim_new_radio_nl() handles them.

Fixes: 26b0e411d37a ("mac80211_hwsim: restore regulatory testing functionality")
Signed-off-by: Mariano Baragiola <mbaragiola@linux.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 02b6d81cccd1..4a567a2d885b 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -876,7 +876,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_COOKIE] = { .type = NLA_U64 },
 	[HWSIM_ATTR_CHANNELS] = { .type = NLA_U32 },
 	[HWSIM_ATTR_RADIO_ID] = { .type = NLA_U32 },
-	[HWSIM_ATTR_REG_HINT_ALPHA2] = { .type = NLA_STRING, .len = 2 },
+	[HWSIM_ATTR_REG_HINT_ALPHA2] = NLA_POLICY_EXACT_LEN(2),
 	[HWSIM_ATTR_REG_CUSTOM_REG] = { .type = NLA_U32 },
 	[HWSIM_ATTR_REG_STRICT_REG] = { .type = NLA_FLAG },
 	[HWSIM_ATTR_SUPPORT_P2P_DEVICE] = { .type = NLA_FLAG },
-- 
2.55.0

