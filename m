Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5F94562BA
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 09:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774842; cv=none; b=iVGQwx9BEiHzUaO1WjyEHekaFIWkaphnABjrihyOesX9Iql46lXgV2/XKK2rjBmfjQP69iUhNAT9d5lU9BueetcZh7m7hezcLHtV8u6T/7j/XZnmq7SOpOfwHCx7ftGa38/Z7ns4GlH1uWMeUk0521kSvZ18J6b1DAfF/qYne88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774842; c=relaxed/simple;
	bh=5a9kc5qSIDnqccQ4eYyVurMLT8GhriRY12MQ4NrIJX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZ7zDOze43XhWRi3ZvP6r3YMIl3mFAPUQjaxZmlwNseHReTxaCgUZFr9Vq+v6ZbSQcp11CjAg84WugmHESi9IEZZUqwl2bIXdvrwbT7lt+i4d/sNsGG6LsYMT4hGDDkrAXrIyUGBZ5aT87KzG7SzID8Nl4dJpfh4J/np+ipzkl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BDJ8vpO9; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDJ8vpO9"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso2220699a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 02:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788774841; x=1789379641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hOc33BWj25QL1XUvLm7489jtJxEZeuSgnZvck6W4yKg=;
        b=BDJ8vpO9DaLFXvqBGE2+iflarQLk8zeguK1tXj4+TgbfT6uKUJZ1GqJyHDHLuK3uVQ
         nCQAqi/VXdzHrW4f5jJRbDOE709wowFALcnhP6JKVdn68VpTZHufdbTBS8H+zu6iXer3
         /PHFjg1yRyR7+R3tMk+1CPjbAiZFHDRCB9PdaKkvzC/NSyC+q+tffN8UqRuWxIV8r0I/
         f5SHm4wlLeGl4gz5RKd/GIiVPU3eFe5vQABxooPMJb+B1A0TSyUaU1TTk0A06K+0zRcs
         ilmlsCAhbNlNoecuJVZqJR/Plq0h5EwGebc5Ml0fu22CspWniwuWVP4gQRmMpI4Kw3j6
         +dQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774841; x=1789379641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hOc33BWj25QL1XUvLm7489jtJxEZeuSgnZvck6W4yKg=;
        b=kg4mfGHEMl96Ny4qhm2uHd59FibRPFdT6xQcpD7bCQ1OuQNm9fNOC8kLPHbBOco0IK
         Hlh8Tsv4Ug7zi1ni2rWXUq3D3ir3QqrrlzGgv1SoWy1DW6GmJVGQBmOoM8v8HcXHMry7
         uRIjGRJd2daN3hhkJdCYYAx5puKZgB/OujjutH50A6rLthwjqq1NIdnWyLgpUUsEF48w
         oGH0J5Rt+d1esD4gPwcAs7nk+fRPZdqhw20brFuNo0nWlw1CDXQCccRgU6fsjOUN5T1J
         m67DjmbOI3hTtAqggEwlkrsf5eFHrt9XC0QO/pHpPbTroct8n9h0+FU57IoxUuNHtGak
         GMLg==
X-Gm-Message-State: AFuF++kXSx1kPHsIjN3sjS/RX7xRrA1ziCZ76/d11WS0deAZ0BG3t2b+
	2WP4Hb0ddvQus4OtYekUqzbAlOgsf0Cd9uUR6A1sPpYIrZ2NJOiGnELZ
X-Gm-Gg: AYBFou2L6FrZFqipI1h1+AqJmRptWPsdw590pFU90jSIDF4s6qlw1on69iWcutO4Uf3
	+lpwj5BeVXBHkOP++CF+gs0H8xGlMtn2aH27zl4sarO4u2Xvklrw/8MXK5hRiscrK5YXLuerNt3
	0MqYHSEChFdJERVeZBKiWKXnjnu+hJombcuGv9c77T3coGesHibyEvvj60jidZS2Sk+644xXn4C
	DyhkS9XdDgsST2/SCEUUixZqdi318dKKzaGhqFARzMsvA8foPUiqUWynLCLM4Fc/EiBR20ljKXi
	ahzwdGuThDWjm0DU/dCXMMdg+3gngpxjz48ku+8jF3KmBWEDE2oGaEv9EDU/PzRFuRRAJmVG/eb
	DPQ5n9O1L17Wi4UBc0v8+GKzNH97pLTgHdTALdmg5W2r3mm57sQ7Hq3uUD75PshkOuYc1s1QDv/
	dAo0pbaF691t92tt6QRkjSCec4X2EEtYxEUTEGcnmG3tQhp0ybNCZEgURQEhFx0Zrd8naV/qIJ7
	e+AUN5KLeKQ2w==
X-Received: by 2002:a05:6a21:e082:b0:3c4:3112:45 with SMTP id adf61e73a8af0-3da39eae841mr29919850637.1.1788774840751;
        Mon, 07 Sep 2026 02:54:00 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm30377066eec.21.2026.09.07.02.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:54:00 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2 4/4] wifi: mac80211: fix repeated word 'used' in comment
Date: Mon,  7 Sep 2026 15:23:48 +0530
Message-ID: <20260907095348.26094-5-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907095348.26094-1-hemanth.selam@gmail.com>
References: <20260907095348.26094-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the second 'used', reported by checkpatch.pl as a repeated word.
Only touches a comment, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---

Notes:
    v2: designate the patch to wireless-next and use a subject prefix naming
    the component, as maintainer-netdev.rst asks; v1 went out with a bare
    [PATCH] and a "net:" prefix. Rebased onto wireless-next, diff unchanged.
    
    v1: https://lore.kernel.org/all/20260907061417.33729-1-hemanth.selam@gmail.com/

 include/net/mac80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7bb4618065b6..9594856a23e2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -257,7 +257,7 @@ struct ieee80211_chan_req {
  * @min_def: the minimum channel definition currently required.
  * @ap: the channel definition the AP actually is operating as,
  *	for use with (wider bandwidth) OFDMA
- * @radio_idx: index of the wiphy radio used used for this channel
+ * @radio_idx: index of the wiphy radio used for this channel
  * @rx_chains_static: The number of RX chains that must always be
  *	active on the channel to receive MIMO transmissions
  * @rx_chains_dynamic: The number of RX chains that must be enabled
