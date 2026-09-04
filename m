Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590573EDACD
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 12:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526680; cv=none; b=REMARiOEaRZHuZ2s9zJfMMEX00/HVnM0x5NrSyAPf6hfvHfxpce2fk0e+ht5e4EKVIKGv8i+/mAqdS60WjxEnlggIWgBnw6ejsbdHKQII9COFrgC1AQ1ieJhIUbXf7r8hCWD8FVRIMEuBmmCakr0OJIyg6hPqjfZsxynQYj9yAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526680; c=relaxed/simple;
	bh=+usWt1vB2N5f2YUiJHGZ4UcnC8jzGuYnlVt3gnLcxZ8=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=CHJJHQe+luidwjQ7MhNyj2NiVNz7yoQtLNEsKtRpFW5eCcZ+bZs5pD++1ABCQK4/ofr1Me/5wreOeenozl9AmFNaVk1R1WrrsEmz9pFq3M/vg5iNE3NPSSN5DDKt0pe2w1EBYizzmYJZb2f7P4DMBAQcHt2jrVupWW4IKnqVJP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NFixcmRR; arc=none smtp.client-ip=95.215.58.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NFixcmRR"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+usWt1vB2N5f2YUiJHGZ4UcnC8jzGuYnlVt3gnLcxZ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788526676; v=1; x=1789131476;
 b=NFixcmRRl5mo9dveJGR0VDz/47sOa85P2j+0zeSzXY4Hm1KBUrJK81hpsaHVdikbTuWdWLLe
 Kh8DR90wLYiSHmH3mrRIyZiGPHAshwZ6GgTYIUd7ysDxEDbyEA4FPt9kMPUiWpsXp5gxNhBL3nx
 DmUcCpM9AOh2LaR2L3qSAz9s=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0a98928b6cf7ffbc;
	Fri, 04 Sep 2026 12:57:56 +0000
X-Mizu-Trace-ID: 0a98928b6cf7ffbc
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 04 Sep 2026 12:57:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <7d886d74276c05eeb1b1698e31b72a5aed98612a@linux.dev>
TLS-Required: No
Subject: [PATCH] wifi: mwifiex: bound SDIO fw dump count by memory table size
To: briannorris@chromium.org, francesco@dolcini.it
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org

From: Tianchu Chen <flynnnchen@tencent.com>

mwifiex_sdio_fw_dump() reads the number of memory regions (dump_num) from=
=20
a=20device register and uses it to index the static 15-entry
mem_type_mapping_tbl[] without any bounds check. A bogus device can
report a dump_num larger than the table, making each loop iteration
store a vmalloc pointer and a device-controlled size past the end
of the table into adjacent .data (up to ~5.7KB when dump_num is 255).

The dump path runs after command timeouts or firmware crashes, so a
bogus device can first force an error to trigger the dump and
then report a bogus dump_num.

Aborting the dump only loses the firmware snapshot; the card reset=20
that=20follows is unaffected, so error recovery still completes.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 54881c6b37c8d ("mwifiex: add firmware dump feature for SDIO")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wi=
reless/marvell/mwifiex/sdio.c
index f039d6f19183a..e40ca40418b30 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2795,6 +2795,11 @@ static void mwifiex_sdio_fw_dump(struct mwifiex_ad=
apter *adapter)
 		mwifiex_dbg(adapter, ERROR, "SDIO read memory length err\n");
 		goto done;
 	}
+	if (dump_num > ARRAY_SIZE(mem_type_mapping_tbl)) {
+		mwifiex_dbg(adapter, ERROR,
+			    "Invalid fw dump num: %d\n", dump_num);
+		goto done;
+	}
=20
=20	/* Read the length of every memory which will dump */
 	for (idx =3D 0; idx < dump_num; idx++) {
--=20
2.51.0
