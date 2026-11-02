Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622875;
	b=yU8Gv20ZNv2aFoFngn2O2FimbaoKAAAEiXMJYo98qwTXgacOOQ5CbBDWKm0pxNgvESf2
	 1EHggRYEswCR4WSE2dDJLnOX7FZ/zjcsKyerM+oLdJSDKVamSUmWSFmwMPk1o8NLwBCkE
	 y4WjUbvn7R5RdI2h6t66/yqhtp8RRvE2B0fWyi1D4m+/BqC5ywDSlnrJ9p2/EEEF6HdZc
	 +TZiHoWb6VcYeWha0dWJegrcPR7rgFYU9tde9VMR5x1igiX/WOoaY8h0Es2I0/+a7BNo5
	 kceFg38VluGltPeD8reAW3Q80JbZLoJfC8k3XtoUzD1jnajl3hGuH55RvcRqvfKyBYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622875;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Swv5UcPabS6E/hCnFYMyFqMC2vY1/PiK8X3IqFBNP6s=;
	b=HwPbDrQeYVpB15kgsdkzCUARWKXsOFPS3CUYPEj00k3pZdpaH6c/A0jOlhy4Rcq5Ec3f
	 MNPlpipfhAK2U68pquXnpEA+11f+45eBjv7fA3qr6UJZkqz9Xw/a4WekLhutrbMmBh0/0
	 Qxdbj8yANMCq/ZTgi0nIKTL5UftuIShnudLJVcLULAnJO809Uz+Cx2nMWNK+uy2k8nnjH
	 bEmqBGIAyjyOwqECy4zbMRxyP68V9xjNJ97izdzLmTKpoPvPxGJXefxZaD6b2xEt8enqJ
	 72JUyC1Y4ytwvKFZi5ru+OmqqDsadd6w+cSosvWjsSlNMcMkfM8bXG2LqNGERckqXfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hgJFK76F;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204E6606A331
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 204E6606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hgJFK76F
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a5720b0a57so20917075e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793622872; x=1794227672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Swv5UcPabS6E/hCnFYMyFqMC2vY1/PiK8X3IqFBNP6s=;
        b=hgJFK76Fhm36xxhyzeI19UjhN/oZQigsRWrV+LXDfh8ZK4oS9UheRcAzrtHTeSkRza
         U0Byj7jhlD6yQRkDuepZBjfML+SEELFp5EGYGQ/4L+xj6j4W4PhuFFaaZCpONxYYOPus
         jnq2gMFzf0sCVXsf96NDXuKI92p9xaF75mwClvJGsa9lAFFs4GRoZ+Y+i/JZegxxE3rb
         z1mf+SntcEZGrtgVjxsW6A5HZ3xRBH1EkhwWn00cA23KnjsaslzJmESbnz+RTFaUJIz9
         UsQt6tUH0LZJxUdQBHjGjBGCrCL3UyAHMrdSVFqyGLddAADBnt4Gi7Yz9lu7mEgaGfY7
         xH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793622872; x=1794227672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Swv5UcPabS6E/hCnFYMyFqMC2vY1/PiK8X3IqFBNP6s=;
        b=Bz9tSd4Z5MIgaA4FSqFMSbeBK2nPuYV5KIRiqnMJdXdk3xnmKGlDbiiV//2GVc3JRO
         JRA79P3uVH/TlMC5RbQJ1fBd1QL+eIafrjtLadS+GFW41CAjUfSpRhEJSdg03jczLWtQ
         5IpAPSCjI2DOCTWxEyUrNZ9eTMvnAPobr+qooQv8uJY5CrzFoIfVWJg+Ayg4n6KoWDOA
         GhPDVEIDV1M3blRXLhBroCrmPlWdkFDCMM0NLemvkk+t+/p1Clcb2eRVp3gRsWieaiRV
         P8kfx2TI4VoAn8stENMCk07haKQtL/P4sRs3KFVFFsg6C04HGaMJ1Z5vFdFhWFtcVF5B
         dUMA==
