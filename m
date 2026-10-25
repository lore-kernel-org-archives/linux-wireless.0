Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792897514;
	b=DlE78wATVy1k/UXhLs83hHxoNmmd+GSq+EZMgfUAjWrwNOuktJKB+XUIzTGP4l5wZZsE
	 fR+ZoFmOdppucoySyou2yszub1EEG2XLYtY7rlsEfIb2kcg2B/y+LmwH8vHJLlmlB5kfg
	 kEyynwDmh/RgROrDXwC9fccYjhX2R0rKmpNOn/efvVogpAZ8LEICCceLzQ8/AsKctZsmm
	 31ZBmaYJEC0cqD9cSImwSIL8PLv+Dt+2QON8fqUUMWbFlwMfShENZxHTB20lPZs11B0hB
	 RY8FX+OEpA7LPDKuFGmE1qg+fUF8KzacZHIU925mwqL+YJKVR94q5BPDQqy30NG2XaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792897514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=p/QFAv6ccqVlvHGU85S9cnOjWRRSIovz0rOvr/3uAkE=;
	b=BkHMOzI0Mp7IizYOLX6E9wTcChATpmAeLxAjBynP9Pq/w8ivQ2k/1kv9fnv2QtTUP8IN
	 qY5k/HjKH4Kt3TGm4x26XW9G7IJXg7hPPPIhdVpW2KMKN8b2lH5YunEgi4Vxfb5c4XD4o
	 OoT3eflhGpw3AGivc+8tQtl/17H/g27VdWGJ1jdRPG8pLq8jzCExgpGpT6ZuZPkze7HYA
	 6xbrHiNoe+RzN2ouwbBbKANQCOzgIH+hILtyrRwuwKjtgPHlAM984LfTJXg5byIELJx+8
	 Sdz/yBr08lY2RE1+6YY8QclQpu1g+lGD6kukWhKgpW6Ucp7l/6XrsF3fdGlRzDZWAFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KqCTg83i;
	arc=none smtp.remote-ip=209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED4B606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 03:05:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ED4B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KqCTg83i
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7a6e560f580so1381311137.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 20:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792897513; x=1793502313; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p/QFAv6ccqVlvHGU85S9cnOjWRRSIovz0rOvr/3uAkE=;
        b=KqCTg83iJu3JeWaIUmuu4tNCoRuFCECQdIaPpOukXLXn8f70pV7vn8R/FHqf4QYtwg
         YO4qyLCv+q1ulTz8DCGGojOYzTgg1AUFz7UvrK+RIm9I8WYUWpBOXzKz8uYEldwbsnut
         jjVx09MfH0yemePwkXKhmfoC50KVRZFWOBZQxqkTkvH4UdpaEqmM8KJj6JxHFrcFJtr4
         cV/up9zmiEPgOk3MjTXa4m3aEIFTfEWg44bULE+g+2CBzUO3WaAVxgy1atfs2XJMgeYF
         v9ZatU3m8/1OfzfVFzf8h8ctJWA8Bg4S5gkIx0oOFJ3iTelqVyDejIwEuc7rQkingxbU
         lKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792897513; x=1793502313;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p/QFAv6ccqVlvHGU85S9cnOjWRRSIovz0rOvr/3uAkE=;
        b=E9D5CyMZu/Jz/MAKOCDYJDeCYy/u2FzhF7ksjRvZe8dTMbztwh5phZPqbFvRwxcHDt
         W8ac1JJM+0pMWA4HhNgjey0r+u5xKkX6utqTpiOeiOr2NYF2wz65dGY3c76tSXB+kcvP
         xCqiI4KV1bzNlULpF5v11wC4SuqO11izluPgm+qXDDalBwbHdP196abcBXVRa+CtRR84
         fZhJ+fHtcYFyH/v+8lyrQoiQbk63+l8uzWpaAb7hUW1IFal+6mCiJ/s66n+L904BfN13
         pB/iWQLBECTMzO2294JuQOncdy3XYFwYFsgHVXSZb8X5VI0aqWzDb9FF/TpMyAZidRve
         txQA==
X-Forwarded-Encrypted: i=1; AKwUvBwWB8CKOg4l5V+eKF26UlnMra2DFU86zsTga02JegUzT6caSWlPNe1S7Vo17JazwYIb/xUXByMk3eWmEO4bUw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJGIr0eUT18JHggaqMBNoKsKgPfwisqPzcvy0QTFpxHYnlJT2rt
	Bp76lDNn3ouISVjlkOsbuTBvg1IsC2LbCCutD7H25A4RMACV11CCdPP9
X-Gm-Gg: AYBFou0ScGO1pZLu/zjq782QHAewkNIaBKOy4rFSdwBUbs2i2FMNaEpDvbmClacZRLf
	CstyjUv1NOozvaNRHUImFAvsG2iH6Nmtwr69yYe3R63C3cyDkdIyExLDv5aLttZpzbm1263/qLf
	piosstPamhCYe/5Bjiy/ovWKof/3QTsEP4T2HluODeHasB3utCU0k/UNZtVW/1I20KuEzJnzXyh
	mfZILEje7aEoyHXMI8f3vX6DASCRDEBdvW/TJCPLYX03LsNDuys/SLKsjqIjUr9tBJMx1EWJ7OE
	nDF9BUzTRRSdd7LXsiBmVLHJjkmiwAnxUkE+39f09+3OtjtgHhUmbkEeoSIHCV8Bu7R0uQXBvYM
	Cf8QaLJtDrrgzb+M+yrPubsfMMngcZBhn2vYsOkLDECCvZEsH9rcPrDjo741nqqh2JqnU2xYbRj
	MCtfV+H1AUa9gUMgbYkk7YtScUN8Ke1UQnS0D4TLsTYkuVRzjtp37yMm6yBc2SI5CHSia52tosU
	GDPjqY9lkPoGt7iPpmUhJTjB3+yXMkYhkD9yMQjfHbCTp2yFGzE1xtwJMS7YBM2OeEwEqUwFgX6
	gBiXIPlSO1BSEmG7DIJWdVOWqbtKeyT/syBOI4tbgBQFgVgUxDc=
