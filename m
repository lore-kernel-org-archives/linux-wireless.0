Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7074D1A5B8A
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809603; cv=none; b=HSuNX2dLLjMnmiXVD+nKKgXt7SY7DIcCaSBGXFMS+PpgmRORNWrmWCXUqWl3A8cMAbzclJcEx3GDPwQzxiSVwEsV74GlronvcEmyJLJY4phkQBvk/FKJH5xZsW4tCFXfFhFhqYftN45BPL+OLoyha9oaQo1ZIR0wozJC9vnRIt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809603; c=relaxed/simple;
	bh=xMzfvl+0Mk3SxZjHFvX097SY0dVfNOZYVfMFEwKLSWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pEelA0EfzUqvBc37fj9+c5anR5VBRbUyHsCRNQMiFJZgOiD9kQ0u1GtL3s/C4FAfag3PNZ5XtsHSOSnh9+tyl7ZtiRi8oL/tK7KkLESaye6ZpMy7vjUErcg7+8QDXEqzd8rjxecX8Qxpm8alQi4VXf8OCBcnRQ8JrL/PRR4Rezk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=e+/MEReU; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="e+/MEReU"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so1913398a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809602; x=1788414402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cMYnRHpbVU+AA7XH09UGS1qnGntVh98BCojIavB7eiY=;
        b=e+/MEReUEZqCIlPF/MS0aZ+wYmi3vsFqzOsdydYCuaKOd7ejl6jrM0x/ecXor2eyHf
         Rh0dtqowsp5buroqz6+JMNpjOyejSpxo9PXxrJm878mJ+L0fX2DMRp9o/6gUz2F0VLjJ
         vJgEmumOyFmiYyG1+CmttUDucVMPWu5JGAwlueClFeUMnGFMuhoi6ryfXQGZB6ODolUW
         ECGwKuXFYjBZE2WvTtEdE+8Rsi/DSLBwADiBl2j+LPamR8FOrzWF8EuhiIYQFBvU5Guf
         xtG+s0k6VWtd0m3WNFHJ01oevcvlyqszYoFn7MLBrnR1ygNhzNKatAWM/OfRCOg8Ggia
         cYNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809602; x=1788414402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cMYnRHpbVU+AA7XH09UGS1qnGntVh98BCojIavB7eiY=;
        b=WTtG9peq5SHG9FX5Erh7/clWyhEoSCZ3Dkqg/Y2U+J28PQ35noouujDvZFEZhIgzAS
         TgIaNxrl6VVWeS22cH7uDuujsQsSbsDG9v9IpxhL+AI7nM82kWCZVnLybtYL8zzZcO4P
         wY3pxdxLS5Ocyc2xcuSF/9l2SE4J4Aop/zDGIaODM63Rp8U6BlRMCQtGoiUMVeMOKN9P
         ICACDvnGwkZ1v0V5dxMELYI57IAbcYFib9gFaky2e2GyWvtzUrdqvmtmXa/SDrqZe2+C
         WKSVe/0amHoXfTFSOXSDcKZJQzn9IJ5nKgO5gMj/Fwzrqilo7wVK5usjB49ctnUgmyo6
         NTUA==
X-Gm-Message-State: AFuF++knQFfxGh9krTcw4t4nwArFND28LRJh2IlF4w4nq5/D5C+JPPCU
	ON8Y9R9wV3/qkoIyio+hXbViVFSAhwgKvLWu0Mlc8d8MECTY7xVtQtYR38iCS8BTiGs=
X-Gm-Gg: AR+sD103UKZLOEcrf55oM3PB3Q1AuuqbooEZROBFq25d+QY5cT4WDgESkLSNjnVJ1OI
	HZKVHwTdWG3nnG5KDVnNG1DY5bIC5CZR9QHxmJ5VFqFnlNbdA1NWn7mtgeT6E3zl0iDW4/J4FIH
	NOm1rj5K/jTVq9s9EN4YmQtiRaDYEPVHDWHRErb1qh76+sARV8KH4CCACZ8F/m8DuhRZeGlUWjk
	3Y4G+HdrvX4H6I7mZm2yDSG6eEqnCDBDrMP8O2WUCeLRut3poQa5ia/nvVnAIDgZ491tgxvtYdz
	hME26qogpUbE6oRk+aHKFtbKUX1gWxf1UnAgI/unv3nFzhj6wr4xRQYirWwf8DU32pPgPt33cLx
	uuGjV1L/c0YSmMvfEr90K1dpkrJSqt29d1i/l14C9k5+tS72Z8+7dz0SNMEEgVgVpYnUiTd39v+
	64QcRjiqFRYg0fMmAjpC3B8WgksKXvhxu1Dy0sb3ezAQ6ys8IuZ35UrZDOMJwGJnMCcs3VpHlcA
	Hglw+EdB4jNQHk51aoypl74OtZfW5yadF6RkNB7WilWDdtImnsY/on/JCDu0m65q4XaUDaHeq/o
	EXeg+UwCo/Q=
X-Received: by 2002:a17:90b:2ecd:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-3966d484a97mr27484574a91.14.1787809601679;
        Wed, 26 Aug 2026 22:46:41 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283fa89e8fsm21093266eec.8.2026.08.26.22.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:46:41 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next] wifi: cfg80211: remove duplicate s1g_cap kerneldoc
Date: Thu, 27 Aug 2026 15:46:08 +1000
Message-ID: <20260827054608.254883-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_supported_band::s1g_cap is already annotated.
Remove the duplicate.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 include/net/cfg80211.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 97c16d4ff127..2abf9e20cc22 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -576,7 +576,6 @@ struct ieee80211_sta_s1g_cap {
  * @vht_cap: VHT capabilities in this band
  * @s1g_cap: S1G capabilities in this band
  * @edmg_cap: EDMG capabilities in this band
- * @s1g_cap: S1G capabilities in this band (S1G band only, of course)
  * @n_iftype_data: number of iftype data entries
  * @iftype_data: interface type data entries.  Note that the bits in
  *	@types_mask inside this structure cannot overlap (i.e. only
-- 
2.43.0

