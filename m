Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779BA52123B
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788547999; cv=none; b=Zfavj3iglpsAtjflqMLjSPfMjYZy+KUBOrt47/vVNzqbsQ7NVsDG9TsSytAvsmU5w2xhSyHr/jcCd+MPmkSp2jXGHSfBbAK5fX/jBdH61HIyrHYzXA6hjt0SgwXwXpJcKuTdcr+F8+Ff/0ur3PWzeIeGQQZrIoL6oO2oHL/+ONI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788547999; c=relaxed/simple;
	bh=shczN+Wd1phO1G5nIqYAq6HteSzRw5Np9oURkf5Lq7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/YYQddASVsnEpW+fsivU9EguRUh1vCKL2EypBwfxMGZYiLFoph8GPGVdIVqdBDy/NeJuGUdFpeKoIG1WVIA4MmjxFpmrnyHIcaWusOu4uVopzkTptC1VAYvkm8xv3ya6aXSHhCdSCRyanyyp2WQU7lEPRD2T5HKpJhTnoukyRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cw07MPRg; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cw07MPRg"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49b8eeb3ff2so12746885e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788547995; x=1789152795; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kR2H4mZOF5MD1bZlVKgICjhHENz8kmhN8v0njF7dUVc=;
        b=Cw07MPRgqf+qAUA2jhZhGpD8omhkAS0e9GPV+J0oGudKnshqc+TKw1n+02r5nwjVmT
         46sfJIJIqhOTXKbFgFnYblzCsjSEp0Smc43jMQ6IDyREVrYgOzsYlx3v0rZt3Rs6tt0f
         dbl3/b2KqkyMxP9Je2crjAS0hehnIupyMVplahJ5IbasOZ5helhVp7XFDGBxeZZwWIMg
         aLHLrdhJ+SxCXvLN1PLxG09NTyq8QTkiQZ48qaWcMTmNPUkPWKFBtJ6KZ2bE3DX3U+Cc
         9jCY1Z3M4yj9a0ce0mHfpxXsviADz7DIdM896hZOWgNgEB/bkL7YV/g13EG4OOaXdtH6
         fSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788547995; x=1789152795;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kR2H4mZOF5MD1bZlVKgICjhHENz8kmhN8v0njF7dUVc=;
        b=GMcqMjaJwu2KSY7u9bczgn5jb8lrJaXxr5Su6ySNwIyJOMn5ED9UxO4kBusFDfjSW5
         LgSWUjPbL4R9p7lahPpgh5FuCEF1bNDgOVGLe8nm7bigFwvMkUllCwhfAPp9VOIHMCze
         hUY+IplQVpKLMzCzSBONoD6CnMTNcq+H+WEhTkv5kwNl/Mnq00QT449mKnHGwyoWKfD9
         GnB63W5hb6NfpmsmwhGsPRAwOUCpus2xF7bFGEwrUciP+4yhZPoGbyXUGG6bejBl/4s9
         7I6m07R/R03zBJrPJooXtgFYu7wbjU7RliB90+A9RKHKiT9+WOzW1OVwmVozR1LG+Yuk
         Tz1A==
X-Forwarded-Encrypted: i=1; AKwUvBx59LqOO7FuTwb4WyntFcub+F8Crl3YIc9NXBwYN6OoWiYSNCiYaOOsFB3HZFhBJa7Px2JXLQ9QPDVFtIKZXQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lu1Xvzbu8zKm1Wp8T2Bns+xPL4k1I4MoWqY9JADOnjkIL1zldu
	1EdLHHZiPlCv8YfZusFQOQf7JizHa1FsyscrOUS0T2YsLtzSASfY5XmA1iVv
X-Gm-Gg: AYBFou3KVZjqhZA3xcpw6I6cgRBt+zmcUu3CxJjdHm2OCxU+nD9QdPLFdSrGiWgo9Wa
	ipa6RObkV0IvNii5+xu7GVCaqMvYdzuuVZ9Ahwu/ek2Zvrh1UzoRGXX1zUT8uoUymNDaTulREWJ
	TY+f94qkH4pMeuNw8X192w2JBmK8HM0c/HpPnr4IuARWOw11Q57scKZfdO5Q9rIMWs5SK5AQkWU
	rYtEbuyECvojK173rC7E+zgbiwedJSg0wfu9bLZvZMXqE2mOyJ3oLGiaLKzQ6wxWJ4mIDdZonNH
	mgo/n7DFLoYn4M0lrpq6b2M0CZXcSn0F/Zdw76OWL9UD2UQTtE0feajz9BKSr132PHbBSkBSgHL
	SL4uejh11hqlS3GVhv1KhUydGwhsXt4Gj5zUZw9TjLR9OSrGKAGbg6GbKk8GAXS5Zf72XHhmNdp
	psTBl1+oJipVHuGwD+CtonwS++UIIGVVd2E+HCBZPDzazZiOp/7FQQAWuOZF6BpK2JNkEcy5+wi
	DEMkTgpeRCcxXeKCL5tx4x3IQt2hMI66o2Yscd/qzSrW0wQjIq5GbrmcccvMxrnpE2dBBKMn0yr
	il6p
X-Received: by 2002:a05:600c:3e0a:b0:495:6e68:5df2 with SMTP id 5b1f17b1804b1-49cf8267a36mr95296185e9.12.1788547995236;
        Fri, 04 Sep 2026 11:53:15 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfbe5b252sm58607715e9.3.2026.09.04.11.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:53:14 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] wifi: ath9k: skip the old channel's noise floor on USB fast changes
Date: Fri,  4 Sep 2026 21:52:53 +0300
Message-ID: <20260904185253.809209-6-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
References: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_hw_reset() reads the noise floor of the channel it is leaving to
keep that channel's calibration history current. On a single-chain
AR9271 that is three register reads, and on the USB devices each one is
a synchronous WMI round trip paid on every channel change.

Skip the readout on a fast channel change over USB. The arriving
channel's noise floor is loaded as before, and periodic calibration
updates the history while a channel is in use. Only a channel that is
left and revisited without a calibration in between sees an older
history entry.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d204cdf3fa8f..64fefbec46d5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1878,7 +1878,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
-	if (ah->curchan && !ah->chip_fullsleep)
+	/*
+	 * Over USB the departing channel's noise-floor readout costs several
+	 * round trips and only feeds its history; the fast path reloads the
+	 * arriving channel's noise floor regardless.
+	 */
+	if (ah->curchan && !ah->chip_fullsleep &&
+	    !(fastcc && common->bus_ops->ath_bus_type == ATH_USB))
 		ath9k_hw_getnf(ah, ah->curchan);
 
 	ah->caldata = caldata;
-- 
2.55.0

