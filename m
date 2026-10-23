Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792782565;
	b=Yt5dc8jfZq9alo1hRW7Gv8iKcke/m2tDxoP8ivdzHd0RDkvk5vX+iOC0vaFWus7JgMJU
	 B5UnVZ7y7q6kw7pJ2c37yymmMNBowQcDU/Duv8TmB9QcrcNX7L2tD/sZHFbt4Vn1K6yPG
	 2Hm/nAkHFnRGFvYoZhtyVL8+couAQ/ufQbgWN5Tg6Glp4id2/r4M8UDp3MoFdEI+ZNLcg
	 FxwR2ICRguvpYcLFMP48C5/mGDDSGMHsQG/TMu7opLyx6FMVyc2MaIYfcBo3DsczGqXJd
	 awFC9XDnKHUIkNwgjMJ7aAgeOEDI2XZjPx9z2aiOmQndjNtHuVFHEye3NrSZV6aKabQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792782565;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=N2r7UOrv8eZqrgzadXu3xwusx/htufx1GM5LO5xd2W0=;
	b=Ut6V4DmAsiqvOLGtcaQyl6SGwQDljrbORgP0lJQcIDYmIKxl3gIYxxZCXDW9IAeww1Zx
	 r8zCJ4OPw5zPD9NpJxMJLYHwNdV7jGBOhHoNW/jDWHm91bXCpnJNJCxQeKqU/CsRnBXVc
	 R2UXoZ3PM6RzZr+nH6XN/3erSqJNnFx2kVzCq6JWegwGweCdgNSrfUqNYFOINlLzkTL/a
	 rP9ihZi1Bwh3EAUmRLb5lvslD7vesttLQuuORPzd/gKn8oOx07ACSvwt5uVsFh6BrbVgi
	 eBgO8QLyF3YuBRGHOfdhQzpsaNdq5ejyIU9v31YuXFy2pWDNcbKRSx+gIwyWHRSVNSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="TzN/0HUN";
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA999606A31E
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 19:09:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA999606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TzN/0HUN
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-33fb4680717so1193312eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 12:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792782564; x=1793387364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N2r7UOrv8eZqrgzadXu3xwusx/htufx1GM5LO5xd2W0=;
        b=TzN/0HUNV9zJoXbeF2BOnY4MY4lm1jv4x56xwpa16+sKN6uyLXR4EpwPXiZPU6vVCC
         EdtXepzELVhCk5RE+u3TI9udHmj0QW3cnrMllzGd5KjaAtOwu3/3MCC8FFzcw5BaR4MX
         cxw+CX5ATckoV/1a9XQZYZf3eMGzE1xtH33SxaaBJfwKRpoJSCuUi1OArrc+nSD/DQ27
         9+QhLLFbqqluvQO657S/+aT6a2CmvUGDVF58SjiunSlY2kWtEP2b1uGthsLo7YZ1JA1+
         v0VnmtFdEtnVXWqMGYvF/EV4qh9FcfJWEO/RDwrwkhD6Ke8t0v5uTiCqFyjmpEITBSrz
         vRbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792782564; x=1793387364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2r7UOrv8eZqrgzadXu3xwusx/htufx1GM5LO5xd2W0=;
        b=sugLbmctH1L2yCzC3WlZ4gUGRMfBrI52B/tbQReWDaf9ZOuRUgmV9+dCsg0F/VLezK
         zd2QY8yJfQ+6nwH5xEQ2M/tBWQebhxRzco4E2nyexKjkJ1vDA4Q1M1DRmirL87gvEIUJ
         qWaubGdTpPMpWMazuJfxbaIWAzgfYR9HvEb/21VH8d2fz47hLq7AbFphZ6vvKuqHeutu
         pvcuTrOtLc6T00ea7H1YA3sSWRuA479fjqX5x0WlKN5rKWlQcJzplmaaJX15ZjK0E05W
         iIsNYAfLKx9arwPIsjSoefwW30TuXmnnU+yf2YEaP8cfp67XcWlUGMAv6uYXiD5NcucN
         zntg==
