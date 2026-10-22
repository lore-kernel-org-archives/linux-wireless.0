Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792679988;
	b=g/KXT+ozuswXnkNdIGYUW1BU4qmMSkb7pAaIlvv7AxFFCryRZg/0mwAZpmtqwINN3kDK
	 2k6xYDa5zXs11lx4Cn35kqHysbMqhy3YcibXhw4eowSZpWUfs+WAlnnos13KmR+cCkAz4
	 YHm0MmoJ7PyFJTx/cRXvkQCfRNsqIfIiJK54ADMdyWgBF2AApGB1WT0/+zJJzEjnG1TnQ
	 Wnyd8jONZt54TF1eILnpa2lcWuMWpQHMBWSO8AZNTw31mniX4oMWwv3stx97dxlGo+DY+
	 v7UuiG+HeUGM2JD6+zQl5ExWLam+Q2rZ/yP5TXVCIHBPnK3IE5zDHYPCz0ohdhIZH4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792679988;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=QE3Ot+D/fRZqXf9cO+uRuFcPL/iI5t+jEKOJbyuLYbY=;
	b=Q/KA395FifWF+0Ic+UCYFBUITRJ7CNYiY2Kq0VOb88eZXIYT0I/0wxxumjr4dnCjuqGZ
	 l2Qvd1OfwAESsjKZqrbE6UmznG+aqAnEVHzmvKHx8tx6CfgiaQzASOkOuUY45AbLTaNcB
	 EPqRwAnotFLjTWYag884U6e84exULV9WZkU8QYdimhr5BxiMYWjp9ZshSGo6lTAxP2dw1
	 AQM8+mI3WE7Ex2LMQl+5Ze9QF92+W/+QnDN0ZGNKUMaOJ37TZsnmtx1WBezSi/JyzF5Db
	 RUZ1hHh5sJJmTPUdz6QNnGphdl7ybnOUjAPJ6HR6l9W0r9zHmqPd4s9OIxTLfKEAGpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mind.be;
	spf=pass smtp.mailfrom=essensium.com;
	dkim=pass header.d=mind.be header.i=@mind.be header.a=rsa-sha256 header.s=google header.b=OaiX8q1J;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC184606A31E
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 14:39:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC184606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mind.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=essensium.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mind.be header.i=@mind.be header.a=rsa-sha256 header.s=google header.b=OaiX8q1J
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a20568c8c0so6155105e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 07:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google; t=1792679986; x=1793284786; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QE3Ot+D/fRZqXf9cO+uRuFcPL/iI5t+jEKOJbyuLYbY=;
        b=OaiX8q1JpNzVeis4BwJ2DKua5z+La5RfBfDKsKZSEB6F7k6iBsClOd+w4BL8jrIqCM
         y8CYQqm9bDEVyKOCjGBCUeUddxRj/70TRZg1z6Gar+iIX70dxlmjgHacN7rAVdnl3JGp
         YtgHl4yzjz+rrf9K5sjuKHYhbDAaTwN46XF2W9CHRdIvitIilLDLOPcA97QcQ7Or/5Sc
         wlY16/iloFsKyGU/JQIEw8BlOi15T2KGsx7EUCFG0D7Z6g5wkXRsnn6Ge9wDQeumgZoW
         HjpO1o80Rn/Wf8kkxKgT0p74e5nSyG3N8WclxrP4AoleMmvTsUvTowHf3T/0mf/qFVvP
         4c9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679986; x=1793284786;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QE3Ot+D/fRZqXf9cO+uRuFcPL/iI5t+jEKOJbyuLYbY=;
        b=OYYxFGXBNZT70rRknolthm5Ql8/+Dtli1Z4NqAKYhFvR+qH5g1xYGSh85LKBPPcvyu
         BV5YgjdPJtV5x9DPpKAk0NZSz6m9iQowEVyn8sGJ4vUOdlfqge5PBiN1KvI+nkteibQb
         S928OakgkccmFuPZU65r1bu1zUH5xNjM+c7KAoca9cRwdUvOLkGVOZ7j9bQsuaEXk/aP
         BjEd32TeIe1jww13xPIJweEjdqqBtThLnmglD8VnDq6GCWU8dJtcqLdlqY8wAXUFvNvv
         E/1LQ1/HHMApeNjWxHGrmXynUdIDBz6a6oR3MOrnW/uIcPHRWtEYqMuQMHXVr2DChBLm
         ydbw==
