Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197409;
	b=mls502foOu8C+/5PqXBJUMkjSLshNt1ojhT0gSdDE7qltfesPPY/yhuhthgxhbgEs2AU
	 /FMka2KOt0HrsgKFcA+V5oMX2jqMNsY/TvPQ1dLr4KbZfJ9iDS6irerI4hXQtS2YsxD/Y
	 JQ4/aIry+YvbLGxZwqE3xCo4YfhvBZWjdaeEw5PR09g9V1ExtllkJK2bM0AZxeOAFWljH
	 IeyWNnwHfrGUeUhYgkyfTG61UF7TmngHeYPUpWtOEL/8u/N+IFOkmbRr0+cqeP47ynD0d
	 pTaiRDvdOvzyciWxEh/NSB8TeFdJ8KFmVvw9del1gMYAsnrnNVFxiC4Go+gMDnTDKIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197409;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cVhL/LPEqcpTbY6iiAqPg/sDis35bxi9SXGTVRzvJJk=;
	b=dN+VKOkmlQ6nTAO3LcJa1eR+016LKcxH0tqhihb5jJGHZnG7XQXHwiu7Z6MiFXWUGxD4
	 gIwQyS92WxQLVDUk6NFygOBu8ZMyE6LN8pdoleoowcIeJ45qyglx1P2/A7Ke07U5B4Zdj
	 Vslmykw5vEoBfX9YLoPPo9uiu7SXowkrHQmBGOpEAZakN90Hsy408kPvzyeklh7p398pG
	 PjUvaDY/QxUP6u9W7NLi32/OoPkH0BuSBthOndyavXI1Ta2MhA3+hHLUL83ByiqwfXsQP
	 qkeYzkiI/MBX8SU2jQKU71Qak49NbV2W0bJaHcKw8bbiflmSJYTEe0vR/+zVvX1PCxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HlgguaRG;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ECD60A263A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:23:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5ECD60A263A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HlgguaRG
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-ccce6d9abfeso806705a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197408; x=1793802208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cVhL/LPEqcpTbY6iiAqPg/sDis35bxi9SXGTVRzvJJk=;
        b=HlgguaRGlWLQNo6tLyekEGWSTluQr4x8+lI5jUjOszfi6sp3Bogma9wO0oDsxUl5Qe
         pJm6GHL/WVae3wBHsJcHzE7zYgm2mbzlizZGl2vOYtguDKiaBaijMWfA2MYDN02wuYxT
         2GHBF1uHpMIKqY6Xg0Lz2LBnpoB9+4HE37L3IjhBilBI0gjTiye3+KWBWK5TugbWmiwA
         QgAyWyxFw9tIib33N8IuRV9hpZpmdyT/X12C6vhTWPqB0DWG7S8qMhszehxjMSqdnltq
         f0yU3FLsPGGBjZuNzzja7Qeew+KeUkp47iAW2oxwv62nhRXDm/gZKnO01U/FOMegNYdj
         w6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197408; x=1793802208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cVhL/LPEqcpTbY6iiAqPg/sDis35bxi9SXGTVRzvJJk=;
        b=2SiSwKwoSolLbKuA8mURKnpZfRD6VoCP4S3N+arDsTfw3t5Q3Nbh1n+s+3oqtbnHNP
         ivHZfAhNtekR/xf4UgFdrGEjalWpe19cAV0eVgkcUdxJjuLaT42IZgRJysm7Lklf4RXy
         WBrLJhZHPeKYWTHkxDXXG9E6/YJFSBFKGiFCLVuOAjdSafld1Qjrd612Tyqr4h4kTmCM
         KtonRJ6PzmCujf1tRJykhKCWjYboeyq3fpSrQWBzkIC0Lu9Qgey/2ViWPqw7u/9ksAOT
         yyTH5GJaulOpedamHmGVerEJUmTtgXjmr2PrqqMHex4roDwp0jBV2DiDuZ3XymrhwiLS
         7MPQ==
X-Forwarded-Encrypted: i=1; AKwUvBwhDUMeXzEsX+1ItXMnoQNlv2pNrxwT2rR7Q5N2a5AsraYYUcXqHPEBgfYI3qWSW7Ya22whdHtM8nGs1m9iUw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJYzx6kZtBKbq+HWDKCigBfXK7QvGRlBcjuwmgclUujCEheUJZM
	DxDY+j40y0+Jx/xRwE4m73RN+cGVuM7TlHV0dHrE0IsHDQyd7z4lfpfz
