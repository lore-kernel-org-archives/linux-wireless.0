Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA5521A42D
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785479563; cv=none; b=GisH6oDU9FPY3ioUze09JnaSUyfcB0KcDNIlwh5Jqd9TYLdeRcpi56NULHJu2k9X2k9s4iSWFR2ukS3X7y/yTYeAkpXaQM0WKIZGWZISoHgW04XypXS/ebgsu7iH9jyXvzLZ2NRpgMGKH6YWC+67iAreNoZOir1hkoTz7HwBum8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785479563; c=relaxed/simple;
	bh=ofZ15thW10V3Oo1i/JC03bWEaUctqtD54+OnPeFR1l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ke8tfwDeRBZsRE6RGuJ50B/0P40xDt6UzZYyxwARcjNfs367AGOYy+8a8yAqEmvyclBh3Esq5PA27E2st8Y8ySeK1wHCUeRg/cHBLbkvZ6Ee5kC6tLH080df6dQ5wzZl/3OFc9l7cBDrUO+txXIBTAjeeefJNJ/kubeEOx0T26g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qER5XtHx; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qER5XtHx"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f97d310caso453708f8f.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 23:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785479560; x=1786084360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dxm2yKlW5AqKAUFOXXuaAiGhenk3HP3ULcfm5FsuF8M=;
        b=qER5XtHxak+wX5xAc+0wZIc9vSqLu72bk89pmoV80yKuP1/vAlqNpIfa31eAQk8xpH
         aQfVqceY9N3XndCOgIB2TTyIPQIJzqi3r73hDw2/btklkrsfdD/Y0x/0nUb550Yrs7FC
         +2g/GePj4dsonuugx17BDJ+CJXt/cxqIR8FtGLXBQgJF7av/NmOb/o6cTG4ZCtrMGUay
         Mmjxjn/4omCPgWLQaPwWhY64iiyu2hHP0PSI2QkPiIid2MEAnDD/R5JlBGbbWLlBFGdK
         7wvTd9slxav0BqueKknlkmVPGfpGklSg1S9z1FrIRFJGl7oC51DT3vX2DNafaUldh7ix
         X3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785479560; x=1786084360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dxm2yKlW5AqKAUFOXXuaAiGhenk3HP3ULcfm5FsuF8M=;
        b=bRlFbQOTACm/PitMVGZW6NFZME/Onv+Qvdefti8/zf/ORmaI681ST31AeEUMxV9uGT
         rblNOe3dMtXmVdomLrMnAIgRhosljulc+xgZRNSqo94vW/lr2n+TzPgEMHUB/jo7ybG9
         l1mFkV28MNGNTJeYbEZP7pXCDaqiScyTR+TwrBy3IeTwMTJMmdav/UeNegWJhdbA8bHp
         zYHPDz9hdlxvJf+pR3W4mEX3UBKT3zGLcqk91MfP9Ejj+bwMW+ijSgxIQSUnylFCEoMk
         cOhD7hd1FTCM5mg0i3vwQq+XU6ojG6sPJiR2Yk5xv2+TJWLsWLWEszu3E9Sjb73d8NCQ
         vpxw==
X-Forwarded-Encrypted: i=1; AHgh+RoZmX8TOgZ6jXpIJvscIgoqhgYUNOOax/7/pGUxYoNMOH3BhOrepkeUDxpwCUWkF7yqaGjsjWzaM7qx3k/VKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy898IZmPO/cPbHhR5ltLeaUkvFjyFbF0cUlwRiM9zzQAakHh3W
	RAvSCADvH/em7OrUA2ICyZKHDV/ISx4hIo9jMqysFdOzVeql9LhHEXNY
X-Gm-Gg: AR+sD13efoo49lMk15yuqA2tRGstACn/jW4sZ49oDgiwDuIFKla6eZK78omDEqUSdyf
	+J3DILH79NDvgK6/SMobgQ7L5GtG/QjB43nrbpPBfF/6c4s4gLC+z4vJFmTkbNpMB82YODcbLoe
	aQVvznx/ylVlUfQUfJgjGgrGRS746+dfzTegSN0OxTtaINpVisqL3oGH6MLeIb9sABz8J215Mlz
	AV1Q9Qk/CA1ehPNodaG3RF2St9wXvLNJa+ZSGfkQvjQP8AlAQ00pzHpypdngmFUWEOw32TCHc+O
	2hsLmUPEF5NwkxAHX3sP2kQWwLDuFfYpG7LkxJH6KTw9V2NA4QxpblL89TxfKwaOpSmOjSnePVZ
	ByQvlRvGxg77rW5Heh7UlryCNcbQBoNkKQQnxm8lqEpArgid0UKAeZ3ve90kAK/K89g8l5S9L+G
	vs2B9ldKOqXk3Fcj4rEdKQ2GiZq/uK+JEVwkjmbYitJ8nlhTd7/GlVuJmqHLfExkUedgro9CkR9
	Vqux19c4weswZCWgOGrtAmQ7k9/xMVwhUbTJyG2nW9v/zAKy2QksH9wKDG5I0yROhw7sL1Lz7Sv
	1vVljGg6RrKzxqEKiw==
X-Received: by 2002:a05:6000:717:b0:46e:230f:d095 with SMTP id ffacd0b85a97d-47fd2ab9d52mr1895019f8f.7.1785479559600;
        Thu, 30 Jul 2026 23:32:39 -0700 (PDT)
Received: from localhost.localdomain (85-118-77-64.mtel.net. [85.118.77.64])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm1188418f8f.27.2026.07.30.23.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 23:32:39 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org,
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
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH v2] wifi: mwifiex: ignore ROM regulatory hint on WRT3200ACM/WRT32x
Date: Fri, 31 Jul 2026 09:31:18 +0300
Message-ID: <20260731063118.26171-1-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <amsBes9fCF9ZdkCS@nxpwireless-Inspiron-14-Plus-7440>
References: <amsBes9fCF9ZdkCS@nxpwireless-Inspiron-14-Plus-7440>
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
The dts files on Linux use only board names. A patch in OpenWrt adds
device names which are easier to understand. If we want to be compatible
with both, we can either use board names or accept this patch in Linux:
https://github.com/openwrt/openwrt/blob/main/target/linux/mvebu/patches-6.18/
311-adjust-compatible-for-linksys.patch

I implemented and tested a better approach with no board specific code:
- check for a device-tree flag in mwifiex_register_cfg80211in()
  !of_property_read_bool(of_root, "marvell,ignore-regulatory-hint")
- add this flag to the root device tree of each affected board
Currently this affects only armada-385-linksys-rango.dts,
because Linux has no dts for venom. OpenWrt will take care of that.
This approach is more flexible and scalable, because the flag can
also be used in other drivers, e.g. mwlwifi (not part of Linux).
Any help is welcome!

v2:
Replace the compatible device names, which are currently only available on
OpenWrt with board names which are available on both Linux and OpenWrt.

 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index abc703441c5d..ff6a22237a0f 100644
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
+				    !of_machine_is_compatible("linksys,rango") &&
+				    !of_machine_is_compatible("linksys,venom") &&
 				    regulatory_hint(wiphy, country_code))
 					mwifiex_dbg(priv->adapter, ERROR,
 						    "regulatory_hint() failed\n");
-- 
2.55.0

