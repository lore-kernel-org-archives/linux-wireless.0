Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993016;
	b=ycBx38T8nRnw02F1n18aMrnyrPTEQ22UN3pfx2AXHTLMaUptNuvyCugRQ2ZR0jgVJqVl
	 LIgcOqnrfpoNbPCSt4hLYKkZ1Dp9JkfSR6N5iUnniGlqw8EiHEKMPF/G4kOrhtnLkSlBx
	 nLj5wLQNBAwEhirVH/p2cDw20xNF0ZetrdFsqOFBiNpMotCiQnr46lpO6M9exwz/MO8oC
	 WfcpsCtBq6Cq/2AmVQEgUJXZkp2ck4nqOP4OENYCd1oxDeiRvpIe4/S32BCcEJVIaUanJ
	 PajHZIVRENGnqagTpsiNqnuNygGnNnMec11oeLZqmxEVXZzH9we8ohGxbyfWimdRrZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993016;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wjwWza2KdfjVMB2kV9JcWa2D3gvBu8dp7vTolxEAakY=;
	b=NuF+WsoebqdjWqczn0eMqTM3kmA6523KIuWf8/P3cTVI4dZYZl4BdppUL7Hi2NIhcNRa
	 //pLItk/BIjhEybJEslq4PuH4VWCcCdKTe7oOHgXDYFJgb5ktm4hvEsodM/Ac6gTTA//R
	 lmU1HMPFQJKWCGHUYffb0adFwX+XllfYFbt56tEDH0/nRBMuxR5JKzUVtVFwZitxSfYMg
	 8ajn/puTRPYSwyBCw7E0NuARUpm36hU8AnYXkla3Kq0YH3382p6kmjj4DAJSgfXT4WUwb
	 vjfLG2asFIz7OKJ788OYXdd6R/x8norUeEy95UYQh1LOOZ6Bh+QcHMXY2l3GjtKEF8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Td6RfQjf;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE72606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7EE72606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Td6RfQjf
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a064fac8cbso1484229b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993015; x=1793597815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wjwWza2KdfjVMB2kV9JcWa2D3gvBu8dp7vTolxEAakY=;
        b=Td6RfQjfblrtKW1KYFCuaRs6WIw1I1Q+zFXKqdcdzGgroEJa7bINtmzGdhOndwgzAM
         jfkpE45UztGGa1YxA+BqriZgXFU/R5ZaBrCkN6Fg+jbkB67cNjO/DEOemfXW2cSwQMTa
         zV/As+7zlZuGB0yXfhSlBS9vtEJMeE/PgjI01O1Ze3JW+fEma2v4zI0yy82/WthydRWp
         3rQ/QpjmIwcIi4yG+gdTxejzHMTOeKnTSOjvorKeqvUdL+VjG/AC1QTy78A2nAG77tcI
         k1sCBIwubjUEMOgZ8qveQ2bjx8jiMy8Fr3HjaD7H0iXaj0vKBiemxKmQbTSYjxZ8iYZw
         1bxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993015; x=1793597815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wjwWza2KdfjVMB2kV9JcWa2D3gvBu8dp7vTolxEAakY=;
        b=eBFglEbWioB3+mWqcTCxsxMy393dUdHabLX8qGhX9izNXEiYNHlx7//94S7ge4zSU5
         e11kOFKudP7gSkyqUY/50sMormrScLDra7OzGu+38y35UbeMWFVZUn+w4Fr27HHmis9x
         grPWjqc2lKMX7ER0oSUap0gKGY72FyJbbtkEoWCjUYBe2l02IotvQTPiyM/HxusQ6EjK
         KUeQlDqlFN+wuAgrc/UMl0XqAx+Whqo5XOOkVziXgP4Tk0TBl/r+qOU6VhUpzXPy8ZAf
         BpvCUMjUdwEePYpBQSeEIlv7SloVmKcYjD4f33d707ZYwb3kVrcSfgKZZfcB+C+rSTUP
         r0yA==
