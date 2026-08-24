Received: from wens.tw (mirror2.csie.ntu.edu.tw [140.112.30.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F059825A642
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.112.30.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787555634; cv=none; b=Tif1NeFCCcw5jqs6CmYYLNb1jryz9rYRZkabaQyyNybfsTwZr9KUQNuEzLVKXN3wptqsPAM7VilZrLhYpuL48+dGQ9FiyuRw0fgDh0M6waiWSxdT58YzWtNi1RfJGT2fn7a5ibCTHr+lBtDeGix1Mjn5EuIXJvwpCdIj+K3w2TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787555634; c=relaxed/simple;
	bh=iYNYVSaW9BtJNXR6/dVpO/X7Jc91U8LCu5/kVt00/Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zao1BWe8qR40U+kZCEZFxKfFNrvLThkJHgiGbYfh8XBQp74UH9btscO58YjMVKwMaXMx3hLdk7pAcO4h1AB4qm1flYti2GTxIuwQzax5xiqsqPtL3ee+PIPN4MI/1bMFd5N+QcG+2Cohpt/5ECnGen9hotDo1lFHCRf54vneLf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=wens.tw; arc=none smtp.client-ip=140.112.30.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wens.tw
Received: by wens.tw (Postfix, from userid 1000)
	id 6ACF9600C6; Mon, 24 Aug 2026 15:07:39 +0800 (CST)
From: Chen-Yu Tsai <wens@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Chen-Yu Tsai <wens@kernel.org>,
	wireless-regdb@lists.infradead.org,
	Ping-Ke Shih <pkshih@realtek.com>,
	Morgan Wong <pbodq2@gmail.com>
Subject: [PATCH] wireless-regdb: allow 320MHz channel width for Hong Kong (HK)
Date: Mon, 24 Aug 2026 15:07:28 +0800
Message-ID: <20260824070730.2089862-1-wens@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are no restrictions on channel width. Allow 320 MHz channels on
the 6 GHz band for WiFi 7.

Reported-by: Morgan Wong <pbodq2@gmail.com>
Link: https://lore.kernel.org/wireless-regdb/CABzKGg0YEm5PfW9YtEM0G1SYY6RD80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com/
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index eb63ff6..7aff3fb 100644
--- a/db.txt
+++ b/db.txt
@@ -892,7 +892,7 @@ country HK: DFS-ETSI
 	(5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
 	(5470 - 5730 @ 160), (27), DFS
 	(5730 - 5850 @ 80), (36)
-	(5945 - 6425 @ 160), (24), NO-OUTDOOR
+	(5945 - 6425 @ 320), (24), NO-OUTDOOR
 
 # Source:
 # https://www.conatel.gob.hn/doc/Regulacion/resoluciones/2023/NR05-23.pdf
-- 
2.47.3

