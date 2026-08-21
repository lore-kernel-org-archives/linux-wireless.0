Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361123126C0
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 01:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787274512; cv=none; b=SilXCCWkz6vwpd6u8rPfOfnj4SPdjjkk805XatEpXFB6MH05gU6Wp16E0uih0gnuUWCzXdNpl2ZIebvJzEZHFmuxHg4kIAZ27RQkAJHwV2tR5071KFK3EMEAGwywcSzRrQX6LW+4+wM6HWvmcaBdnofx1/oNG2xBn09TUvnH7X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787274512; c=relaxed/simple;
	bh=ZTq33qTyxzeI7zy/moK85RxzAbygclRy8/OKmRR7gKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl+RvZ8TZlGobhh6xn5vAhMJuv0Jbe0Wtv03he8GCP5v1v0pLacoc0ntjuYU1JlXeJYETOgv92yFiuOA2sxlFAiXesxU3/xf3EoJcnPAh3/0VYy5SHC7mNvKa94ejcVaT1/6pwDAyxRg4SM+HAONJ+RAkLyr3F0Qu1sBoRjjmSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qVAILmvP; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qVAILmvP"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a3e145e1bfso702327a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 18:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787274509; x=1787879309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3cBAaDb2n4Yj0YfebzefO8jXzgNYsaQik+7MKadIvuE=;
        b=qVAILmvPaLm1FzXq2NxBxOD9/TnTekZaJtor4tOL065/02ssJCzB7ymGppw6o1UiEn
         6FT+8alTKsrLkkP/13k4iRScf2fC1l71ZJGQNhvS4kxv1R59/UdRVBsgDblY//3DFYxA
         lke1p1QaTDWnalE0swKCpDvg1mzxPEuwN38n6yHHrYFyeEDCjdyxHjjXFm8d8vNo9j4O
         IXmtxhVaUicEFRm14sIE+EUwYQBABigwtrdx6HSZo/sOuYBBhs084W3P5bw8VKb+7TuU
         uMko3CbNm8JFaqDY6noGyJVBFvta8YmimJQF6c+PL1pnT2so4FF4HuYGm9yIaSsYsUAB
         +M1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787274509; x=1787879309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3cBAaDb2n4Yj0YfebzefO8jXzgNYsaQik+7MKadIvuE=;
        b=fa5cBT7yoDgd0p37i8bZpVAQ4R1vphjqakBszoca1sLCVAIyqQzgENL0nU7VTuimss
         dyHQ0TY0CdtrLc89hrxc0WVtODOkS7S1Xsie8BxUjW4mxOasZfOgoxcELUVlmUcWOT/Q
         uCFyhnLu1HAtso9Nni4KLHweFljOmBVgVjAmmzK1pXwyixNu9UL7TRnfVdpauQjUJZge
         36/AOsras562n735BvSiu//+i2MuX+ebNrFEHPHE1N/K9t1CHWNg2zQcRTvVrkISJFPP
         mOajgV9b6ek3mracRdkzSxvOkys3aebSat/UI7B7gfOoGatdZdNFIw8k/p+Et6K4iDDX
         AFnw==
X-Forwarded-Encrypted: i=1; AHgh+Rp5/V0qu7G77wxUmaC1gc7sh/ZgnnTkFx0C2nzQnGrh/LheUqJOfjZI41ZrfWAi3HTJBVzZbuYXL3P2xLYYzA==@vger.kernel.org
X-Gm-Message-State: AFuF++lU11IsRpzbmLQ2q0OWeU9JwPM6Kj0ABmGUD0GUTn0NObRbj1j0
	/zk73DDE023IGVHsZ8GdB5zgcZmXhjyFNzk9iX+0IOtCovpw1sUwZPMB
X-Gm-Gg: AR+sD10tRzu61OTVgUCNN0lq/4KOTabg7ft65t3QKnPosW37RO4b4GbUpbWSu7CLIOY
	1M/+fE6MCQFFyT5hEZLfo9HojYnBFc+Pktx8/Vu0yOzAoy8rSOmil6qfhZXXnKJDWkt01SWKv1Z
	L+gPmK7DRtciN5XNFb+iozLpgsGVwzCigE1eGfnI0AOk3hJvzMy2/9w+n+Kjcpvp9OxUMqxpSfA
	gCSboL7Q61WpOmRpXzEbhW+pPgXqGIZo2bOyfOtu6RGQhhaK50/eRaJXhNXA861B8swbOUZvrD1
	8oU13N6cRPTO2HJSe978g3Qlts86FO0EoO0MxGMPMpdDTnXEASUGYCwSYVUfRytwIzi87w1A50G
	BhGSAozemx5kQ9WRA+ECYd9ZsZY7DZ5XzFvCgoVLkMmyRAOtcUbsgPZsLElGKPM8+euxXVsTalH
	pMo+XDnuZHGIAwRT97FMSl2/4o6y+k+d+ub+JzmRlFAMg8KCwhnGb5tt9cz+6VlAEVTAmmjY0hI
	iC8BpfoYV7QeVTT7rduUgudVUic3xLSvIiH1JikY9SJ16bBi0xr1ogiAV1mzvuR7A==
X-Received: by 2002:a05:6402:4348:b0:6a4:21c6:1d14 with SMTP id 4fb4d7f45d1cf-6a42eeb21b4mr3325630a12.0.1787274509430;
        Thu, 20 Aug 2026 18:08:29 -0700 (PDT)
Received: from localhost.localdomain ([151.251.247.22])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff1563c5sm3913104a12.14.2026.08.20.18.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 18:08:28 -0700 (PDT)
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
	arend.vanspriel@broadcom.com,
	peddolla.reddy@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH v6 2/3] wifi: mwifiex: add dt flag to avoid conflict with platform reg domain
Date: Fri, 21 Aug 2026 04:07:27 +0300
Message-ID: <20260821010728.45065-2-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821010728.45065-1-gvalkov@gmail.com>
References: <20260821010728.45065-1-gvalkov@gmail.com>
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

Tested-on WRT3200ACM, OpenWrt
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