X-Gm-Message-State: AFq9FYJ3DlPThk7+sZ1hQ3Q0dMZ6t5gFiJZfAw1vzOxQE6Lfejrt3f4r
	9rbrRJ5uAGhy4tXEizAAG6XdJWuXUgZ1G8vTydsYZ+3DVS8lfSr4OwrO1ysOe1xi
X-Gm-Gg: AYBFou1VfYk/zMrukBCs1LibbEvrEkLwwuNJ57+KsY8jziSJGiOUGAKuLLJ4AYtAhr2
	supg11jhMDLiiPPIrkGrRmMDBxRNsSan8WMio0H3Fp7i6vJCjOY2i90zGkdWd6bCHrSpGqhDJV6
	Q12WtKeJY75NyW6jq/CpwNiNNSHyWzjN+LTUAM+a203as0KqwZ4AQLXMy41wbOLmfC/6TeZFg/m
	Dhri9RdyxCJ2cEOTcWmWHvto4NSbvF84947V8TxEuusifuVjnvybTmtirgmqfzEyF/xirJb80Yy
	TRIDRwR8BztdrQo9WAgVf16CwUjvJ64lvbn/G2iZRNgJ0sIu1QoBxbrGo5fnpzRHZrv0fI0k+z8
	WemC+Trloi96snB4jmqE1yClZ9GeA3VPY25C/Uj7rqc1gbwZU5nLNk8wzsyxPCo1gPKciOILxdd
	qVkvAza38rbPT2TT+fK2fweVDFzEjW+lZgEArvQjQXpQDU4rZ+zuzTGdz/WkwqXoeJe46uNKXTw
	lbJTqp2tcOjMy/TlFDqyySX2HUpR3XsOq8KPoBp/ZN1FX49VFzEQfrssup9s1Oyjhyj7wkrcvCB
	kFG1o9x32G2CvEbEuqqtLvakdcx90Cuw/VphbH1T7TixTJc+TjkMKB6JUseApBdZwNFauL0kN16
	uEu53zIl7vWOAH79vv1X2uQ641vHR
X-Received: by 2002:a05:7300:80ca:b0:369:e918:3c95 with SMTP id 5a478bee46e88-369e9184604mr68042eec.4.1792782563590;
        Fri, 23 Oct 2026 12:09:23 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8daa3a8sm159990eec.16.2026.10.23.12.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:09:22 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org (open list:B43 WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH wireless] wifi: b43: apply the TX power limit set on the interface
Date: Fri, 23 Oct 2026 12:09:21 -0700
Message-ID: <20261023190921.73237-1-rosenp@gmail.com>
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

A TX power limit set with "iw dev <dev> set txpower" never reaches the
hardware. mac80211 keeps such a limit per interface and only passes it
to the driver as BSS_CHANGED_TXPOWER. The power level of the hardware
configuration, which b43_op_config() turns into the desired TX power,
is only recalculated for a limit set on the whole wiphy, or when the
channel changes.

Take the TX power of the interface on BSS_CHANGED_TXPOWER as the
desired TX power, and recheck the TX power right away, as
b43_op_config() does.

Fixes: 1ea6f9c0d48b ("mac80211: handle TX power per virtual interface")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/broadcom/b43/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 3825b6ad9f4f..01e3e80b43a5 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -4161,6 +4161,17 @@ static void b43_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	b43_mac_enable(dev);
+
+	/*
+	 * mac80211 passes a TX power limit set on the interface only here,
+	 * not in the power level of the hardware configuration.
+	 */
+	if (changed & BSS_CHANGED_TXPOWER && conf->txpower > 0 &&
+	    conf->txpower != dev->phy.desired_txpower) {
+		dev->phy.desired_txpower = conf->txpower;
+		b43_phy_txpower_check(dev, B43_TXPWR_IGNORE_TIME |
+					   B43_TXPWR_IGNORE_TSSI);
+	}
 out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 }
-- 
2.56.0

