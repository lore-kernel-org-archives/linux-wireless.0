Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793689952;
	b=tlldoHkuBajhOYVJkAqKU7Ll/hshPbzIIcUfix7vlXXRsJtAvP3bMMvLPMRVeHoXIjaH
	 rOSlv1XmPORO1QdUcLXR1Ypk+WCcRNNcAGhDhn5ip9uOTgh74NQ7lvbbGdwKZ6C93IV7m
	 nbMwMTVOYR0WcXlIzFGGkitKiotG4g+wyHAlxYFhjtHSwUH3ekGaBkQP9+g3aerXmbah+
	 lSszZ+SofMAeVJL0p6r3uv/W/Wo6/PZKPlDz/tNPMtdo1UbzBwWywtKYL1XGwETIAuTiV
	 JdWfc3wzDySAGAlM6xtMk3QKBy99ZBxzdbIiPe+U0puDAotNewVq3ZW3yHKOTJ4zbFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793689952;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=AqKxs5uUt1YSeqbBR/C8gR3VaWJED/4MoRfLDJact7I=;
	b=apZRwuMLliAixIdJovwNBuwXC0nBny7qp4gNqfQek8q9LrOmeBwD8wMVOLuEqjiACpoI
	 BG12Mb8Qw4eMlDkZL5Z7/vR7wtRkLV3i1vIy2FDiKphK4ZYbobHP24ttc59czau4h14Iq
	 BuvHX+CwRzm7UBS3ekyQdVVXp0LcA/uP45Q1fkRGiPDBoCK5W/4GHxSf6LM58KABilG8P
	 XlHO4owsNLS3sisFkhFSP5akz7HD4ZfSJlFERxB0fCfd6+0DhJW56kndjvwljSUY9f86p
	 5bn7oVc30yo5KIh1VgF7jw0l2+lrc1o/MZLSwLX8S5Ie8QyVWZPMAn5TJkgKlvWIQCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=remarkable.no;
	spf=pass smtp.mailfrom=remarkable.no;
	dkim=pass header.d=remarkable.no header.i=@remarkable.no header.a=rsa-sha256 header.s=google header.b=ZRIUOhY1;
	arc=none smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748CD606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 07:12:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 748CD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=remarkable.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=remarkable.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=remarkable.no header.i=@remarkable.no header.a=rsa-sha256 header.s=google header.b=ZRIUOhY1
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso6111933a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 23:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=remarkable.no; s=google; t=1793689951; x=1794294751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AqKxs5uUt1YSeqbBR/C8gR3VaWJED/4MoRfLDJact7I=;
        b=ZRIUOhY1hytSyfv3BuM36boJvBvWuRAd0KZMGEbjxGbl9T732kCHYid1rpCfCYXCQl
         7bUu4IwUXdTJ4wiElejBWnbENqKF5qf0/paHnE7SB68nVKPz51Pj3hRu+GeGkJQ4sZBb
         87/q/VJLHYOS0jeM+7Y1aLgQ16gTSCLKkC3UL0lTa/KPj/LuVGeotYUH1Y4Vzs/cWeWQ
         fmgNU2TOqkZTY5lJr5XhUnA+iLXJ+yaNd3c3M5hKvphsRW52IM39NrDO+BVO9EoqPzg5
         S4vP1fdQeU8iG4sl5/o7yuazCzkNDfLHC7OyWbRrFbee2KIDJjWiG58vNNSxg9wkJ6Y2
         Es3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793689951; x=1794294751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AqKxs5uUt1YSeqbBR/C8gR3VaWJED/4MoRfLDJact7I=;
        b=VRYj+KzpU/kJDqisMS8NkqlPW+X8+Guva9ft5kxAB0Kvi61ILp/MWqd5NNIcn6t111
         yv1M+DvtTSqZUmYg8f4fgtckSbOLhHXmQAfvx7m4LJCfe1OFNu0HcrX8CxanRFruqiqC
         OS5n1Ha+Wvh4ZlCprXoXfmhxMo3/FUsZ+HgRxcGbao2e3j5agzeUXD71q9xPUly5qGsu
         Rt36ofDEBpROTIKUyVnJPtFQVfdYbzUsRvTimPwj64JUrroCkC2Rsn+4681RDuwFA65o
         m1AuPg4laMO/T2Gi5WzD4rVn0rDbr17CctTUbSr93QG2AeBL7eK16a4KvFfQ4Y1YIaV6
         M8Dw==
X-Forwarded-Encrypted: i=1; AKwUvBw9jBHigD7s54uxorGJhzMTUDm4li1HQ3rZEAtkeMFkffPGApJa7YRcykEovnBG4IfHJsyrD7enzBx8t/Bg0A==@vger.kernel.org
X-Gm-Message-State: APuU4Z+bVjL1cbZ0DzIYPDvzUJhAptOKvbRPh4V1CpNvyaMnLEdcGroW
	GnXrs5kbTIHDsWJ+f2WkgMfA+AbzbU6jFKajgLQbe7o6R3VBIZB78jURybaqHfD3bFA=
