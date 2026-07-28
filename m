Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD762C11CF
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249962; cv=none; b=bTiSSxyY2vF9Iq0ahQXr2Vp8ykM33MwHpgL5k60nlnc51aJ2dSJkTCMwAhY6qAzapgnzoDiF/EKAYM5S3h2yKAbP1C4Ga14NlhJKR+AdFPA6u11jIu84w4vkIMdziHSsFFtn9VrmDRBOxLBAyjqiFt1ICF10s9pFWF2QjnnpC5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249962; c=relaxed/simple;
	bh=BD6HkR8+ixjVZGr4BNZE3aZpvN45d8J2CJ00o01dUFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tci8Kazy3UWB8skS0erqGDZC868NFil8TvGKijhCrhvoQaxvHDb4fUv8NiRXINgtLVzO6jB5/wqA66ju/n0m/aNVanhaHKCt1F4EOEVsIu0BK4BNvzWhpauVJdS2rRRA+jAF8Zy3POQwfrgO1TZ8qGurzL5Joj2K3Hhz2Gc/nKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=etr/WPeR; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="etr/WPeR"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2cacf197759so55733375ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249960; x=1785854760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Z+rUEPK43VSdW2Nuxb3Yc2SpJSACoEL0UZ3g3JUyDo=;
        b=iX5sCxgDJAjENlNBVrhqE0nxzBgqb+Cq2q70OAHJfkoQNi3AyEhW+LiHw0fOWzgg7S
         VPMjsj09gQ8o2UrQkCgbx+xcv3zLhWT1w8qOtZ2ywfC6gTaR7Tieq8YvVcWmXqT4YFv8
         z7fCSeSrFW0M2/6qZJEXEngnoACTxAXttWTKLELwHv2NGLoqLv7/qD555tFyJpFj4yE4
         sXCd3HLpP6rE1ybR/w5fBDyahmp4V62ICDlbdYFBcODFt3ledoC8shIIbdd+aZPFVGUU
         xPvPWwjSiZHc4fJUrmqVPjj6StIPk/AVWvlR+hFioI/kzSDhZYQi6cBJcWj2Q96A9zEC
         p2HA==
X-Gm-Message-State: AOJu0YyHYoCbrd3xjZ9q1mSoHoDb27U6KXma7PwkYohNc2m/Pz9C3qvS
	pECWAKPZYLXZ+xQyHV6737RXKe/Cui1Q3qQKGcEjbuJZ+hclF7RMHGMuNhIu97fHiRsTQTZV9D+
	CQdhLTTAuIDh3YMWHdAVOCQiRyVZdF8gb+3QZzRPc/bBrUzg0aeychykde1eWZWRcvqV8zE8TTr
	Pwbg6/VhqwxrPMupEQ0VzclBep0x61l66Ko5Q+R9SvYdkLvp2YxipEx0jV4OA5CxM2gPUn3qgPF
	AfTf7lx9CbNehuY8ulxg8KhIE2N
X-Gm-Gg: AR+sD10Lm8MfN9uLfcrb3/CZgMfbCous9kkROgdZ9VqBl5XLch93VGE6bzTlLUtGYWu
	qh6kw6yoAbdxVgT/MM40ZkFRIM5/RYU37xN/QnQF35BMZbzkxK2bRfygqYq53MNzb7FM2qYyUA1
	LJw66thqqu1P3RpXH0sqJSIJkdHya72AA6ADnQJeSRSmPHcuxKi7eX9LKmJsKE5mGSXJYGWyKJf
	1bGkffFGugv6oGw57XfmtLvCd5AZr2HNW5EytTtMgRYokf3FMticiRcgodM+MkL0AFeP5QLY+oR
	FbCVbWBJQ0uFJ+1oKCFmyeUbqznOKrzLDADdi6m0LCQTDn9ywQHlTAUJXvPGefsnTCtCQYFcso8
	R2Dk+QyoqmAth5IpIO60mzT0Oc3zGjM7LbPtd8mh9YE0HVO5m7pvMVB4We3hUiRReXCk28ppX3v
	BF7CDprRCybiIfN+H1cBCBWEFX9ZroZBlpyrGZTMc=
