Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B22E38333A
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 03:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791428996; cv=none; b=k2btFBSW6iWl9tvLxJ3bWNJqxMTKhrozxnOdS+cEiAW0ZHi6QXmg7sS8HApxK9YRMZXoh8yWie9wKCo7ZZgakswmAExwGLaZvbHLSi8F+q7ZRmEDi7yFZdPGz2R7NzxI0P8fw2zFjsR0N9qYlMgvb3poiahBkE5vvJmxtwl2PFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791428996; c=relaxed/simple;
	bh=+IN+k++3uYEIFtDj1Aq/O0C9T/S9i3qP3dvmjPZFnC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6uu3jP6TxrQvNFLItjPGRh3vkBQRGIEPJad8SNmfDxsx2s2zSdTeIvvkB229TE3yqR4Cbhvr0JdcmvWjWRxYVz+K/gHh8JAJlXbGOkNT/Zh5x/CUAVgdL1pB6yav+A7tIg8VGyByAZ4HxrKvdeVCWQlqhtCc5PurAffqld2/7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=Hl/Pljxb; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="Hl/Pljxb"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-ccce967aa8dso2041110a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 20:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791428992; x=1792033792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u1qIa03jIegGY8+uBtCvVPQ5wDhOtPQymszOeJQ61K4=;
        b=Hl/PljxboNlCjIV1BtTm55BvJT5jkMIH8htih0p3vcTtfOHR30TxIh3ptjRmkRq01O
         hzAmL/qPs9rafTHGjoJp8hT9P+R+HaurThB3c8IA16NPfj2cdeGrNZWUMGBdGjKhfepp
         nq6B4lxXIgrZPbpcO8KCnX51yocnaxlN3OB36+PFMeQVm3u6rb3DObZFANjTRSpsRlKR
         EZagqdBvlja4wcrHor1yqylsbkc0oSZ/wIqgtpHNPrw5wkAsNKYvLFreuPT4Zcv3lAbQ
         f1omgG3Of8pM5uXlytmGMiSjyGlsufy9rGjUEO9N9dNTbjWKlvtlhxQOTUlp6GXLNSAG
         QUsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791428992; x=1792033792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u1qIa03jIegGY8+uBtCvVPQ5wDhOtPQymszOeJQ61K4=;
        b=beNCf1cNpvxIqHeMFxDH/Oyor2iFZJLLDrqSbfXc8AePSEVewvEvWdzv5B03mziEsG
         tPhzCfqiOvC03pMYxY0wCbQWnxv//llv2EcCVVvbi1VK953AyuhFPatmOEuE7rSCUSvj
         oL+CKaqTBA+XIhiXFsE/FzFHNY71orRqWPJuPgSrnUpHYOp2caYTAyVwcajt/IppIzzx
         aCI80KaFQVPH/OnpjMhD//J3K77VyKb9Sdhl8BiAmybpYmgBl3JdZPDqfbLei5N6Lxyv
         8i2YIY3VKh7zoIa3S06upCyRx0toze739wiqgLGOhhVpYAbaKOVhJ5Q8Q8rxjdHhD/yT
         Ckqw==
X-Gm-Message-State: AFq9FYLL9oKS+gsyYiDonxUG2z+ZLu27wCiKaTtU21v0WRo3RH3eg66U
	3OZqB2dDoyv14NSyQ7YggK7YUA0e4jK+qYF8FVtcXYD1KdM4GrWTmD11dDQhRyHYlqM=
X-Gm-Gg: AYBFou0ciF1BighqPHbZBHWcOu7LYl8W/UCJnZM2d4tlkZz81oCdoUidgNtL98GzrWS
	cjlKhmpEGNtuG13LicRefWKkoXBIrSCyxSSgOaFOLBJ/oAR4PO8c+NGnKovuMvRj91ZhX1HaUrw
	Bi6TgmV+hBAcaxNVpSkUFNaqByDQXQvEmYi0Tu3nDI6k0D7fIez1Mcali6wIMveWNXkHKyjz9DM
	B9HQnqCgb0QHTcGHsM9wNiMCLEcB+P7DoB54SbP5Yevktep5yu8HnMuBsQwT6bB+Lc+GUVw5CXq
	AJppv7WH+O6BDp7xYzBK2dQ+ayFDr5pSXcSzbG6zueGwUmlMg3yVJJ/UA8dGZV8M5NllHAuURJP
	5Tcn6jKSjiB3TF+1LxYNBs6arsRjcE1tAEFNIbzIb353y1cITWeHfrDcGHSUCTBmj3YfarRowfQ
	uHJS4/awTf2wa9NS/H4E8nAEdaYyy4ZSMvHTZo+Jzj9tUCUpLYyEVDLGv6Kq5fDVx09kTDaqeoa
	em+i/JY4ZpBKF/qRAT/wXYuYrtmEMP6e8HzImRATdqPyGlU6UmrsJvQNPSpdmFG2PnyQCRoRkVV
	8/RIv+cwpWQ/hQ==
X-Received: by 2002:a17:90b:5486:b0:39e:4c81:6c5f with SMTP id 98e67ed59e1d1-3a8a1ac80a2mr3305582a91.26.1791428991668;
        Wed, 07 Oct 2026 20:09:51 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3aa0cbc6e23sm2149514a91.14.2026.10.07.20.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 20:09:51 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next 1/2] wifi: mac80211: handle shorter S1G TIM when parsing elements
Date: Thu,  8 Oct 2026 14:09:38 +1100
Message-ID: <20261008030939.474493-2-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008030939.474493-1-lachlan.hodges@morsemicro.com>
References: <20261008030939.474493-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An S1G TIM, unlike the regular TIM, can exclude both the bitmap
control and the PVB. As a result it's minimum length is actually 2.
Fix this by allowing a shorter TIM for S1G connections.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 net/mac80211/parse.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 3b66ca7d7a5c..7a472a908eb2 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -449,12 +449,15 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params,
 					IEEE80211_PARSE_ERR_BAD_ELEM_SIZE;
 			break;
 		case WLAN_EID_TIM:
-			if (elen >= sizeof(struct ieee80211_tim_ie)) {
+			if ((params->mode == IEEE80211_CONN_MODE_S1G &&
+			     elen >= 2 /* control/PVB are optional */) ||
+			    elen >= sizeof(struct ieee80211_tim_ie)) {
 				elems->tim = (void *)pos;
 				elems->tim_len = elen;
-			} else
+			} else {
 				elem_parse_failed =
 					IEEE80211_PARSE_ERR_BAD_ELEM_SIZE;
+			}
 			break;
 		case WLAN_EID_VENDOR_SPECIFIC:
 			if (elems_parse->skip_vendor)
-- 
2.43.0

