Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EE5468C3E
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787835845; cv=none; b=gXK9CcH9kKJwAjnvOmT8kHzGJjYrVs5ErYtXrWPKn3A0+jOHb9eXDEpuGlepORYPhq5gjgRYQBstL/im0aJ1zhxeYoc8c8JS86aosPhucMl4gFx0jo9DCl3FO8PIoFGdV0Vq6blaZ1ZQZl17+0jmRETf6ugB/muN4wV3ot9Bylo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787835845; c=relaxed/simple;
	bh=MKz6TKDh/MzR6/ujqUMWkSFnSi9qZEpM9ovgfX/AxUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2AZKx/r+Qgmu2XT9N983XNipY0Ln+3vq9Y2s/sot9Y/VCNDE7Cu4Bw8sq1PcueECe9gKaxA+X/LhHzmzPKbGQa0A6h2gLmvXXv0lAErTPYI1lYdgjnFmyZUSaLr7gWJ7XxwRlIdoVdMwRh4q2zdrG9DNMoeYC+57BwYkshAXPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UZJeuNoC; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UZJeuNoC"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso20992535e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 06:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787835835; x=1788440635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DxPA/ygF05pMbAMW0vsuxfL/xhlpJsyjpYIxaZ1WIpc=;
        b=UZJeuNoC+bcEdra5Vus8a67yvyDUbIjhStmx7xfxz8VOY+WWW5VCVvF+SBnW70gcG7
         60i/Jn6sgyNPpyz9qG5KZvCG8lDHWwd/67QgdMnxY7MI+pbYrkjNsV53iZ1BkZpoqM99
         A0PkCnQ1gDT5k4JhjLg8/2I8IaGI9+/xPlcHhX6sPYVcBV07H5o4v+j8269NXE3j/K8c
         hNdTUN2YOQZZrkSbO07u6J+19dv2Pn4fJHupXH0lf8ddX1rm/z6lUevXH6T9jvOxKUvf
         CCDWF3af7dc320pXKRk3QA9HLKMpMmB9wDxbnIu0HLkv8px2G4OUPPVKjQcHMXUOiM+a
         a1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787835835; x=1788440635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DxPA/ygF05pMbAMW0vsuxfL/xhlpJsyjpYIxaZ1WIpc=;
        b=SvVXeHE/9KKUdZTFXKrRpOO+lY5drY6SUR7bCHWD0Z6nve54Dobm6mbODueD+31vUh
         qnkMc/UMQTGDHVpdqH5IqwbMwRVwKY54ndNFBR0fnuKmKZAZSRzqoDKxXqDA2ZeRRfxx
         0mkMlilex34ln+PgIlb3MzQRTCiHGoqgFA7l+qsBujS1SgB4KcscFhJPupVlaj9rrcF2
         u5NWFmdtThDwW2OxdSsEU/AgpttGr6vhQEyEzqt312UeCGDEk5Uyju0lh2jY+yflFjwo
         PlZValYcPYw8XJgHOHiQWUvkvWyDuHQrJWr3WgsbTFO8kNpIV91dfyyTJu78fueOALPf
         u6+w==
X-Forwarded-Encrypted: i=1; AHgh+RrVZjlIU0MHkSvSsJM6OCv9z2PkFYCpPYoTsU73CPfdlu18cBfNT9IsOlAPVAUVUjUplfVvY58Aff47xXjRoQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mr7yupLDzDRPitsnTMNiUAbLFB83ckUa8d/f7eU7XSbccQhAYh
	FYnwLrJPmiog6dWiFpTMW0t/MVW/7CIp3kn1ylqAXvcngIKp7Im4/Zmb