X-Received: by 2002:a05:6102:3e8f:b0:7c3:1395:a090 with SMTP id ada2fe7eead31-7ce5cca8d37mr1117124137.6.1792897513242;
        Sat, 24 Oct 2026 20:05:13 -0700 (PDT)
Received: from 1.0.0.127.in-addr.arpa ([2804:7f0:b101:277b:8118:1af6:d493:fe05])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9910e80701bsm4189123241.11.2026.10.24.20.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 20:05:12 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mac80211: protect the mesh RMC with a lock
Date: Sun, 25 Oct 2026 00:05:08 -0300
Message-ID: <179289750857.55325.15619359041208016782@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

mesh_rmc_check() looks up, unlinks/frees and inserts rmc_entry objects
in the per-interface recent multicast cache without any locking.

Until mesh fast-rx support was added it was only called from the rx
handlers, which run under local->rx_path_lock.  Since then,
ieee80211_invoke_fast_rx() also calls ieee80211_rx_mesh_data() (for
plain frames and for each A-MSDU subframe), and that path does not take
rx_path_lock.  Fast-rx is meant to run in parallel on several CPUs for
drivers that set RX_FLAG_DUP_VALIDATED and USES_RSS, such as ath11k and
ath12k, which also support mesh.  Fast-rx is enabled for authorized
mesh peers as long as the driver does reordering itself and no
unsupported cipher is in use.

A frame reaches mesh_rmc_check() on the fast path when addr1 is our
address and the mesh DA (addr3, or the subframe DA in an A-MSDU) is a
group address.  With two such frames being processed on different CPUs
(or one there and one in the locked slow path) whose sequence numbers
map to the same bucket, both can walk and modify the same hlist at
the same time, and both can unlink and free the same expired or
oldest entry, corrupting the list and double freeing into rm_cache.
The sequence number, and so the bucket, is chosen by the sender.

Add a spinlock to struct mesh_rmc and hold it across the lookup and
the insertion.

Fixes: 3468e1e0c639 ("wifi: mac80211: add mesh fast-rx support")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
---
Found by code inspection, compile-tested only (W=1 with
CONFIG_MAC80211_MESH=y).  I have not hit the race: it needs a driver
that delivers rx in parallel (ath11k/ath12k with several REO rings),
and I don't have that hardware.  mac80211_hwsim does not do parallel rx.

 net/mac80211/mesh.c | 16 ++++++++++++----
 net/mac80211/mesh.h |  2 ++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8f88141253..e3718a2252 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -184,6 +184,7 @@ int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
 	if (!sdata->u.mesh.rmc)
 		return -ENOMEM;
 	sdata->u.mesh.rmc->idx_mask = RMC_BUCKETS - 1;
+	spin_lock_init(&sdata->u.mesh.rmc->lock);
 	for (i = 0; i < RMC_BUCKETS; i++)
 		INIT_HLIST_HEAD(&sdata->u.mesh.rmc->bucket[i]);
 	return 0;
@@ -229,6 +230,7 @@ int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 	struct mesh_rmc *rmc = sdata->u.mesh.rmc;
 	u32 seqnum = 0;
 	int entries = 0;
+	int ret = 0;
 	u8 idx;
 	struct rmc_entry *p;
 	struct hlist_node *n;
@@ -239,6 +241,8 @@ int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 	/* Don't care about endianness since only match matters */
 	memcpy(&seqnum, &mesh_hdr->seqnum, sizeof(mesh_hdr->seqnum));
 	idx = le32_to_cpu(mesh_hdr->seqnum) & rmc->idx_mask;
+
+	spin_lock_bh(&rmc->lock);
 	hlist_for_each_entry_safe(p, n, &rmc->bucket[idx], list) {
 		++entries;
 		if (time_after(jiffies, p->exp_time) ||
@@ -246,19 +250,23 @@ int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 			hlist_del(&p->list);
 			kmem_cache_free(rm_cache, p);
 			--entries;
-		} else if ((seqnum == p->seqnum) && ether_addr_equal(sa, p->sa))
-			return -1;
+		} else if ((seqnum == p->seqnum) && ether_addr_equal(sa, p->sa)) {
+			ret = -1;
+			goto out;
+		}
 	}
 
 	p = kmem_cache_alloc(rm_cache, GFP_ATOMIC);
 	if (!p)
-		return 0;
+		goto out;
 
 	p->seqnum = seqnum;
 	p->exp_time = jiffies + RMC_TIMEOUT;
 	memcpy(p->sa, sa, ETH_ALEN);
 	hlist_add_head(&p->list, &rmc->bucket[idx]);
-	return 0;
+out:
+	spin_unlock_bh(&rmc->lock);
+	return ret;
 }
 
 int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 3f9664e4e0..27f12ebc28 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -216,6 +216,8 @@ struct rmc_entry {
 struct mesh_rmc {
 	struct hlist_head bucket[RMC_BUCKETS];
 	u32 idx_mask;
+	/* protects bucket[], fast-rx can run on several CPUs */
+	spinlock_t lock;
 };
 
 #define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
