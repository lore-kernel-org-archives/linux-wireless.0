Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3163C40862C
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786623377; cv=none; b=oo8p1E9fuovBMqSQIigrkULf8liTz013xUuqbZ5kJUxUb0VAIzl4xGPcCnPhyDIgG4+W48coM4LTrIFZ9PHISbMTmRxj8P+cf9unH1JFaSqsNUi5Iv+c0OewdfrUyza80/Ecb3YTfwwsLdQ790O0SiUTEB1OhFBwjcIEmCP3C0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786623377; c=relaxed/simple;
	bh=3qDa8TBOqoc7DSQJzpe94yUinLK5UobGC1SZFqpaaX0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=X8IGq1OxVoNtqhjyyWyuds6N5vjJ17bQnHipCAG7wCbYy0fa4x7APHP58Lef4Hb/UoJIQE5Jy23JjmwctOD7+E79BH7+Tn+5ce1c4JMqXkXxmUkQGLXjhiAghpjOekNngWYxvjnTbGO/fr0nkPTb7OLixtEWQ3pTFbcONtYljoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DdfaeZ8p; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DdfaeZ8p"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f59f25ec4so803257f8f.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 05:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786623374; x=1787228174; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=c64E2R36qwjkaxktM22vflgbxK7VH2cQNkcuM8Kj1/Y=;
        b=DdfaeZ8p522ZoRissRuq9rVFmCdUCIBuo0RXU1JTwb+xh6RADRojxZiL+T+DI3ot0L
         jsqTQXT32ExWBMU9FoePgJ9NLkACtQ2MIYNinvPDoQpr9s2r9JGCA5KzWP+eJX4jMcmS
         rXuU8dm5lvhn52IUgGNNl0PkTh+pK6tRlFJ+YJNU3zouwV+cUhuWtSmWz6XCs97/VjVz
         0V0AUERb/PuuTvYHijLb1EgllmWqYlnf8XnkG5hJxZw87p5GdQ2TyMDgBA/d92K9rMMv
         WMW/h8FVI3AuWojx2d86jZScp7npciodrPq2Nl3Y+U7F2onigH1VShuURWdfLMS1U/bm
         h5EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786623374; x=1787228174;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=c64E2R36qwjkaxktM22vflgbxK7VH2cQNkcuM8Kj1/Y=;
        b=jGeMxcvTATem4ja+gTMaUrbkiH025MNYXqLeGcuTGHtxrBnweazZbrR+C11zOu8NIl
         BuHuVyAOqpLEcuXiBIRqmhX+ZSP4hml6qf4Kxsx+vGh63bQx4b0OghEwoQqPd3yKE0n2
         ZvD5wxJfDKNlmRj1PqMbrK7KtKYNcqxPf2bNwT4iPEPJVZnxJr+EgRuntp3dEAUk8jZN
         UZwvHQ2XMbfHtaWwU1fS0bAEmSm8ktKJUe+OjxeH7qI8egZ74FLhZHZWUWCVOdZCuFGE
         k/jzoaCm5OnddpOPjjqS/5Cnp5eUOf82WcjE0ZBp9Qay45KffjCBQzEWH6Y1+XX+lRZV
         pbzg==
X-Gm-Message-State: AOJu0YxMc7e4WgaJEq+lzWt0B72ZVeXVZmISZ2tBPGglukczNWSJCFHP
	cUEC2WW0YuT22hHg2imVvUALCnuozDl1QLVPL78GWDdHJO9ZXSnWQC//6bEidA==
X-Gm-Gg: AR+sD10pg6Gw2cJcKT62/1ZDtTjA/U3r8DfDchHZiv9bj0I1qu2jpHEoCksHZQixp+o
	mFgs8PKgwCP1qXeUXqBvmv//8+Ym+ryEd3VqAq9pxg1m8gd2BWP9ab0a18rg7jOBF8dRGuOGvW5
	LIVY6K2GWQOUa/MHih0Xm/yw2E+Q/QVxA6t9L4DUwI0V0aoFiigOsAdkCxX2UA9mtvRnC+Eud4y
	EpAEQv/qOUdGTuNGsz4MJA4VP71prVo1flOFdKO6oqtwjCXy11+mq0qFe7qctWgtGvV/qE2ifgr
	gLawd/rWzercwUO4ymh/pb2DrB6YfjIsJWNq/c887Cn6ZoDY0icWMgDfqHnK3Mzerh97Xenf8XR
	FrCkSDkAmS+cWdukSxE5min2IUWL0Y30TLPhv9R3qgpsnAzI2NUpCgSOSM3wrAbMpThMMe+xiG4
	cpVYQ1iRinKWWAuDXbde7X+OE2DO/G2HtVGDUaBngT8iwBnZ35sGwCkL6hBH17i/uNLQdPzbB9V
	khcskaALs9M3CAGWn6k
X-Received: by 2002:a5d:5e82:0:b0:47f:7129:e30 with SMTP id ffacd0b85a97d-48159cbb72cmr8313513f8f.11.1786623374277;
        Thu, 13 Aug 2026 05:16:14 -0700 (PDT)
