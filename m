Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFF9361675
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 05:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790830885; cv=none; b=L0Q9NgioyIVLmLtwo/4LAkQ/XxkZqpdV3Z+jGzg68+Zx1Gl8emyN0jSVPoiFUz4rs+HBj3BJ+EoeD8BYT4FrjPAz8SiXhfs/faNlwbEL9bp7u9SGSrrJeEys/qg3DAyTqYy4aZnHFlE2rRx5QFNhAVYq2YTowrKz6klwka53Q2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790830885; c=relaxed/simple;
	bh=LB1sY84a1EE+3kSSw4xtbjuyLg1kQRZO7UTUKIYXGMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jwdl9nKGAHU8iQyRiHScbsh/KiA7/OfNBHWU1hLflS4uTOXpmwCiwgDy8sCRUMx1tO6Up8/G0H/c5jJX/rNOj6Jzbq0o/x7yIU2LfNTPh9osPaJ2t/VXB38WEjMznAhfkdiCcKLwkzHUPNO83BH8XKb8g3rDvuuvtlD39O77Mag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RoVc71j2; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RoVc71j2"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747ed9866so43660125ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 22:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790830880; x=1791435680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VTxV+1nEYr5jusQwn3L4od+0vUpR+87EIFrgdrNzUZg=;
        b=RoVc71j2mX+Q5evTGwASdtomsgJFX6LyGmM0T8WH308T+798n9bW6H+F5yJjgM/gXN
         s/5kO4DupWobHRRjL3SK4OKOzs1ggBscJHC2lt5CdekZxFi5olhUZ2FALxuSYdbBlClM
         uu3KNedqaHFQJV70Tx1uo7QR2XZSCSsKVaS1vRQ6hhVzi2qjacsXY0tZrpFeRmWpxMoP
         1bnzbEWjfbKHlsDxpm7eiUVu8bkUhDamxGOkgtqUvFuiPZCVnT9712SXHZT/T+6eUjN9
         tO1uHrkk0ck98rAac5+h/UHTZGypfaFK8ryYSilbKKVitYBJg6JII0t46cMK+i9j4pFl
         wEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790830880; x=1791435680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VTxV+1nEYr5jusQwn3L4od+0vUpR+87EIFrgdrNzUZg=;
        b=DSPEUgHZ66pNJwaVLa1gcHBAUC1m6MERagn6la/I2Na5SpvIHL88SxV7S/pzZOH4jo
         vt5KotNNk0fo3XWHTYdGqaMJqJdM52Fqmf662s5OIe3mxmolHkhpTtHlpW+PJ6jH2G7n
         j1FCmVqYw7AA+il4iDxVDzxYSuWFEUqfTxn9wZi/W5KmJMVWf/+udPtrouqBFEubAPzG
         Ha9p1l0QnKRDB/LioShyCvJvz+HFvPLjGAKabUbw2VHm/nZHsu+LAIu1SzLeMN3fvSCE
         VsmhBRYguHFhN/jFyGk1xHYqXP/Lzd6mG0LFkTVKmXpm5lPlMwBLJOQNr0cvMZPWGIWP
         1wxg==
X-Forwarded-Encrypted: i=1; AKwUvBwhoSeddo1nWkHWfbJCZrRQJc8pyQGy/RpBqXbd7wnq92Vzkb+31Re9lOE7bG3stmQvwGzDpwy3h3sDP60csQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIZJYeaqkt0xZZxKUE9Er4E8uii69CYbd2KSchjEyklCodVTTv5
	WewQVyzlDVnv6gNY/dQP5XdSz+bRUCytX1mOkCKBSgvqWWqrWf5aPyZu
X-Gm-Gg: AYBFou0V7AMvI/tlNDp4AiR8AT5SSLKAfxueNNjNYokn7Tdb3x+5ttL2mpGY6L72Hcb
	5xYtFHaofu5jdyTsF+MqFK19zWezV54eDk7ax7THlI5k3YbvNXd1u2uOSsNkHC6orwY6VT7/rqq
	BAWLtRQlxg8cnyjJltiDrJjttvk0m+XfogoNDdC2eEzKViAqWJKhWySZ/97HE5hZH5/m/E0bHwJ
	MTVINFQaEEhYJHLkowT1IYucpf2WMQXmJm9DHa1oocy3zjeiC72BSm/3YGhfVyWiHhkHPyDeDbX
	RCZIqxdF0bNgQN4N7dgQM5LZ+fhSeaFonaNWeZpuGs3VVse38v1+u6rWMzIcUHj5DS/abEsCRGj
	LZz+51nu5doLgdxFRbIdDqbixx7GQwGtU7ouD/L65fKAlaqwce9YgjNgPStQ6VUaXFsGQUKKSak
	xstfVvI/jHeAvOUTBBZL6pc3w9DC/++R0HANAQAmkZ4L6KTX7mPa8q0ngzi5CftDHUc0QiOrWi7
	TmKW6qztPMlje9K9exuTA==
X-Received: by 2002:a17:902:ce8c:b0:2e2:cc25:b232 with SMTP id d9443c01a7336-2e2e4b75346mr29200155ad.42.1790830879917;
        Wed, 30 Sep 2026 22:01:19 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e300b21912sm5112085ad.54.2026.09.30.22.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 22:01:19 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: [PATCH v2 2/2] wifi: iwlwifi: mld: Fix GP2 to nanoseconds overflow on 32-bit
Date: Thu,  1 Oct 2026 13:01:03 +0800
Message-ID: <20261001050103.860584-3-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001050103.860584-1-zhanxusheng@xiaomi.com>
References: <20261001050103.860584-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same problem as the mvm driver: scale_update_gp2 is a u32 GP2 timestamp
in microseconds and NSEC_PER_USEC is 1000L, so on 32-bit

	u64 scale_time_gp2_ns = mld->ptp_data.scale_update_gp2 * NSEC_PER_USEC;

truncates to 32 bits for any GP2 value above 4.295 s.

iwl_mld_ptp_gettime() and iwl_mld_ptp_get_crosstimestamp() in the same
file already cast to u64 before multiplying.  Do the same here.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
index 9f7d17dbdee1..643664d35772 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -49,7 +49,8 @@ static void iwl_mld_ptp_update_new_read(struct iwl_mld *mld, u32 gp2)
 u64 iwl_mld_ptp_get_adj_time(struct iwl_mld *mld, u64 base_time_ns)
 {
 	struct ptp_data *data = &mld->ptp_data;
-	u64 scale_time_gp2_ns = mld->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
+	u64 scale_time_gp2_ns = (u64)mld->ptp_data.scale_update_gp2 *
+				NSEC_PER_USEC;
 	u64 res;
 	u64 diff;
 	s64 scaled_diff;
@@ -149,7 +150,7 @@ static int iwl_mld_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 
 	spin_lock_bh(&data->lock);
 	data->scale_update_adj_time_ns =
-		iwl_mld_ptp_get_adj_time(mld, gp2 * NSEC_PER_USEC);
+		iwl_mld_ptp_get_adj_time(mld, (u64)gp2 * NSEC_PER_USEC);
 	data->scale_update_gp2 = gp2;
 
 	/* scale_update_adj_time_ns now relects the configured delta, the
-- 
2.43.0

