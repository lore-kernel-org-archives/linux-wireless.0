Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C120340B0F3
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 08:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788423571; cv=none; b=P3gthwXMFJwAi/zQ+LFuBg7PAaK2ze0v18yRltww6rDR6KJ/g6qQNxgAO8e3vSBswuoadF88bg6/2tFEgtNxoerOqe3xdWWcKPjHaMHjzRJ5+oNFTL4jIEW2lP48l4Pg7VaQe0WJoc6TZncl6AN4G6pQunq/8AmN72IwQFCp3jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788423571; c=relaxed/simple;
	bh=dboskfr/WbnD9iy2g2Z6ZHyrdYGaOgiWcFxOHivsHsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=msk/3bhE7V4/nDM7aiIeA/UBCzxIp0r494nJ/W/KipzzbWinc39FnT4/LXyKsv4+VG9a1sgdTMMgkfn+MXcpjcmQCY9G3eOpC2+GbimBw4P39q9nkaMx3bOujk8g2vDZdvJJ1lM3UFcwtrdNz7P9zFWM84bYXq9p5bq5crCS4+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=singe.za.net; spf=pass smtp.mailfrom=white.za.net; dkim=pass (1024-bit key) header.d=singe.za.net header.i=@singe.za.net header.b=qIn9VHsp; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=singe.za.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=white.za.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=singe.za.net header.i=@singe.za.net header.b="qIn9VHsp"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-482ea739de2so1126826f8f.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 01:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=singe.za.net; s=google; t=1788423567; x=1789028367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=87q+8eSNMFxYzwvsFisXuoJT/zkVDq4SE1UqY3UlKec=;
        b=qIn9VHspg8YLxX/yxnv/L6Au/hX6137h5/CEQaBixmrC30295AlXF5LX08bV+k4NEN
         gX/vHgPkhVTEyMMYIKq+WlDj7gfBbYIbc+fjad4BSJ4ZG/DJz/wG/Rh2pQ5QRl7I2O0+
         XpycctwRrGcpdz2y8+HMlO5yqFMrVQCryq5ZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788423567; x=1789028367;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=87q+8eSNMFxYzwvsFisXuoJT/zkVDq4SE1UqY3UlKec=;
        b=KHrDN26aMdHlclHePoE0UNs19i3C5SSTpR6oBX2LGp/cSZd8IZhXTe8G1mm78rgPhZ
         K7aVWfHiar0tAzvpEi6V9nXfMBypkn86W1UNhxLSFum9ccFWX2oatRjobYnGq0u0DN0C
         hs79drep2pG2rxWS0y7bTQZSM1pu/hRqibirIHwVMQ9J5Zju9RYhtuFTGoKUzNUnxMvu
         +0OiSXewj88PAzETgPu4jhXkLxN4ATJe0t1aTeAnxtxkMQRblASuWbszjlZh5fAR0yJ9
         dweq5hDE93AzIkg6EAoad4vGZ1VJ7teSKiZo4uTRr9UZLXvY6BvqEYgoF4xyjgkHOjD/
         9aiw==
X-Gm-Message-State: AFuF++mr9tnBuxrn2To4FTrxcCC5a0A7T0kLemhOrna9jV2h2ZCcvZKP
	2mHC8raXOIK4q2/OtVKTh822Sivj418MsfJQP1zjbVDjClaEiN+G9MvIBvou551vO3g=
X-Gm-Gg: AYBFou1nE1UBD664YJMTFaIShTSoKjyI6H+tbzyvHVdrLYMPgcpC/0Y1eMQ9zGBOoKg
	Y3B3/C8TlJG1IBS1dS4K/bwi5a1U0Fh9cOOhlibD6S+tLRYBBJU/zx1xkHjMiwTSY2PJB31Am3L
	AqTUyf4cfSJpOhG6ibBtrTHuc11MwVu5pn8DooFytYrjCJ+hetc3r+EK+T9vN51idVye7Li0Owx
	216wtvXXaRJuTN/AgptW1u+7jaSH+iD8QBozPDnacVgu+3QcLl4XHuw+I/nNwV06UThsbMNvvxm
	lgNooYo/GSrn2vqkn5idv6E11OvMawql0NRp6LAfN7QeAiq9aVao7pWfxGQ7yPoa2cLVp3o5r+H
	NhkcV7LmHqUADhq99yCpxfzXA5EJgZx7MFji1ns1oWWSrROnu7/j7m9ZmhIuw4Kt4wtnCmxlt3Y
	P2pr19v4mGfFQ7JH0zIgu9BqvRR2O8g8o5KOCsWh47izJ+2roduO7el77K/U9+0pNjmPMApkEdK
	6Hshbabj7J7/a4=
X-Received: by 2002:a05:6000:2589:b0:484:36c8:ffb9 with SMTP id ffacd0b85a97d-48488ded10dmr21114530f8f.4.1788423566735;
        Thu, 03 Sep 2026 01:19:26 -0700 (PDT)
Received: from localhost.localdomain ([105.184.8.214])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448e7315bsm12348292f8f.7.2026.09.03.01.19.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 01:19:26 -0700 (PDT)
From: github@singe.za.net
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dominic White <github@singe.za.net>
Subject: [PATCH] wifi: cfg80211: allow zero HE OBSS PD offsets
Date: Thu,  3 Sep 2026 10:18:04 +0200
Message-ID: <20260903081804.96532-1-github@singe.za.net>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dominic White <github@singe.za.net>

IEEE Std 802.11 permits the OBSS PD offset fields in the Spatial Reuse
Parameter Set element to have a value of zero. (IEEE Std 802.11-2024,
26.10.2.4)

The standard specifies the offsets as unsigned values added to -82 dBm,
with field presence signalled independently. The valid offset range is
therefore 0..20.

nl80211 currently rejects zero for all three HE OBSS PD offset
attributes during nested netlink policy validation, before the values
reach cfg80211 or the driver. Allow zero while retaining the upper bound
and the existing minimum/maximum relationship validation.

Fixes: 796e90f42b7e ("cfg80211: add support for parsing OBBS_PD attributes")
Signed-off-by: Dominic White <github@singe.za.net>
---
 net/wireless/nl80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 44f2bad08..57251cff9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -529,11 +529,11 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
 static const struct nla_policy
 he_obss_pd_policy[NL80211_HE_OBSS_PD_ATTR_MAX + 1] = {
 	[NL80211_HE_OBSS_PD_ATTR_MIN_OFFSET] =
-		NLA_POLICY_RANGE(NLA_U8, 1, 20),
+		NLA_POLICY_RANGE(NLA_U8, 0, 20),
 	[NL80211_HE_OBSS_PD_ATTR_MAX_OFFSET] =
-		NLA_POLICY_RANGE(NLA_U8, 1, 20),
+		NLA_POLICY_RANGE(NLA_U8, 0, 20),
 	[NL80211_HE_OBSS_PD_ATTR_NON_SRG_MAX_OFFSET] =
-		NLA_POLICY_RANGE(NLA_U8, 1, 20),
+		NLA_POLICY_RANGE(NLA_U8, 0, 20),
 	[NL80211_HE_OBSS_PD_ATTR_BSS_COLOR_BITMAP] =
 		NLA_POLICY_EXACT_LEN(8),
 	[NL80211_HE_OBSS_PD_ATTR_PARTIAL_BSSID_BITMAP] =

base-commit: 89a312991dc6e638a36adc43ccb91dbc25504c04
-- 
2.50.1 (Apple Git-155)