X-Received: by 2002:a17:903:38c7:b0:2c9:c46b:1286 with SMTP id d9443c01a7336-2d015f39404mr33654165ad.34.1785249959784;
        Tue, 28 Jul 2026 07:45:59 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cfde5b557bsm11106315ad.17.2026.07.28.07.45.59
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:45:59 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-930a098ea19so437676785a.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249958; x=1785854758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Z+rUEPK43VSdW2Nuxb3Yc2SpJSACoEL0UZ3g3JUyDo=;
        b=etr/WPeR4Mt/f+IScOb15AHJKuTZwyff6xFi3guctb6MyosuN1UjaBfFz+n/RaCCLs
         sUjmacLNz7xzOj16WGsM/bm9+dSN/gccGt2rsNIlSJXX9bzJNeh4m7AmYTD29plvr7dK
         oawvU2pR9wMvLFsj4aOK469lo8LHJ3ObV4UhA=
X-Received: by 2002:a05:620a:2947:b0:932:de76:badd with SMTP id af79cd13be357-93302672fa5mr262210585a.32.1785249958289;
        Tue, 28 Jul 2026 07:45:58 -0700 (PDT)
X-Received: by 2002:a05:620a:2947:b0:932:de76:badd with SMTP id af79cd13be357-93302672fa5mr262205485a.32.1785249957657;
        Tue, 28 Jul 2026 07:45:57 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:45:56 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 01/12] wifi: cfg80211: pre-assign cookie for driver callbacks
Date: Tue, 28 Jul 2026 16:45:38 +0200
Message-ID: <20260728144549.2207061-2-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Having a single place for cookie assignment and keeping that
responsibility in the cfg80211 subsystem is a logical choice as it
handles the userspace nl80211 API. add_nan_func already does this:
cfg80211 calls cfg80211_assign_cookie() before invoking the driver.
Apply the same pattern to remain_on_channel, mgmt_tx, probe_peer and
tx_control_port by pre-assigning the cookie in the nl80211 command
handlers before the rdev_* call. For tx_control_port the cookie is
only pre-assigned when the caller requests an ack (cookie pointer
non-NULL).

Drivers may still overwrite the value for now; subsequent patches will
remove per-driver cookie generation.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h | 6 ++++--
 net/wireless/nl80211.c | 5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 15c08b24502f..d503648bb25b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5107,7 +5107,8 @@ struct mgmt_frame_regs {
  * @tdls_oper: Perform a high-level TDLS operation (e.g. TDLS link setup).
  *
  * @probe_peer: probe a connected peer (AP: STA MAC required; STA: no MAC),
- *	must return a cookie that is later passed to cfg80211_probe_status().
+ *	must use the @cookie as provided which is later passed to
+ *	cfg80211_probe_status().
  *
  * @set_noack_map: Set the NoAck Map for the TIDs.
  *
@@ -5218,7 +5219,8 @@ struct mgmt_frame_regs {
  *     user space
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
- *	tells the driver that the frame should not be encrypted.
+ *	tells the driver that the frame should not be encrypted. When @cookie
+ *	is non-NULL it is pre-assigned by cfg80211; drivers must not modify it.
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ac0c0da45241..bfb3005c23a7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14630,6 +14630,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 		goto free_msg;
 	}
 
+	cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_remain_on_channel(rdev, wdev, chandef.chan,
 				     duration, &cookie, rx_addr);
 
@@ -14871,6 +14872,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	params.chan = chandef.chan;
+	cookie = cfg80211_assign_cookie(rdev);
 	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, &cookie);
 	if (err)
 		goto free_msg;
@@ -16359,6 +16361,7 @@ static int nl80211_probe_peer(struct sk_buff *skb, struct genl_info *info)
 		goto free_msg;
 	}
 
+	cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_probe_peer(rdev, dev, addr, &cookie);
 	if (err)
 		goto free_msg;
@@ -18574,6 +18577,8 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 
 	link_id = nl80211_link_id_or_invalid(info->attrs);
 
+	if (!dont_wait_for_ack)
+		cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_tx_control_port(rdev, dev, buf, len,
 				   dest, cpu_to_be16(proto), noencrypt, link_id,
 				   dont_wait_for_ack ? NULL : &cookie);
-- 
2.54.0

