Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B224B2BF3F4
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824089; cv=none; b=aRvjvXRwBqjC9zS8YNEFQvILv/Gd3dlm7+lz2bedQkH8JmNTqljJYl6l6gaUf2Mad6sGSLU9GeJHwYi+tUkv02U7PVLlW4eJEmsMEi0fAxo8i69IA67VxAm1r2X+1WFjLYv4El5p0OUEawbXi0EMwL1TkXXqD9YCK0WJ9j192wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824089; c=relaxed/simple;
	bh=9Ji1KIwpvNu4vys9sR2AMX28jbD9entOZsYcywuZsBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O6fHpf187U+zGnk11bRpRWF7hwvaeaO2or0TU1a8bb4UFO5LKB2/ZKSRENB/a/bX7zNlSq2OIR4dhRSmK1/W0kiuq39THZkEfM/b3qce/B6pGGAAtqzVIXhSpq8o1COVQ0P6luvTYFo1q5nqfSQM3IhrJG6WjObHdix6oht+i4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2UvqSEcw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2UvqSEcw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=oU/plu5+18mAFtPmLNZXR2zxX1z77Rr+YDPk0gABB1E=; b=2UvqSEcwv+6shZuHChDGiebLDi
	fBn0YJJI4VxIhxkQyNL7fbJjfNCid2ZFWIeA3H5u6nzni3nP+peNE4CJ2vLIlRupV76vBoWwyZzYV
	hBB/i6sNWw5o8PTHj4nOlLgxKVHQnCyeahvQWx+KaE/vgaKvw3ODZ9LiNZWY5c0YeWIv1ExAhhs+g
	OkkqTY5MnJYu+X95Ci2UZrejTzdSYHnxX283icZELGmVIGxq8EvGupL/us8ohNA00tiuw7B5DN0XT
	0p85WgF9Xo7HGHRBnv/tq66TzYdib1KIOGrp4H/T+lutTFnbw1UnSYBjxR1ng/hP5Lzm5cLK2gPdz
	6B9H5pQA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmwH2-0000000EigJ-1E7i;
	Thu, 23 Jul 2026 16:27:52 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-wireless@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] rfkill: repair malformed kernel-doc and add some descriptions
Date: Thu, 23 Jul 2026 09:27:50 -0700
Message-ID: <20260723162750.167914-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use kernel-doc format for function descriptions and add the missing
function parameter descriptions to avoid kernel-doc warnings:

Warning: ../include/linux/rfkill.h:102 This comment starts with '/**',
 but isn't a kernel-doc comment.
 * rfkill_pause_polling(struct rfkill *rfkill)
Warning: include/linux/rfkill.h:109 function parameter 'rfkill' not
 described in 'rfkill_pause_polling'
Warning: ../include/linux/rfkill.h:112 This comment starts with '/**',
 but isn't a kernel-doc comment.
 * rfkill_resume_polling(struct rfkill *rfkill)
Warning: include/linux/rfkill.h:117 function parameter 'rfkill' not
 described in 'rfkill_resume_polling'
Warning: ../include/linux/rfkill.h:330 function parameter 'rfkill' not
 described in 'rfkill_get_led_trigger_name'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Johannes Berg <johannes@sipsolutions.net>

 include/linux/rfkill.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-next-20260722.orig/include/linux/rfkill.h
+++ linux-next-20260722/include/linux/rfkill.h
@@ -100,7 +100,8 @@ struct rfkill * __must_check rfkill_allo
 int __must_check rfkill_register(struct rfkill *rfkill);
 
 /**
- * rfkill_pause_polling(struct rfkill *rfkill)
+ * rfkill_pause_polling - Pause polling
+ * @rfkill: rfkill struct
  *
  * Pause polling -- say transmitter is off for other reasons.
  * NOTE: not necessary for suspend/resume -- in that case the
@@ -110,9 +111,9 @@ int __must_check rfkill_register(struct
 void rfkill_pause_polling(struct rfkill *rfkill);
 
 /**
- * rfkill_resume_polling(struct rfkill *rfkill)
+ * rfkill_resume_polling - Resume polling
+ * @rfkill: rfkill struct
  *
- * Resume polling
  * NOTE: not necessary for suspend/resume -- in that case the
  * core stops polling anyway
  */
@@ -325,6 +326,8 @@ static inline enum rfkill_type rfkill_fi
 #ifdef CONFIG_RFKILL_LEDS
 /**
  * rfkill_get_led_trigger_name - Get the LED trigger name for the button's LED.
+ * @rfkill: rfkill struct
+ *
  * This function might return a NULL pointer if registering of the
  * LED trigger failed. Use this as "default_trigger" for the LED.
  */
