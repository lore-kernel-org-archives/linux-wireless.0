Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993074;
	b=atTX7pGBEWD7WYHHirwrUTCY+ixs00S3YsvYDFNKRsrRkbH3vTOq1pkH65yo/Wjc1ny3
	 iOA2CUdos5lyL4ove6p9rTXPaNH6MT6sHzlPmazAJYRUqXvu9rZ7gIeXPe2QqpNxCQsEB
	 xGGbsV8AcVO04UvDWksnxw6KiU5csBopk06UPckpxtCT1VDoH+mSvzQIF6LCGGQ0UNvDa
	 1No9pGTFd1U349G1ZDEyIurhVpFAA+9ILwmZkdyiMHIMPftykfdgfpK5nhE6R71rGYXyH
	 KNKy5YBJ8Sfa/bYMcaTxleW/A5nMjmCJ6+frgiEBxnOIlOxKd4NWaA2PrEDFYwBxDOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993074;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=ILgCWsWfIgmMiDb4TrI2KyIgydeoYhhsJJxEpH1dAE0=;
	b=oZHXKNrtLDQWi/M870N9Kn1zMqpHeuITVC88aggykT51kw3APuggGs17EHU0Kn4eNUrg
	 oZ6Jv+Su/UQuN7IkMMdm77UiD+/14uCyvopPjkjpYb0SmPP1vcdCCh1FkbsASAjCLlsY3
	 AOpzBatQDt78trAf/ilK8y5MRslykvfyye5JWD3gPrTQJ/zzhZVPpypwmzs2yFZR/8MC2
	 KGRREf/fb1AzlRAKwgMiKQTLXarVNUteY0PlFd7Y2Qbm/3SAyqGiXNNZwWPEloFxrauwv
	 utefwsGsIzjm7dna9tV6gKw/6YKCFHdYcOKwJMMgrtcHY99IerXYVrHIWf7fCHESyxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gDYewnBI;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187EE60A6F70
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 187EE60A6F70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gDYewnBI
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a070755c8cso1083974b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993073; x=1793597873; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ILgCWsWfIgmMiDb4TrI2KyIgydeoYhhsJJxEpH1dAE0=;
        b=gDYewnBIn0f2uMGOzKc0pDNi6R746uxHwvMfV4wHD0/A7Krs3ExeFlGGRtT5PsiHZA
         FUCa/zl+KSVrsUA0hkN12thImSVz6RqEpA+FVoXcm46HB5UL7JM8MEpKgbNAyyvPDis3
         O2V5/5abCTx5nA23ZGqyap2S91t0PWqEODvbwqcJXKGBmsVd9Yx0wQ3cBgv4hzyKqS/O
         RrEHrCrEFdUPD0Dxoh0N9RsVkzgbDQllzYg+m6uQWQitXhR0UyXybNLxju0z95j3AU6L
         FacpuHx+/SZZk8CRI6rVRru8KIgpPKXqbd9S/rVvOE8pi695e/A6fcXijarwUmnN+WOu
         V3KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993073; x=1793597873;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ILgCWsWfIgmMiDb4TrI2KyIgydeoYhhsJJxEpH1dAE0=;
        b=zmu/vMIPstuLl+0UioXdhQVR/ak10/Ca6k9n4D3HqQ9c9cWXREomLS4mOuwojqclWe
         DjAJDqngqvXoDIfgsdKKtFqg6DFHGGW3MOKsMmdPtjb8gfp9IAc3rXWMt47whvqdfHxF
         8n2FDrooPdREKjF+qFEIKdyugfVucIsWU+7r8cdihBbFDSVXpWkGquN55jrZmL2CV4W0
         KNzM3yPYaT1R5Bp0iETzingM36zTaotaARO6Xm5E32aGJkDcMTqhYDGeWOLhZcQi70y+
         EBnsNKgYazYDLi3/upeKmPtPddlZn7K3UALD3hrKwFCx/BDpAT/xDQIBLoy1m4ccLcnG
         q06A==
X-Gm-Message-State: AFq9FYIM4n9ikOXJeKqE+/F4IOXguPWR5pbLzGws7qyewuEwKxuUdjta
	M03Vm7BtdVaN9IehnpA9VDOQ6P11/xarKnVjk0VvoPKwCiITn/fYDN/cfq81ZhiBBvJxwQ==
