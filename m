Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6FB52B1C2
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792071127; cv=none; b=Yhb1LFwUDyMA07wzfkt4dlu2eXoNZtgiIksPt760FFKFUIHNWtMisn+XXQ5LVXwoq+CAVxuNFLGqAqJ2cCLwwRy6BMladXglrKQU9viAfUw4syCbl2mnyz/EtW1Xo/HfTb7CATiLmDTKYXJDq575jViK/eX/rmz8pmh8Xy/RGs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792071127; c=relaxed/simple;
	bh=yh7CxzzcgveUPvADfwlYHhL5S/vf5+PDVOFhtED17X8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KVqjiBCK3I3YaBM+7FG/7NqMvybT09WG6n5NwVibJiL0O2cP6RHm1E4EjWYfMqqQzxWdfDZwVrv2tSu4XfcqjY9A3Sqs2re0WYmsmtEvsq27a3gSCKzioD2vO4LNejd76pk+xEvTphYRZjaUABk8SwLvvpiDYv6th4WvoNGS8DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i12Mmki1; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i12Mmki1"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4887dbe4f2dso525154f8f.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 06:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792071123; x=1792675923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cyNEyKLQ/jrd+Lrq1caBuwPPaSfg+nPmt7eph+HDO7s=;
        b=i12Mmki119TiBMzzWABKcgv/bF16wdpD+BjGKFiR17jyuhq9js6IvVvP8d1u34z0qg
         e+Tyi5jaAiw0OLSGx5Onz+E20IE82EU2oyHOHCScyZQ/zTmnopCmPS24JMcR9+N+SbEO
         YUAymzgjFWlVM2GCnOtU1C//hf25Euc298QsU1yv4sHepmfyivjY0ejJSNN8ig/dENvY
         s8GcBz9wITmQKlteuzsaX7PXAQSK1k314h5dVifGJxVp6h99awA5I+ZKyROIxXFWbwow
         iJPPfq5N//UpN8XlV/ALFkjUWG3jrhzq0MjQFvPMX7Zy6CpMvfHDCwI6MQrrL7eA9yUF
         Xjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792071123; x=1792675923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cyNEyKLQ/jrd+Lrq1caBuwPPaSfg+nPmt7eph+HDO7s=;
        b=Y6EdlToRMI026f4Rck8Q8WpCFYlLrhS3IQvaED1N895d3xzEwN1egXYtiSfsp6G5vL
         LBrf9nuQH+DkdRIAmwn5NrehqWIYKWxMjbOWk9Iiql3pI5A6aLTRXPkz2wa11AH5I5+n
         J8KeZzCCI7KdUgN7p+c7SDSlKXzAV4OTBRhl1rHk4g3wXkGl39VoDOOfwtoFvllVdvyB
         f8i2+0+r23rVCqyhSEuFLoIrABnDobrSHoijgp/8U/6dF5E1C6baPbJP3lmVjac95l20
         0frpkL3K+WYRu7XVOTkyR0vl3IFyT24qdkf1platxBKcvj2YUOKapoSKWJ8uTkhyKoxS
         Kp8w==
X-Forwarded-Encrypted: i=1; AKwUvBwdsocDDX5I5pHQZZzGijbjvXlz8JKfudO/Jt6+jHqSYFW2AVaxcMd1hQ5nNS2cIuDDvosXxdfzNti6RzvVKw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIWilDq8/N4TSZ9wXLLEXWjE70l610WdaWZ4Dnb5rJGmFtIpq89
	qps/I6d8z1/FDBoc7RMKeZ1RMLXhrlQj7inp0NgF6nAugYQjE472k6OM
