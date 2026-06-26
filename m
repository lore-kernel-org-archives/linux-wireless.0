Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBF62771B
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 06:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782455436; cv=none; b=abaXZmXLPU/0wGkK8DYINxZdK6HlzOsQDXKfnKmqc/PBhnakQrhjZHJuKgaImzPR7qx4TQJtwrftHUjNzeGehPTv2jvZpQPxW62WCMuQ/9dyVZ6rvmWjAMAmYkvbrcUPzHLPTsRAcNilopUnIP/rwzbN8Uy1moNoYKz0wKV7BuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782455436; c=relaxed/simple;
	bh=CiusaY/ofkCeKC1FZU8KepIDCZJXDNb2vfsorgA3o6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CepWBf12j1dDW2FNzTdDOctIVSBUfn3ePWCOnpkKCrip3b4B51n0kaWQtZ6vT29Se0J8escx+XM/khEe4LuAh+Aj/oh2kZQyZQVNC+NwjFe8EKL9Uclzl0cMStF+QsIVWO6wamE7NmsRoDbWQzH48016EPL9UXpk1b//GJqB+eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=m9Zkiteo; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="m9Zkiteo"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-13810b63a1aso1700688c88.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 23:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1782455435; x=1783060235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=siN8CxeHge9hqdj7gGzIuq8EyVoCvM5Rc+iMvERNBeE=;
        b=m9Zkiteo7s7kQQIjA2R3WHrCN93RMxexMDnQSPCqzSAMVjioDPHYFh1If+6/wZSLK7
         OsOLiZQ6bnwhNH7UmHlIegLihCieUhEKEx14HmD61b6un2/CNqoY5RRZc2rRtGJb/Ifn
         UEtZ/jsQxu8hbSCIsiHV8ryjDeZLF8nQljQo2wpafyIRo75nEcYPOYrkA5ZwkGqmfb0Q
         pDBErZgNra61x/80JfUO7IK1vP/hGbq2uCb1zqBH7qnPWRJUWrVo1UweQZMTIzU1mlLL
         X4+ZjdRAsyIgpDRSOHZRxodmAjg7wIoLGP6huVb/Q/U5q6Z+oZcvCGeLnyfsnu62uLXZ
         wuSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782455435; x=1783060235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=siN8CxeHge9hqdj7gGzIuq8EyVoCvM5Rc+iMvERNBeE=;
        b=j3CtobD8SuSdlr4qSsYftOOSCuUhtvWAkKNxqP2K9SP9anKiyQT+EJkIY+Fdd7vwhY
         ejdWvpwmdN0MzaNf5m4jmfK9vEuadpXTSevh+VBPGFHiKRwD5qda/j1DsbtKQuloBqYR
         kFl6WsLABSmc2h3YPmoK5mdVAazhdZ+0dN+9mhUsE/3zkR9gK9tr7SV0fNBnfhJOLoe0
         f0xZG3M/r4Wgyu8heXFJKqGECaZ29NI2T/auW9NF6pvjpCj2WmM7kVBDNUx94FJ7BOMJ
         rxOhQZXos/kx6CQ7lqMnXa0TSuUH3wmZTckCs5/nfOgJaNJhMZBqxeaCq1weXh8H6jK+
         n3Rw==
X-Forwarded-Encrypted: i=1; AFNElJ9QEh31hcSugS/zkVznMN8bXPmCxlKgvHK0VyeSsWb+R3GkZHpWssAFtFvQ3iuYfN9vaicyYmhv2zCLTuic1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVrrPe9GXr3GqXKHelT+H/8uk0FLbqC10Bgxml1kS/YoOsMmSS
	3IBDwNgmR5FC1MAAWKh0nThDwKZkoPLJufwilaU1jEwqtc6CRxMXATYZbCTZsEtERT0=
X-Gm-Gg: AfdE7cldYRbcIBGeVq/kiOHqXG1SkXNkGeg0HVInb3RBBtxjcxxJYdrCQzorNgqHTxD
	FyDyidLaFnnnw28/mzWKLbQx1WkjRr1vhH5pugOXUa2djP7YoJmSz5lU0fsbOMP2ZR4s6eGnu7R
	qnPAI45WKJ46E+OLzEfkYuu0oAmYnRRew/R3oNpx72zzsRKazJmUuhAZ6sSNzqETsxCDJmpMAzK
	Uco7cQj1RnESgpIZLtnndQVTr6XOZaj3TXwwV4aWAFUQuRPXEer4or9ghBsFR5BymCem/1Axz2x
	qg8jpcFNP45MYuVR9NIU8+NXcQqctC2qeszfnCNQSQeQiZRnSPI5I6adST6sJXs++iEus4h0Y6u
	cGFHMvQdjSINR7v5b/udMw41NHwt80qC3m7VgJsyKU4U5875InxM5rWippCHDT8VxJwrdQV4lzi
	F9b2+hkirSjI/+tq29vF88vhPnq0n39njO0Z1BfZ7PbGclh1vaMrf2BXB/KHqM0fTE/4KQ0mWfm
	X+fS6e2Dc0/+qzdD55S
X-Received: by 2002:a05:7022:4592:b0:12d:c730:c7f with SMTP id a92af1059eb24-139dbb61cd5mr4287341c88.33.1782455434643;
        Thu, 25 Jun 2026 23:30:34 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d91006bcsm15463687c88.13.2026.06.25.23.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 23:30:34 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: arien.judge@morsemicro.com,
	dan.callaghan@morsemicro.com,
	ayman.grais@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v3 01/33] wifi: cfg80211: introduce helper to get S1G primary width
Date: Fri, 26 Jun 2026 16:28:57 +1000
Message-ID: <20260626063014.1275235-2-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260626063014.1275235-1-lachlan.hodges@morsemicro.com>
References: <20260626063014.1275235-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is needed for drivers and will be needed for mac80211/cfg80211
in the future so introduce a generic accessor to retrieve the
chandefs S1G primary channel width.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 include/net/cfg80211.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8188ad200de5..a5d54d70d72b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1236,6 +1236,26 @@ ieee80211_chandef_max_power(struct cfg80211_chan_def *chandef)
 	return chandef->chan->max_power;
 }
 
+/**
+ * cfg80211_chandef_s1g_pri_width - return S1G primary width in MHz
+ *
+ * An S1G interface may have a primary channel width of either 1
+ * or 2MHz depending on whether chandef::s1g_primary_2mhz is set.
+ *
+ * Note: There is _always_ a 1MHz primary subchannel, regardless
+ * of the primary width. So chandef::chan always points to this
+ * 1MHz primary channel.
+ *
+ * @chandef: the chandef to use
+ *
+ * Returns: width in MHz of the S1G primary channel in use
+ */
+static inline int
+cfg80211_chandef_s1g_pri_width(struct cfg80211_chan_def *chandef)
+{
+	return chandef->s1g_primary_2mhz ? 2 : 1;
+}
+
 /**
  * cfg80211_any_usable_channels - check for usable channels
  * @wiphy: the wiphy to check for
-- 
2.43.0

