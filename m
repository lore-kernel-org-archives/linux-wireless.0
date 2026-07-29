Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB1E2E03EA
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785291287; cv=none; b=cx02itNKo5YzYvt7ikS4VS+qZpS3TUPbu8UQVBSmAizZ8tvEnqOIrcQHx6l+GKzLtdFOVoSIVkD24PywgcceYrc1j8RB+uWmaR0IT9SCHUd6sNRg3QwTH+2SWYj5FbjxLtKd9V+Yq0XaNENkr93XRmm2b7KlULCC9sQ80y5+KnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785291287; c=relaxed/simple;
	bh=1R2vTJFmqsTU0x06PRZkv1w7HMSkW2PhQBuyeuPqwfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p5zguHAduQ23vrQqIeNotNLd44t6bY/wxYXHSw/cGMLFSQALKx5X7F0QuGgLuTiCn290ajL7peBENaa95ZGHDXNd/sNstCEo95FJJaXLid4Wg0ugkk6kOCZTN5g1E/aHD5ZMjDU8t0OY+B9jQOWA3oZ3B6jNqF+J+a1M31o/XZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EMlrm8rx; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EMlrm8rx"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca2fad0ae38so286283a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 19:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785291284; x=1785896084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rbUCrmdI/D1+7MliQyPPx7KnkhrNLA9n5yUnvCZwLOA=;
        b=EMlrm8rxjrauYw/anU/BAxhfrubezsdX1wc6n+VEbn9ThjG9IEtM6IF40r064vQmK/
         UJuOGvrTdhz1SWuVSRdzGadPFrmYJ532fYtTNeOKTvG6pKbcalj/OHlxXans0z7RT2g0
         SQqi2G9rzKiGXRj+riguSNoGbM74sdYV3GXCUHTRqA+kYIVsXzQddPV0lNaLqt+8lqJe
         jR5Ifu7BUSBHc0preisNS1zsi1CQH7Au3bIt/85zJFfHWjW+yRJP9fdFfSAp2F5mUAQB
         oTjVz9sMFu26V8hNiuBSuj5M4KwRsrCWTvoNY1n4R+jt1IFOsrF8ofSsPGKdT4m5dhgj
         8XHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785291284; x=1785896084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rbUCrmdI/D1+7MliQyPPx7KnkhrNLA9n5yUnvCZwLOA=;
        b=ita5PWx5n2v/N0vw4/y9G1W3n2PE1CxI0G+GnxUmBHm8pjiAwllb5sv7kty6BupoLc
         hn5f4HQz5YUqunBi1PHjRWeDqeyvVm5NQc0eguI7rXO3Et7LwFZ67n7Rox9qjmZKHfM0
         ci62s827GOEv1uKMydBi6I+3AsRd5+mD/NHB/CVUyV3lS1+vo3gvs+T/FBjEiWdzrX8r
         4PAPz3a3t34mTpGgSvP4w5ghZIgq9dGNpUW6lxkD5mAFnhJvBBmgIxebk+tGB8OHTCSH
         6L4L1EY87yPubqfm5Ph3V+/CKe/aR2gNFdHIKdrv+QVFbJrYltI+1LG0USRAB3PEW2mZ
         3Tqw==
X-Gm-Message-State: AOJu0YxY8x9dZABEZYM/kAvFtyh2ORNc9mCJWhjsLziZgrHwMnvi8ouX
	8jkJXN9JABNDaAvBOMpu+SVE/gY0X5pV0k9YKqiVkqENld63a0hpSROy
X-Gm-Gg: AR+sD10d01cpsUiQa66xV8Iuipo126LZZXkh5hkKAkQK9osReLQD5s3JTn/YYFEX7Rf
	15xnu3r0YUgwMZq94hMfD/OjI34ImOviKqPqAR4S7pezji4pZglhgjQC2TgnQsjWG6TyMuuf8WP
	Ai/SoVu410PF/KOu0cNevWPlbNw8AJgkhmC42j20bzeGiVaajpxqupwH8wghVwas6XTxTYOn1xs
	X85eFWQ1QcdcHN1ZXnWyhto1/8ccMIqeBIwNht3q4vdhVXNHSlT+S19/BcT72/wpTtkjg1nx0mz
	93DRFp+PLvYTcrgGN04+yDrmTdBf2/egqpPudARa7IC/OUqkt3i5i3GiePOHtFOrrpfAE88kFGw
	wNoF/rBKgWXfMgkDHT2mSzbEP9J2Vfy05QYv4Ff9FrdxRPY8ZOZt+aoHPB6slUTpuaj3hrm4APs
	yCyZ30VukRWa0GAsy7tlg7fLbVj0eEczER2QO1oaS7GyvteIprxrOqBY3QEixXrivHebdeIRXOx
	VGUNyubqytwRa1GUgUyhcL6FxgmaPUvltdfhTvmdvo4