X-Gm-Gg: AYBFou1wYZ8mft5mLTE8yRMN8IYzIOw4PLritxXzo4V1UUJHDuqXuIp5QWwc1zcUbn7
	vtnhxTsRbmdFO4jcfLmBqe/n5+mhcgOrBPi0UjsASRbLnqR3hq3wmXDX8cVTaO4bFOWcFyG3eGv
	Zdu44BErzibtt+6lS8zseXFXSYCRFO3Pzsu/WHrhP4+5rn6ErjIwBqe4CVEBO7MF51ukFdggnLs
	pr8lriZzznCesH57ridGoMi/TOyVT03LzVJ0mk0a0TaaNSlnBaeV6W+oKCv+9pJn5cLIJWXMOqt
	0Htzkz/MgLzoBzeY1JSNK4VF0nrABVgQCBjgd/n0lS70p3H0cZ52ykFmduiuVkkJXDnRcu9pOaX
	+sl+UxPmAoVgyQgF/DS7eHCe9TK7s81t7GVMAB9QXUI7+SOzHv6sm+3rT/UtU0GMy/LBi1BKBkH
	jcNvOpS/nhPyROquQ02IFPM7idWCTaS/BDsaBEfC3KhWK0+Nn1aDal/lCkGKuiExcHg7U3uu4xK
	Lxqfn/vNoh1zNkwsVi0PbMHj/GZMNZdHxIEvQAf0LX9Pi6WJ6d5xNAsPNiawTiG/Rm/8mDcjtaB
	9M+c
X-Received: by 2002:a05:6a00:1808:b0:87d:ee98:606 with SMTP id d2e1a72fcca58-8a367f0eb74mr4354231b3a.23.1792993073630;
        Sun, 25 Oct 2026 22:37:53 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:53 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com
Subject: [RFC PATCH wireless-next 17/17] wifi: bcm4323x: add Kconfig, Makefile and MAINTAINERS entry
Date: Mon, 26 Oct 2026 13:36:23 +0800
Message-ID: <20261026053633.361454-18-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Wire up the driver so that it can be built

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 MAINTAINERS                                          |  7 +++++++
 drivers/net/wireless/broadcom/brcm80211/Kconfig      |  1 +
 drivers/net/wireless/broadcom/brcm80211/Makefile     |  1 +
 .../net/wireless/broadcom/brcm80211/bcm4323x/Kconfig | 12 ++++++++++++
 .../wireless/broadcom/brcm80211/bcm4323x/Makefile    |  6 ++++++
 5 files changed, 27 insertions(+)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/Kconfig
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 733660095..91f4eef9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5210,6 +5210,13 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/media/brcm,bcm2835-unicam.yaml
 F:	drivers/media/platform/broadcom/bcm2835-unicam*
 
+BROADCOM BCM4323X USB WIRELESS DRIVER
+M:	Ragul Balaji <ragulbaby@gmail.com>
+R:	Ho Jie Feng <hjf3108@gmail.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/broadcom/brcm80211/bcm4323x/
+
 BROADCOM BCM47XX MIPS ARCHITECTURE
 M:	Hauke Mehrtens <hauke@hauke-m.de>
 M:	Rafał Miłecki <zajec5@gmail.com>
diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
index 19d0c003f..e363ebdd5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
+++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
@@ -23,6 +23,7 @@ config BRCMSMAC_LEDS
 	  is enabled and reachable from the driver module.
 
 source "drivers/net/wireless/broadcom/brcm80211/brcmfmac/Kconfig"
+source "drivers/net/wireless/broadcom/brcm80211/bcm4323x/Kconfig"
 
 config BRCM_TRACING
 	bool "Broadcom device tracing"
diff --git a/drivers/net/wireless/broadcom/brcm80211/Makefile b/drivers/net/wireless/broadcom/brcm80211/Makefile
index 88115d072..4d0dc67e6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Makefile
+++ b/drivers/net/wireless/broadcom/brcm80211/Makefile
@@ -11,3 +11,4 @@ subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DDEBUG
 obj-$(CONFIG_BRCMUTIL)	+= brcmutil/
 obj-$(CONFIG_BRCMFMAC)	+= brcmfmac/
 obj-$(CONFIG_BRCMSMAC)	+= brcmsmac/
+obj-$(CONFIG_BCM4323X)	+= bcm4323x/
diff --git a/drivers/net/wireless/broadcom/brcm80211/bcm4323x/Kconfig b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/Kconfig
new file mode 100644
index 000000000..0015893f9
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config BCM4323X
+	tristate "Broadcom BCM4323x USB support"
+	depends on MAC80211 && USB && INPUT
+	select BRCMUTIL
+	select FW_LOADER
+	help
+	  Support for the Broadcom BCM43231 and BCM4323 USB wireless adapters
+	  used in the Netgear WNA3100 and WNDA3100v2 and the Belkin F9L1101.
+
+	  To compile this driver as a module, choose M here. The module will
+	  be called bcm4323x.
diff --git a/drivers/net/wireless/broadcom/brcm80211/bcm4323x/Makefile b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/Makefile
new file mode 100644
index 000000000..406cc8fad
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+ccflags-y += -I $(src)/../include
+
+obj-$(CONFIG_BCM4323X) += bcm4323x.o
+bcm4323x-y := bcm4323x_core.o bcm4323x_mac.o bcm4323x_tx.o bcm4323x_rx.o
+bcm4323x-$(CONFIG_MAC80211_LEDS) += bcm4323x_led.o
-- 
2.53.0

