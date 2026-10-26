Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028341;
	b=4bl2hmStgSjS5SGW6+5YyQYJKsFl7M4753OxGH5VlSG+BqbjLxsa3QjTtu4KI0oUPS2W
	 DpNdZc+SYamHrpUCCZHTzxv3+GMH5vCaPE0LXhumVNksZS+hI9KLupsphXDx/zlz8WYn7
	 Dj0s41G6UD7IO6RH2qV5QpS0RxEpb768c9zb5jK7jrbAZe+HSsy6henPNgy6AGmoOsc8v
	 sQI2MEaFjJW8RZSx+y3TldA2gkACgdmACq09DjiPKo3WT9KjH4zoWJP1DkwwJZZnJnZ53
	 2fOk5gq7ebJA3DD3JnXrJUwwiV6AfiB00zkbkkmq3+xA6PenjtMynN24oehqaopAVig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028341;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4YwDROZjw8lJkfVsNq0JU1At6fg3SRg612YAoXh1OEU=;
	b=iKdhf5BMmxjW7aqGQskaz1MGU5vNWr8mGBVcHtE2ZkNxhK1yfXY7hyU2/bU7rHaaozkU
	 CTxDeekXluSr499TKL5I7ut+lm37CzS/nTJ0juCvl8O7QLN8StyaJXYA3gsNUCANBg4gW
	 5ZZaLDGjni6QctPRDrddLt97kf/pr86fhAXo+qvSfXjOb5OjCim8ltauvU0BZagzEHf66
	 981p6UZAvXGlBW5M+CzIjfePW+ksSqOYHZuW9JHlReEh5cSj2U3ZKm2tOr38eoVZ6LrqJ
	 AcT9BZZOU8cygmzGHq55cYqoXYERM81y5y+Hzyan3BWVEUpqb+vizRQmwTgwbj0DC/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P4YQberJ;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB25606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:25:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FB25606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P4YQberJ
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so20933195e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 08:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793028340; x=1793633140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4YwDROZjw8lJkfVsNq0JU1At6fg3SRg612YAoXh1OEU=;
        b=P4YQberJdPZJpMvUqWaUC8q4sGotadpwikV8wHwjBJhqrPe98kDTlNIu3aGRXAG7RL
         hbWtchVT1zjIDyKKFqTn0IBSTFm+6hrP3xhwj5/uZPd/CZ/nR/ZLmIZcJDYOqP307q4D
         NHTt2cWS/5iuiBFQZ5AJtcQ6awsqLOSldFlv3DqPtoRmdmBpeaTM9ZU9U/3sS2uX+Wrf
         9e3a9BJ1kmDzgLvFUHwdVdUuJTI5SxdLdjqVWe0oJHQUCzyQ4f8qDXDOFXv1q1dSJAar
         ng+hCpg/wJHzjOSTTvOxEzRvFDPRBrtyWRlXlnihC/Oux0McFYEEkoRx8WEKwz6u0PyH
         9XEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793028340; x=1793633140;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4YwDROZjw8lJkfVsNq0JU1At6fg3SRg612YAoXh1OEU=;
        b=IG4yMh5SrBj5aJy4/UqTs3uZu6noyuugjctKdZq9/AwFFTo3CXuHh3+bFxveTR5JAE
         PwfJk2ujcjhJNy7BUietYOkggXsYNG9uIiXcrkBi3QBS7zzhfzp7lyH9fiJXWVXyTvv4
         Cf/s314f7NDYXSYMON+VrodFcLlGJBNwkDxSka7oherUeFa7+uVlL4ISv6IY713ecSEL
         jGGZXHSeqqprpFyEpne5s+FDcbl4NRC+RZZNq77kiRwLI8iKaZxmnEFB6oH0iA+r6FAR
         DNLMb2842GH41TkaUg/RHuwuqtDLB54D1JIMe2kRFipfrMi897NeZ7cYrz3jbj+DcO/T
         JveA==
