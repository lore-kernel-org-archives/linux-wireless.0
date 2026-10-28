Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197383;
	b=PI0ErWIpw3S8EHVRbaR03bg7HPfEjKVOviA9Z9CuYu28Muc1LFO0QmNxr8GBufj2q5am
	 GV9/XphD5eUGjiXE8BBr5vE8aVPbVWHVHmfe4d+Z35WmSJrhZZ8Ew7+p2YyH142crpRz9
	 kgavXpJ1kxcv9r0oWQg8j5t4MYaSVU4xbk7OMdj3PPUusQLif9XSwLtkS9VkUUifTah8R
	 SzPLsF8x9wIiLDeCL3gUnesMf1v2UxKZZyg/sGZYvgaZQnD0sYg4jWiUNzcrHb/ZxCcxw
	 ak1CsPIKyzmzJSYvTKO2a5MBqUdPd06GeG8q6bGen70fJFVRsNMwqe51vDsEs5dQd6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197383;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2EjwqmUAG4LVpCIBaqLuA4imatC8t7BVaBsfJCHKdeI=;
	b=q6+PIaR6QiKc0q+4jq9cbWnF1KUG2rZdLevdLq+ImsmwPl/eLuwpgk8y2oHb3Ru8S1v/
	 jDHNf++FVBSTuARDYDxbn2NbM+bxPQwywucB51kRRnHxYwuzXHoI/KjpSS1N72ZWRu+ZW
	 6s8RHSyswA+JPGwWhjpT2Rp+g7iI19skIDF3bDG5ExOMe06boq/3WPKd3TIttJ0lm/cn/
	 +GVupeYfnCjGDyr+8rniCz5TBIbBl4vkQsBxLjXPdGPY/7F7KFBE1IAGdCQjUpUr5g2NI
	 Y34oQ91WPmgpR/lcfSJqYP7rR5e6+dSuQ1py2iIn1c0xjjkUASYhe3m7G7XDMZ8LsHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WTvJrCSC;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AC4606A326
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:23:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11AC4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WTvJrCSC
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a070b3f44aso482240b3a.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197382; x=1793802182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2EjwqmUAG4LVpCIBaqLuA4imatC8t7BVaBsfJCHKdeI=;
        b=WTvJrCSCS5fiZvdk5coryFKio7Svqrh5ARAM/N3GbSRvPoDa2woYMG7vyYstYCZplJ
         k7fS3rAuRu9410kE3ITExIHLH4rl1XVvrguUGqSgj3Cd5W6N5Y5qQuG/fqAleC+0g6oW
         YZy6UipYhbYzZNc8/ylnpQeTuDWnAu5ZIYCF3DTqz3RHiZB9eeO/TFKA3m4sNua0ST7z
         7b1TXpm2r+Yk6q/RwVrUlWxQp0BZ2WYpl5Qlw4JP1d0oAM9NZzqNWXyaW1kDY2/96A5F
         UJWBCD/nAwks0yEZwmYXf8G312w9vakk8UvlFDQldpGsq9RrlJlZ/xuFdNQTBSidRu8/
         dEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197382; x=1793802182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2EjwqmUAG4LVpCIBaqLuA4imatC8t7BVaBsfJCHKdeI=;
        b=SJnpxCBh1KX3EuqBFFBha+y3kNLyhJeYC5azi78RLiuogxMllcwkvADPjGiEJl6vbJ
         ChGVCHBrbPvW3CkiCTEKVp99u01Odmt/qj91n1RDs2UfhemVo6328vcn6v8qr5IkUBHR
         MVs7OhSpS3x/iMYs+nn6Eso/QdZH83j25zv0vSodI93w7wUghwLnkVrQZsT2D1Q2iuIB
         0J70bxfRtvw8LbymvIBX0/NGsq38bSbZ33ItGpmQiafoGrY7a0D1P/7CgBfPswaUuo+O
         TejoX+1fAENm0R+DOlWW/AsROihHgFgEC8oc4ZiE63wxpe8Nl0BykieL5U/JLwzetXYJ
         p3hQ==
