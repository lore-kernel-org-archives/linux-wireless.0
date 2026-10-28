Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197405;
	b=sQkuu57gkkpMMYZCIJWwDSY5PLbbKB03FYo5Ik6H962kN62MkBcDSySecfFAm85Nouo+
	 JnaKPI5Z4jq0D5qVPtXrND4LhySJSIhd66+p6rP3op4GzLjLkwwAX83okFoxYfAlGuA63
	 FLVvpTH0p7az21y0z5vK0c8cgoeIKCVoirlxt4xa+7cQZRlUWHT5l3p7lDc+WxkPzK4D+
	 +QkNB4/6tYi9hi/wVkRrIoWVQBJF4eJEezW2Y6In9dE+QngBuO7Vw80kkFhqCgIGw7X5C
	 uWAEt4D9Jag8Lywz9xa9E20XLageV/3C88Rnct/VFHxadLy/PChZXdCJLX280RCbfWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=alnKCsFxzyORsFsXKCIpyKnL9PTgktadfxwbxtnPw7o=;
	b=P+fXrg124idab788h8s1jCSZgSltnjwDxc2PEim7tLM2uQmz3wiqF8y4vZ6DS7hUkyKX
	 QqoSb99ygZnRO1cJHnhVwosFLPzXZAmGant47qDHiomUtJsJjz2v1s7wf1lcv5DaBlJTp
	 VRnJdSKDSbMXiM/evIr2Rh1LxZtX+CZwGoTuCM4YqtfunT6pzerk4BR+mKq7tYsuIqbfN
	 thNmnemNRzPDtl7CW8e/QZsZKO6MLnjE2ePxHsvNcKJLUF7EtnPal50uV+pTmr+IpdTFo
	 0Ss9za4t4oKW5rqMVNnQrYvAeMd1ElNLNLe6XrQgZb3dqxd5OAOEHCpuyQNVDtWNp4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i7zH5IKK;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C0F606A323
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:23:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36C0F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i7zH5IKK
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ada8bc2380so516697a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197404; x=1793802204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=alnKCsFxzyORsFsXKCIpyKnL9PTgktadfxwbxtnPw7o=;
        b=i7zH5IKKJ7SBUu17/XuTpK2eb/CPIFpHe1xmP9UpdHx6hlxiLPprhyPN/lJkP7FchN
         dACeyJnnIeGZVXF+Q173Tnogstf6yXMV0lmJh3yvcYRkxju30JB2sde02qJKEbiTEes6
         p8UoC+4LTpFPzGuC8ZK0yroiFP063Xqlvp6Vx/OdRTlqEFRjx/AalRcmwWcqg02djYBm
         UxphkjnzyunrO4SaUUeQqxlpDrKUlchwnLh9+UnFraZjO0mnpQEAjKJMir4p5h902mz/
         KGvtIyxTfIyEOj9DbNtpwGROOY5P6/5EuIttqDvtuWqtUyLXJpkzGFXHVlmYbDcyA6v9
         BJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197404; x=1793802204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=alnKCsFxzyORsFsXKCIpyKnL9PTgktadfxwbxtnPw7o=;
        b=WM2OzPW7q9Wnl8KGTabsmxDPjwx4Nxj+l27pP69XCH7sr4Bk2jE3gH/Q57/QCjvWlI
         K2XFtxJT5p1c8hGLjEvINJnoRcmeYAw3/3fCfzRzC6ezFAc1pEQyr5X8Z6tBw8mNNRzy
         9FezSBd53jJPqAV5HGl4Me/JDdOw8TBPsQwcnPaqJiT1HNuC6iLW5v4tNGguoH562AXH
         9LJeMol0rBdOfBaoylkvhk3t7tA1a9IvwyGz4HR8/QxIbhq/uyTmDr1Y4y+O3qqxWnrb
         20s+EjhHtoxryRs0qt/PZqIW+0UKiibIy1FQYrJqJ/HOwVwCi0zyxAhkH8UFuCfMpCMZ
         +20w==