X-Forwarded-Encrypted: i=1; AKwUvBx6+CG7R0IyNF8JtW7JMGVB3L8l6ASlOGpIDE7gUJBrHNk+LxIE7yR7mJMsRwftkFNqUewOaGWBUTdGsoQ8tw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKMehRuMivTM1NV5MdMfuKnyqZGu35EFVdG5H3eCh036nuYiuwx
	o20rbIsaGhLRaD9W4nyeOFmBHbSEIiw4FWMBefxojLz1kHqdKTelwd8w
X-Gm-Gg: AYBFou3B1dbL0EhBb5ZyiP2p5hMtjrJGQH7ibUstE4qVxbhhV4w5QntXusWseqr7V2t
	fokETXxRDYMFBZvwRulb1GaSM5PISFS4jCM5v2XXF3rSuBkn/twcKTRsfnqqVVS5TwhoLLR3PcG
	mWFpirxCdAMQsfiFgMGTt7zCXtL7ANir3qQWbeCVyRuCm91NiDQ/ENjYfPWnQTrIu7VbzcAizmh
	206T9Ey7cRqPDK5CMQiuTBMglFcioLfxRPS2vGtu4k9yXNh7HARvXeEzr712FRpTO2lEwrdgzGa
	F/Ww4CK30lvkwa3UHjautAtX6jTvS+PK8gH0Q2Nblmu4hfoonHacHbeOAIoUKeAh05TYlNCaLYS
	TH/V+I5UqjDm0TXdhXG7rvGWk7aGbWM26kLBN4gVSbr0P+YW7h+b0zyVob84z70IiPs17cu4oFV
	TRlnb0N4tvr7QcYqh620Z8tpQDlxUvAU4kKoX1tQRjsHjYnOqGsoT/Vit/PwyNpApSGqdz1PHPo
	v9H6ZsU5J0s3xw0YxiJHlCpL/syXovC8jTvKBjVCc+q4P/RvAyRQWEo01DKhQ==
X-Received: by 2002:a05:600c:c095:b0:4a6:44b:2593 with SMTP id 5b1f17b1804b1-4a6044b27fdmr53438845e9.29.1793028339458;
        Mon, 26 Oct 2026 08:25:39 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a08643dsm159615375e9.4.2026.10.26.08.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:25:38 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH ath-current] wifi: ath9k_htc: clear csa_vif when a switch is aborted
Date: Mon, 26 Oct 2026 16:25:37 +0100
Message-ID: <20261026152537.1272836-1-mehmet.fide@gmail.com>
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

priv->csa_vif is cleared only when the countdown completes or the
interface is removed. When mac80211 aborts a switch and stops
beaconing, as ieee80211_stop_ap() and ieee80211_stop_mesh() do, it
stays set, and the next switch on the interface hits the WARN_ON() in
ath9k_htc_channel_switch_beacon().

Clear it when beaconing stops and the switch is no longer active.
Off channel, beaconing stops with the switch still active and the
countdown continues afterwards, so keep it then.

Fixes: f0e449627e4a ("ath9k_htc: add support of channel switch")
Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/linux-wireless/c8bc5affa75d7519b424ea98c07c1d6b65942347@linux.dev/
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---

Notes:
    Tested on an AR9271 (firmware 1.4), 6.12.114, also with PROVE_LOCKING
    and DEBUG_ATOMIC_SLEEP. A mesh point left during its countdown and
    joined again hit the WARN on the next switch 3/3 before, 0/8 after. An
    IBSS does the same with [1] applied: 13/13 before, 0/35 after. A scan
    during an IBSS countdown still lets the switch complete (24/24).
    
    [1] https://lore.kernel.org/linux-wireless/20261025193615.1123718-1-mehmet.fide@gmail.com/

 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0d6272ac0dac..8080fff765e9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1569,6 +1569,9 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 			priv->cur_beacon_conf.enable_beacon = 0;
 			ath9k_htc_beacon_config(priv, vif);
 		}
+
+		if (priv->csa_vif == vif && !bss_conf->csa_active)
+			priv->csa_vif = NULL;
 	}
 
 	if (changed & BSS_CHANGED_BEACON_INT) {

base-commit: 9d8ec0b5b5295bd23d979d1b2b905de25c36fff2
-- 
2.55.0

