Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31AD38F957
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 06:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788761675; cv=none; b=MekZayJvtJXUUj5X0/JUyQ8JrQh+R9ldPLMkzKvhn2hJBhx2lZeLHkeiC6fFRE5bDMxV4Pdqi9LDY8WujGdhO0d9Xi89ymNL+dF/P+DinmzcZsvZnBRJmF4Z3mDQn72aQj0C+8/V6Z5713RETom9CavnQ3Uu15GLliLGmsAD7Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788761675; c=relaxed/simple;
	bh=63d3EFe70af6cIHQJQbIo4z0No8L62ks0NNHSrUyVGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIov559NEDb8Xznd6iNQ7m0VPdKdPIkgo2ff4xJnr3mNxVmy3C/cGdvjoTCiLbUiGGRdjiDouq8ACPu7qu8afIg+yYZwa3qVnczced0+aBrrouJm9CBFGEncaYpHH60C7jGsj/bpAJmjE8g/XS0Ay81EO68jqXLF98xIqGL+/CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nHe9kOnc; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHe9kOnc"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c9e7391839cso3346467a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 23:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788761666; x=1789366466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3qi9DqL8zkpOd+OvESCrZGBtHA/Pj08CoKDMwtF+4/o=;
        b=nHe9kOncZ2vhKfaxPDqpyu3adcvQGo/tA/NkPR726VTOAYg1bN+g3DqmtqLs9FS0Ga
         Gt8HRs1EXD5UXnyDMvFVtpjhsEqMUnXHA+OXdcRRIZJgW19zIu67bHNW8NaozbHxC9wM
         xZkTdc7IGPcgtVWgOHprdm54vMld/etqesivBHH5pfqJkOKb5JJWTQa1tdGaZTdaWO08
         9HC1h9X35msnG/yi8x2Af0GGWtGG9ttip5HkOlghlT9kk+W56RNdnvCUt7eq3hj17Ovw
         CH4mWW630hJ5cn66aMx358zDMfhs2uMN9qTX41CxwIu5wyunZ0ueBcN41B/+bvX5lbqL
         t2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788761666; x=1789366466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3qi9DqL8zkpOd+OvESCrZGBtHA/Pj08CoKDMwtF+4/o=;
        b=OyabJsDH2ITSPTNiAaEWRR2zdeEXIWfzuG4n62kmNhnyn3hiASyZf0Nfm9kgjD+g1x
         JJswJkAhhqQKgRovKdx+JlytRWGZ9YFpNKiZe20FuFnV/gArIUcA6Q48nv39PuxYywnS
         cu1+YUkA9GZAcw6s1aDbTf/MUpBb9edE1PjsQkAWivZ9m+3kAlBlyS9PGMaF2H+O2XfO
         DpfHwmr70Oz9M0jTQDBK5c8SVPC7azAYeT/4q7flY6k8v1DmSqC4IEuZ8p9K9sc4tysj
         ESey/tc6RFoYQkjvpujEg6cY5/umNi2F9Ayjh1jop60R76A7hAyHKzeL7/mQk0pFp407
         SfPA==
X-Gm-Message-State: AFuF++kx6q5i9cpsJx6qxap77aNO5CitAR3ieyY/WpisApMgpCZZ1I49
	3ptlAMv/dauMBBkbWvPyN1ojHzhSyQsF6KjEFvXG4RI/yKr4hNTNGNGD
X-Gm-Gg: AYBFou2vQYpmQj4yANc87U+Dcyeyo6jr6ujnJJpo5OXRl2sI528C1iwfmTofGhBHi2N
	xHZHz/ZN6oTS4e0JrKxmCu5hczm7Sl316a6BYx7jADsNQYknJPm+xVyB0QuF4IgtXn5sR1PLXfX
	y7yis4UdzVFwxw4oeLcxeXBu7K44oTeyoIftnorWm6KwDcivo0CIrTHxp6TC6fAxlg0fnYO/FNl
	KEvJsWtHoH4lcXRkcaxGG9cu/8dL1PInYjpc2SY/fkbggWtgB6YskgsW54KzW+ZpO4Pro0f6y/i
	wymlFmIi8oXbxb57NQUM2ycLaJauT3kEg1eHSbpCHP7A9WsIzEoAe6NQGpCgGy982+0LFMyvSzX
	uw8+W1/YQ36trXoNdSxInR+99s54bVI8xptg+G8CXgAdbwMsH8aE+Ovd9Btyv1rx7djcsCiayqp
	PzFGIFbINDrzw7K1n3RFwbkPWM/V8p/Djiw5YiBITFJabbdHOzQflRBzmf4MUb25HRHNPu11ErI
	xARDR/hEXP9663KzZO0sti0
X-Received: by 2002:a17:90b:1d4f:b0:398:9be5:b417 with SMTP id 98e67ed59e1d1-39b26221eb1mr31137813a91.18.1788761666128;
        Sun, 06 Sep 2026 23:14:26 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14340a69666sm4651595c88.9.2026.09.06.23.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:14:25 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: fix repeated word 'used' in comment
Date: Mon,  7 Sep 2026 11:44:17 +0530
Message-ID: <20260907061417.33729-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907061417.33729-1-hemanth.selam@gmail.com>
References: <20260907061417.33729-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the second 'used', reported by checkpatch.pl as a possible repeated
word.  Only touches a comment, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 include/net/mac80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9d1fac6e8082..33eb8b8675ce 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -257,7 +257,7 @@ struct ieee80211_chan_req {
  * @min_def: the minimum channel definition currently required.
  * @ap: the channel definition the AP actually is operating as,
  *	for use with (wider bandwidth) OFDMA
- * @radio_idx: index of the wiphy radio used used for this channel
+ * @radio_idx: index of the wiphy radio used for this channel
  * @rx_chains_static: The number of RX chains that must always be
  *	active on the channel to receive MIMO transmissions
  * @rx_chains_dynamic: The number of RX chains that must be enabled
-- 
2.48.1

