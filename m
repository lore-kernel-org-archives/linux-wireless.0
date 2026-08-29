Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99E133970F
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 05:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787981780; cv=none; b=LRLPBaJcmnFP8102FTZe7VeYv24jLVLBfPKJEOiOrmcl22ba97rryoqUCrQS+p0UeerX2WKO4tXXTtP4PLMoQBN9dnFrFGAXcC6Yt7c+9Ymr7p8Xjkcij2i4rtO18pkXsfKEtKslFBEmKO4WAAKGypOc74kHxjvIunSQ3luZsow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787981780; c=relaxed/simple;
	bh=cKZqSmehl7OI+LxoD9b8x6/9LCjN8on9qHorIN1IWoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ff9ZZg/29IwcqnMDKjdGablvcsrMqWp3q95859uwXSytpjX/E7InuiixzkL7B3X5IVKw98QdjOolHPdDKKRqksvEUL681IVVlRMHlFgRZrzUddqVTQeGOZVOfaI/T3qcOkCqvSI34t5d9ANiA7F2lPkOHBtax4q6UbgfyWnmld0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=cOys1/xx; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="cOys1/xx"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ceaf8a1265so21967355ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 22:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1787981778; x=1788586578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l7Xkt5SZEqJGM9ra3JPDKx3OVlkvHu4q2Z7EUWtEFH8=;
        b=cOys1/xxOWW3kP/4hdhlnuQlXtLQiVcIAbvlt33BA4VYPwhcezB890cy34NkkyY+b/
         Z3hFTmWYtMk4bmh8Cd6qjioQjdCpzkB0JXYDYcgvjFcYIToipAFKivG1SXb06LBPj7mv
         tvN12ptD6WSSFDIzdE8oqfjFqfTvIUP2udpWYGpW3fdcEjFXpUTplwFOa/L7K/H8lyAC
         lai0x+EI8vMHh8WRdjHshCcvL74ksoNVsmbhyd/uR3M+7Wn0/yOLsl5n1K+TXmvHdJus
         3uYfv41sw2HAN0e8iK35iFrMQfIEl3OpYpR+9PZYi6/Vcmu6VF8wGeAZD76bFI2FgXH7
         yGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787981778; x=1788586578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l7Xkt5SZEqJGM9ra3JPDKx3OVlkvHu4q2Z7EUWtEFH8=;
        b=FgICKuafkvkjP9b7vvFhtbHPrByRBkLDcDfe5MqBaU8PllXq1EQDYA+q41+9baQXdq
         lYl/jQbs5V6KtK0GVup+eCRumefqYcTPxvZ9yUcE4fMRsNGuegLxeO8JZaBFV4/yX0pG
         W/b71ZqVVmeRtE0pFILKmhfx6E6t96elVTO6uC7VWwbN06B7Swru64xXvjPot58RKRJo
         EgwD5QDp+Igyx49xdRXgp5/dVpklUqQF/W1QyxWD+LG8S55FYHtvudTdjnJGFvEv/NSv
         1maUn3yJUV7tZfUq+SLqTAdT9pdFWPZgMzTKq2gxN1JN/w5jFWmlYOBPsl43eLvhbR3H
         VqnQ==
X-Gm-Message-State: AFuF++ngzKkySk3FC8FDIcMr+6TDelFJyhT/nG5Jjt19OlmiKCXUdZ0W
	w4QRjGDORmA0NcBBPivyL5ZVCjJXUPcUGa3ucPN2PtPzN12quAJhBU7G487TkKLZy0UDaH00wQm
	rBpJG5aeevgE=
X-Gm-Gg: AYBFou2XsPOgtZXPWWAfdTtzFrnqTTErLT04NF240+I2uQEtC3CgYoWTlMKAAcjId4s
	KSSC8QPLOKkEZH6wfJuZs6v21xyvqIKJfxPYh5wqfCIalcBr9rKoUeOu17h2OZzQ440iGopPKzr
	X/s8+h9/MgjJM/RCKjrlTdlinIX49exlFxu/Q/5oz5oAXS/nDthZaQFPLq3Er7wECNJflpFJ71P
	oOp/kjn1PHPIjVzl9mtTDAmn0wJ2+OUi7H28z/sexDjYOHkuFl6WFylutAgO0eb/busWC8sw7oE
	5qUf4IECanjjZ1GPxZWQD5NhUWPUlLSrMdiwbACbTFLZyxO6rxVkZyRtSLx7DqE4rY/dnjLDCXr
	yYxDZ5FIZDQeJq6yKZ925yaZ89CWW4oVCwRlWtMK6B/T93YSiFv9Z2HdR9b1qvFaGNOyyQeDDL9
	xto0zTro92YOUgUar5z7zhSQbZoMLKT7RQmeiugSF88auARouC1mz35dPjhp0NULgkOpYsiAMGH
	IfFeCE=
X-Received: by 2002:a17:902:d2c6:b0:2d8:d4d1:3138 with SMTP id d9443c01a7336-2d8d4d14ae4mr66807245ad.15.1787981777955;
        Fri, 28 Aug 2026 22:36:17 -0700 (PDT)
Received: from Roxy.localdomain ([2602:feda:30:ae86:216:b3ff:fe40:dc4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f8094dasm12117408eec.13.2026.08.28.22.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 22:36:17 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 1/1] wifi: mac80211: fix fragment length overflow
Date: Sat, 29 Aug 2026 13:36:03 +0800
Message-ID: <ff9b52fe8e4afb8af643ab5e6c638f8fe6596714.1787980055.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1787980055.git.zhilinz@nebusec.ai>
References: <cover.1787980055.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fragment reassembly cache tracks the amount of data in continuation
fragments in a u16. An oversized fragmented frame can therefore wrap the
value before it is passed to pskb_expand_head(), leaving the destination
skb too small for the queued fragments and triggering skb_over_panic().

Use an unsigned int, matching skb->len, so the accumulator is not
truncated at 16 bits.

Fixes: 3a11ce08c45b ("mac80211: add fragment cache to sta_info")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/mac80211/sta_info.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ee0d32877c5b4..112c333fbe45b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -458,7 +458,7 @@ struct ieee80211_fragment_entry {
 	struct sk_buff_head skb_list;
 	unsigned long first_frag_time;
 	u16 seq;
-	u16 extra_len;
+	unsigned int extra_len;
 	u16 last_frag;
 	u8 rx_queue;
 	u8 check_sequential_pn:1, /* needed for CCMP/GCMP */
-- 
2.43.0

