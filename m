Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDD9476078
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 11:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522457; cv=none; b=ngQwu2Z/WzYZeLDmmes/ZkWTcJnRHc5pOce9BVOG1/fonC9Lr2HzAT/hppbnbdmuww55vWyuCXnaVBOVyQXTFZKLXruCVOGoQHtmhfgmxpDdzXueNpE3U6fojqlnDOUO7Nu4I/ca9EfsmcRg09oW1k2uKHdf42rbqgcCcbmsTWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522457; c=relaxed/simple;
	bh=iB68G608M5544MxTODhl9G55WJV6BkwwETG+cXIq0bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdAOaBgSkUqw734LrcZ7oz8iIr2cjrw434nNSbmTfg+kx2AFKgv/ji/UaValjc7FSljNarmztsmM5mtwzoYuWPz2P5wmld/Biy1n2Hh7iB4CpdgLvnnAN5b3+j0Jdhqfrw84FTe8raQS1VOv2KQJE++4qr7ahDBJy8NUzGqWePA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7zDeFZu; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7zDeFZu"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6aca0f482e5so860945eaf.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 04:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788522455; x=1789127255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rkP9NftzEX0Ficlnnu4eHVjyAkgFD6uNrnuDsL2+R7s=;
        b=A7zDeFZufnvSjxZ6SatO+LGPZLuS/A2E+eYysvAaSOy0RkynphrhSuEsj5BJk92dqd
         dpSfYlXl++lqCWbnIj0ngwt5+bWpiHORyiHFC/tJWQ7PH77jumZ3mDuMTFDHPx/2SXpT
         u8exJxcADcAXWbDC7dqKOvoSqiaBFtUxKhFPiSm2ELWVODwKAHdbAZ0tw+/m49R/SnBZ
         vVOE1nYMEjf68afkrulLEWdQgp/ByfAHzcB97EzbzBGmd1jm0N8M1KOC9GSK0LEGsPtw
         6fEkP+JIFqTreyRYScUQnbuHN3LKeCT39zp1ev3rTPM7QVCz+49FQluJKK9gug72bXEX
         +hxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788522455; x=1789127255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rkP9NftzEX0Ficlnnu4eHVjyAkgFD6uNrnuDsL2+R7s=;
        b=DEwOJrrNqRqYKbHnJasjCO3e8q6H+FoTYoUqVxN5ydKwwXV+THljK0LmzVPCT/xwtT
         UXRL5b8KK6bVLLFZzxnXm5OLMNRmEDsmsAS6k43ItmtUn684vk2pPdFKaiCULLHOrOdw
         9Eci7uPb+TclxlIG3gBMqf0Fvr4sc6oUBIbDfvTtb6yKyBvAw6O8Gq6MWWqmhy+IAyUB
         QyBHCYzm5fbE/TrT9sPdFESy2N03CFcMH1/8AoXxpx8Nr1plXfQn7JlsJ5aImy6TXFZc
         y3MfZGUdm3QF3v0wrg0IYTJ5YpYathbMI669Av8aI/xnkXQu1tfZFB6yQhFueta0DUNs
         TKBg==
X-Forwarded-Encrypted: i=1; AKwUvBwkOdkJ38K+qKeRAh+RlSZ9g/aRDBS/olefehkLWLYmEkiUNR/Sf4dnSs9/8kL93DnLfm/EIiAUvkcnTq6Z+A==@vger.kernel.org
X-Gm-Message-State: AFuF++lfj2zHkuTsoCIB2dj1+ifMrlL7h2888rke0NaO8RBroEX4Rjwb
	XL5K1qK6yAx1z/3OnVM9V+3zuOz5+jmgvFbRXDKubl+bucexsUfXiZpg4fen0SetzVo=
X-Gm-Gg: AYBFou24rtpNCq2nKuPt1VTT71nFh6Yxq1lCSwqTIq/N1sM2ZvOD47KTR3qUXwUawDQ
	uIE17xMjoQI9fA5UyqppWqngzNGeEp5TAyr5BA0pV1YpW0gSGHNRytlWpq4/VyLTkEtzMQfy422
	Q4cNM9x6GXPVDBNOYsJPhZFqJM2MGHpao4xqnpac1qjTmG9Ld6lq2mZRmdYbWOmUyw2Ovwv4BZ5
	brm4wgI5pFb/ESC7KsimcG++AzIMil58jvrLNCuTuZn/m7BR/hJufI+AsBNaDdktnKFXv9La9o2
	2j0KRvPXAXATeb+dLDSsCljmgNvdzVfWPNndvMosxCZHZpsjiZ3ogqPvEUU6JdlcqQocHlfs7ld
	OSyBxJr6POeSZW4ahZM5SE9j7AjV+6qAmhKYxsrVDiINt+pDEi7u5LWUU/MU54XMAW7Oj6UHEBc
	m9A2GEzJXsDvmb0rvnXu/9upWuMgyMc/Zc8hkwYYGrMXDpZIHy83HZSAaR/12QO0YDmPNpohSmp
	jNiwOYvZ3T9F9c=
X-Received: by 2002:a05:6820:814:b0:6b0:4fbc:aecf with SMTP id 006d021491bc7-6b6fcbd5788mr4026803eaf.24.1788522454723;
        Fri, 04 Sep 2026 04:47:34 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339c0ec914sm6950891eec.31.2026.09.04.04.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:47:34 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wifi: iwlwifi: fix repeated words in comments
Date: Fri,  4 Sep 2026 17:17:22 +0530
Message-ID: <20260904114724.32518-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904114724.32518-1-hemanth.selam@gmail.com>
References: <20260904114724.32518-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop words accidentally written twice, reported by checkpatch.pl as a
possible repeated word.  Only touches comments, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index 2e16799818e4..186dc7aad159 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -931,7 +931,7 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 
 		/*
 		 * For non-QoS this relies on the fact that both the uCode and
-		 * mac80211 use TID 0 (as they need to to avoid replay attacks)
+		 * mac80211 use TID 0 (as they need to avoid replay attacks)
 		 * for checking the IV in the frames.
 		 */
 		for (i = 0; i < IWLAGN_NUM_RSC; i++) {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index 115e65ba19f8..5ba89e31aaae 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -727,7 +727,7 @@ struct iwl_sar_offset_mapping_cmd {
  *      regardless of whether its temperature has been changed.
  * @bf_enable_beacon_filter: 1, beacon filtering is enabled; 0, disabled.
  * @bf_debug_flag: beacon filtering debug configuration
- * @bf_escape_timer: Send beacons to to driver if no beacons were passed
+ * @bf_escape_timer: Send beacons to driver if no beacons were passed
  *      for a specific period of time. Units: Beacons.
  * @ba_escape_timer: Fully receive and parse beacon if no beacons were passed
  *      for a longer period of time then this escape-timeout. Units: Beacons.
-- 
2.48.1

