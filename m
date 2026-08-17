Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62403CCFD8
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787003730; cv=none; b=DyNSpF9bsXr9Qki59kV9yJF5ymOpixWxvjrvlvSLDL2kDgpbXBY1nAM0r96O2M9uFPWJp0r9vVc4mbtxj/ijE+5PsVfK/udTR5z8mvYgGSGAKDymTFRErk5vejfuW5cidt+l0H1kjcQwSrd4DdQ6dZbkSztg4Eb3QzCFu7GO11U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787003730; c=relaxed/simple;
	bh=TJY3hex+l5/Tl/ivjiuYNGr3PPDEzX3hWulbnq7k2rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hbnfv+BBKDd0WsbukRaO3BRA9zdqj0STPUu0WtVuqwoh7r+KgNvB+wJd0+aEc+/sK/Vzsw901AJF0C49h8124Mcf/x0uDugs8xZ6lXJMbWaFHkVXBX6QdjlRoWVtW+whdtHRFWxcnsOeK5WSwY0ViGW32KfvptI1T68hQddqwIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ieU7D1gJ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ieU7D1gJ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4956869750eso26474575e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 14:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787003724; x=1787608524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aDO6GjJPOwWJ3cCExfgafVeJUpNRoE4Oa0/Ds8leCk8=;
        b=ieU7D1gJHgWghdtS1WlsXGjaAOqxQ5SQ2/hN+drKbAQtYkxtV66KiOgghg8ALCAyDU
         TVghmz4mpuA0qRktYeRjHsaoMG3bxd83ixQI0AF9FaCrkltuTIvGXqfBaJka4ouFWZGE
         f1DDptgZHEvkFdTjKFDhQkRAZXrNnyxqW0DCiwJ/B/sS/DVJBYKHBbGOFGDnJLx9R5Yf
         iaf+OJAD2oD4U08PBBP+hBrv4SxwIId1sKnuwsjYM6zHNxT/CgvowSPXlX7q7Yim/mct
         ofKe2P75b2lHOI82F7SRifwhILmiTQiuNUok4y07HTdh3XHPf1FDGpeois31hBe7bkCE
         zd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787003724; x=1787608524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aDO6GjJPOwWJ3cCExfgafVeJUpNRoE4Oa0/Ds8leCk8=;
        b=PWHS8RfP3Qj6crSDcq/03QDBhktQjfFJ/ICa36YphDwUCg6ciIQAgHjb/h3vYrBRdN
         jwJD3wJio9NsDoS7cACvp1FRy/4o/ktBPCP5zeBCgjta87EX8Y5q8UQ8MVJ9ICQUtvB4
         coE/pHpa+zw8b0H4/SBrhprHOoDk7X+LM05m9yDYF2ZsTuHupOJQaPa5FQlFpxnsNANu
         bFWGB1wqyo0jjU/7FEqPuvXy6Mbh73fwqYCjjIPCh5ZqIYbfKOdEht+IvDX8i+eqBDhl
         MOkqp7aMRpJA9xO89+U9he1G4Xw9VdBfHgyePmRYUOwv3pGT2TPwhEFPTi4m1nnoqcxm
         ieMA==
X-Forwarded-Encrypted: i=1; AHgh+RrkNxptjM38ShSA17JWm3aIaAb9xZ0LNzDrlCqejfeqZw5e97Q0Yyq0sdyUA+5cEgO4WqFSKD8LHoV8ZYAPow==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb650qiWimZfCd+xGgDyTCveyH53d4ktGEmr3SaLVzHsVdHGcB
	l96HofdrphqaJHkm7YOOQobACXxH9Fi8GhXdxKHHbkIm4CPVEmJjyI6p
X-Gm-Gg: AR+sD10KLwlEm2Mpx8WwbAPew8ByCO0C5oi55pYIpZEgUctYDoqAulvZ6hx1LRYCRH3
	ICfLcfy85BZo1pW4L047mxeHi5yUew33ky2AJ+UgxkrIPd8ka/miYlB1ST7YTEcm8RmI9z23SdN
	+xM53SSp89pgwZASDO6JLVVYuvoit5WIHhoJIG47WYh7IvNKeXlgJMvE4dWiv0eRaAIY/C74h5r
	A3kKZCrhwAjsdih5GSsAo9GLXWejHPzaw+JSCkw9bL8mum5sp7cpj4bbMLMl/TMRB1shQ/oVGzb
	dbrqLTPcea9DTMh2f+oBEDszFZkKG1T7ZSJsxx3Nda4JEkONdymf+lDjL156SQXXWxA/2gJ57sR
	CNk5XTi8Ag0dtDxRseR8kzZg12BJgabGBpYscpJpy4fPlbWlwDQZ+xmdwSbPqIQdvmaO1NBs1rN
	HR8fNeX3ci34BWGcQa2BaTbV6watLDGiA+MYEfJDjIbCfokYM7IyoviVNQ5Yv4sl88f5ogtB4S4
	WcuypaPw+UMfAMuMovx3+TZ47wsVPLd2/tP9+Sdx3XhtDMT759PW4OPNOhPdmOOR3L46h8oAuYl
	glbDb2pKZA==
X-Received: by 2002:a05:600c:3485:b0:499:8758:8cb4 with SMTP id 5b1f17b1804b1-49987935eecmr451205815e9.5.1787003723726;
        Mon, 17 Aug 2026 14:55:23 -0700 (PDT)
Received: from localhost.localdomain (85-118-76-205.mtel.net. [85.118.76.205])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49987b2a176sm309622525e9.4.2026.08.17.14.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 14:55:23 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org,
	johannes@sipsolutions.net,
	andrew@lunn.ch,
	krzk+dt@kernel.org
Cc: francesco@dolcini.it,
	johannes.berg@intel.com,
	kees@kernel.org,
	miriam.rachel.korenblit@intel.com,
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
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH v5 3/3] wifi: mwifiex: add dt flag to ignore incorrect ROM regulatory hint
Date: Tue, 18 Aug 2026 00:54:28 +0300
Message-ID: <20260817215428.84740-3-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817215428.84740-1-gvalkov@gmail.com>
References: <CADOrJmbTyrGGkq+9OJDXCgTa2HvNo8BWxoE6yjafcrOq7WNamw@mail.gmail.com>
 <20260817215428.84740-1-gvalkov@gmail.com>
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
preventing use of 5 GHz and DFS channels. This also affects phy0.

Implement a device-tree flag, which allows affected platforms to ignore
an incorrect regulatory hint from ROM, so userspace can set the correct
platform regulatory domain. This avoids the region conflict and allows
the 5 GHz radios to be used.

The change affects only platforms which explicitly define this flag, and
helps overcome the incorrect behaviour of proprietary radio firmware.

[1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
[2] https://github.com/openwrt/openwrt/issues/9956

Tested-on WRT3200ACM, OpenWrt
iw reg get: no longer reports region for phy2

Cc: stable@vger.kernel.org
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index abc703441c5d..26978158a0ad 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4899,7 +4899,14 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 				country_code =
 					mwifiex_11d_code_2_region(
 						adapter->region_code);
+
+				/* Allow platforms to ignore an incorrect
+				 * regulatory hint from ROM, so userspace
+				 * can set the correct regulatory domain.
+				 */
 				if (country_code &&
+				    !device_property_read_bool(adapter->dev,
+							       "marvell,ignore-regulatory-hint") &&
 				    regulatory_hint(wiphy, country_code))
 					mwifiex_dbg(priv->adapter, ERROR,
 						    "regulatory_hint() failed\n");
-- 
2.55.0

