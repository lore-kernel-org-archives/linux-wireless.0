Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197380;
	b=kkMzMeMKPBUJjR/OqVs27UeAsdGuCfSyL2Txcq2KcRzp+4netGY90LMLYE058CvtFWlh
	 0qEnoXUui7XeBpkAf3qRS/3/SCGzzoVjWMo2xRIYLPLto2j7QX6UvWLM0NxKR4Br4YLKA
	 2tmymT4wKKE1urDN4wSjxoAabVQLVQ0/Hr5dhDTjD1bwoB7nhd6iyOiK6SDAjBEGbrS3z
	 u2zZ2DwgaTIujOqeAmclcVXRfO53CbWtwJtfMbp2eA++DUJrq1JUNcdPIT05DAS/4NtaV
	 BU53XKSOg692ZcWjcJ3IIaGkfS1y2XIVHfzjRAypqwQ3jGjLgU7Ud8UutMUdwcRqzfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197380;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7V8TJ7hV12SQrdPDboL85gY+G3YL3+ZJkH+iYuGDZo8=;
	b=vTSbJxAD7R0kgvj33yz0X22xjvkUtGXrZzxD6MFGq0onYsnpzIVKCI9ERzXcLAxRfwM7
	 7k7qucCxVjUYnASLnO2i0pGnhy9AlgQE2FvMd79wTv/YjevjsQ+EoGFBaJSMqr36dqSe6
	 +TchJsNO7w6iZXY/wuSCu2Pxu9wXQplWAJ8EIRFRZz3HAg6bX+vj6nJAKkBpMswHXDylk
	 1MdYC/upqE/yga9nC1PYrvKMMTKPIB09r6Vx7X5ixEc664FyStUf7hK7PEvRujNrbeB4T
	 HirL9q/i+59qBc9hYd/oqRrbctQeDJkxW6CCwxc4rtiTsX1gmOgz5ZV5ide2HnVKv6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ebjSrOn+;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34E1606A32F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:22:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D34E1606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ebjSrOn+
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a05b210703so525927b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197379; x=1793802179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7V8TJ7hV12SQrdPDboL85gY+G3YL3+ZJkH+iYuGDZo8=;
        b=ebjSrOn+E7LVjMvKaDuAmzTut4DQ/a9PuFwQjTjtotC5x51Cq3iv7YTPD2ibgTLG2Q
         zhMTozdHmHNHQ3lHAs5DJc8Pj0OcHJB+cVh/oVjvobFu0ZIFK0Pq9AyXUcf0ilW6RWu2
         omNLyzj5mEbxskBE7MF+AqkbHljddxsyAQq1WCGpR3RlbtcKGXYd8V80+cfangXeHisi
         Yq3hwSsJKmR/DwYTYRwh6ukkDtfEaUEDq+AysSwMCrIeGc5fwNS1//bP1tApiP6QUxcz
         v35xaryw3rSTvy318XMKUuOP9TLlHRJXrCQBrDYnBn3lXKo7UV8WUKu1rN3xImwGNo0v
         B50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197379; x=1793802179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7V8TJ7hV12SQrdPDboL85gY+G3YL3+ZJkH+iYuGDZo8=;
        b=XEw38A7LWqRZNICu6JLVV+h8/kpj+yoFDYMumRWJlfqFiA3uwFoQJ/IM+9uWbUOAur
         OXe3sZCSWol5ZRfsD/+Ylp0C4SGVa/UreeKC2Xk2Y8tam5dHkJUUpmNzzyiIl1GLg3rr
         DGQfz+WF9FTxfueSa1sUlws6mwj/dontjHDzzPhRBTYKXjmMARrLq85bPqRi9sz2Ip51
         z+9irD3sfJzXcZORnkuRwKshAg/mx5EyU0edKRoT2fGZYkB53CK+2r0OiOf7YtJOzPe2
         IdStcXI5wfHjvm1PIvesNJujgadPmBgMV16y6VGYln4vw3iytUD6rw3AVoEXCF06/4tK
         el1g==