X-Forwarded-Encrypted: i=1; AKwUvBwl0RGPzdVfav41wW12qXAZ+FUd7n9Eylev2Jbm5Nx0tNA3Mpj/wDboH+oI2TcDCzxNmX5GrlNLA/gSeVgWVQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIGa29NfShPJ/+ocsfqa/+EoYUiGMMjK00benvS5EloNIZMg1au
	ot8hZDRhbnK5HGCuySYy/+uT9mvNB5QSPYkMtaweNWq8GoqPaNQRbrIvn8wLxXT3
X-Gm-Gg: AYBFou2hDUuRmX0ZXNVSepUmW7JPuuWQVQkMUYfsTzz964OKK/tQ8WMpSpVDzEzbevJ
	f3zSSu3RiuneudItJAIcf+ztxLYnG4QxVHuFuLdJ1CN7/IVYj6ybIF/CFh/rA84qOW25v+c6HeP
	uCt9n2iI3RtAgv4l/ZMCDpKjAFnkrBrxLZ3Ac/yPp/5goJ1INtH0f+ACuPPqGlgPBhY25gHZwMI
	xcZeGr8UwDxGWMdCU1uF3T2GZJmoguS9cBRD+buMglmN+hXEp/WKsaRv8B1orpJV+5Nj8J4Bzo0
	nWIkfN+AUUP5VlEBH+S2QU0oGu+bXEehc9zH6pM7EwaLmmapSnoVWH0uLmF05VB/RgTfRmkTiX5
	Zus5Ogl4og/ym+DM34aSW9F+RXgpp5pqL2/fUxoEuIDZPoJ3hjoc2xyuGcXBWTa53r93+cyK4Qb
	JY9Ah2unhgHz06K/fmKRNYa2o6Ah9MDwDfW6CgbZ9rv1+v4AJ3Ukg9MytpX1vzw5dSakHk2Wpg9
	pVFlURmOZ2mylcc9AWSlFv3w68QEEQK0PLgyoVfJpFB5AiCy51fmG5JJ4+1a9+m1SHuB9K+d4eF
	+OQRkPHqnFjaLuvIjhc/KPdGogMJewbbhP/ht1DYyp1XK5/Xdzn+W6bwpg1vaB/0Dveu
X-Received: by 2002:a17:90b:2f4f:b0:3ac:a521:953 with SMTP id 98e67ed59e1d1-3ae58181a3emr1804006a91.46.1793197404548;
        Wed, 28 Oct 2026 07:23:24 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a501083sm3773918a91.8.2026.10.28.07.23.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:23:24 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rostislav Lisovy <lisovy@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] wifi: mac80211: recheck the OCB station limit before insertion
Date: Wed, 28 Oct 2026 22:23:01 +0800
Message-ID: <20261028142302.16634-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028142302.16634-1-enderaoelyther@gmail.com>
References: <20261028142302.16634-1-enderaoelyther@gmail.com>
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

Frames from successive unknown OCB peers can make the deferred worker
install more than 128 stations.

The receive path checks local->num_sta before allocating each station,
but pending stations are not included in that count. Several allocations
can therefore pass before the worker inserts any of them, and the worker
then drains the list without rechecking the limit.

Recheck the installed-station limit in the worker under the wiphy mutex
and free entries that no longer fit.

LLM assistance was used to find the bug and review.

Fixes: 239281f803e2 ("mac80211: 802.11p OCB mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. The
insertion recheck was not exercised separately; the two-patch series was
run as described in patch 2. A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 net/mac80211/ocb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index e9bf4ba3e60b..a8dd4f4dbf70 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -139,8 +139,12 @@ void ieee80211_ocb_work(struct ieee80211_sub_if_data *sdata)
 		list_del(&sta->list);
 		spin_unlock_bh(&ifocb->incomplete_lock);
 
-		ieee80211_ocb_finish_sta(sta);
-		rcu_read_unlock();
+		if (sdata->local->num_sta >= IEEE80211_OCB_MAX_STA_ENTRIES) {
+			sta_info_free(sdata->local, sta);
+		} else {
+			ieee80211_ocb_finish_sta(sta);
+			rcu_read_unlock();
+		}
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);
-- 
2.56.0

