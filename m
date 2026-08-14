Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2792D471401
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 12:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786711899; cv=none; b=nAw5/8dLBiaA36v5xKd18eaxMXMjWzcMsqPVLMGZpl3DcOhR2VqOUF6IQD6s50c/AdO8HKV0IxJjO7oOfrfoS1PK491JB5BaYKpl4cwdP1UXWjS+kO9Rkx5lOTVvGeBZFii3OWbuPmY5EVxx7wH7e5HioZ7JJXJ3mE9i/0igerY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786711899; c=relaxed/simple;
	bh=+cdB3jlbfOwPvLHC7qFXAtCDuK+tf5d2RCCwL4bvx5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlFRi/oQ1p+AiQnZ9qxmRG8dQC5hNSFpRl1J5OuvSaLoDaxI/nFweLh5PbUNLRQXGZZnr59h/HEVoBTC6mzbO19ckI6Rn4YguBWlpgKs4tSGM8o7GyQ3EpgzgTh0Vh/lVVbpse97gct11pYF+rZIGWxk9B091WjjtvnoV5fqkII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cX2wSaV6; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cX2wSaV6"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so12861415e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 05:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786711894; x=1787316694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jxmv/7o/NfVI89rAdTVtRInPWnXbZJb6x6oPXtKGqx4=;
        b=cX2wSaV6B2IcEy3kVNw/bSheHrVxlaAoZdKynyoUz3jg0oo+lhBYKap9dh7zHuaXPC
         JwXj7nVJwDTywIm61FURM33JKNdQe9Wep5Ml8eGwe0EVE26S2n8aBtedE4PNzAfh4azs
         P6p9PhmVkrnGSqg0We+Zfhgg7fmc2B5j40wQr4l48d72JGp772reLKme3z0sUoE/kH3O
         n4ohfiGZEthQhoPVbchm6SOQ9lhcqfXrt4P6UdYYBaFaEjFhnguADFqdsM799pRTmQHX
         wccvbMxR3rn3tl6BKRtVT9p+XyWR0Mi0aAVY1/poC976ahaM63yIzah/dmNwMBrwKf5c
         yaMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786711894; x=1787316694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jxmv/7o/NfVI89rAdTVtRInPWnXbZJb6x6oPXtKGqx4=;
        b=tPftfovyQfHwJArhz6EVOHA/jNGtTgRi+mPJt62/EQmW8jb2j2qyygu70yJsxvdP5V
         qtGHMySN4z5s+XTUG6ykJkeRDM5ryM9e+IEgMR1N/nJzWSfFcqZ43dJ9HEAEej/i6C9u
         oDYW8UTzX2kSrWbJQW3mZ+RiFJGc8WqxN+t5v80o6DG1lZ79W3+HPD9eBJasGS1+IIGc
         ktmGWhd72SYmm7SgT3QEZjUXMEw9zNqchtB6lrYn+EGBK9mgClC+XH79PFNmbxOhh0uo
         YViMMmBnCwg5odkzJMw7m1f2xsXAq27/W7yAVJUTjhcBTK7c4dLvfZhk6PLp5inr/Uw+
         YWYg==
X-Forwarded-Encrypted: i=1; AHgh+Rryib2ruHzKpdFGYzph12C8KAjKHg5nnXF+JJyWfkqKg+AtAPD2g86lxP5D3KmTK+NW5NukiWcyPSKmkTOgQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxvuoQiM1Cu3W/fvQSs9uj+vBEWCtSUUPrnXO2mmnl3dIqdQIM
	FZbZ9nTvsvXS/kcLVl/uOUzVAieVhJt3rXvWNJpP8CzhzkjelJ8DLmlG
X-Gm-Gg: AR+sD10OuwdK9rlDhm6mWlQy7tMD2K0vUWMS3TAD53pcvVdeRG1zLzwaecE4EfAq6+I
	njRZRIoF14o1qS+FodX5D192RHeXwzQxzA/jphIIT4yx2FWb7MkZukvMGtSegRoBvd9jnkP4cdF
	D1ldDCqBgqFTYZtdW9dANh9o1ZlOdJOrR/HQ/EMV/H769I/+7JoygGmcfOsgZ0QzPEFiikN+eY0
	YDhJ3Gzq4L5HJGT+nq0iMcTPFpxRr9Fb7hccH87gf3zb52+OYAwJayQfJm+CJQ/yovkBth4tKgR
	GgqkjNx4Tbg6qAo9pnyKku/0m/jmGiUD9ryViabHWSkYrFUaw6DnHDVwHGX7gaKABA5CMSkm/YO
	yQZaZQm3sYjeRPegFrsN3T7e2nPhS+hpLNvDjuDhzdR0/ORSpXr+YqEjfnf26zC9rLMmB4XqE3m
	jtqdErukxk8mQkXn8tdX/T8nXWHUEP8F0CvA2LQkrmumFjKqWo4lUh22lMADKz556JqzbVHEQOd
	S/lyua0hYu4DhZYnN2dQ+ry+Blk3Ly9vWx2ga3AA6RZLPrXBOyfEv2tw9xAHaf3dA==
X-Received: by 2002:a05:600d:117:b0:499:5f80:83ac with SMTP id 5b1f17b1804b1-49987ab4e1bmr49051825e9.7.1786711894092;
        Fri, 14 Aug 2026 05:51:34 -0700 (PDT)
Received: from localhost.localdomain ([151.251.241.52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49988ae8b62sm49727315e9.5.2026.08.14.05.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 05:51:33 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org,
	johannes@sipsolutions.net,
	andrew@lunn.ch
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
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Frank.Li@nxp.com,
	chunfan.chen@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH 3/3] wifi: mwifiex: add dt flag to ignore incorrect ROM regulatory hint
Date: Fri, 14 Aug 2026 15:50:25 +0300
Message-ID: <20260814125025.90522-3-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814125025.90522-1-gvalkov@gmail.com>
References: <anoYr9H4KojJv-aZ@google.com>
 <20260814125025.90522-1-gvalkov@gmail.com>
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

Tested-on: WRT3200ACM, OpenWrt
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