X-Gm-Message-State: AFq9FYJuZMs306gqdASKWIx6oInqPdk74D8HtSG5cV7d+k23804FWdhi
	VItuFDNOSEs+PiZ2gAqdEVub8kmxCBEQ3NzvMLwrHbpehmdLwC0HAPQcKFiJrSNkQdDy3A==
X-Gm-Gg: AYBFou05hcUSal7I5A0c+bPMCOkwCojVHTJN1jrfxP8U88aaa78JLEgjVzA8jdySdIk
	UuqUW2X8deEO4Ciw4GD/N0QqkF1H7S5W+ON1sXWt/618H4FBg11fPkQ/d54mwV7JBPhArM+2spD
	9VoW+ozxwEpwOOw58DW+P0x+fUwz3838lfUsb9P71Onkx1zvgRchU0Ou/J0INeSMrN4xGTJqjth
	TTP/K5PyzXG/r+LL4/Qo80yTxWv12ufPJnoqW89Z4APrSdExFpRDWoTzbHebMB8dmoKQUnpdErm
	smK2y5EHUjvpwu1cABq6+Sp6R15Y7DDjht2zAQ+BNf26nxt6PCDwa54i0pLUhYgyyYFNVD2elQJ
	slz2nGdYsgzU8MaS8m3scLTNQiKgJIchNCcC5+OKsyv+yy9LDT3u9nTu8HQlWaJDCkkExjcixM7
	VRUnPVe+tAnPXU1RK//1BQ3ojABy68bkSqt27tR5/BBFu1GvJblvD0pk+T9vp3on6n8nnSZWKYt
	kD7SenWZdyUAsea2jV0S7yJ6vU0AJX+NGmkRLcPT4Ua7KhACZKo7Wnw57TBGPDvEJuJE3jRD2Ez
	8uoz
X-Received: by 2002:a05:6a00:12cb:b0:882:8aea:fbc with SMTP id d2e1a72fcca58-8a367a385edmr4665632b3a.16.1792993014913;
        Sun, 25 Oct 2026 22:36:54 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:36:54 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH wireless-next 02/17] wifi: brcm80211: move d11.h to the shared include directory
Date: Mon, 26 Oct 2026 13:36:08 +0800
Message-ID: <20261026053633.361454-3-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
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

Move the header to brcm80211/include, where the other hardware
definitions shared between the brcm80211 drivers live, and include it
as <d11.h> in brcmsmac.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c  | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h         | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c         | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h         | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c          | 2 +-
 .../net/wireless/broadcom/brcm80211/{brcmsmac => include}/d11.h | 0
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename drivers/net/wireless/broadcom/brcm80211/{brcmsmac => include}/d11.h (100%)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index c1a2318d7..eeae85cae 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -28,7 +28,7 @@
 #include <net/mac80211.h>
 #include <defs.h>
 #include "phy/phy_int.h"
-#include "d11.h"
+#include <d11.h>
 #include "channel.h"
 #include "scb.h"
 #include "pub.h"
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
index 9cb09c8a1..d81de701a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
@@ -21,7 +21,7 @@
 
 #include <brcmu_utils.h>
 #include "types.h"
-#include "d11.h"
+#include <d11.h>
 #include "pub.h"
 #include "scb.h"
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
index 0a0c0ad4f..6841bc005 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
@@ -17,7 +17,7 @@
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 
-#include "d11.h"
+#include <d11.h>
 #include "pub.h"
 #include "rate.h"
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
index 2b10fd542..e178b1a0e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
@@ -18,7 +18,7 @@
 #define _BRCM_RATE_H_
 
 #include "types.h"
-#include "d11.h"
+#include <d11.h>
 #include "pub.h"
 #include "phy_hal.h"
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
index 79d4a7a4d..6e92dc4c9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
@@ -17,7 +17,7 @@
 #include <net/mac80211.h>
 
 #include "types.h"
-#include "d11.h"
+#include <d11.h>
 #include "rate.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h b/drivers/net/wireless/broadcom/brcm80211/include/d11.h
similarity index 100%
rename from drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
rename to drivers/net/wireless/broadcom/brcm80211/include/d11.h
-- 
2.53.0

