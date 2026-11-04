Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826898;
	b=WYoiddvro5iXoki5VbY96vE9cQybr+/IESobnAP61FeQCOvYkT2uW1P9iyNElZAekmD9
	 ZPcCEHi99xApFhFPb2X1vMJdJvASq+r2hQE5Bkkzaj0Jm0Y60CYvXZBDi/4QiuyXlDz1i
	 NGG7iDrmXtbPL0aTK2G5j2XD+P1tJH00xEdvhgBmVmA7Ta0BrIK+e0bwkTNKSgn99kLUI
	 fGckiHds+Ty2pqP4zxVP+akvaNCyQgIpMUxGCm9OTTITGy8G70YR2fZGd2NJuuSE11W2A
	 /v4apJ0kVrax9vG9Gvvz7MsKuNMiQRcTiAZiMPvq2SXnMX+XnJUOPZU7TERr85Ka0EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826898;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=f3BqD1OwVSoHT8EUbtaIi6oF8j+TF/48vKRJtgYYzW8=;
	b=sBwi423G7qRJkh6tvjDTJ6Hrye/1x2epDXyRBRFIbiAXPNRyClRs+qofX44vXcbo4k9e
	 mXWPP8wPPLdq766eECNEQqvKuvgvAQ+w4ABAjyhwSdopWanfWmwFWF8SgeYPsMPzqOiMg
	 9tiJQ31GLAfQTLfPRwDw9zPmux4HUOwETkkKeSI8R8ZtLCMTGwVq9tABCzR1e046iDKAO
	 Eby1+HZd+pFmmTW1RPeLx+1S8YR2K6TQRQuIcfY4o97B8gWW6PiDI0gUya8bjCA16z3Si
	 KdxoYD/wkcBWNP+POeNIcnHaKswN490Ic7DeZTEOAxYZdrwaayn8FAEv7aV1NdRxFpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h2ZPue3G;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F57160B478B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 21:14:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F57160B478B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h2ZPue3G
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso2683495eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 13:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793826897; x=1794431697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f3BqD1OwVSoHT8EUbtaIi6oF8j+TF/48vKRJtgYYzW8=;
        b=h2ZPue3GAkA3JRtKQGC492+Qb8gnc074iQDaQkTM2tmgKSXJVLp/iTkI/eT1JZwSdn
         LgDvNhAZjQ3ERPkhlBCJ8U/nMje/dxi6+1yfveblQv4HiccV9mFM9zUXqF/3b2A2rj6k
         dvyXKSyNdZfXW9JcCeljSsJRKiCVE+1K5Vc+7IRZHhFqGmkU56Kp/vlda58J1nxpVEw9
         LSy4mYyKl8aiOSc8jP/dXFtDj3ElMWbKBkfBGDPfbQa6kMEZW1dDz4BcpcjZaDhCpzH5
         jqJEsoBVq0obh/o4JGJ32Yetbje944HYNCWQhtS6oBLBEssKsz0boclZHUv8H9YuDNwk
         Ge7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793826897; x=1794431697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f3BqD1OwVSoHT8EUbtaIi6oF8j+TF/48vKRJtgYYzW8=;
        b=PFFzPzI4KjXQXLMmJ4cH5bFq5NtT0gZ3Z2+wm1u+YtZPP3GQPlueW1C5wu3Gf+rUcX
         p/J4FZyTK2LCLwsCV35U42DditTv4zu4UmQwSgn6nb3lPNAsJNiVYoFX+GC9Kh+sURJd
         BlKE+RyyXBMVHiGqz3FhwhbiV8GrZ4ovkDJRKUcX0xTyEv/xx8nh/tWPqpXWNfxglwZM
         wgKU9J8LtjNsw95ozd5HmyAnvFMow4trqPz7QEfD3G8ILBucseJFByO99oxjnOaWB+ti
         OMO9ivmR5koWPZ52fvs1nt6bzS+4ULOpi/I/zoIJo2rk9UzFLv/4PwJaDJTL7tJ3pQj5
         NzAA==
