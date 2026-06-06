Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858C63CB2E5;
	Sat,  6 Jun 2026 20:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780777646; cv=none; b=a0Y1OMAh71wSEibAibf6RfTqgPUMIaGcET6IGj61+toUu4o49SD3zD124qMbr2lfD2+VeXC0iVdQjQz8pPdiVoGVJA4lnRcu/JzvcWo8hQNloJQ2jCOe9G4bYLU1+Fre/kekUm4UbLTVAKrLCm/Btr0d/T1gTeld4XtAkU+WwEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780777646; c=relaxed/simple;
	bh=eCCKzflE/VkI8fQZqfi2+WTPlncXDVoav0KhiEbF2/I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nDaYR8gjiSOm/TRNAEACnOWHM7MgR126CSTKUAlUW+JC5+oXjgE/HXEglML62JcqqxTlb23ZXfl/7e93aw+XjeiPQK6s5YzdvAyrvQdnL8hDCmUGDzTOa98e7F8FSH08ZIqHm7Dg3153C9QDHGvhSQ+FhaIwP+10SEnxL8pVJb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=moUAUrYi; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="moUAUrYi"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxc1-007cKh-U4; Sat, 06 Jun 2026 22:27:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=UW4f4UkAl+P0I7lIPRNtIDszxiyneFrhBfATX8XyfXM=; b=moUAUr
	YihHApM1rzQAXgjTTMMTXYClFg6TlWL2fW+a0wGp/O2S/dptcIvjXLPPdjx+WmA1xXxfrL73zVuEC
	sgC/m5StqxIpnMLju/KR7ZOFA2ah41uxf9dbYUdhWIEr2L/8aYXq6w8L11xfe5+silNtuWrKpBbU6
	SMojk2XYHAly9qCgrb8Nd+1XV2T7MU6kH8M8c+R7JpqjY+Gt2JWAzonO1Koefp36U1LCLNgTTc8vE
	SSF9c1QdsViXjzUhNT15MaJ8iam74QRZxWTdJdDUC9NocTsTIlx1ZYs8QJKUtMWnKiPi8ASwsQT+f
	ISywsPR1WdakduT56EzpiKZptXCQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbw-0000uU-If; Sat, 06 Jun 2026 22:27:16 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wVxbc-006V18-1l;
	Sat, 06 Jun 2026 22:26:56 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] rfkill: Replace strcpy() with memcpy()
Date: Sat,  6 Jun 2026 21:26:02 +0100
Message-Id: <20260606202633.5018-8-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

The length of the string is calculated in order to allocate the correct
sized memory block, use the same length to copy the string.

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

 net/rfkill/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 4827e1fb8804..9e143c4bfe6a 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1000,6 +1000,7 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
 {
 	struct rfkill *rfkill;
 	struct device *dev;
+	size_t name_len;
 
 	if (WARN_ON(!ops))
 		return NULL;
@@ -1013,14 +1014,15 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
 	if (WARN_ON(type == RFKILL_TYPE_ALL || type >= NUM_RFKILL_TYPES))
 		return NULL;
 
-	rfkill = kzalloc(sizeof(*rfkill) + strlen(name) + 1, GFP_KERNEL);
+	name_len = strlen(name);
+	rfkill = kzalloc(sizeof(*rfkill) + name_len + 1, GFP_KERNEL);
 	if (!rfkill)
 		return NULL;
 
 	spin_lock_init(&rfkill->lock);
 	INIT_LIST_HEAD(&rfkill->node);
 	rfkill->type = type;
-	strcpy(rfkill->name, name);
+	memcpy(rfkill->name, name, name_len);
 	rfkill->ops = ops;
 	rfkill->data = ops_data;
 
-- 
2.39.5