X-Gm-Gg: AYBFou3Ck2REhfOdFLG88YDjQpB6ZdaSb1axUBWN975OyGKrwV3ghTQfi63YMTxwfSO
	q2uXJTZS2r0g1VQJdo/1VnkqJj/HHFR3Y53npVeLjs9kCK2Q+gSElhUEJZiJE4jVHmezbMFJVa8
	9gjSN1DT8fNcuP3kENYRt+zcZzPmERZOP4K1t8uoa8mA+BKQwRY6piFmYn45wr0SSpGv550UiFf
	E35i2Q+98eoOiodfYX+ra0fCCutIXFdFujNVgyHSbGIVl085AfMs7KLDMqtMTsGPnVcMBPR9NTn
	lTgNAgjIgLTIx9vv0Mnf1CYAnjFBdCTZNIhxGBIAwdEcJrzhT1nh2S769m8J0MWLqk+W0ST6nu/
	txYWVzb0PVy/7A2nPfOKHggTNAa2gHcL/QV45YeGTAZwKxx7g6InLzVBKuEW2hQuP23Gfk8KXYC
	kkF2erUsVdUP/TNo7KYAsA/ZhdJjvh4BJuFW6fbZ9dFmN+g2swfXK432UL9FDUjeWpXpG5mQKUG
	d0PLHD4MJAKTJ+XDqxuNHqA7rFpb6EthHoTus/ctNKgwiD8x5AwbqyaKkWjbFb+81yMPHvt//32
	YXQcaimEGwFAQrPUiMpNzj4VyuDQVMRmfqbAerNm+CZDcwFkxEG2sfY5Uz0DzluFBe6X
X-Received: by 2002:a17:90b:2891:b0:3ab:afca:1d79 with SMTP id 98e67ed59e1d1-3ae581b45demr1855722a91.21.1793197407822;
        Wed, 28 Oct 2026 07:23:27 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a501083sm3773918a91.8.2026.10.28.07.23.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:23:27 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rostislav Lisovy <lisovy@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] wifi: mac80211: bound pending OCB station allocations
Date: Wed, 28 Oct 2026 22:23:02 +0800
Message-ID: <20261028142302.16634-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028142302.16634-1-enderaoelyther@gmail.com>
References: <20261028142302.16634-1-enderaoelyther@gmail.com>
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

Delaying the OCB station worker while frames arrive from new peers can
retain an unbounded number of station allocations.

The receive-side limit counts installed stations, while new allocations
wait on incomplete_stations until process context inserts them. The list
lock does not cover the interval between allocation and list insertion.

Reserve one of 128 pending slots per interface before allocation. Release
the reservation on allocation failure, after the worker inserts or frees
the station, and when leave frees the pending list.

LLM assistance was used to find the bug and review.

Fixes: 239281f803e2 ("mac80211: 802.11p OCB mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. In a QEMU
hwsim guest, a 2048-address flood left 2048 OCB stations before the series
and 128 after it, with no KASAN report. This is a resource bound, not a
memory-safety result. A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/ocb.c         | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9374c2942489..52bc69774ea6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -696,6 +696,7 @@ struct ieee80211_if_ibss {
  * @wrkq_flags: OCB deferred task action
  * @incomplete_lock: delayed STA insertion lock
  * @incomplete_stations: list of STAs waiting for delayed insertion
+ * @incomplete_sta_count: pending entries and reserved allocations
  * @joined: indication if the interface is connected to an OCB network
  */
 struct ieee80211_if_ocb {
@@ -704,6 +705,7 @@ struct ieee80211_if_ocb {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	bool joined;
 };
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index a8dd4f4dbf70..90c43eec61e3 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -70,9 +70,18 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
+	if (!atomic_add_unless(&ifocb->incomplete_sta_count, 1,
+			       IEEE80211_OCB_MAX_STA_ENTRIES)) {
+		net_info_ratelimited("%s: No room for a new OCB STA entry %pM\n",
+				     sdata->name, addr);
+		return;
+	}
+
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
+	if (!sta) {
+		atomic_dec(&ifocb->incomplete_sta_count);
 		return;
+	}
 
 	/* Add only mandatory rates for now */
 	sband = local->hw.wiphy->bands[band];
@@ -145,6 +154,7 @@ void ieee80211_ocb_work(struct ieee80211_sub_if_data *sdata)
 			ieee80211_ocb_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);
@@ -228,6 +238,7 @@ int ieee80211_ocb_leave(struct ieee80211_sub_if_data *sdata)
 		spin_unlock_bh(&ifocb->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);
-- 
2.56.0