X-Gm-Gg: AYBFou34OG6kN/xDS54PaXBns0exwH6PWy7/D98Njzu9dQO94jfGHADSL8XzTpJg3UZ
	3OL8vKXqXYPfS+CdKtI+M+Yy7kwQZy3eSDbCttYrSNyDefDjTs9jmPmhfNn2ZWrOxp9Vah0F/mU
	ALbUdL72RA+/IltQMWfrHVEI6KSuBoPraetZG7q4Pbtr4vuOdhDR70nxOWNuCg4gTK+4hxERa6r
	BtfLT2d4vzKWAVIHIBV+vMluNMtOJ4jzmwMJv42NE7kIafEpxPHUaAEq1ZmMwITF+5786wF4+MB
	hmFRakDfwr2pr/Osuc6syrHutDkMv3Eo9NJePErzYRHUxeVmy6D/wAbWuB+OFrSyiI74GT+yJBr
	uigbfN4toKE5feQCfTxJ2O82Xan5Uud9wrtoSSnVuk6LolCW83WVbNfcKavGw25c7+MoGESIHSa
	DzRdhvMyz6v1bQ71fa6FyPVpgcVDiyvrfrva3ergNoha+frifD9NppiRgfDELyeIXur9yiIGtIy
	o0nlP2zYVKNodZK18voUygrtpRPQz942gnCyixVBRsF7QMVA6NPDmqEeau4UJnmnhOU7+9moeDQ
	FzSjKAYwLL8Io/o3MlDo81UbowuwZAsrR8qmpA1Mldo8mK6w/HC9F8bw/smesV65Ef8qI/Umhoi
	TB+DrHFA=
X-Received: by 2002:a05:6000:4106:b0:48d:f14a:9186 with SMTP id ffacd0b85a97d-48df14a92e3mr7001420f8f.6.1792071122317;
        Thu, 15 Oct 2026 06:32:02 -0700 (PDT)
Received: from ast-epyc5.inf.ethz.ch (ast-epyc4.inf.ethz.ch. [129.132.161.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48df5c3b89csm3301942f8f.23.2026.10.15.06.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 06:32:01 -0700 (PDT)
From: Zijing Yin <yzjaurora@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zijing Yin <yzjaurora@gmail.com>,
	Haim Dreyfuss <haim.dreyfuss@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH wireless] wifi: cfg80211: fix out-of-bounds read in valid_rule()
Date: Thu, 15 Oct 2026 06:31:57 -0700
Message-ID: <20261015133159.1499728-1-yzjaurora@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

valid_rule() validates a struct fwdb_rule from the regulatory database
firmware file, but bounds checks only the first byte of the structure,
the length field itself.

It then uses that length, which comes straight out of the file, to
decide whether the optional fields are present, and reads rule->wmm_ptr
at offset 18 of the 20-byte structure once the length claims 20 bytes or
more.

A rule placed in the last bytes of the file therefore makes the parser
read up to 19 bytes past the end of the firmware image. The image comes
from vmalloc() in kernel_read_file(), so with the rule at the end of a
page the read falls into the guard page and oopses, with no memory
debugging enabled.

A length of at least offsetofend(max_bw) but below offsetofend(wmm_ptr)
takes the other branch, so valid_rule() returns true having read nothing
out of bounds, and the database is accepted. regdb_query_country() does
not re-check the rule, and reads rule->start, rule->end, rule->max_bw
and rule->cac_timeout off the end of the kmemdup()ed copy.

A malformed regulatory.db is parsed by cfg80211's own
request_firmware_nowait() at init time, and on demand from user space
through NL80211_CMD_RELOAD_REGDB, which needs CAP_NET_ADMIN but no
wireless hardware. Both paths require write access to the firmware
search path and CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=n.

Bound the whole declared rule, not just its length field. The existing
check on sizeof(rule->len) is still needed, since rule->len has to be
shown to be inside the file before it can be read, so the new test goes
after it. A rule reaching past the end of the file is now rejected,
which fails the database rather than reading out of bounds. That also
gives regdb_query_country() the bound it already assumes.

Fixes: 230ebaa189af ("cfg80211: read wmm rules from regulatory database")
Cc: stable@vger.kernel.org
Signed-off-by: Zijing Yin <yzjaurora@gmail.com>
---
 net/wireless/reg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 11665e0a7efc..44226687349e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -679,6 +679,9 @@ static bool valid_rule(const u8 *data, unsigned int size, u16 rule_ptr)
 	/* mandatory fields */
 	if (rule->len < offsetofend(struct fwdb_rule, max_bw))
 		return false;
+	/* the rule must lie entirely within the database */
+	if ((u8 *)rule + rule->len > data + size)
+		return false;
 	if (rule->len >= offsetofend(struct fwdb_rule, wmm_ptr)) {
 		u32 wmm_ptr = be16_to_cpu(rule->wmm_ptr) << 2;
 		struct fwdb_wmm_rule *wmm;
-- 
2.43.0