X-Gm-Gg: AYBFou3Dsm9O0SWnXCK8EwQLOSo4g9K8RhecQpfUnIrunpfyBtnt2yHV3RHtkEkjasg
	WJmiOd5R8PRGgON7he6SftHtotVuvwXgjke6Qc9MU3CDghGocmSGI+E2bV1qAgTQNIhGfRqSllQ
	uMEhtnZmioTy1cS/j2QGyR+AUOHoXK6ky+gsYz88aGgrqhY+mRv6svHIvgBYoUBWycCLJfMuKg3
	ZX6c4iiCfoMTLoS8W+NEnz8fqVPy+N4vFqu5ZP4xVevWW1WBQRvsqJ6SEXdwCLEi6JkpEv5k8Ou
	Zomn9Y4kHBtPkAq+tyzd0pknsGm3sf2RuzSFH8mrw1mw03DHzDLQV6B4BarbhM2rGwKZKz8Sme5
	lNIBB6VTQGW+DrDrH5bHn6dKSXPMx5t1EzYUOTp4+Fzjfh72GRY+LRi3T7/3XqTmiX1vUvwz0TR
	XPbj8G39dJhOXqyTpmYamJHjRhvn/TmsY2b3SkzgQtLT8SieXdY4mKG90EbSsACGu6wiL+gILdk
	8gyShePokP/eGB4VFbHoMRxW5Apq+Kj6sWQsQPxeS5TPyGXqZRamKE+ciYUNZXBNMFetNH2C4cI
	+t7nsS7e9WySCFHDmwMWM8rIKkCUyd9sKSfaqwceZjok
X-Received: by 2002:aa7:d488:0:b0:6b4:2fc3:7d85 with SMTP id 4fb4d7f45d1cf-6b4d4d8257bmr6199677a12.26.1793689950891;
        Mon, 02 Nov 2026 23:12:30 -0800 (PST)
Received: from vkn-desktop.lan ([213.52.63.204])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4ec9ee537sm3895470a12.10.2026.11.02.23.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 23:12:30 -0800 (PST)
From: Viktor Korsnes <viktor.korsnes@remarkable.no>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Viktor Korsnes <viktor.korsnes@remarkable.no>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless v2 1/2] wifi: nxpwifi: fix hex parsing in nxpwifi_parse_cal_cfg()
Date: Tue,  3 Nov 2026 08:11:59 +0100
Message-ID: <20261103071203.1288146-1-viktor.korsnes@remarkable.no>
X-Mailer: git-send-email 2.53.0
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

nxpwifi_parse_cal_cfg() passes a pointer into the raw firmware buffer to
kstrtou8(). Because kstrtou8() requires a NUL- or newline-terminated
string, it fails with -EINVAL as soon as it encounters a space after the
first byte, causing nxpwifi_parse_cal_cfg() to return 0 bytes.

Use hex2bin() instead to parse each two-character hex byte, bound the
output buffer to the command buffer capacity, and return -EINVAL when
no calibration data is parsed.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Assisted-by: GitHub-Copilot:Gemini-4-Argon
Signed-off-by: Viktor Korsnes <viktor.korsnes@remarkable.no>
---
v2:
 - Add missing <linux/hex.h> include for hex2bin() (kernel test robot)
 - Change src to const char * in nxpwifi_parse_cal_cfg() to avoid
   -Wpointer-sign on architectures with signed char

 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c | 28 ++++++++++++++++------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
index 5e8ffd306b31..c2ab32fc8e12 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
@@ -5,6 +5,8 @@
  * Copyright 2011-2024 NXP
  */
 
+#include <linux/hex.h>
+
 #include "cfg.h"
 #include "util.h"
 #include "fw.h"
@@ -1391,9 +1393,11 @@ nxpwifi_ret_sta_mem_access(struct nxpwifi_private *priv,
 	return 0;
 }
 
-static u32 nxpwifi_parse_cal_cfg(u8 *src, size_t len, u8 *dst)
+static u32 nxpwifi_parse_cal_cfg(const char *src, size_t len, u8 *dst,
+				 size_t dst_size)
 {
-	u8 *s = src, *d = dst;
+	const char *s = src;
+	u8 *d = dst;
 
 	while (s - src < len) {
 		if (*s && (isspace(*s) || *s == '\t')) {
@@ -1401,7 +1405,8 @@ static u32 nxpwifi_parse_cal_cfg(u8 *src, size_t len, u8 *dst)
 			continue;
 		}
 		if (isxdigit(*s)) {
-			if (kstrtou8(s, 16, d))
+			if (d - dst >= dst_size || src + len - s < 2 ||
+			    hex2bin(d, s, 1))
 				return 0;
 			d++;
 			s += 2;
@@ -1423,14 +1428,18 @@ nxpwifi_cmd_sta_cfg_data(struct nxpwifi_private *priv,
 	u32 len;
 	u8 *data = (u8 *)cmd + S_DS_GEN;
 
-	if (adapter->cal_data->data && adapter->cal_data->size > 0) {
-		len = nxpwifi_parse_cal_cfg((u8 *)adapter->cal_data->data,
-					    adapter->cal_data->size, data);
-		nxpwifi_dbg(adapter, INFO,
-			    "download cfg_data from config file\n");
-	} else {
+	if (!adapter->cal_data || !adapter->cal_data->data ||
+	    !adapter->cal_data->size)
 		return -EINVAL;
-	}
+
+	len = nxpwifi_parse_cal_cfg((const char *)adapter->cal_data->data,
+				    adapter->cal_data->size, data,
+				    NXPWIFI_SIZE_OF_CMD_BUFFER - S_DS_GEN);
+	if (!len)
+		return -EINVAL;
+
+	nxpwifi_dbg(adapter, INFO,
+		    "download cfg_data from config file\n");
 
 	cmd->command = cpu_to_le16(HOST_CMD_CFG_DATA);
 	cmd->size = cpu_to_le16(S_DS_GEN + len);
-- 
2.53.0

