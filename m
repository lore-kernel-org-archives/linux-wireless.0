Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793555066;
	b=OkKm9K4oymssWRNgPxAwK6uBM+iV9vSByWRCoFvqPUyCUX3asZzwrBxiXhw0PNbSdr6d
	 AZYtBUF6akLUgYl/OPkJpxRd0bMBaPHs+8YbWFOxVMIZJy74/dr8+YZ391K0+XVjuaGA1
	 IFdMIS0c35wyjmIt3Zj3wG3pfPizPvaiOfql823TUxO4euTRmNeM1wpHeFRiCAxNy/fgp
	 sHJf7N0DjPg4HY4V/kHLJHm1M7Dvmp9Z2wIAcTJJRUuOFHBoDsybf+tNuVhHGZcsUDlly
	 5e0+QednCRHTGCyHh1/a+1+whaLOD714Da7YW/4zvAnqPWAUYALMQVKlB+X/DFzF4qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793555066;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9O61ATkKp+DlIEXsj3DD0qBP/WN9VXV3+UsO1P4gT6Q=;
	b=emZwH0wxGfyNECtWrx+ORx4SkxSjD6mQFVvqzGjelvDRbYpyszi8dfKVMGQY90P/7+IR
	 GKj8d5Yy87sNjY2TrnJP51HZ/o3dWNSBp8Q6mpY1ktbgZr9/vfIiLIG8uEhJvIiFsNEc3
	 WY4lnCZYLW3jGtf0khjzkzGka71jsGvJJbl5+6EvuKhu8BSRdGfB+p7V2/0JSeJd/CPEe
	 gGGs7ghCMXwTdYhCEd0/vXtpBQtz+xLrt5XhYiwBU3memX3frGYfoX273ccF8QjH57nGN
	 0d32vCtcOZNkvPpjsNnKSjZEqUO1u90U1FLM3clwp+K3RM0YV9yYgDzMVgBTr0tUx5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b="Axr6b2C/";
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B530606A32D
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 17:44:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B530606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=Axr6b2C/
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b3dd83e779so3988482a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 09:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1793555064; x=1794159864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9O61ATkKp+DlIEXsj3DD0qBP/WN9VXV3+UsO1P4gT6Q=;
        b=Axr6b2C/htBA5mpk/A7z04dUTzsIIuRRDwi1GBxebzzC2Wr8Mj+BOuS4O5dONN1yZ2
         fFczSqudfLWZpQS4yaHhhl47jufjbZ8fOSmRGeFpwJRAtxXn1mgKHJaoap+PZ+OdrrXH
         +Yzt71aga+okNJ4AK4sp85zltvrNWePW7mgBlscR+SoTIjkq3HGj0JigZytcBsRjbvqx
         AEuM+XMtdwPKbx7s1FsLoW8NA9vOqey8NOgImB0T1spm4yeIzoXsBr81NrITfTjGd4jp
         QmHObgnt4Rs8ZrcJvOxldrUdxupBDSvPe/dAiFWyAKsFWM7aTAXx0HjTZhypALvYtOSP
         Lcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793555064; x=1794159864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9O61ATkKp+DlIEXsj3DD0qBP/WN9VXV3+UsO1P4gT6Q=;
        b=aOnmgnVxAa46EBuKnbOOnxb6kCRhw+BexjQL2XdM95PbO3m/Zt9/QQCAusvwTsgSBE
         hsmyWxwZNpg6/8Ft/Nn5DgC1mqZMuYAVl3+W9/78XXFAH049FMUus8MPIrVyV17vz6XK
         tI4bWnekyfeeuvfTuecaACHI2izJ0w5+6OOH3xRIPLT6yZ4GqDn9fk0O5kmlXIjHmzmv
         ak+YB0xdlmjHBBup+9Tp9aZ3I7RIFoS+HGPx4ujYZcc5NuxKc/LyiDta32HQ0eRF1tEi
         Jxs9SerP15i3Z1H5Fk1QWfk+F5j7AMjrxmAcDEMFXJuzKIGpqV4zdA44VQMDgtP1N3L+
         yJdg==
X-Forwarded-Encrypted: i=1; AKwUvBzBiGWUC1bp93vI8jX+Y0+bC5R3eSA5wDj/3C0hIZbw2dXB9zDlVqD1UZit+7ze7uHNEs+3Dzz2fkuwIYUMxg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+NXINvH8WJeWc3pHbzMIMgVwqmzt1xbUxEgvx5lKd7LD8k/t/x
	32dLdVAU9+kRpiSRnKyMHTBZJbnfSGgaWt9qJiqriHMuFdg/wI1RPoIopRH/KXt9CA==