X-Gm-Message-State: APuU4Z/LJV2dNhrz7Ez4tHh0RCMMdmO0kgmoiGo+tyjzZr7HANdXAqLY
	sHLgnenQ2ia3QTfoZfQIdxTxAr43Q2a3ypxBt+wRsCrX6hqxtCuBRvg1JShiHvsp6yJIzb7U
X-Gm-Gg: AYBFou1Syx9CplpEWP7UcgWbggd/L0ROco8fLNppZ0zyshRtD59tLSMtxsnQpf1yUid
	YnPZSbz2qgmVdnwebCU4QsNOpuyc3vdQNZqCaNdSr2uckJqoEJu8I/95XaJlEIGFv1rbHzgDATo
	2vR+lWu0YkUPR2xzNCPezwYJFQQjoSJU5IOznHXIHWNIH8dEfUWRvoY3r+kU+vghVq6bTgPb/Jx
	yzkMu4Pbc/z3GCsqvXdIlUk22NViEiRtaxw8xnFylQMyZbp0ru80b3h530d3p4y4v5mIae9w97h
	9QS5BGk6Qetd3LJzvSl6h543w5mUUbXitIdNCfycxed8EE330BZIQd3g22oijwIdnrnL/JAh9b6
	KdLkZQ2/bNo5IMsEwVp/eGKC/fEURM1WcH4XCPwEIiQIpHj2nggXl38Y3gs7tK40i2irs+uC2fp
	/vUngIShnDZffeXMrf1QXwZQf2yc9M2oUKoLkVwjX0e1IuxjQ5Y+/JQRyz7SQ0+T8VcKo275JkU
	6a4Ol9RRwOPcoOm+fsPdaL3oAA7FcKJiN4bLW7nTynXn6e9sI3FFYdXmJ1Y4PvUmJ5rFRhf5ZNb
	pBcyxZnMNB8vemwx4b0fEElyeDzIow6VWuJ7eTC+EunXHsspc8ug2glBZHpmbBOyJw==
X-Received: by 2002:a05:701b:2806:b0:190:b2de:1549 with SMTP id a92af1059eb24-1ac557770c0mr23698408c88.1.1793826897202;
        Wed, 04 Nov 2026 13:14:57 -0800 (PST)
Received: from anon-laptop ([103.187.196.159])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c2c2f7sm10606078c88.9.2026.11.04.13.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 13:14:56 -0800 (PST)
From: Wahid Khan <wahidzk0091@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	sara.sharon@intel.com,
	luciano.coelho@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless 1/2] wifi: cfg80211: don't truncate the merged MBSSID profile length
Date: Thu,  5 Nov 2026 02:44:50 +0530
Message-ID: <20261104211451.693451-1-wahidzk0091@gmail.com>
X-Mailer: git-send-email 2.56.0
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

cfg80211_parse_mbssid_data() keeps the length of a non-transmitted BSSID
profile in a u8. cfg80211_merge_profile() returns a size_t, and it
concatenates a profile that is split over several Multiple BSSID
elements, so the merged length can be well above 255 even though every
single sub-element is at most 255 bytes long.

The value is then cut to its low 8 bits. A 300 byte profile is handled
as a 44 byte one: the elements after the cut are lost from the generated
non-transmitted BSS, and if the Multiple BSSID-Index element lies past
the cut the BSS is dropped altogether. Any AP in range can send such a
profile.

The multi-link code further down in the same file already uses a signed
size type for the profile length. Do the same here, cfg80211_find_ie()
and cfg80211_gen_new_ie() take a size_t anyway.

Fixes: fe806e4992c9 ("cfg80211: support profile split between elements")
Cc: stable@vger.kernel.org
Signed-off-by: Wahid Khan <wahidzk0091@gmail.com>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ac56338f0f43..8e9ce8336876 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2592,7 +2592,7 @@ cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 		if (elem->data[0] < 1 || (int)elem->data[0] > 8)
 			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
-			u8 profile_len;
+			size_t profile_len;
 
 			if (sub->id != 0 || sub->datalen < 4) {
 				/* not a valid BSS profile */
-- 
2.56.0