X-Forwarded-Encrypted: i=1; AKwUvBz40X2RIO2aLe/GlRjTrw0nh0NhcFIdMl0PI5HjYExJ7XWXMJwbTisVeKLu7z59EzLfQn9Z6+FpOIljWawHrw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJHu5cEtqpGQEfSJZmQdVWPTSLhgwd6z9HCEAX3X517kyZsJ1Vr
	KAI66xWE+Ex9zynluoV6pLLrTfxrjCpeTM8S9+Xu+70DJFeL2+YuY15hSJ0d7Uujh0w=
X-Gm-Gg: AYBFou3ylerFd2aH6inKJ4PmLj1a8SwM1PlvqUrwAeRuyCwshxENWXISAsqNBwnlICC
	+Ra07RdVUgQaRvFaVRur9RSLLyFqVIuentFVQW2a4sx3p+M1w2MLUsN1gxrgo2gv1hQsJJEC64L
	GccuA8impcq48Gbt/xmXigyOqMnUPb7Z7JHwQ8u9uA3E4ANgNAxavHgJjXNl6uCfQJ4wbj9XFs3
	eV3s1MA/gUNOoz2OBeHA7xmrjL4JV/Pz6yjMEF6YYpZLMmgsaImm1N0e1DmK53MyHtbYzRnjwAz
	CY/Qc0cIj/qXwj4BjSMS/VO+sEhlblXcEtc4ldklnhE4CmiF41Hm8vlwljY7MnNqfg8lWnGjhSu
	wjTflkXUFCvf1/NVVFV0LHWTMJ3cOTV0u96L8byczdVwctjrFgHIfeLvbph4ev9rCZg1fYnX+AL
	QxqG/esir2q3c2U/B9ifKsJb+liCzj6HwOZbtHTskA/eSz2d2LWnBGX2sxOO0FJ2A86b7ZNZA0K
	RFUnOAMy3gfviyx8+Nl2CGImd7NcK7giV1DFAfWyePArv/t/FdP/ZFezqXRIPwH24OrJ38xOdqq
	VbDsKJ3jxppMtxbf4NFF1F6Df3Gy/6BuUN64yMKlIwIdr3sE4gnIRGfd/EfgAodNLg0FRiofePZ
	FxjRPEbo5+qVmNA==
X-Received: by 2002:a05:6a00:3989:b0:89e:9c7e:fd49 with SMTP id d2e1a72fcca58-8a6e7bc8597mr1970471b3a.20.1793197378617;
        Wed, 28 Oct 2026 07:22:58 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a662ba00sm1245181b3a.23.2026.10.28.07.22.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:22:58 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] wifi: mac80211: recheck the IBSS station limit before insertion
Date: Wed, 28 Oct 2026 22:22:34 +0800
Message-ID: <20261028142235.15428-2-enderaoelyther@gmail.com>
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

Frames from successive unknown IBSS peers can make the deferred worker
install more than 128 stations.

The receive path checks local->num_sta before allocating each station,
but pending stations are not included in that count. Several allocations
can therefore pass before the worker inserts any of them, and the worker
then drains the list without rechecking the limit.

Recheck the installed-station limit in the worker under the wiphy mutex
and free entries that no longer fit.

LLM assistance was used to find the bug and review.

Fixes: 8bf11d8d0811 ("mac80211: delay IBSS station insertion")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. The
insertion recheck was not exercised separately; the two-patch series was
run as described in patch 2. A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 net/mac80211/ibss.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d74b66426349..bd7dbaa942fa 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1626,8 +1626,12 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 		list_del(&sta->list);
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
-		ieee80211_ibss_finish_sta(sta);
-		rcu_read_unlock();
+		if (sdata->local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
+			sta_info_free(sdata->local, sta);
+		} else {
+			ieee80211_ibss_finish_sta(sta);
+			rcu_read_unlock();
+		}
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
-- 
2.56.0

