Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444834B04AA
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787853577; cv=none; b=ic0oQSDhqCEN3i0FvJ5K6+ZStu4/DUA9AQ2AUwfNqIC/iyi106JZoj3rHSW/E/TRwLIHP4ajdtg2FOaDjyQKBP7XJY8qvm+blPn9JLly5hHbPJxosHM32HfnsgNZ4AU1RbCT4MHk56ESJ0JeX5eic449pzNbTILwSuhA+rBSv9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787853577; c=relaxed/simple;
	bh=KmjZVLDRFmwIO+/PB7Lg2YlmWzNd/QpPcrq536d1rZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPFfLOBIagZUlQCSsHcgdRnXTDcaWxH6FcrIOUTcX+DqXhNzUG+uZ/HYBwJj2JlXTHZHdfzxWyEWs+fKU66JwBCfkbjnclsqkCmrXU6cWLrAOEjbKXyqqj6LNBCK+MBvxNER5i7FRrRxf6lHOvnIaM2wQINutdmm/S8iyQdehcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zb0xplqg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zb0xplqg"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495437bb891so732265e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 10:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787853572; x=1788458372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0yDAFIIvoVKf4kVeSrPAjhgGoxZ9yQ0YMJMc17NgMdM=;
        b=Zb0xplqgldqHdAwINA+Xyz888HbfBDmjgwIRppuFlI/WwHu8b78j9yusI9gw8Krfki
         9ObIbKNAHfol4HX9652WKcSQ5BFpH0T8+DJl5x4pacABR4Z6aAMBND2uksJ8odldeyzG
         PwtDZRTb8rW2Hs9XSbGiBGP/85m8yo4NYEkTtLCm0NksHo47CdqqFFieu9Mw1r2MUmrP
         bf5nSvVz4mloT+USKByoYV+VDIOK3JJrt2LyEni7n67kL+RHKaP1yNEws+D8ea2ORxdw
         u6MhpXVOxExxpEeFmwXEKG9WPld10OLHUZj8a+Od1TvtVxVfporsKDc5/v+EkEAd//nE
         4IQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787853572; x=1788458372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0yDAFIIvoVKf4kVeSrPAjhgGoxZ9yQ0YMJMc17NgMdM=;
        b=kxqs8+JZd1oRkI3GH2J4ElMWqu2pYuQverV3fTUq5zfAoI5hszP3kH5cqjQiRr24b3
         djxBaZbxUTNs4vcdEjlj6WQIj8a2LEtHgWIBkful1PRpVEO3rPrnjQrMGD821Wq2bgGW
         a3vNjFXaxMpiw1UDMpIVdEYOpDKyStRJ91swdj+CT2tzC3oFMi+YsLCYpK0q26mhQ5k/
         4ZbEsS3kFGAZxmffSQGhnq5ZvU2tDef/2mN1QjlPKYgPBPe5AQsUglxqUB2ZC68Ti6Wp
         XTpY/3NLhyF9UcGhfci/X+XjDqYrd5NjCj9zb9SAVqbEErLINEqKWQrODLZourBT63jI
         XWkA==
X-Forwarded-Encrypted: i=1; AHgh+RqOgmi8b/J0YbYPqbSgwneMPZVDOQtzDI9c1aKCmm/SrQle9qlx1/4KAQIGieogoQAH7E1hE8gJmEhXxVS5mQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nbodcej+cR3KPAboPoCiFv640QA+r9bZGOeZu9WtruzWEwc0CI
	uszQBraXOylG28sP5fh4+tJNi9OD7Q13BqESlgI/5l4l18pdnEMfnXW3
X-Gm-Gg: AR+sD12H3Ygty9giDtC3uHuYVlhWSc8xyrnWApQuWMT5Fhkf11FOYRUnZEqfMvpufl7
	EjcKq7t2aBdKPIKW3CTzAF1fUZyhtla61+b0a91f/vZHTW+vZc+Uo1mURVN3joVuEE6+aSmQb1G
	iWC/zHdw+mFjXTpTVKJFnL60U92qvRjTHlAbzsoXGbMM0u3lpxLDwmfFDj550vHFgU6J903x/yD
	JQSaXe/hf3y28+u67phwXN3Wv7EYwSUsdP/uYl2VshD9rbFx9liRDVnsbxFlOJRxXp9HBAeSChy
	F6etj0beuCwFQvqqX8d8INhbHUhBNPoUqtmCfL5AXrD67HZHLVCp/J1545wzbff8zMlRwsqP9Kt
	/x9VoImdr3uBhxjs+Up8pG2bA8b4hjuEDpGJyIyHTlVxNbS1QGbf5wFUhnKjK6hq8iim5ZsT1xf
	h9BTqu2AUv4TQ0BZ3DpoKgFCIsunPrS1gTeNIy8XUPlj9MtIvvnDpYCmeZ+ZueVpzj5LFlyagvw
	Sd8uQzi62WZ45SN7labrXzB88pMlDpXGQo69NzELE6RBTomB7hh6Xz2IkD7klkOGpkf1VHpThQ=
X-Received: by 2002:a05:600c:198c:b0:49b:8eb6:5700 with SMTP id 5b1f17b1804b1-49b8eb65823mr75948305e9.6.1787853572313;
        Thu, 27 Aug 2026 10:59:32 -0700 (PDT)
Received: from localhost.localdomain ([85.118.83.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e27a9945sm10272342f8f.9.2026.08.27.10.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 10:59:31 -0700 (PDT)
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
	gvalkov@gmail.com
Subject: [PATCH v9 2/3] wifi: mwifiex: add dt flag to avoid conflict with platform reg domain
Date: Thu, 27 Aug 2026 20:58:49 +0300
Message-ID: <20260827175850.89395-2-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827175850.89395-1-gvalkov@gmail.com>
References: <20260827175850.89395-1-gvalkov@gmail.com>
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

The change has been tested on OpenWrt and fixes the issue where
phy0 does not start on WRT3200ACM-EU when a DFS channel is used

[1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
[2] https://github.com/openwrt/openwrt/issues/9956

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

