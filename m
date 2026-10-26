Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053936;
	b=1XcAXB86b8fSqtq+ux3NtWCtxI+ncl0/5XrgICH4mgNkgFTeLjKTwvVpBmhQ0dePkptm
	 163NGwhf8E8eyi5BmUk07WIaz2/DvfkpDxlNOWZiq0O4ZzrKFg20CNlkJ7KQrcC3yatzO
	 9mvZzmUZh0r1AwMNqM8WyYBnoEeswZFU1bk8bIGMd5vjc/2m4SC6nO3pzg0buNEzW0Zr8
	 79ErLW7kOI9Ae6s7qwk0cWI/d2m1ZFWV7miAqtznq8OgqyxdwQMXo1E0GABAIXbtO6lU9
	 kXN73P2SHUlkGWMCKQiCB/bHwkNAEougr3zgYQCukXlBUOn3gq81+0o7xTLG2NS+DpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053936;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pLaJAO5gdQUGb1UHhzJRFMc38wz+LAD8Exy48sOnSII=;
	b=DcMznkfDDnO4MP9HfMX8PkWFvLgVpfOdpCd0FBwSUJuIjVPXjyCTYHzs4GwGdWl9qi4Z
	 7KmF4gTotm9UC4I5ju6E8/dRH7/cTPoCE5yN/aE5ygTrfvbVlfgWLcRbvPl0LkcX1Oz/d
	 b9Au9mv5CysvyN2xi85CvNonkUdC90nI7g70M/ESEkXUwyC+TnXMqQs+izVJjOPSiraZo
	 8IJavK8AkTv0OiPxXICdLvrhq/kqs7eoJUrZ3E6YyOQbq7jg/VxkYg+UYBQHDzGW5D8sh
	 U+dIACq/cte/3vCblNXc4oKFt7Bh5GA8JTouS9gTLu0CAMXyOAlKq5A5+Grm3nL3FUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pA5y4emS;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCC2606A32E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:32:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DCC2606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pA5y4emS
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so22706095e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793053935; x=1793658735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pLaJAO5gdQUGb1UHhzJRFMc38wz+LAD8Exy48sOnSII=;
        b=pA5y4emSgAGiQ2V3ti8+pUQOQGyGTRv1fwG3tNIJ5m7VfVS6F8nLXRdvMG5ArqA+qk
         42X5+5tHmiqbsAyFzzr0jfs3ZFS8HMf9kkNUgPNqbpQjizqFMYOYlSHmeqxTTqi6NOoT
         Y74My1iK0ewVLZsBPOfMmYmpZn3hiQTkCcrVJ2XkEwnmxpInD9k5oYmV893eMFcyFdch
         f5f+GluMr7/snoEHN0RsIvLKxTMkm0Ses2/GcDVV6r29ebvawOkDZi5FL06uTwQsG8IQ
         vuTWzDJMWyrX3FWU3BZZFtDIlt7vApzPGed2x0ow013a+/y7oKeas8IITmr49vVRGv6r
         0rEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793053935; x=1793658735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pLaJAO5gdQUGb1UHhzJRFMc38wz+LAD8Exy48sOnSII=;
        b=PupJVyPax9pWnUW2M0KtfjaEbntbv04l3wxJUmMOw0v8Ab9JCKXiqszgF3IV4Mocra
         7rzuO9CWs0uIWUBw4NVwF8iF6xlqoPKL6p0SyMTp2ukB1ZMs6SVuGNTDdTFcU0jjBuoc
         n4rd14oXoivnH3HEJ1De/vCJaiA4cVbQN59WU97qqPGlbncsQv937F5iPc+R+22XrFha
         24EpaDa64s/X/5JP2IikyxuUT6Aw1J//H6TBveMopIi/LAZIerRDleT81ojbjU3ljnJ+
         vW20KD7/qUnAa0zdwADmm0dxPqAb3fNAp3bwwuPfGwXAzCRDorWLYaTrfkdSRz1ZCdog
         FF9w==
X-Forwarded-Encrypted: i=1; AKwUvBxg4vJ1iDrf5/gfgSlzPJYNGLOMfQbCGrn+Ot3qAcmSjd5OFf3mQlsIu0tGJsj8FOCdpmhMAng1a2cTfgzcyQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI0dB5jjOrKjCCZFo22JjPvfsX29hBi9Jl4qA/2krJftU+PMsGY
	2y/458GP/E+tFxrlxzI2D+TLTbdZr58SYDZajfNxigfaMbA9BjENJLvV5s09