X-Forwarded-Encrypted: i=1; AKwUvBw9gIaDVK9jzVV18MfLxOnubH9UbjwMNK8MOji9LZVp2LSxD/WSSVW6ce1acoui0do3+s4P3ZDo72pzEkyWCQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJN9PzpFABRxnU19TSvuK7IlPKSXQku9JIAldKarHKBXioOxdwq
	t2SQb7Mvt3y432cytGQXk0fsmAUyhqVRK+grcN8TZ2xArEDDyuZdWDyP
X-Gm-Gg: AYBFou38EGLBdmwt2tWDS6nKV6+Med33Ky6DYWJ6vDCSCxhtP5zLjKfpOQXKEeSgtUT
	fCjkDQkdT61fIW7cXpWq8rHMYPgwS/s9CU3r+i793a0Ya402ideQ2OubPvxUEN8gm2e9UdbMjvP
	kJEVp+6EIrtSlOmVEBdZed/Wp/rRsB0LcqfQyNyznAu9TZ3VbeAUaoeeztmvQi+yEF1wCrdJGUM
	H48MtAZUUxOYA1gzr0odImzy9LxNw/iibCgiETbsASw4fOWSRSFA07vqXVz6Nrk/q3S1TwYZu7O
	2ajTPadVomlcDBlEy6V1xittz5J4lB++TovggxSsUxhQUVC1OOzG5fhE14ABbpYnAb4h0jyDnA4
	YhqpVGtZx4ssY28IWZweDAWJ1KLHBONXvIRZHeLWxgYDYqBQcgDHvujrZrz0kXhEGJcDLAvNGj7
	pwE+u3Xqav5bVQYuLUTCRv+ZFL/ieylVQmPeOXF4jCbc2yPRpZ8iSohBveEzfztJLCUz9eOWc1c
	uj4rAPwirtDfxFFY4WnL7MbjTnFWEbLfxeBLUIaRXcU2843GjYsl1GMHfgIdQfGbjceiqHD7SrM
	UzzaVTIMy4TKAGB6Ap1bJChK7wchQsvkLQg=
X-Received: by 2002:a05:600c:3554:b0:49e:6581:7baf with SMTP id 5b1f17b1804b1-4ac14ec66d9mr242086245e9.2.1793622872329;
        Mon, 02 Nov 2026 04:34:32 -0800 (PST)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80ecbsm20321842f8f.35.2026.11.02.04.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:34:31 -0800 (PST)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH ath-next] wifi: ath9k_htc: do not fetch the beacon of a finished countdown
Date: Mon,  2 Nov 2026 13:34:30 +0100
Message-ID: <20261102123430.1136741-1-mehmet.fide@gmail.com>
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

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

ath9k_htc_send_beacon() checks the channel switch countdown only after
ieee80211_beacon_get(). mac80211 replaces the CSA beacon only after the
channel change, and ath9k_htc_set_channel() re-enables beaconing before
that, so an SWBA event can fetch the CSA beacon again on the new channel
and mac80211 reports "beacon TX faster than countdown".

Skip the beacon while the countdown is complete and finish the switch
from there, as ath9k does for non-EDMA chips. Finishing from the skip
also covers a count of 2, where the first fetch can complete the
countdown before csa_vif is set.

Tested on 6.12 with an AR9271 AP and hostapd chan_switch: the CSA beacon
was fetched again in 3 of 40 switches with a count of 5 before and in
none after, and all 60 switches with a count of 2 completed.

Fixes: f0e449627e4a ("ath9k_htc: add support of channel switch")
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 81fa7cbad892..2b5bf07511bb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -214,6 +214,13 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 		return;
 	}
 
+	if (vif->bss_conf.csa_active &&
+	    ieee80211_beacon_cntdwn_is_complete(vif, 0)) {
+		spin_unlock_bh(&priv->beacon_lock);
+		ath9k_htc_csa_is_finished(priv);
+		return;
+	}
+
 	/* Get a new beacon */
 	beacon = ieee80211_beacon_get(priv->hw, vif, 0);
 	if (!beacon) {

base-commit: a3ddbb45768717b5c9f923489387cf55c838d1ad
-- 
2.56.0