X-Gm-Gg: AR+sD116yGELcP5Z+/QPju8hA5a6mPIzEiHvgbmn7tNYbbMRPFiPXMTtS7XKrkcRhRb
	S+8BNZdAVFyLAc9/6GLM6pdMnklGVYsZlwsuJUKairsw8bTtRZa/fC0S7KRa3IS2Yjdfgy39j60
	C39GRr0Y2mQZqjc10jlhAxBeYccGCgOvEAN+EKvRKeR2qVZ0njuy2Er4IAodUCd7okLY2D+y8eP
	n3LYDGQC7Oga2Wr6pKjQ1I6ZzVAlZeZwZulhLutWrj8xaJtLg1uKFoEHO6SZoW0eVJL5YLqjNjB
	eZxoSdKtLwY8QDiTH78rdFBIACU+mHFDjTYBHW+uKboFeUfSTmk2G4RQlReuzKqr8hKNbMJpemT
	nRkmVtyN22ZNhrhnR/t5EG6jYJJKEh0Y/HUfGtcugykFnKIWK3PvwitA7oeJwGABWbba5DJzevV
	h2xzkBzG+yQ6KBFfXqTdJ9GbHRGJY5UWIRei0bcr3DdgQ1kn8TZ2cz2AodWH5u3Zwq1O4AbMksZ
	L39hfxBZEM+uwL2Ar8ePqNcA53TA9RszFvqKzOnseO6DwDDb1N8RHtzRolaOEVRx6nX3zaSxc0=
X-Received: by 2002:a05:600c:a418:b0:49a:2c4b:403f with SMTP id 5b1f17b1804b1-49a2c4b41dfmr127644185e9.13.1787835834813;
        Thu, 27 Aug 2026 06:03:54 -0700 (PDT)
Received: from localhost.localdomain ([2a01:5a8:737:d4a7:e53b:30a6:3c0f:1dad])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b49610170sm116081285e9.6.2026.08.27.06.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 06:03:54 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org,
	johannes@sipsolutions.net,
	andrew@lunn.ch,
	krzk+dt@kernel.org
Cc: francesco@dolcini.it,
	johannes.berg@intel.com,
	kees@kernel.org,
	miriam.rachel.korenblit@intel.com,
	rongqianfeng@vivo.com,
	wenst@chromium.org,
	rafael.beims@toradex.com,
	avraham.stern@intel.com,
	error27@gmail.com,
	s.kerkmann@pengutronix.de,
	gregory.clement@bootlin.com,
	sebastian.hesselbarth@gmail.com,
	robh@kernel.org,
	conor+dt@kernel.org,
	Frank.Li@nxp.com,
	chunfan.chen@gmail.com,
	arend.vanspriel@broadcom.com,
	peddolla.reddy@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH v7 2/3] wifi: mwifiex: add dt flag to avoid conflict with platform reg domain
Date: Thu, 27 Aug 2026 16:03:34 +0300
Message-ID: <20260827130335.6606-2-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827130335.6606-1-gvalkov@gmail.com>
References: <20260827130335.6606-1-gvalkov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
from the mwifiex ROM, which conflicts with the platform regulatory
configuration on units sold outside the US market. For example:
- phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
- phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
- phy2 mwifiex 2.4 and 5 GHz, hard-coded region US

When the system boots, it detects a conflict between the user selected
region and the radios, e.g. BG FR US, and applies extreme restrictions,
preventing phy0 from starting on any DFS channel. phy2 works.

Add a device-tree flag, which allows affected devices, where the radio
conflicts with the platform to ignore the incorrect regulatory hint in
the ROM of the radio, so the platform regulatory domain can be used.
This does not allow the user to change the regulatory configuration of
any radio. It only allows phy0 to start and operate according to its
certified configuration.

The change affects only platforms which explicitly define this flag, and
helps overcome the incorrect behaviour of proprietary radio firmware.

[1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
[2] https://github.com/openwrt/openwrt/issues/9956

Tested-on: WRT3200ACM, OpenWrt
iw reg get: no longer reports region for phy2

Cc: stable@vger.kernel.org
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 7a1ba32f1fb3..293876397b67 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4897,7 +4897,14 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 				country_code =
 					mwifiex_11d_code_2_region(
 						adapter->region_code);
+
+				/* If the reg hint in ROM conflicts with platform
+				 * configuration, it should be ignored, so the
+				 * platform regulatory domain can be used.
+				 */
 				if (country_code &&
+				    !device_property_read_bool(adapter->dev,
+							       "marvell,invalid-reg-hint-in-rom") &&
 				    regulatory_hint(wiphy, country_code))
 					mwifiex_dbg(priv->adapter, ERROR,
 						    "regulatory_hint() failed\n");
-- 
2.55.0

