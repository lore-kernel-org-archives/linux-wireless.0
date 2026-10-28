Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197051;
	b=bJyubJAhEFfuVJnvCq8fCy0UXvnkcSef2J/Ht7WGz4guFz6GzgpfYgGVi97aItjswlJM
	 ucIlmFvfEw0ZTz84hApjubVxa1fhf384xDV5tHbIy3sJekQmSM+F3zH7Iv9ebZT7oYhgW
	 a91XbMYhIoPRd8qZcxKCozDlFoHb1er8e/XR6tGIgFMyS/SC08KfWt8qhOjg6rWJ5xYBD
	 gqN3aeMt9Otb8x7On1DDNX8HNySSYZYPEBychZG/NISr2YGLSHjkv/HyRA8FwX8adJIeU
	 oayNCHbQuN3UjMHpCxL6CpAfk6fYRs5xEdUoRHUEyEJzxIrryFfXtW1KpuxAv7ncNjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197051;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=400J3GHcIQLYwc1sIdmefx5I/Bqi2GbTm1mkxszhp6A=;
	b=RpiFUfrdarmdmdenHAUNmNVwbGaV40u4sZuc8P6tYID82Fiq1WlZaJHzunmeIII9LvYa
	 +aaPkai1aEQ1nrfkZM3KwgDScYI4VLRjUuoiLH2RyF+ERC9laqcaIcmIChzcEQI8Ck4lL
	 816xdvGs0yFT/NJdiBnHEf2px82ufVeyNKtFN1U6sBKeNXxNrvoZykIzC6odfkxrVyzDn
	 Vh5nUSlJqAPV+9kkryaKu2dVDER6VpA0W4MYoZ8gO+KKyOGM4+hh4yEr7vsNe72OnytmO
	 GcFK3lIQyO+4cqfXzpl3SDbntxidXxoatkVRGxfSQZsw8y+WZLLDJmqdQ5L3/UchDvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DXYDhQyP;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0A9606A320
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:17:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E0A9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DXYDhQyP
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e5378b281aso5332955ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197050; x=1793801850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=400J3GHcIQLYwc1sIdmefx5I/Bqi2GbTm1mkxszhp6A=;
        b=DXYDhQyPBdB+66SGq5pe4HNqA7llbQQiVEhcYQMMEPtK6oNXB6ldbDG10MbPNB7CNO
         aVArXI/j0nIa9vUh9PwsdlfIrqAkdy/c6HfY0v7X5QrV+HLrjycExkRtiaEfxEGrVUKY
         NtBkwW5x2i0mCLvIHwZWzqaRklYkVabxm4ix1PZ6eaY99yJVEOdFoyCFmVPqzumzSz7F
         MvWLFuJ0Ndl+UfThsEwJLtrxMxRjMF6MPJ8WCdNVsA38Fu+0Yh1DxPfZNeYJMgMFpC+3
         pybBmYTrNyTcAGj1zaZqUS/nmWKXmPKTG3tNAQecnDch2OdIxy63hjn3eHArAlqwTwAv
         3bHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197050; x=1793801850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=400J3GHcIQLYwc1sIdmefx5I/Bqi2GbTm1mkxszhp6A=;
        b=o4G/b668XgRKCsGprQY6AhjOOER1uwp80vp8vMv2XOpoe/Yt87QI8Rc4s3MA2X2WFt
         UKwNrfNSUN9f0R0mFOp5tmJdEWsCk8FTF23Fat9+nnhqjObd9N0k9H1cLsohRVW9drtP
         KAUsn4UikpwwIlm4VVCpRpy+X3UNEwXz6hIyYtmO5akPn9nbwP3wG5Rq215TabGPp2AB
         hw8l+uJQnrNkw+lbQsr2S20L1enfcjHsTKyLBuRTGwM+CJPuCMfzLE0Q6Y0GviQCtAie
         naiadcFSioFxuH2Qs/LCKMyOBgQHWtfDUFEALRELCn6/BQd/ZWk50ZOODXiDjTKSyvsH
         8DiQ==
X-Gm-Message-State: AFq9FYLPzpi6VVPZacRIF/M/rNdM7oNZO2lwBVyXpSZESlBaI594WCNR
	ZFHof/i4lUZw3KMiN3BBK55cTRBcKiPb3HDFHG7mxE7hTkrIySfqe5mHPEPdTfvm
