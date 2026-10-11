Received: from smtpdh17-2.aruba.it (smtpdh17-2.aruba.it [62.149.155.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F35A469842
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791758922; cv=none; b=I2aqw/Ky4FUCTPcp2+BaxeGZWysJ1Rdv8wUM51CtXf7PZ1msrTZCirCOPiH3FMO34laQZsn9uE+UDwE9e+Ao1EIeDl8GYdgHRrhQHplCZ3yY6M/ndH+Y7/KT+1OC56ofI1yMrhVC62GI5CdtW4RtP3r0flaAfm2ovdKruNIAnWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791758922; c=relaxed/simple;
	bh=rFXTrpUCw2RTFwskTkLoOBNivWtd42NvSspWk91m10U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ghW6EmP0nNyBBMRhqC7tzigCPrWh03EyUOfNu0+O1c20p5vNfim8QLALw4hlW8ynGxKXH1xzBzJT4A+0a8y+Z0ZO0VoO1pXp3RxRDjugh+ouatUUmy5WxIzf0h7gjUtrJ24syxiWINANGLr7ViqEKibwCjyWiM/SXj5yiqr1oBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=T2duyeKP; arc=none smtp.client-ip=62.149.155.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="T2duyeKP"
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id G2INxu7ww76R9G2IOxOsyn; Mon, 12 Oct 2026 00:45:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791758732; bh=rFXTrpUCw2RTFwskTkLoOBNivWtd42NvSspWk91m10U=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=T2duyeKP/qE75pEMO+Zd3NIwe6UFOut0+XHC5djez/77Cg4QdVIY4KWGduGbxc5sh
	 1rH67cJHHuh32RNQq6kq4zoGWGxqGsPAQlExbif0duAE6GbzwjRHcsV5F3lQOm1mP1
	 Z/TSBRiYjdMfyD+0zP9twOlaoq8NDefknjVsyDrkrK9cfpd8CLrj9jo7VIVuiGFtGX
	 VjrQVkSx5lYgv21TU1uCZtImo6SUAzL8r2bNI8aHSGiubxKI3wKLj9fgu2PTZUTrsP
	 z0llxm9JDpadSuUQsx+kvBdv2IvEF3+SeOYb+hXuXetJJ9PebMx70bl+D+tek9376T
	 NnU/11zHczzYQ==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Mon, 12 Oct 2026 00:45:27 +0200
Subject: [PATCH v2 3/5] bcma: scan: accept wrapper-less cores on
 wrapper-less backplanes
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-bcm6362-wlan-v2-3-4752da7e0982@mythread.it>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
In-Reply-To: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfP2cNQoSpltEWhkdtWFlmY8vumarz2zBu0G4omizKhl/O1KMs3UROV8wnvfzf9jv66Hka1krNUOchSfVMILfwtz6Xyn3OtJB1FE5YrbbRlYsWbF+UDpA
 aK6Q7XygWRAnrqECHPqKuP+8DC/fVu0/qNNcxJiUhnJRs/5DHC/IlY3+qHvzhRXqLsHs4iLXSxtFxqWUxNZlW4siVByqrbo9Ta/K5KicF9ePdxd+XygdmIBg
 Ho9aP2hKw/UWbH3TgWwS8Uoo7WiNmWG8bRg94CjIvDwxJw8n5rkpdyLID7xWVssf8EmoA6ctW0GTVcHQxb4sBTx9PBoSw2b6EmSQRKNZ4LxEHmCeMMu46v49
 0UOz52wxPZ3qGZrMZo8gDH+PqqxiftVRtbx1yEXQbfFM2xxe9eD5lCxBjLO0lqVbuNsff5G9YPD8PCQKw+74pgwbLTc2BCNaDkhJN8CbRDup1S46QVgSon9y
 uWWou51+3rMjTLqi3oBuv0UctdEv3aqG9uKPLPEVW+/PNyZMZaj1/WxZWXi/7ho7PlER+kE3AYzUFsJathJK+ybAafotwJ99IbBQJwafZnnFtKWabKCkOgeI
 wBpE+zxFRnF863MiU7IPwxzsoj4d6BQLkh5fnYGC2uEez+3OneAKIqHkbxOTqzkamgA=

The scan drops every component that publishes no master or slave
wrapper in the EROM (NMW = NSW = 0), apart from a few known cores,
because without a wrapper bcma has no agent registers to gate and
crash. Since usually bcma is loaded early, it ends as a loop-crash.

Some backplanes, such as the integrated WLAN of the BCM6362, have
no wrappers on any core. ChipCommon and the 802.11 core are gated
through a SoC-level register block owned by the host driver, whose
aread32/awrite32 ops emulate the agent registers, and core 0x837
needs no gating.

Add a wrapperless flag to struct bcma_bus, set by the host driver
before bcma_init_bus(), and accept these cores without wrappers when
it is set. Other hosts keep rejecting them.

Assisted-by: LLM sparse
Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/scan.c       | 6 ++++++
 include/linux/bcma/bcma.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 983a62ddeebb..ef880b635971 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -318,6 +318,12 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		case BCMA_CORE_GCI:
 		/* Not used yet: case BCMA_CORE_OOB_ROUTER: */
 			break;
+		case BCMA_CORE_CHIPCOMMON:
+		case BCMA_CORE_80211:
+		case BCMA_CORE_SHIM:
+			if (bus->wrapperless)
+				break;
+			fallthrough;
 		default:
 			bcma_erom_skip_component(bus, eromptr);
 			return -ENXIO;
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 7ab2b21e7238..5dcf877e2872 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -365,6 +365,8 @@ struct bcma_bus {
 
 	/* Backplane registers, EROM included, are big-endian */
 	bool big_endian;
+	/* Cores have no DMP wrappers, the host ops handle agent accesses */
+	bool wrapperless;
 };
 
 static inline u32 bcma_read8(struct bcma_device *core, u16 offset)

-- 
2.56.0