X-Gm-Gg: AYBFou1RwpFJsh4Y3sAj4evn2gmunxEJeccHJDpjJJzgJ1lSxxsehyUFkatR62bQi/W
	0Z9lo3EMxmmnpZwmEw3lt/3jK37AGOenSxM/CQjwyyfU/Y6nFW0+rLziQ+pIhmiw9CHly1IyQX3
	YFML20fn6n8QVmCgczkRN0xe8w2dwmY9mcDJ1jz31oaNb1v9pedo/osVVCQsOUpa3kS51RmjqWJ
	PbfODirLZjWzBJdCYIm7gZ9c3RygR+89LM7dUTRmWhL16S/yLm4OSzeunMtQ+d7GIuJbAH55fG2
	vvY1wzpEl8/P7np0ovgpp45nDniq72ZnWOmc0cR9QZSsyHy5Uo9sAXp3mpidPsqDOZWSQBnZjzb
	uW2wM/TTKDEn7p/DgRTcFshwvKd60M2NMeEdW3tBHBGglzwa9jgMV3ul7F6NamZZHrHlG0Bb+jA
	yJHmRNfHUKic33eCNikudNvh0mf0Mie83BUi2wcQPxEckQB3hBwCvkBM0hmmJoSNwT103o0JO4U
	SdTtzxReg/+ZejyUwQwOHbg3ALrUI8XQfoqmkVLvkACCKnpM9N45Rfbv8DMLCvjlkJsOuhgrVAg
	yUSCLyZ9QI9MdEYb6Xk2OSgK1w3xS4jY8gqnXYNa/3vMziNsIjMTldOrUsKqLI5hUQA9gg3EtDv
	tmV+1niFbd/gMVZyKO8BmKbMJD+R3h3MKH+VouC7DP9fSlWWzaoaGs79DFmNNbZqZWeLIBcGyag
	Rj2BhNWsWZ7gzkiqrsabt/cGoLlxAe2OxdiAetVjUf8nrXWIsE/H/XOtpWiKRDUTmmDzXwv4FFx
	tc6HqE83ez4qGIhUznrFWziXPIVB3EXNn5N/U6vtS0cOAPmGakqdt+UN+iKk84VKisdkV21+Ied
	LL1jtwfnGZoNWPP9sqk=
X-Received: by 2002:a05:6402:1d51:b0:6ab:7700:9371 with SMTP id 4fb4d7f45d1cf-6b4d468b63cmr5289419a12.25.1793555063954;
        Sun, 01 Nov 2026 09:44:23 -0800 (PST)
Received: from Desktop (p54aff7cf.dip0.t-ipconnect.de. [84.175.247.207])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4eca21356sm2369094a12.35.2026.11.01.09.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 09:44:23 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath11k: do not fail down transitions of the station state
Date: Sun,  1 Nov 2026 18:44:22 +0100
Message-ID: <20261101174422.1275413-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
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

mac80211 requires sta_state to succeed for down transitions and warns
when the driver returns an error for one. ath11k returns the result of
WMI commands for ASSOC -> AUTH and NONE -> NOTEXIST, and these fail
with -ESHUTDOWN while the firmware is down. A station removed during a
firmware crash then triggers, for the disassociation:

  Driver is not allowed to fail if the sta_state is transitioning down the list: -108
  WARNING: CPU: 1 PID: 5952 at net/mac80211/sta_info.c:1561 ieee80211_sta_eosp+0x119c/0x1668 [mac80211]

and for the removal:

  WARNING: CPU: 2 PID: 2080 at net/mac80211/sta_info.c:1652 sta_set_sinfo+0x1118/0x1144 [mac80211]
  Call trace:
   sta_set_sinfo+0x1118/0x1144 [mac80211] (P)
   sta_info_destroy_addr_bss+0x34/0x48 [mac80211]
   ieee80211_del_station+0x1c/0x54 [mac80211]
   nl80211_del_station+0xf4/0x174 [cfg80211]

Both paths already warn about the failure, and the removal releases the
host state of the station either way. Return success for every down
transition.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
ath10k and ath12k return the same errors for these transitions.

I used Claude (Anthropic) to help write this patch.

 drivers/net/wireless/ath/ath11k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa37d1..e5bab84a36bbd 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10074,6 +10074,10 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 				    sta->addr);
 	}
 
+	/* mac80211 does not let a down transition fail */
+	if (new_state < old_state)
+		ret = 0;
+
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
 }
-- 
2.53.0

