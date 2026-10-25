Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792956979;
	b=Wd09SAGD8Ek6fkOwtEOd/qWnYV+gpZCyGvfxMqb1k76uNtBurE7k25e/WsGFbipRVUX5
	 101HWLhgSzQ9brFdSE+YszSLbNlsjHMNpLehSbg5/SRdIRxHAn8+DnlQgoDsYiO3MBHgR
	 TJaotI27Rp43iNLzbmWNtVpa8jBhVvIZEkyOqM0C9twUDt1a1W/cjwCt4fJrKr6IYucjz
	 eLBbnsOG8knyg0Yw2udX5V+fk0SO2c+Q7lhOrN7yKmEAlS0uCGpkLnKnLXu1bNqqknz2z
	 yskPo/xxnHIPMxGsAy+6ocOkSnYaHSLz6mF6qZeE8m4/iemDZURP6lx/0BoFT3J/OTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792956979;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wMOFZY244nygca19B3RPi4rKsuHnVMQUvsXeSfGlKIg=;
	b=QGcimyEHy5IaEPr0hWVt+1Jx5WQkH2Ae0DlOHzyyzBY4QeBkZAJXsvoxtDi7pAZrflAX
	 mMUAmhxV3V+RzY1O4pTov6lfbS+rxifSF84MwPfcafCR/HZ+YAmJ7Jg55rnN0SzjuvTdc
	 O/JJ1FXhe3ydp6Rwe06aqKGrYKuO/+9G7I9E2kJaUjaAqBFELa6MkDeQFhvi4u9KMejKT
	 VJGQSIz/D2j1iGkbqBm1bcnWOo0w2qJS+LGk4coSuQMzeR2ycG3p6F5M0bCD9UkWJxzUT
	 pWP1dVCC6YAjgK7tFKe3ZkeZ9FMP+jQ75Xsk+3byXpfxNR5Oew4lgPPPPHZkV3u9Rwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JcJ4bt4z;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C577C606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 19:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C577C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JcJ4bt4z
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so13399625e9.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 12:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792956977; x=1793561777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wMOFZY244nygca19B3RPi4rKsuHnVMQUvsXeSfGlKIg=;
        b=JcJ4bt4z3SNx9hoMDlqg66KSCWiWA56jw1TajJQkqMjImupgz97mGq7QFARp5f3vMB
         /8B/06OnTql1tSyonLwHg2fg885SbdxqzcS0c1cMpll7R8kA3yPT8cwNCbrN9wLbfKXk
         FNbvXgQ9YBvwF38fDdD9dYQPP0IbmCsGdiUGMPu76MLbmoXiIcEfvwPD5u9I/oX3Q1pJ
         iP9Ver33D/8yh4dyvdwClLkCpM3uAU0/gIgAROomrQ71Ip8Kx3WmaAEsM62cIu0T9/rV
         JqIWl3BxuMKK2trMnDGS3Cywd+MdBdyuaa/6t8CYpNkWXlML1gTGDVRrM4TqM8H32/t2
         YhmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792956977; x=1793561777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wMOFZY244nygca19B3RPi4rKsuHnVMQUvsXeSfGlKIg=;
        b=JF5U8c7At+LR4tClF/WpxbdOS4L1B8/tzCWcPjF1qz3GfSbzpkEPwKi0Q2B/TXaMRs
         KuEkrXC7hN9cyIxD/Y9wzHiGaZ50jJW7s6/r2mlrR3izBPJP7ELe8q45vAHwVy0iip0P
         vAjUWHxTq0sr0CMFNlBcmRwt1aVb2N2w8+Uiz5QqeEfv4KQ7Kjz5bB9XJDDiRu6IyKmS
         yY/Z/gd/68q7NTbLSIPhwOwThbqNuyCDVPDRdqtTnQ41Buymbo+wdtEO+GWXv4bqwvbS
         Thj7K+PO6gkqvct5veONzXN4mOYURrdSLZ0qZ92oaUcD9qS3cDpWF8fPrjKvzDAIZOrY
         AY4w==
X-Forwarded-Encrypted: i=1; AKwUvBzQwQWk6NRYYR4ZqpzUMniM6mfxShNrhM/9x5gvkO7M9rytjWFpasCjDry1c1SuZs30cV202vgWLlUzpgbgTw==@vger.kernel.org
X-Gm-Message-State: AFq9FYID7B7IK+LxdImUvutv6PoX88U+R2oo4pWaSef3MtSxlBe1PSUq
	CObJzs++/QxJKNxXbjeUVkqbGGL1r2nMP2VlzAzA/kE7meY6RFe4j0Ps
X-Gm-Gg: AYBFou0eykD0NuxXkfcENKcjc2XKi6hGc83M2/oHGktVZOFcaO7yuTQWI+DcPeNTYlM
	Rzpyj8vB9+pay3iNtsA2lsn7qECn53DRFvG+i05viD5pCVx2lMIcq7lPpXn/y5zMhhp69Lbough
	KGc/1iTekDpxU/6e0kZ0KeJ7LD6N0985p136VR3LjpD3Xnr2+ndghcbT7hDH4KsUTtVPFuOoVO1
	RdZALlBBdWD1diF8XNX50KeCUWuBYBGrg6+hEr9qdRiMYkMga8JOIc8dOoZciq0aCOQKeF/nOsM
	ukIPO7PM+GblMqHhI/rNxmRHnxl/clEArwYI3jBlR7Vy7t75ZmxyNPu7Ja3WUwV2/HKEq/XqHA2
	yQRlcAPfzL6Z/M2wSqoLPhOzu1MgoH4fKl4nTiuljoq/aqjR3ijWqd4/cJhqfkiIVZb05FxpDfJ
	fP9hjUczg504R5qqv6N1R4KLeEuAG+q27YMVQQCqW7lK/qFAWL8qFXytI2Ub6td+U91e+oJEG2w
	KUWtxwMdpQibuo0+JeT16s4Mz4LT8bi30EsbejlTSIBK6cQO4Y2CxFFfMbBEQ==
X-Received: by 2002:a05:600d:82e5:b0:4a1:cd83:b23e with SMTP id 5b1f17b1804b1-4a35aae3e29mr111501935e9.0.1792956977032;
        Sun, 25 Oct 2026 12:36:17 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0aa097sm156667425e9.3.2026.10.25.12.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 12:36:16 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH wireless] wifi: mac80211: abort chanswitch when leaving an IBSS
Date: Sun, 25 Oct 2026 20:36:15 +0100
Message-ID: <20261025193615.1123718-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
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

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

ieee80211_ibss_disconnect() leaves CSA active, as ieee80211_stop_mesh()
did until commit ac7472a24bd4 ("wifi: mac80211: abort chanswitch when
leaving a mesh"). An IBSS left during its countdown and joined again
refuses every new channel switch with -EBUSY.

Abort the channel switch the same way.

Fixes: cd7760e62c2a ("mac80211: add support for CSA in IBSS mode")
Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/linux-wireless/796598480d47c5bf474d11828769e864b8209558@linux.dev/
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---

Notes:
    Tested with mac80211_hwsim and on an RTL8822CU.

 net/mac80211/ibss.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d74b66426349..b9ab4ceb0332 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -669,6 +669,10 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 
 	netif_carrier_off(sdata->dev);
+
+	sdata->vif.bss_conf.csa_active = false;
+	ieee80211_vif_unblock_queues_csa(sdata);
+
 	if (!sta_info_flush(sdata, -1))
 		synchronize_net();
 

base-commit: 9d8ec0b5b5295bd23d979d1b2b905de25c36fff2
-- 
2.55.0

