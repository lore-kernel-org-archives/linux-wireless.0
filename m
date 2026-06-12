Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801D03859CE
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781270345; cv=none; b=ol7+RK3+HAjXFxQpwAuNPNs8VjfLwLrOpxaqAEFcGom0uNaRrddTaC7yiSht3rIJ4n2Oy+q38nFiTrQNJyT+sAWaAzybR84Xr9bIk32sYNj4tBlXxlBWyDEBAVf7qhUW/vCBS6NmYGKEICwYk/+5drRuPVj2JyqrO0m9cFtFNNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781270345; c=relaxed/simple;
	bh=dQnVo8lNYu4xpPQLTXxhW7sL5FzlYGqTsz+uxrdY8Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fZvjXil0rmj15pfJtlMwKSo8k9fLWuV/KbS7evIedR1l5fsE7v1DXlHwECaS4g+jIuhDInlbFsb+eOWAt1rktnMh/6RRY3+YwDNS0aIOqsWfBg46mYIKJIyesGi7BkEmCsrZW09jrVHtV1NePBvATKjmjUsN18396mD22ej9Jus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZQ0DzEd6; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQ0DzEd6"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2bf2247e38eso9391875ad.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 06:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781270343; x=1781875143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9z5jaJokdbimHtXlGzYNhQuuXCJh036DzUL4Wz+Qe14=;
        b=ZQ0DzEd6Ku8mHLQYaepheY0HDKhW0LO6c3VDqHq/Put3+wVEkHEPef7im818CGgpyA
         ocvt34ciJcWaifpXDpR981sukJJnEyp6aYqfa/Us82sYp3pPEYMa/3cS9tKq1QfqsasY
         80OXaB/GDcQf+KPl4i08oXQt6wGVq3pAGxgGT9sD1Kg9vrfX9qb2+sYlwwJJOTG6a+VJ
         K1o+YIrogfGskFWTUfS2LJmF6K1UqlEjJCuqw33MFW14Qzsx/DENVZ6i6LE/xvdiJ/aH
         XKD1ImkN4b4Oq0nCFEKEICwGCkcn5uaii4YoX0jQSpp7GSAxhPWqmxhIKX5ZhsXlyn2L
         DutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781270343; x=1781875143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9z5jaJokdbimHtXlGzYNhQuuXCJh036DzUL4Wz+Qe14=;
        b=ftTS2MuuzQpDhPlu7HkPijtvY4INdnlhiGORt4qlmB4QtUxdQ1QcHUKKsJrV8zOy3n
         V+nQmioTE1esJ2CZky9mb+r2jSF2T1W0LLoXYxN+B4ROFkoelKew557hHtoSbUxtX7W/
         S2PCNR6ps07ZdAiXkR5H3PA9+N/14asFAHdQ9raiP6OLZvfibqhO1ONvKNBJ9cOsitFT
         iEJgyw0HCu2He2JkkVXcfSRVaxOtF97QrcESC8GZJygQNlsB54YLtoOVhbzcWb5Ggl+Z
         g97CnglpGbPIkqtYOXVvV0r+Z1u90j59FPPHHdncI5USrE4Cf35b1eSGtkh+wGGup7oI
         qvnA==
X-Gm-Message-State: AOJu0YxribXesUKeNQiL71irPkPK9OYGwRh62rbQk4/uOv9afqcpQov0
	XNAgtCBgIjzwSP6Ts77Aa5+TR6VY7+TIqSgo8eW0eQMJQUn+/s7sjPpU1r1AzBU6/JSNwA==
X-Gm-Gg: Acq92OHDST0ehD7Xj4kVRqZWBzPCgb6wyvmpFqAlE3smY/ux5lUKmh8db4lmKzAa6b6
	TDAkeXOLmQlj/tl3fTNvGhprwoYi85l2Oamg0BFeAoNPU/aQczRNJlanHaaD3Nk4McLDkFmlgvb
	ml+686JXADu1SvGGEZXMi5+O/cKpU8iXoSVh8lcsxuk9tY2Ei4FdKnSZjo0m/qiXo2ahlxqqsJD
	cSTXCo1gNLWU2WJz/oBVZCwufJ4K4IjaDml6FaouTWja1cd92YsE3Yqm/Dmb5ZThNi4IMp3kn3G
	cywFUrCipx5dHNcxjhxBBbWPjcuIcXknwg2so08mFf5C5aBpwrbhPtSne1bCYtbPFeEvPArbJGr
	QPgqapeup4S6mF8VrfVgRy9RZh/HfDjGSRmWWX3iDcUNC4QuOD+fURn52R+uQkKYB94Oz/xTQOK
	6vJIuQfxJdiWGz8je030IEhjhwtnVHFXEgPhR8lSMC4v4+kYUGIP0qC5o8KvydmWs=
X-Received: by 2002:a17:903:4587:b0:2bf:2e93:c624 with SMTP id d9443c01a7336-2c41284101amr35137785ad.27.1781270342888;
        Fri, 12 Jun 2026 06:19:02 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c43345e604sm19923585ad.74.2026.06.12.06.18.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jun 2026 06:19:02 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	John Crispin <john@phrozen.org>,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wifi: nl80211: validate nested MBSSID IE blobs
Date: Fri, 12 Jun 2026 21:18:55 +0800
Message-ID: <20260612131854.43575-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate each nested NL80211_ATTR_MBSSID_ELEMS entry as a well-formed
information-element stream before storing it for beacon construction.

RNR parsing already validates each nested blob with validate_ie_attr()
before storing it. Apply the same syntactic IE validation to MBSSID
entries before counting and copying their data and length pointers.

Fixes: dc1e3cb8da8b ("nl80211: MBSSID and EMA support in AP mode")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 net/wireless/nl80211.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 76c537a6e8b52..2baf1bef0bbd2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6321,7 +6321,8 @@ static int nl80211_parse_mbssid_config(struct wiphy *wiphy,
 }
 
 static struct cfg80211_mbssid_elems *
-nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs)
+nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct nlattr *nl_elems;
 	struct cfg80211_mbssid_elems *elems;
@@ -6332,6 +6333,12 @@ nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs)
 		return ERR_PTR(-EINVAL);
 
 	nla_for_each_nested(nl_elems, attrs, rem_elems) {
+		int ret;
+
+		ret = validate_ie_attr(nl_elems, extack);
+		if (ret)
+			return ERR_PTR(ret);
+
 		if (num_elems >= 255)
 			return ERR_PTR(-EINVAL);
 		num_elems++;
@@ -6503,7 +6510,8 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 	if (attrs[NL80211_ATTR_MBSSID_ELEMS]) {
 		struct cfg80211_mbssid_elems *mbssid =
 			nl80211_parse_mbssid_elems(&rdev->wiphy,
-						   attrs[NL80211_ATTR_MBSSID_ELEMS]);
+						   attrs[NL80211_ATTR_MBSSID_ELEMS],
+						   extack);
 
 		if (IS_ERR(mbssid))
 			return PTR_ERR(mbssid);
-- 
2.50.1 (Apple Git-155)
