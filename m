Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993047;
	b=S3ia+g+rnRu0H5Pni1owrWRoSsHRkjGL1/gvvy2XvAd9wA7rJwUnSZ3pJs6c8IROv/Vu
	 cQWGzd4e4W1u2D6evAjb2MbEwjGaG3+kwE/RQmtPkiSgrieCSw2wCOg9WDb0CkHLgekt6
	 vBieNB9x2MQxJ6QFqEk7Nn+AXVhAaxU0pRQtQP2GSSVsONqacMrm0WroUs1Mb61WeBv2s
	 rsxEzjwI5b2TuN1F5w1BV3q8b+0QauqzXKfsta66r7Fvy83qHWV73j4iLeFf9Dk0x2fIB
	 Klsa+2V9SkMhD1aqqRmhwhCdpawC0ToZRfpl0cCTZqGda2Q0BVrFKJP+Ah3az5Nk6Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993047;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cdjemExUanYI/hEJuo3YfwdKRJvOmxKb9CCJzMVOt5M=;
	b=ucO4vwzgk1NFtQlQGRnOIzkp09NONPlnJ3hUIeOH/+mEkjjc+pu4A9HuEdDL+zsA2SuU
	 ZNx+EQ7qSsHS32TOknnQhgR9gOEAe/Sg9NsBuera3nGW3z2eLXFgFggtqK1M/kbD/65E2
	 oQjBDUpTc4dTvBPMQZxtcCnqGxqqrXINrBbQ+6kPNkUAOd3riH5vsN521208BJkNkVAwY
	 TTbQ3VXeozdIEI47cVVC/g4PIscnmohXrYg9XblrNwDaBHzIaRJYkOcCZO1CNp4hFCNRN
	 IjLteZ8UqOB0a9nlCv5HDfZb8WuN3DBjAuBWgosIiBYUrN1df66xVevQsap5y450m8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eMqiACDE;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB60D606A337
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB60D606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eMqiACDE
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a06b436dffso1172688b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993046; x=1793597846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cdjemExUanYI/hEJuo3YfwdKRJvOmxKb9CCJzMVOt5M=;
        b=eMqiACDEGwBmfzTw8w/a6w84CCEaDMUvw0eFqNu52lB81TmgZ7B6MCf5/CW97oxu5N
         D6wVjwGech55e2Boft+dFclJFKKD+rTra2lDg18N2SAHwyFGD0+kNOrmcwb5ReNRvrSj
         2KnYPNsqigvlzrOCgq+w3KaRiUb286HYdnFS3bRh9oFMzN5mQ1AqelMaMpcSa1s8X+6p
         iazvsVkLnrJLO8zxpEjx5rqkJckqMDG5OPoz4CUKn5BkNmDJRfl9Qt9v9DScScfAR3iy
         /+UZGLSDjQIyNjp+cMxJ5Qpkmtq22Tm7b+rV2ipwt0xc8L6vyLkeGnyQPHG7VfglmmkE
         /3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993046; x=1793597846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cdjemExUanYI/hEJuo3YfwdKRJvOmxKb9CCJzMVOt5M=;
        b=UUSe7jx/r/CCy+sCcx5SNB/orELLVEOZNr+sZL9Uhtaolsoiq0yIetyu0zPCn8e04i
         DqDLqP9i0JG/LkRhSgiGn8yxyDnXIfzkrnJjc+7Uvq9Gs0PMnRf0oo0Odc2XKNxDR4VF
         s9ocxeG/2wkoKU/cyC0CBM3fCiUHYW3w0fxCAvFVWCBgyI4x5sHtnb0qx56jeL5g20sM
         IwHIZuMDM7odoVE5sE95U9uGi4Q/5ei1s2NBUAq/ZuZqkADQH3mPKg6/yWchGxELRQzY
         X+TBfM3jIStBlZ15wkLVaHWgTK6t7emZH/4nrP2JjRiVjX9W58QyHhsRvhuoGf0hBklY
         ucVQ==
X-Gm-Message-State: AFq9FYI5itaAgFm/x0tKfqNsXy3yDd+k/Pbe5GKqgyfQMk5BJuQfLCMN
	F5jcHxTyoIsCRG26tj10R7pA2J4u17px98rMbCGRBUavxquZ+mFLv8DCozP8Mku/f71cTw==
X-Gm-Gg: AYBFou0KTMiGMMyNTYZPvTB2wpjK18nbIJ0tpxxf9mTvmNi5xW/4O7JXZMsJ2A5pVLT
	ATeL27C4MsiSMMIOr3dQa8VvcojXxoz9f3WDo18eNdGwp6NAn+lSxt2o8+eM0UodN5xHZmXNlHZ
	Ep9wRDHgbA3gWEPEfY7tV0CUrS4JmCscQ0dpEizaYWnC/RK8z282IE4GqipF316ZLn1a8SQ2dFK
	xQtK9JpUJkoYSeEwX8fyt8qZSah5x/BRYR3veEwUyJgYQNtyWy8zXsBDEgLPx0AGQiTJpqI1/I3
	Vbnxm0wJ90xU919t3h1bZc8Vq2vBbGzl/1eN38ubKnfsZ1KwUG0d8rJC1op6QYgL3mw1HLIwNPc
	lT10HnI/FPuRPfm+c0+C6nEWpq8bBXoO6EupI7rXmJB2+ad9jsjOYdldGaYkBe2ySUu6VeI+NPb
	+5jaI3i0zZ/H4al5ufAGf0i/kFi6kLzsehp7FrptKhVlJxcW5Gg5WgBvMetiTZ8wa1MWo/Q3C9E
	XBgIuh2Oaqqo4SZN2YtB58t4aaow2IgXjtqmr4rBICHlhO2F/OXTGVOfr2PThGBbYotMrG01+3N
	/0VG
X-Received: by 2002:a05:6a20:3c8e:b0:3e2:b295:7678 with SMTP id adf61e73a8af0-3e7bfe01e08mr4900297637.50.1792993046052;
        Sun, 25 Oct 2026 22:37:26 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:25 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH wireless-next 10/17] wifi: mac80211: export ieee80211_get_bssid() again
Date: Mon, 26 Oct 2026 13:36:16 +0800
Message-ID: <20261026053633.361454-11-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
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

Export ieee80211_get_bssid() again in preparation for the
new driver.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 include/net/mac80211.h     | 12 ++++++++++++
 net/mac80211/ieee80211_i.h |  2 --
 net/mac80211/util.c        |  1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a1a6409b4..607369e32 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6166,6 +6166,18 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					size_t frame_len,
 					struct ieee80211_rate *rate);
 
+/**
+ * ieee80211_get_bssid - get the BSSID of a frame
+ * @hdr: the 802.11 header of the frame
+ * @len: the length of the frame
+ * @type: the type of the interface the frame belongs to
+ *
+ * Return: A pointer to the BSSID within @hdr, or %NULL if the frame
+ * carries none or is too short.
+ */
+u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
+			enum nl80211_iftype type);
+
 /**
  * ieee80211_get_buffered_bc - accessing buffered broadcast and multicast frames
  * @hw: pointer as obtained from ieee80211_alloc_hw().
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1a6cbbb5a..ee3a49321 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2968,8 +2968,6 @@ ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 
 const char *ieee80211_get_reason_code_string(u16 reason_code);
 u16 ieee80211_encode_usf(int val);
-u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
-			enum nl80211_iftype type);
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 44feb8027..182b41db0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -104,6 +104,7 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 
 	return NULL;
 }
+EXPORT_SYMBOL(ieee80211_get_bssid);
 
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 {
-- 
2.53.0