Received: from [127.0.1.1] (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5c2352sm5122353f8f.34.2026.08.13.05.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 05:16:13 -0700 (PDT)
From: Nicolas Escande <nico.escande@gmail.com>
Date: Thu, 13 Aug 2026 14:15:28 +0200
Subject: [PATCH ath-current v2] wifi: ath11k: fix locking problem in
 ath11k_dp_rx_tid_del_func()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-ath11k-locking-v2-1-f4113a0bd0f4@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/5WPzQ6CMBCEX8X0bAkt/558D8OhLgusQGvaQjSEd
 7fgwbOnyWRmv8muzKEldOxyWpnFhRwZHYw8nxj0SnfIqQmeyVjmcSkkV74XYuCjgYF0xzPZZpg
 A5FVSsHD0tNjS6wDeWOhymK1F7Vn9Dd18fyD4HbnXW2sm7nuL6rdSyCousyIVUZIGFYILrglMh
 A6UbvDaTYrGCMy0E3py3tj38cAijtl/KfW2bR/plsJ5CQEAAA==
X-Change-ID: 20260812-ath11k-locking-52f5e3cc6937
To: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, 
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.15.2

In this function, we iterate over dp->reo_cmd_cache_flush_list using
list_for_each_entry_safe(), under dp->reo_cmd_lock for concurrent access,
and for each expired entries we :
  - drop the lock
  - call ath11k_dp_reo_cache_flush()
  - kfree() the entry
  - retake the lock to keep on iterating

list_for_each_entry_safe() protects us from deleting the entry during
iteration but doesn't protect for concurrent access. So another thread can
take the lock and modify the list in between and crash like below.

To fix the issue, move all entries that needs to be freed to a local list
while under the lock and then iterate over the list to free the entries
without holding the lock.

	BUG: Unable to handle kernel paging request at virtual address 00000010ddbeef8c
	Call trace:
	ath11k_dp_rx_tid_del_func+0x164/0x3c8
	ath11k_dp_process_reo_status+0x1d4/0x2fc
	ath11k_dp_service_srng+0x334/0x338
	ath11k_pcic_ext_grp_napi_poll+0x30/0xc0
	__napi_poll+0x34/0x184
	napi_threaded_poll+0xb4/0x1d8
	kthread+0xdc/0xe0
	ret_from_fork+0x10/0x20

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
---
Changes in v2:
- Dropped original patch from Maxime
- Switched to a new design suggested by Baochen
  We iterate the list and move the aged entries to a local list under lock
  Then commit the entries to the hardware & free all aged entries from the
  local list without holding no lock
- Added harware revision to Tested-on
- Link to v1: https://patch.msgid.link/20260729085741.3485711-1-nico.escande@gmail.com
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 33425707c084..5b717b731197 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -762,6 +762,9 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
 	struct ath11k_base *ab = dp->ab;
 	struct dp_rx_tid *rx_tid = ctx;
 	struct dp_reo_cache_flush_elem *elem, *tmp;
+	struct list_head flush_list;
+
+	INIT_LIST_HEAD(&flush_list);
 
 	if (status == HAL_REO_CMD_DRAIN) {
 		goto free_desc;
@@ -783,23 +786,25 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
 	list_add_tail(&elem->list, &dp->reo_cmd_cache_flush_list);
 	dp->reo_cmd_cache_flush_count++;
 
-	/* Flush and invalidate aged REO desc from HW cache */
+	/* identify aged REO desc that needs removal */
 	list_for_each_entry_safe(elem, tmp, &dp->reo_cmd_cache_flush_list,
 				 list) {
 		if (dp->reo_cmd_cache_flush_count > DP_REO_DESC_FREE_THRESHOLD ||
 		    time_after(jiffies, elem->ts +
 			       msecs_to_jiffies(DP_REO_DESC_FREE_TIMEOUT_MS))) {
-			list_del(&elem->list);
+			list_move_tail(&elem->list, &flush_list);
 			dp->reo_cmd_cache_flush_count--;
-			spin_unlock_bh(&dp->reo_cmd_lock);
-
-			ath11k_dp_reo_cache_flush(ab, &elem->data);
-			kfree(elem);
-			spin_lock_bh(&dp->reo_cmd_lock);
 		}
 	}
 	spin_unlock_bh(&dp->reo_cmd_lock);
 
+	/* remove aged REO desc from HW */
+	list_for_each_entry_safe(elem, tmp, &flush_list, list) {
+		ath11k_dp_reo_cache_flush(ab, &elem->data);
+		list_del(&elem->list);
+		kfree(elem);
+	}
+
 	return;
 free_desc:
 	dma_free_noncoherent(ab->dev, rx_tid->unaligned_size,

---
base-commit: e07447e654476262558bee570f4cf456e2b32565
change-id: 20260812-ath11k-locking-52f5e3cc6937

Best regards,
--  
Nicolas Escande <nico.escande@gmail.com>

