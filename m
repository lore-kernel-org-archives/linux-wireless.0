Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6CD378D8C
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786127252; cv=none; b=rQ5WS9E2MKiGBqvFkT9kW/l7sTrg5SMIb0PtvuncSoRuPpGjbKthYpj9V6Bo6Rj4K39NK92et8U+Vxo/uBuN/8bYHghOt32wAxfWwgv04iPzqsNWLvr0+TVhcdRJ3LiFaJXLmn3stIm6pWzxdaObJRRTyMYKrXp8CrGMkFZtsLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786127252; c=relaxed/simple;
	bh=Kk/Th42Le0i+/EVJjXBpuhzcRB4NEw90hZMlGQNKPFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5cB9cHiYFjzBN+ZjAbj2q7u/AWBQDckWGSghkwUaFXR5FIIim99PYzVpLNsbjvDjfbf0XiD41v5a2T2vD3iNA0U3qvvN6JIWkWdgF/++NxFsL0QBvEOmj8d6/82YjcixEjmDmUYZCE9LZ36ovq7Hpfs/Od1BOLeMO9bKHo4KCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHS45aHx; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHS45aHx"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47fde295992so1995783f8f.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 11:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786127249; x=1786732049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r3QOegBrxpOQoOf5XBMAtesiyJaIZB0qfo5JK8U5SZE=;
        b=BHS45aHxaHuk0CZLulMxbzJ5qctEZCBHh/51I3G9onS+3+5nzBYX4zmL0Td+csO4x/
         qAwOhYe3C1k29OvT8ZxViQhwN2Q0ct1YPqqrNBfCyl7wk/6fsMaj49fq/cxNL2wO2CnT
         1dH+MCnUREMOEj58//1YEuG/9ZUCQOwQWH1NFl97VkEg2g+tFXs1OH6vtck21HkbBSEf
         s4BpByvTQBHLJQpgUruRKotuVaaLblKccGmjglbM7y7c5iemZnC8yuUY+5UQX6nuXQh6
         kBl+6vseIE7m0vbjJTZ2eADPi5CmefQI+URUtCR4lPdNXut0V2So5qlGBB9CMD5b0AYu
         5LTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786127249; x=1786732049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r3QOegBrxpOQoOf5XBMAtesiyJaIZB0qfo5JK8U5SZE=;
        b=prnv04H0hvWj+J0yruRKjY9EPONQsoF4OavKI+yLvzI9PLoYS9yTD/7FxVhFRXph9Q
         irBcqYbap4ny0ZG/caxq+M5Wt8ZusIwKbrpnOO/eIZXFaQJjaXgvruAt48ryOCg/L5Nu
         EMUwmA0Q8BU+AzKzarsg2V3iTQkyVa6eji3AxZJL+KYNlhz96CNi1IZdS8d7iOoVKpFU
         n6im0MtZ86XxqsebRWvEdpA+F/09sJL4iyW0aZqf/BPZz+5XaVxvMtfoYpv7ZRZngBbT
         MFE/1SuPAWYtPgVUymUUkSFHsNe5sI3vBpuPfm19XF2fr4BClEWXDfFLDyja1KRfSf4y
         XNsw==
X-Forwarded-Encrypted: i=1; AHgh+RoQGb9DDviJSx8+xOVFJ0ZeLXSD8GsIPkOUhlGu5kLCGGr8A2HB08c6Ca7MEpDLJBkahSQvnDNG8MdtvMdjxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjqsnhgXEAteGdUS3RSZQ9FLaCLAAS1oodpO4pKijJZ8a2JIgp
	DS3i6rTG4jC0NWAeOgsc/lrIHS/+bvkL+wxvvhb843342E60YYQCl054
X-Gm-Gg: AR+sD12iQQpuYbNhF70chCf9XSBXBdSyRMTNs3G+NOWuHlkwhKJx9YDcQeZxHM/15LT
	SQpaXgZ9VTa6Br4utwbrrZ+czkbzAwSW3q0uBxUXuKAv+Jg2/XziMqQnRUUakqla7Ue7kRR2lgq
	dvHUasdtFshfI6PS/F9AqpMDzuTngwV+jej5rFktMc3etlAhoMJi5lcXLJv5n/MKI1Qvsf6xU9I
	1LH8sz+DKqLCIcepjGv/QJK2tNzoqbOolVv7dqikTUu2OndiPclLZIUgCPJ8gOgAYIXwJUBBXUk
	MQ1F3RdcJJBTdS6uXnx7Zc872T7YB3iHvKU+3MKeFOzpxE5+w1EwhuQANdWNydm6lGxN+dwtK7b
	aLt8sqwDOLW7r2TpNuitx+dkZ5NoGT8tVTIEupM54gI+r3830lk93mLaChLzPnSVZg4Qdg0jnU6
	mI7faecl80ZosHGLOtQFvK7QN2Go1phlOrVS85kUMBiEcuGYuelB/5vZT0KuQuiPX962kOEXQTt
	3apXuUQTR4S+0o9UBxVURPLgZgkVTh0mxL7KnRXp8etOOil+PSxCUFVUs9EcfvrU6teHZsbwd0=
X-Received: by 2002:a05:6000:2889:b0:47f:90f1:68c8 with SMTP id ffacd0b85a97d-48131915e4cmr788570f8f.1.1786127249329;
        Fri, 07 Aug 2026 11:27:29 -0700 (PDT)
Received: from localhost.localdomain ([176.222.12.34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021e7b3fsm8543886f8f.20.2026.08.07.11.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 11:27:29 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org,
	andrew@lunn.ch,
	chunfan.chen@gmail.com
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
	gregory.clement@bootlin.com,
	sebastian.hesselbarth@gmail.com,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH v3 2/2] ARM: dts: armada: WRT3200ACM: add marvell,ignore-regulatory-hint
Date: Fri,  7 Aug 2026 21:21:24 +0300
Message-ID: <20260807182124.41572-2-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807182124.41572-1-gvalkov@gmail.com>
References: <anWWr80yAcOQaVVS@nxpwireless-Inspiron-14-Plus-7440>
 <20260807182124.41572-1-gvalkov@gmail.com>
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

Add a device-tree flag marvell,ignore-regulatory-hint to the WRT3200ACM
device-tree, which signals mwifiex to ignore an incorrect regulatory hint
in the ROM, so userspace can set the correct platform regulatory domain.
The radios in WRT3200ACM/WRT32x are locked to the hard-coded configuration
for which they are certified, so the only impact is that the region
conflict is avoided and the 5 GHz radios can be used.

The Linux kernel sources do not have support for WRT32x. An equivalent
patch for these routers has to be sent to OpenWrt.

[1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
[2] https://github.com/openwrt/openwrt/issues/9956

Tested-on: WRT3200ACM, OpenWrt
Cc: stable@vger.kernel.org
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
---
 arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts b/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts
index 4ab45f294de2..6e283e223ca4 100644
--- a/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts
+++ b/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts
@@ -14,6 +14,7 @@ / {
 	model = "Linksys WRT3200ACM";
 	compatible = "linksys,rango", "linksys,armada385", "marvell,armada385",
 		     "marvell,armada380";
+	marvell,ignore-regulatory-hint;
 };
 
 &expander0 {
-- 
2.55.0