X-Received: by 2002:a05:6a20:b40b:b0:3b3:2703:115 with SMTP id adf61e73a8af0-3c8aafda28amr5599473637.16.1785291284393;
        Tue, 28 Jul 2026 19:14:44 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:383f:4684:f08f:7d61:c1d3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504d3250asm3536485eec.20.2026.07.28.19.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 19:14:43 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: johannes@sipsolutions.net,
	jeff.johnson@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Subject: [PATCH v3] wifi: cfg80211: add cfg80211_validate_ies() helper and use it
Date: Wed, 29 Jul 2026 07:44:36 +0530
Message-ID: <20260729021436.19909-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KASAN allocation trace shows that a malformed IE buffer is
stored via SIOCSIWGENIE (cfg80211_wext_siwgenie()) without any
validation. The crash trace shows that a subsequent SIOCSIWESSID
triggers a connection attempt which calls cfg80211_sme_get_conn_ies()
to process the stored IE buffer, causing:

 - An out-of-bounds read in skip_ie() which reads ies[pos+1]
   (the length byte) past the end of the 1-byte buffer.

 - An integer underflow in the memcpy size argument when offs
   returned by ieee80211_ie_split() exceeds ies_len, causing
   unsigned subtraction to wrap to SIZE_MAX and triggering a
   fortify panic.

Fix this by adding a cfg80211_validate_ies() helper that uses
for_each_element() and for_each_element_completed() to verify
that all information elements in a buffer are well-formed.

Refactor the existing duplicate patterns in validate_beacon_head()
and validate_ie_attr() in nl80211.c to use the new helper, and
use it in cfg80211_wext_siwgenie() to validate the IE buffer
before storing it. Return -EINVAL if validation fails.

Reported-by: syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cc867e537e4bd36f69bb
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

---
v3: Refactor validation into cfg80211_validate_ies() helper and
    use it in validate_beacon_head(), validate_ie_attr(), and
    cfg80211_wext_siwgenie(), as suggested by Jeff Johnson.
    Remove redundant ie_len < 2 check since for_each_element()
    already handles that case. Fix missing semicolon after
    /* nothing */ in for_each_element() body.

v2: Use for_each_element() and for_each_element_completed()
    instead of open-coded validation loop, as suggested by
    Johannes Berg.
---
 net/wireless/nl80211.c  | 15 ++-------------
 net/wireless/nl80211.h  |  2 ++
 net/wireless/util.c     | 11 +++++++++++
 net/wireless/wext-sme.c |  3 +++
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5adcb6bd0fc5..27bbaf916574 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -228,7 +228,6 @@ static int validate_beacon_head(const struct nlattr *attr,
 {
 	const u8 *data = nla_data(attr);
 	unsigned int len = nla_len(attr);
-	const struct element *elem;
 	const struct ieee80211_mgmt *mgmt = (void *)data;
 	const struct ieee80211_ext *ext;
 	unsigned int fixedlen, hdrlen;
@@ -259,13 +258,8 @@ static int validate_beacon_head(const struct nlattr *attr,
 	data += fixedlen;
 	len -= fixedlen;
 
-	for_each_element(elem, data, len) {
-		/* nothing */
-	}
-
-	if (for_each_element_completed(elem, data, len))
+	if (cfg80211_validate_ies(data, len))
 		return 0;
-
 err:
 	NL_SET_ERR_MSG_ATTR(extack, attr, "malformed beacon head");
 	return -EINVAL;
@@ -276,13 +270,8 @@ static int validate_ie_attr(const struct nlattr *attr,
 {
 	const u8 *data = nla_data(attr);
 	unsigned int len = nla_len(attr);
-	const struct element *elem;
-
-	for_each_element(elem, data, len) {
-		/* nothing */
-	}
 
-	if (for_each_element_completed(elem, data, len))
+	if (cfg80211_validate_ies(data, len))
 		return 0;
 
 	NL_SET_ERR_MSG_ATTR(extack, attr, "malformed information elements");
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index bdb065d14054..8322ced6b551 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -129,4 +129,6 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info);
 void nl80211_mlo_reconf_add_done(struct net_device *dev,
 				 struct cfg80211_mlo_reconf_done_data *data);
 
+bool cfg80211_validate_ies(const u8 *data, int len);
+
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 24527bf321b2..dcaa5903bcd2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -3083,3 +3083,14 @@ bool cfg80211_wdev_channel_allowed(struct wireless_dev *wdev,
 	return false;
 }
 EXPORT_SYMBOL(cfg80211_wdev_channel_allowed);
+
+bool cfg80211_validate_ies(const u8 *data, int len)
+{
+	const struct element *elem;
+
+	for_each_element(elem, data, len) {
+		/* nothing */
+	}
+
+	return for_each_element_completed(elem, data, len);
+}
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 573b6b15a446..1476d933c7e7 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -319,6 +319,9 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 		return 0;
 
 	if (ie_len) {
+		if (!cfg80211_validate_ies(extra, ie_len))
+			return -EINVAL;
+
 		ie = kmemdup(extra, ie_len, GFP_KERNEL);
 		if (!ie)
 			return -ENOMEM;
-- 
2.43.0

