Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D884218A5
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 10:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785235035; cv=none; b=NBAbX7bkTgRwJEQM5Atj3o3sDYBMQqx1Yp3TUByojc4szuTCwju4fTC9bZehlFtbdJOjCgbQUTmuQUt+dcFUPJFZrjjBNBbiY8op9JSTaVlCRuE5UFeebWDmpC1hr4aAvprGFvOCOb7k2a5LqbZVdc00/UPa9bSBugB9KmiwtuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785235035; c=relaxed/simple;
	bh=TwDswCnhLGMjnmvVs4bZnK990PhMC5sQgrIAgM5AHz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OtSlVno7WstyHTd8pmBBmCRJRiftqxLRSpxjwE5wkj+LWjf+aVgCqnwcCXWvfqG9o49byyhI/keMTcY0GpQR1wd7cbe6CI3HbeKyyavn1zlvBQtbv6aGMugaJgqGHqf/aVflwlmqemNnDym4R44yVzs7ARqFrHWvCVZ32BqfpAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g5wndHGL; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g5wndHGL"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4956242332dso32341025e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 03:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785235032; x=1785839832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nz3o8jqJO211kGfAinv1dCAnPUoJ02ddlXqShlrRvxs=;
        b=g5wndHGLbSCDzyY1bPZeoMt7fuZH8Vg8qnw88lI82wPvhlEj9mfII+/Dxl6QpHZihB
         JeUgIs0rx6H4Skl/eJqd1RDg9ayjdead0z3fwDTwUqxEySZKBPq0v9WZ9XW7WpSpT1jK
         rdPTE3wq1jxCL5KVVvuyeMSgOOCHNv7gu1gTsK1iZBGLc1P7RkvrHpxWumMnKnI4S1XL
         xO0QvHcUto9gIAhCXK4iY7RBulIzuS1ojzEmeyz+OM69vuWNJ1N03a0Ga9YtTfu5eKr+
         ileI3YLsPPL75p+2oeK6cFH6uJZ49QbKtroTh+Mog9LfIVY5XROx4RXxmnXxGByg98q9
         u6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785235032; x=1785839832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nz3o8jqJO211kGfAinv1dCAnPUoJ02ddlXqShlrRvxs=;
        b=WKz7RxxRNIbYeepN8fbmFffIMLCsueH5PbRD4BOenyBiPWKZuo0MHi5d7SEfRebOkc
         2JJz18RmI5k9wRHgBR7mOwx8hlfC1neVS7uPEQRBM1FezXiGOEGT+UdN1ck27pYTFSp3
         8BNUk93M7U1YhxxaHelTjMnRTPIFXedcAhyv84K8fUjujCYtV59vaGWnWFH3lGcf30NJ
         uwugFfJkFr6nskriNsIYgZxDKka6DkwzhO34R8CzSD0kHRAhxUtPnt+39L7q0AfK8smi
         B4QrooxyDG4O7Y+wwtW5KACrKqn5M7oonYvDiabWFqvOAGfwqO+9AxptXZfi00VR17gb
         qLWg==
X-Forwarded-Encrypted: i=1; AHgh+RoKbTKClm7s2t03wx6UEo3sPcUMZHDl6TofuM/r5h2OzF1P6MfPLNHZkV7EOTzn99UeBkpqCEfpAYwsndaV7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzgstsK/JJDNy/x9yU1yj2c60sd8AgQyVlJmaLx1JUufsGy1z1c
	nUG9krbdIni/7MK8CtsDjRPyK2SFZtOzAwaC3SCQgpShB8r0KWciIl+p
X-Gm-Gg: AR+sD13YYwrn652sr2wCJe3zKzHP1IZBCa3BH5zFi31DqHHJDaoI4kvTlxAb2TCkM15
	grysnFTPSr0+H0zki1QQzKVkgRtSx0P+QfdtmKjh2enBmfSHfR/fiJvSp3dHaPR41BeaecelD1Q
	lRGleEQZcKKsLn4VDgsUYCr66gW2uwxKJFQfzN1ENI+n0LGdMQOeY47TroSz4WUQnZCCoac20OO
	gynk2uiboKxLAvKGRA6LZ39rTj2rwEQJp+zKpFqz0vB+4J21yoPCh8yUJ49pOz3gY88tIzLrU5y
	1GsUe624wyigpPt+mvUtgSAlBUetnPKs0mK9q1H+4LT6apXfNu086QSkk0V4dGK831BY/IZVwRJ
	7Mys8a9ywwxgIgDT/NBiukCCQfJhtPFMrfa6/9fkp6OTMhetTaWM1hbBpxs0x9/me4yopfQJ9cP
	ZqcJ05PJH41TKkZ8sfIr+1FW62ohc9tpTcGdqKeKQ6w9Un7spEuUBVqRbs8BG/z3ogwCYez1cx3
	wj/BwZMwuyqCKA=
X-Received: by 2002:a05:600c:c493:b0:495:4d88:e630 with SMTP id 5b1f17b1804b1-496c6545a58mr18452665e9.10.1785235031527;
        Tue, 28 Jul 2026 03:37:11 -0700 (PDT)
Received: from localhost.localdomain ([37.63.24.239])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957f9ae5c3sm408677755e9.3.2026.07.28.03.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 03:37:11 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org
Cc: francesco@dolcini.it,
	johannes.berg@intel.com,
	kees@kernel.org,
	miriam.rachel.korenblit@intel.com,
	wenst@chromium.org,
	rafael.beims@toradex.com,
	avraham.stern@intel.com,
	peddolla.reddy@oss.qualcomm.com,
	error27@gmail.com,
	s.kerkmann@pengutronix.de,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH] wifi: mwifiex: ignore ROM regulatory hint on WRT3200ACM/WRT32x
Date: Tue, 28 Jul 2026 13:35:36 +0300
Message-ID: <20260728103536.25012-1-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
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

Ignore the incorrect regulatory hint in the ROM of these devices, so
userspace can set the correct platform regulatory domain. These radios
are locked to the hard-coded configuration for which they are certified,
so the only impact is that the region conflict is avoided and the 5 GHz
radios can be used.

The change affects only WRT3200ACM and WRT32x routers, and helps
overcome the incorrect behaviour of proprietary radio firmware.

[1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
[2] https://github.com/openwrt/openwrt/issues/9956

Tested-on: WRT3200ACM, OpenWrt
Cc: stable@vger.kernel.org
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
---
Please backport to 6.18, which is used by OpenWrt.
And let me know if there is a better approach to address this.

 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index abc703441c5d..04f7f58cc7d0 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4899,7 +4899,15 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 				country_code =
 					mwifiex_11d_code_2_region(
 						adapter->region_code);
+
+				/* WRT3200ACM/WRT32x ROM always reports US, which
+				 * conflicts with routers sold outside the US.
+				 * Ignore this hint so userspace can
+				 * set the correct regulatory domain.
+				 */
 				if (country_code &&
+				    !of_machine_is_compatible("linksys,wrt3200acm") &&
+				    !of_machine_is_compatible("linksys,wrt32x") &&
 				    regulatory_hint(wiphy, country_code))
 					mwifiex_dbg(priv->adapter, ERROR,
 						    "regulatory_hint() failed\n");
-- 
2.55.0

