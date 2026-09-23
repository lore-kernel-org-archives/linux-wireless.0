Received: from mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D285383FA
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 14:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174639; cv=none; b=ggRW0r9kycPP6DLW5SH4YoPwKmtu8/izk9qaG7qx4XJsZB41XGIQ3LlUsuJVUNjsPhxTX2CSsBU2UkXdy291GIp+ojFXFT7VSQSbnPW4Bp0Qs45jyp3QmgYV8tcrIGzaRXDl61evmvM2y7vrDgXMFUZxvpRZbVHSVhR/D4YJHec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174639; c=relaxed/simple;
	bh=2m3LdbjFR72eTXAN+z5CIKY8wPHQCaYQvTtFb6HddOs=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=CI244NIQytma4DM4Ly4LIqxbwozovG2GQB3cm35TrPMFar1z5Q3SVDxQUJ6ljgfWOspmZiLBR2OJKxEGLSD2GSmD1D7QfwJccPPbrhty+3u9/NOsJPdelbBMmFfegZX83wcdsf5tk3gwPzNJ7pf7GpfbFjoCSz58IzNza3hxegE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oJtE65xO; arc=none smtp.client-ip=95.215.58.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oJtE65xO"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2m3LdbjFR72eTXAN+z5CIKY8wPHQCaYQvTtFb6HddOs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790174631; v=1; x=1790779431;
 b=oJtE65xOldqGtIEnMhPVAI2KZo728/BvIqqJsaF/8jSqZyTyR2p2csX6z9B99CkfSlgBIvhE
 KKWTL26ubNbjMgq0U5wAvZmErsk7xLP7ofh3bE/TSVHsYQz6TfQR68ATb7dQi1Ojh6l986lqOuZ
 0kvE8g/Ntjs1G82n7op34jPU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fe46a94df024e453;
	Wed, 23 Sep 2026 14:43:51 +0000
X-Mizu-Trace-ID: fe46a94df024e453
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 23 Sep 2026 14:43:51 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <33a45fd59b5569cbce79142d2e012e191989ec26@linux.dev>
TLS-Required: No
Subject: [PATCH v2] wifi: mwifiex: bound SDIO fw dump count by memory table
 size
To: linux-wireless@vger.kernel.org
Cc: briannorris@chromium.org, francesco@dolcini.it

From: Tianchu Chen <flynnnchen@tencent.com>

mwifiex_sdio_fw_dump() reads the number of memory regions (dump_num)
from a device register and uses it to index the static 15-entry
mem_type_mapping_tbl[] without any bounds check.  A bogus device can
report a dump_num larger than the table; each out-of-table loop
iteration then reads entry->mem_name and entry->done_flag and stores
a vmalloc pointer and a device-controlled size past the end of the
table, into adjacent .data (up to ~5.6KiB when dump_num is 255).

The dump path runs after command timeouts or firmware crashes, so a
bogus device can first force an error to trigger the dump and then
report a bogus dump_num.

Limit dump_num to the table size instead of aborting the dump. This
is not expected to change the behavior on normal devices.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 54881c6b37c8d ("mwifiex: add firmware dump feature for SDIO")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
v2: clamp dump_num to the table size and continue when bogus dump_num
detected.

 drivers/net/wireless/marvell/mwifiex/sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wi=
reless/marvell/mwifiex/sdio.c
index f039d6f19183a..c15d6e1dd8f63 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2795,6 +2795,9 @@ static void mwifiex_sdio_fw_dump(struct mwifiex_ada=
pter *adapter)
 		mwifiex_dbg(adapter, ERROR, "SDIO read memory length err\n");
 		goto done;
 	}
+	/* Limit the dump count to the memory table size */
+	if (dump_num > ARRAY_SIZE(mem_type_mapping_tbl))
+		dump_num =3D ARRAY_SIZE(mem_type_mapping_tbl);
=20
=20	/* Read the length of every memory which will dump */
 	for (idx =3D 0; idx < dump_num; idx++) {
--=20
2.51.0