X-Forwarded-Encrypted: i=1; AKwUvBwrXjEgAxnYUwUoft1+iD4ngQSQET6ca9QxzN5tvdivH/MYUzn4eKt6/teVT9aeI9h5Laj4SCNqp8w/9oaOBA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLUQrY+vy/IO5JMiImbQBj/KODc7lYM5MVnCjlupTF443Vu3jf8
	bOyytVLuZ1Eqw1k0RTjB1IQ+B2Qe/619CfbBW5rBMT3BYQw1IIMdQX4A
X-Gm-Gg: AYBFou276qCdV+WQXlHPUo3pLJCGAFPUSg6YDzl3cxISUISsXhV6WcQkQjw6pSju8h3
	pHTTYzEWaDsQOtzjgC6NVus2FS/JLssvDVn8SmSy/yX77iFMGlJ++VN6BAfMyGJe2IYA06r5cKc
	O+0ZxWxU0WeFe1o2DwJPlo6hnDT2QImxM+aQbgEtje6l7OxCgutzzZux7CnC0spg5X+Ze7mi7GF
	fAWb2vmjoEpnNkHcZzUqwdkIjQ3OrnpXJvk0Vq/WlmOZzFowur44BvGETpJWy27nTDfdj4K++DV
	J46CfpBNddyBHPk8efjjSY/urRpBYdt3IqJHFk+zVyR1onn6k3w8aPCaMOHHAetFzuklfyOttCB
	Cdj6GfRhN/86RFkPRpBR+B21n4S9gQD1k0K6ScN+5H5COFdKveOsRtyYMs69+AJJ15/vanSuZ4G
	gkJmMVMKh66gfowjlqVoaBu87IU5Z6edAZFjIP8lKqnAJ77FzMNYMH94ZC1BIn/JsjzMNDVzr4F
	fyWRZ8ayjQLcOZP4nRGgBTMs4YCNGSIwJQFmATA/s1IrClY9zTy4An8BVTjW6jTwLtWyERtBl+5
	EeL+KSkx0S6dHbb/4msLf7opPt59W+NbImR4gTpz9RywprBfcxb/NY7NM6NS+aBClSxr
X-Received: by 2002:a05:6a00:b56:b0:899:394d:2976 with SMTP id d2e1a72fcca58-8a6e78d158bmr1990970b3a.39.1793197381902;
        Wed, 28 Oct 2026 07:23:01 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a662ba00sm1245181b3a.23.2026.10.28.07.22.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:23:01 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] wifi: mac80211: bound pending IBSS station allocations
Date: Wed, 28 Oct 2026 22:22:35 +0800
Message-ID: <20261028142235.15428-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028142235.15428-1-enderaoelyther@gmail.com>
References: <20261028142235.15428-1-enderaoelyther@gmail.com>
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

Delaying the IBSS station worker while frames arrive from new peers can
retain an unbounded number of station allocations.

The receive-side limit counts installed stations, while new allocations
wait on incomplete_stations until process context inserts them. The list
lock does not cover the interval between allocation and list insertion.

Reserve one of 128 pending slots per interface before allocation. Release
the reservation on allocation failure, after the worker inserts or frees
the station, and when disconnect frees the pending list.

LLM assistance was used to find the bug and review.

Fixes: 8bf11d8d0811 ("mac80211: delay IBSS station insertion")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. In a QEMU
hwsim guest, a 2048-address flood left 293 IBSS stations before the series
and 128 after it, with no KASAN report. This is a resource bound, not a
memory-safety result. A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 net/mac80211/ibss.c        | 13 ++++++++++++-
 net/mac80211/ieee80211_i.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index bd7dbaa942fa..e7d69869772b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -680,6 +680,7 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
@@ -1173,9 +1174,18 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
+	if (!atomic_add_unless(&ifibss->incomplete_sta_count, 1,
+			       IEEE80211_IBSS_MAX_STA_ENTRIES)) {
+		net_info_ratelimited("%s: No room for a new IBSS STA entry %pM\n",
+				     sdata->name, addr);
+		return;
+	}
+
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
+	if (!sta) {
+		atomic_dec(&ifibss->incomplete_sta_count);
 		return;
+	}
 
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
@@ -1632,6 +1642,7 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 			ieee80211_ibss_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9374c2942489..cc0d02ca56eb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -682,6 +682,7 @@ struct ieee80211_if_ibss {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,
-- 
2.56.0