X-Gm-Gg: AYBFou0g9I/QBYWu6les7CMnnRUihSV6KX1k8wFxsNL0JRvWnncIQgBpOFtiscHS2Uf
	rxUqUlp++wiPOyIxCWzSqS2wLiNCimKTUgFnRfRR7zTmCTS3uBG/DHIXEZfrPKWySvWhJQRm8K8
	rCX6+LVH1k6h3txGSQBeU5u5FqwhE8mGv3ctOufZOCqfb2aXFUzh7oYBiv2kx2DLckMV6lDzQRn
	VOvqDB2ozclQSsTOi26XT5yMctEPHtRginnK3DN7eRtQ15Mh/fUCBeoQGBDoJg3mD22PVxNEuGK
	hiSsPmtnFsG+ccl/RmG7er7jBTa3X25Mn8GUNE6CbECbylFPGIk/zpSL2NOGKu4ZUwXapl/kF+z
	WsQT0hg42LSTR+YA+4ZDmPTb+sRVYnZiSGzKWUnT8dlH5HNqrYqLZcxhGt6AutVgeJU9AvViWlY
	AYJ4yDDri93jcxKvNCqCuk8asKEDYolUYXEh/4dixntsG+G1KfJuI251yxIbq7ok1NMmohnutI3
	nhQARHG9DTd/EtvmRkF5hErM+xNVR30lH+lxFyeo1nU9TIsEw9twEuFYZr9nSDnhnitC8xW9hHv
	r7fVx+eAXImNfDZw+ZgZFiWpp134b9UrBsOBWPKqyRfXqFBLHw3KkA4WmS/mtmnVq3PV
X-Received: by 2002:a17:903:2447:b0:2ea:71a7:7f21 with SMTP id d9443c01a7336-2eb002e2967mr23279075ad.13.1793197050082;
        Wed, 28 Oct 2026 07:17:30 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6b76dafsm22396935ad.18.2026.10.28.07.17.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:17:29 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mac80211: drain link readers before stopping removed links
Date: Wed, 28 Oct 2026 22:17:08 +0800
Message-ID: <20261028141708.5532-1-enderaoelyther@gmail.com>
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

Removing an MLO link can leave work queued on its link container after
the container is freed.

ieee80211_tear_down_links() stops each link before the RCU grace period.
A reader that fetched the link earlier can therefore queue work after
ieee80211_link_stop() has canceled it. ieee80211_request_smps() and
ieee80211_csa_finish() can both reach this window.

Record each removed link while removing its keys and debugfs state. Wait
for RCU readers, then stop the recorded links so cancellation includes
work queued by those readers. Free the detached keys after the grace
period as before.

LLM assistance was used to find the bug and review.

Fixes: efe9c2bfd1a8 ("wifi: mac80211: isolate driver from inactive links")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. In a QEMU KASAN
guest on the declared base, a built-in test reader held link 1 under RCU
while ieee80211_vif_set_links() removed it. Each of three boots reported
22 unique use-after-free reports before the change and none after it,
with no lockdep report. A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

If "wifi: mac80211: free keys asynchronously" lands first, the key-list
context will need refreshing; the RCU wait remains necessary for link
readers:
https://lore.kernel.org/r/20261026125145.68153c510dfe.Ieaf95b8e1336f07866f54d174f699c6aa079d9b8@changeid

 net/mac80211/link.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 931950a10508..41c7dfc49a24 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -191,6 +191,7 @@ struct link_container {
 static void ieee80211_tear_down_links(struct ieee80211_sub_if_data *sdata,
 				      struct link_container **links, u16 mask)
 {
+	struct ieee80211_link_data *stop[IEEE80211_MLD_MAX_NUM_LINKS] = {};
 	struct ieee80211_link_data *link;
 	LIST_HEAD(keys);
 	unsigned int link_id;
@@ -205,11 +206,16 @@ static void ieee80211_tear_down_links(struct ieee80211_sub_if_data *sdata,
 			continue;
 		ieee80211_remove_link_keys(link, &keys);
 		ieee80211_link_debugfs_remove(link);
-		ieee80211_link_stop(link);
+		stop[link_id] = link;
 	}
 
+	/* drain RCU readers before cancelling work they may queue */
 	synchronize_rcu();
 
+	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++)
+		if (stop[link_id])
+			ieee80211_link_stop(stop[link_id]);
+
 	ieee80211_free_key_list(sdata->local, &keys);
 }
 

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