X-Gm-Gg: AYBFou1oKhg2lyXiYoOdHibvAcoAc0AAZail1IfzB7Hq+MhCa53QTltI/ZgXKrQl2vt
	gb+39m9VhCEKl+ppH82GWt7sMX6oYQUZew/EtyKSEk8rKs52p3Lw8MJHetRudPeVdQVtsqg6yVr
	OK2qOop1IscD3fp7wrN2i0lgSbEFB1HVllQZWJwDGMfDKywNsWuTaXv8UFttTPc8lO+G53/q2rL
	YrisIUfznyFAjGm7qYwFw3orr+PHxj+JHHBv1PJaHVp6f6fAvqlYOTNAuqBhu5cA1NVDizW1Xqa
	nhbNBaD9q1JagsIFoTiD7AqI9Uh/OhTJmOglZ7jstL/4mo3IdwhScKrhhTPKCOXwWZOG45dXMIU
	FtdJTX06J//kOSAJXp1u+y0M6ZfqQbeKbVfJU7QmhgbglC2GrL6tNJ3huo6yEp+L+N0ATKgqsRE
	wnROce1CjveDBVArVHMOZKlUG+NO+9zAAod3z+2U3tfp1SnBK1a2dpMa9f+fVp5OCN0787XgGUA
	TMnjCFgzTofrJpeYD6bhnaTaIEZ+4m1wRqe0A==
X-Received: by 2002:a05:600c:4e87:b0:4a1:f7f4:7cf2 with SMTP id 5b1f17b1804b1-4a35acaa046mr152238715e9.17.1793053934795;
        Mon, 26 Oct 2026 15:32:14 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0bb112sm241921425e9.8.2026.10.26.15.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:32:13 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	tristan@talencesecurity.com
Subject: [PATCH v2 wireless 2/3] wifi: rt2x00: replace open-coded IE search with cfg80211_find_ie()
Date: Mon, 26 Oct 2026 22:32:13 +0000
Message-ID: <20261026223213.2091616-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

rt2x00lib_find_ie() open-codes the IE search that cfg80211_find_ie()
already provides.  Replace the hand-rolled function with
cfg80211_find_ie() at the single call site.

Fixes: 1c0bcf89d85cc ("rt2x00: Add autowake support for USB hardware")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    | 30 +++++--------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 4d94b7062f440..921383a630bf2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -557,26 +557,6 @@ void rt2x00lib_txdone_noinfo(struct queue_entry *entry, u32 status)
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone_noinfo);
 
-static u8 *rt2x00lib_find_ie(u8 *data, unsigned int len, u8 ie)
-{
-	struct ieee80211_mgmt *mgmt = (void *)data;
-	u8 *pos, *end;
-
-	pos = (u8 *)mgmt->u.beacon.variable;
-	end = data + len;
-	while (pos < end) {
-		if (pos + 2 + pos[1] > end)
-			return NULL;
-
-		if (pos[0] == ie)
-			return pos;
-
-		pos += 2 + pos[1];
-	}
-
-	return NULL;
-}
-
 static void rt2x00lib_sleep(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
@@ -642,9 +622,10 @@ static void rt2x00lib_rxdone_check_ps(struct rt2x00_dev *rt2x00dev,
 				      struct sk_buff *skb,
 				      struct rxdone_entry_desc *rxdesc)
 {
-	struct ieee80211_hdr *hdr = (void *) skb->data;
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
 	struct ieee80211_tim_ie *tim_ie;
-	u8 *tim;
+	const u8 *tim;
 	u8 tim_len;
 	bool cam;
 
@@ -666,7 +647,10 @@ static void rt2x00lib_rxdone_check_ps(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00dev->last_beacon = jiffies;
 
-	tim = rt2x00lib_find_ie(skb->data, skb->len - FCS_LEN, WLAN_EID_TIM);
+	tim = cfg80211_find_ie(WLAN_EID_TIM, mgmt->u.beacon.variable,
+			       (skb->len - FCS_LEN) -
+			       offsetof(struct ieee80211_mgmt,
+					u.beacon.variable));
 	if (!tim)
 		return;
 
-- 
2.47.3