X-Gm-Message-State: AFq9FYJZUgSd0j+ApAsXlxbT7IsP2sHIxDZcc5QPfqqkOGpKyJ5aFZBT
	/nr5s8idUp0Xw1r5qAHty0zn3mv+aUM8OA1JqL00H3kP9qcVe0fKBUhFLEJ2GkwCJ68=
X-Gm-Gg: AYBFou2tav+/kLJVFBbTXcejLcII4msZCDHotUb+r2sCeuBBGX3rBHuCjqDTsKb/CFD
	8lmvhKO2MAc2h9dIRF/mV3bccT6J0lgK36qzkXFP/Bpf9sx/IK3BnTBINpiUleyDqLhJYZim3BO
	sb7bcCiC5U30yNGSINhQoIgM3FLXkQWsEwx0qik5/0Ialwg7TFOJN2hz46vX8GeRoTxa5X94HUY
	EM3MhbDfZR48kUIxSMMzKNshcCZ5hL4KB32vdfwg7BIVX5zkXbHEuhWvyyVM+pYa4M/zFdHbg7p
	QFE1cMuMgh+TWESJHyjy5YiEe1boTdG+eYh2vNUM8BNBr2znFRV0fNGmxhPaGoqg5LdZIPhzfyY
	8VF25tMWaToGAno2STj644t2HVxX66FaGQa4RtLQQ7fb3BLoQI8eOGR6pIBVRPcYx0H8yCrpmFv
	v2+bz+fsggSO1HnEfOpPAc61ZLVhd1vCyJU/u0sS2zzlXeepzopomp6JqnniTlmVqByMvt+ULSy
	DFN8uixbsj9JCBzBM5B2x6qTQDRbKJlmTnVp7PoYt7wjZE3KD3+dcb1Cw==
X-Received: by 2002:a05:600c:6212:b0:4a2:a8c:22bf with SMTP id 5b1f17b1804b1-4a20a8c23f5mr33166405e9.3.1792679986183;
        Thu, 22 Oct 2026 07:39:46 -0700 (PDT)
Received: from debian-hp-1 ([212.233.51.18])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a21034cd1esm271715e9.5.2026.10.22.07.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:39:45 -0700 (PDT)
From: =?UTF-8?q?Rapha=C3=ABl=20M=C3=A9lotte?= <raphael.melotte@mind.be>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	miriam.rachel.korenblit@intel.com,
	raphael.melotte@mind.be
Subject: [PATCH wireless v2] wifi: mac80211: limit assoc mode by AP when there is no auth data
Date: Thu, 22 Oct 2026 16:39:43 +0200
Message-ID: <20261022143943.1045238-1-raphael.melotte@mind.be>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <94c01af4b987ae7b04aab040d2683edc3262c35e.camel@sipsolutions.net>
References: <94c01af4b987ae7b04aab040d2683edc3262c35e.camel@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When user space does the authentication (for example FT with iwd),
there is no matching auth_data. The connection mode in
ieee80211_mgd_assoc() is then limited only by our own capabilities,
not by the AP. ieee80211_mgd_get_ap_ht_vht_capa() thus requires HT
and VHT elements that the AP does not have, and the association to a
legacy AP (or to an HT-only AP on 5 GHz) fails with -EINVAL.

Calculate the mode from the AP elements in this case, as is done for
the other links, before the AP HT/VHT data is read.

Fixes: 7d8b02592d52 ("wifi: mac80211: obtain AP HT/VHT data for assoc request")
Signed-off-by: Raphaël Mélotte <raphael.melotte@mind.be>
---
v2: Use a different approach: limit the mode by the AP with
    ieee80211_prep_channel() before the HT/VHT check, instead of
    moving the AP HT/VHT lookup (no zero values, no code move).

 net/mac80211/mlme.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3c31c16860ab..3e80ce443324 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -10530,6 +10530,19 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 						       assoc_data->wmm, 0,
 						       &assoc_data->link[0].conn);
 
+		/*
+		 * Without authentication data, the mode is not limited by the
+		 * AP yet. Only calculate it here, hence link/link_sta == NULL.
+		 */
+		if (!match_auth) {
+			err = ieee80211_prep_channel(sdata, NULL, NULL, 0, cbss,
+						     false,
+						     &assoc_data->link[0].conn,
+						     sdata->u.mgd.userspace_selectors);
+			if (err)
+				goto err_free;
+		}
+
 		uapsd_supported = bss->uapsd_supported;
 
 		err = ieee80211_mgd_get_ap_ht_vht_capa(sdata, assoc_data, 0);
-- 
2.54.0

