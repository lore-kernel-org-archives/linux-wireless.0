Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C81C3B83EE;
	Mon,  8 Jun 2026 09:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912550; cv=none; b=Xq9OSNON6nXdzhyWSj7DJKA+PSBqJuYbkiR1LHZwyrfB/WcZbtoODwCuElZOASezGFd/+CwyV11yQ31VH3kPW94DQ807w7CalVhBFNWqS9POFMg0ebFlApjmQy5Id731HldABOtXyTj/2Mn7dMiI7v3NNvk0eFY+NaHFC8NOdV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912550; c=relaxed/simple;
	bh=1adYdBswyTfJyxkVS47yXOR9EW2XKEdW3V3CnEHrmfY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Jk46vKcOXqUIX62v9k3jrYiDe8tVbQyx+AnwYk2Vr2An+w2Za28GzR3BmznuRsvMuIhaXqFndkg/c3ui3bCKl+exOe3MmfIdfbj7l+ksbu4c2qyljhtaCLicwc15bgzHfPosHT1ufNbYhFWl9dTexhOFuEpEysT/XUA1gKcJK38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=Sc50sQfl; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="Sc50sQfl"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhp-00BRyL-U0; Mon, 08 Jun 2026 11:55:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=kwUAKZVIljGeQ14hKwZcWqCUMIz4UFBg8Q5CAZLBU/k=; b=Sc50sQ
	flaYzXaLKCSPlS7iRXdYE2kb2Y4VGlRespRIib2wDXi2jQkw3z5GE6QXaygTILNuNUSRFmlbg9mrP
	CWqrHPlbn0SsCS1FQl/621wo9mNNmZIjzgyKQf/rRnyM1cj8alBg9OmpJTJocXu2T9qyZ+6X52CKP
	vUA6xaG7FcWCR1QfjkBr1B2I3BdF4cRQ3PEiI32k1+0JMYFHibGFuVbvno2hUdO3cJ4NcHlKIwQhA
	rZincjgrXhLZeIWpVto3+3VzlPIfhxya9t7YV55WgJ6v2f9M9jnv8lVRdIaNVsKV6cpvOgTr8pZ2p
	tNlydp4a0E6FCG4j8dpNvaLbh8LA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhp-0003eS-6S; Mon, 08 Jun 2026 11:55:41 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWha-00Ag6G-Ju;
	Mon, 08 Jun 2026 11:55:26 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	Brian Norris <briannorris@chromium.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH net-next] drivers/net/wireless/marvell/mwifiex/sdio: Use strscpy() to copy strings into arrays
Date: Mon,  8 Jun 2026 10:54:47 +0100
Message-Id: <20260608095523.2606-3-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Replacing strcpy() with strscpy() ensures that overflow of the target
buffer cannot happen.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index f039d6f19183..d269bc4fdce2 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2512,7 +2512,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		if ((val & card->reg->host_strap_mask) == card->reg->host_strap_value)
 			firmware = card->firmware_sdiouart;
 	}
-	strcpy(adapter->fw_name, firmware);
+	strscpy(adapter->fw_name, firmware);
 
 	if (card->fw_dump_enh) {
 		adapter->mem_type_mapping_tbl = generic_mem_type_map;
-- 
2.39.5

