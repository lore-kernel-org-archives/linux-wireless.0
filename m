Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C363D7D8E
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 12:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525846; cv=none; b=Y7oulnpd3H8pE4QjLwaCHLB7AEwHsvy4EXcgK+WxFAmUmj7QwXCzhSJm8ae3Kp4PGPY5WVKjQpyLMkJ9A7ctgNShwEdOXG7dhgo4j2Y4ApPsh/y2DRBcga/Tc4xTFxX6oNfiWUvd5OpDgPkxsPXEkwsLgVxVqKxJCee9El1yJHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525846; c=relaxed/simple;
	bh=Zi6AYOEPAerUdjoB0HPNJdrfY/vHHScNjF8xHYWT3T4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b5fhkG9hgWMF4FLVxCPoc2XFMkOFO5kfqDeGCwIlt1wp0D25Igrs8FGQzzyvB9ibjBlMEf7iNSMoSaeGsRT/xCu2f0eDkplHhDSBOpyHwJGhf4aHHEyqmuAueSyfP1L8PbfV3OQ9p3mVruzUeIJtAGoUozadscnEcDiDDvL+iI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pjqkyjaw; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pjqkyjaw"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6b1c75f0049so731455eaf.3
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 05:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788525841; x=1789130641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iek4ilrA4WDaNiJdLGkcpv/Z3+yEfAJWNYjwBxmV0G0=;
        b=PjqkyjawBDhwuki0f2Pwl4gqG6wq9B5vAf0Bq7Rby6Av/q61WZvB12xNNJZvV+2kk4
         IUu2RfG1t/kpUMvgYVaGEuiWQOepfCXxSI+mDul9KyQSrRepM/zl47y2Q0xML5azjtiG
         e07S92ssULp9VhLa5LwrhnrAj9O0Y1Y+fjcCSgOn2jsT6RnRlYJ+gaV1QxgIFE6YEdNM
         Z8+eFlWUQ1Yq4Hlk7G3JftFHmnf9KV33KDWLkhxTEsgZGYkm1CiJQPhcAQPGPpa8y+Uz
         aOuQ1WMslVDSRku+sVlwQxhAg/qcKNQaDfRlg/RWddoy6geklCt9BpAEbYnWDQSRPYf7
         8+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788525841; x=1789130641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iek4ilrA4WDaNiJdLGkcpv/Z3+yEfAJWNYjwBxmV0G0=;
        b=CB79HmWPYPS/YECQrsGkYTZSWeE7Nro5rtREfelpkWBro0EVzNAast5McKOgn8HBZ2
         AKOEPKR2h1YqYbMts7h0YCErW9g/I6A6+h6Grd76FA5Bp20/PHbz/hvX8PG0K0WtIMZD
         6NLCUhYM/EgnwwesFVMKh0IdGZkyil9A13yZ4o4xapjIExepHRNdHWx7vwagfMBe0l2h
         R7PaKeqFQh3JihEXiU+ycORh568ZKhfZzq9+Fu/lOKBSjNDC+osQNIhhmPF2jQ3HYp1T
         dyn2V0mk/pP4rnYakqqp3mLJnGzi2KNfIdzvE4a0/u5iy3jXiWF0jpz8zWbtlJWKDT74
         FXyQ==
X-Forwarded-Encrypted: i=1; AKwUvBz5BUWU3hnJsQlEWeWZScdYQMrtPOX9mqVIoHzv+S40GmpQoWsJvGCMihGk0RjpEQRyxW/HBQDM+pb/xu3xOw==@vger.kernel.org
X-Gm-Message-State: AFuF++kwzU1jns/CVozAh+HDK1Wuw+Fq7hveR/qbScTK+vvbMPEWPZD/
	FRjnTNS2SIWs9nFVuZ7SDm3mkbJlXYjz21ZHxKg1y6Merz+C6iJcofc7Im8z+4W90+c=
X-Gm-Gg: AYBFou0T4sR63vPXw+1AP1HKR9p0BsYmtgfoTleIK8gmbx7hfFCZiuXJlACXElqyYhu
	VQhe7x6XNcFTXa1tOMQDlzGXnu1hPSwG18UzfrW37VFVD2Y7/sXEsfmix3WtZHNhv4gfX5Vcpwq
	jo4PqxdBDRw9eSWrOvECh5vKEudV8ukNTaOt0u6A3R0qeS3XSIvDSffBjPHEGLroCtBQW9GTVft
	Yja+01Ix6LXmPjlKoQTW0tajy5XByHjGrXt4pcR9Nq1N9ks4oYJkX7FkIqdb3QNw0Z9+wfzpM1w
	uMqFzwtHENXkqKdoGiZUKFMj0V5e/XlauTc/FfBdLZZU5Qg7U/H+FgQ6xsCWUKkDY6+wVkJe39z
	LfW6Ln6S9j6iKzGDYayIUygTTfTq7wyqrgE7LnxUSevyKh/3c6zyXZDwH1nt94UMxK98C9oHUsV
	zPEVElChwX/kOA2Tgdm53eRxvdND59ua0GlpFcEKTFchXH5RZ+kaVYiX6KKi5wy6bHhWrSOQXiR
	sfr1gi00GPUB0Q=
X-Received: by 2002:a05:6820:2912:b0:6b7:46fc:1cd with SMTP id 006d021491bc7-6b746fc03a5mr2515016eaf.44.1788525841095;
        Fri, 04 Sep 2026 05:44:01 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339ac24d7esm9927817eec.15.2026.09.04.05.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:44:00 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Michael Buesch <m@bues.ch>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	libertas-dev@lists.infradead.org
Subject: [PATCH] wifi: fix typos in comments
Date: Fri,  4 Sep 2026 18:13:35 +0530
Message-ID: <20260904124353.6183-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/net/wireless/ath/ar5523/ar5523_hw.h               | 2 +-
 drivers/net/wireless/ath/ath.h                            | 2 +-
 drivers/net/wireless/ath/ath5k/dma.c                      | 2 +-
 drivers/net/wireless/ath/ath5k/pcu.c                      | 2 +-
 drivers/net/wireless/ath/carl9170/fwcmd.h                 | 2 +-
 drivers/net/wireless/ath/carl9170/main.c                  | 8 ++++----
 drivers/net/wireless/broadcom/b43/b43.h                   | 8 ++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c   | 2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h   | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c    | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 4 ++--
 drivers/net/wireless/intel/ipw2x00/ipw2100.c              | 4 ++--
 drivers/net/wireless/intel/ipw2x00/ipw2100.h              | 4 ++--
 drivers/net/wireless/intel/ipw2x00/ipw2200.c              | 4 ++--
 drivers/net/wireless/intel/iwlegacy/3945-mac.c            | 2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c            | 2 +-
 drivers/net/wireless/intersil/p54/p54pci.c                | 2 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c         | 2 +-
 drivers/net/wireless/marvell/mwl8k.c                      | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c            | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c            | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c            | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c            | 4 ++--
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c           | 4 ++--
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c            | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00config.c         | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c            | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c              | 4 ++--
 drivers/net/wireless/ralink/rt2x00/rt61pci.h              | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c              | 4 ++--
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c        | 8 ++++----
 drivers/net/wireless/st/cw1200/cw1200_sdio.c              | 2 +-
 drivers/net/wireless/st/cw1200/wsm.h                      | 4 ++--
 drivers/net/wireless/ti/wl1251/acx.h                      | 2 +-
 drivers/net/wireless/ti/wl1251/init.h                     | 2 +-
 drivers/net/wireless/ti/wl1251/reg.h                      | 2 +-
 drivers/net/wireless/ti/wl12xx/reg.h                      | 2 +-
 drivers/net/wireless/ti/wl18xx/main.c                     | 2 +-
 drivers/net/wireless/ti/wlcore/init.c                     | 2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_chip.h             | 2 +-
 include/linux/ssb/ssb_regs.h                              | 2 +-
 42 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523_hw.h b/drivers/net/wireless/ath/ar5523/ar5523_hw.h
index 0fe2c803f48f..53723eb4f5d9 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523_hw.h
+++ b/drivers/net/wireless/ath/ar5523/ar5523_hw.h
@@ -101,7 +101,7 @@ struct ar5523_cmd_hdr {
 #define	WDCMSG_SET_DEFAULT_KEY		0x43
 
 	__u32		priv;	/* driver private data,
-				   don't care about endianess */
+				   don't care about endianness */
 	__be32		magic;
 	__be32		reserved2[4];
 };
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 34654f710d8a..4a66eaba0ad4 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -246,7 +246,7 @@ void ath_printk(const char *level, const struct ath_common *common,
  * @ATH_DBG_FATAL: fatal errors, this is the default, DBG_DEFAULT
  * @ATH_DBG_PS: power save processing
  * @ATH_DBG_HWTIMER: hardware timer handling
- * @ATH_DBG_BTCOEX: bluetooth coexistance
+ * @ATH_DBG_BTCOEX: bluetooth coexistence
  * @ATH_DBG_BSTUCK: stuck beacons
  * @ATH_DBG_MCI: Message Coexistence Interface, a private protocol
  *	used exclusively for WLAN-BT coexistence starting from
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index d9e376eb040e..338ef24f0717 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -548,7 +548,7 @@ ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 		 */
 		*interrupt_mask = (isr & AR5K_INT_COMMON) & ah->ah_imr;
 
-		/* Hanlde INT_FATAL */
+		/* Handle INT_FATAL */
 		if (unlikely(isr & (AR5K_ISR_SSERR | AR5K_ISR_MCABT
 						| AR5K_ISR_DPERR)))
 			*interrupt_mask |= AR5K_INT_FATAL;
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 90e0859a8e50..031913920ea8 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -459,7 +459,7 @@ ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 /**
  * ath5k_hw_set_mcast_filter() - Set multicast filter
  * @ah: The &struct ath5k_hw
- * @filter0: Lower 32bits of muticast filter
+ * @filter0: Lower 32bits of multicast filter
  * @filter1: Higher 16bits of multicast filter
  */
 void
diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index e5bcc364f088..40554e4bd149 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -69,7 +69,7 @@ enum carl9170_cmd_oids {
 	CARL9170_CMD_FREQ_START		= 0x23,
 	CARL9170_CMD_PSM		= 0x24,
 
-	/* Asychronous command flag */
+	/* Asynchronous command flag */
 	CARL9170_CMD_ASYNC_FLAG		= 0x40,
 	CARL9170_CMD_WREG_ASYNC		= (CARL9170_CMD_WREG |
 					   CARL9170_CMD_ASYNC_FLAG),
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 61c7a1288743..21d8798dedb5 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -575,7 +575,7 @@ static int carl9170_init_interface(struct ar9170 *ar,
 	 * NOTE: If the previous main interface has already
 	 * disabled hw crypto offload, we have to keep this
 	 * previous disable_offload setting as it was.
-	 * Altough ideally, we should notify mac80211 and tell
+	 * Although ideally, we should notify mac80211 and tell
 	 * it to forget about any HW crypto offload for now.
 	 */
 	ar->disable_offload |= ((vif->type != NL80211_IFTYPE_STATION) &&
@@ -677,12 +677,12 @@ static int carl9170_op_add_interface(struct ieee80211_hw *hw,
 	if (old_main) {
 		/* We end up in here, if the main interface is being replaced.
 		 * Put the new main interface at the HEAD of the list and the
-		 * previous inteface will automatically become second in line.
+		 * previous interface will automatically become second in line.
 		 */
 		list_add_rcu(&vif_priv->list, &ar->vif_list);
 	} else {
-		/* Add new inteface. If the list is empty, it will become the
-		 * main inteface, otherwise it will be slave.
+		/* Add new interface. If the list is empty, it will become the
+		 * main interface, otherwise it will be slave.
 		 */
 		list_add_tail_rcu(&vif_priv->list, &ar->vif_list);
 	}
diff --git a/drivers/net/wireless/broadcom/b43/b43.h b/drivers/net/wireless/broadcom/b43/b43.h
index c0d8fc0b22fb..ce09d397af7a 100644
--- a/drivers/net/wireless/broadcom/b43/b43.h
+++ b/drivers/net/wireless/broadcom/b43/b43.h
@@ -167,7 +167,7 @@
 #define B43_MMIO_WEPCTL			0x7C0
 
 /* SPROM boardflags_lo values */
-#define B43_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistance */
+#define B43_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistence */
 #define B43_BFL_PACTRL			0x0002	/* GPIO 9 controlling the PA */
 #define B43_BFL_AIRLINEMODE		0x0004	/* implements GPIO 13 radio disable indication */
 #define B43_BFL_RSSI			0x0008	/* software calculates nrssi slope. */
@@ -359,7 +359,7 @@ enum {
 #define B43_HF_SYMW		0x000000000002ULL /* G-PHY SYM workaround */
 #define B43_HF_RXPULLW		0x000000000004ULL /* RX pullup workaround */
 #define B43_HF_CCKBOOST		0x000000000008ULL /* 4dB CCK power boost (exclusive with OFDM boost) */
-#define B43_HF_BTCOEX		0x000000000010ULL /* Bluetooth coexistance */
+#define B43_HF_BTCOEX		0x000000000010ULL /* Bluetooth coexistence */
 #define B43_HF_GDCW		0x000000000020ULL /* G-PHY DC canceller filter bw workaround */
 #define B43_HF_OFDMPABOOST	0x000000000040ULL /* Enable PA gain boost for OFDM */
 #define B43_HF_ACPR		0x000000000080ULL /* Disable for Japan, channel 14 */
@@ -372,14 +372,14 @@ enum {
 #define B43_HF_RADARW		0x000000002000ULL /* Radar workaround */
 #define B43_HF_USEDEFKEYS	0x000000004000ULL /* Enable use of default keys */
 #define B43_HF_AFTERBURNER	0x000000008000ULL /* Afterburner enabled */
-#define B43_HF_BT4PRIOCOEX	0x000000010000ULL /* Bluetooth 4-priority coexistance */
+#define B43_HF_BT4PRIOCOEX	0x000000010000ULL /* Bluetooth 4-priority coexistence */
 #define B43_HF_FWKUP		0x000000020000ULL /* Fast wake-up ucode */
 #define B43_HF_VCORECALC	0x000000040000ULL /* Force VCO recalculation when powering up synthpu */
 #define B43_HF_PCISCW		0x000000080000ULL /* PCI slow clock workaround */
 #define B43_HF_4318TSSI		0x000000200000ULL /* 4318 TSSI */
 #define B43_HF_FBCMCFIFO	0x000000400000ULL /* Flush bcast/mcast FIFO immediately */
 #define B43_HF_HWPCTL		0x000000800000ULL /* Enable hardwarre power control */
-#define B43_HF_BTCOEXALT	0x000001000000ULL /* Bluetooth coexistance in alternate pins */
+#define B43_HF_BTCOEXALT	0x000001000000ULL /* Bluetooth coexistence in alternate pins */
 #define B43_HF_TXBTCHECK	0x000002000000ULL /* Bluetooth check during transmission */
 #define B43_HF_SKCFPUP		0x000004000000ULL /* Skip CFP update */
 #define B43_HF_N40W		0x000008000000ULL /* N PHY 40 MHz workaround (rev >= 13 only) */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 1817adc29cd8..b19d8559e26a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -82,7 +82,7 @@ struct brcmf_proto_bcdc_header {
 #define BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES	12
 
 #define RETRIES 2 /* # of retries to retrieve matching dcmd response */
-#define BUS_HEADER_LEN	(16+64)		/* Must be atleast SDPCM_RESERVE
+#define BUS_HEADER_LEN	(16+64)		/* Must be at least SDPCM_RESERVE
 					 * (amount of header tha might be added)
 					 * plus any space that might be needed
 					 * for bus alignment padding.
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 63e534523f51..003878e002b5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -149,7 +149,7 @@ enum brcmf_profile_fwauth {
  * @BRCMF_MGMT_TX_ACK: mgmt frame acked
  * @BRCMF_MGMT_TX_NOACK: mgmt frame not acked
  * @BRCMF_MGMT_TX_OFF_CHAN_COMPLETED: off-channel complete
- * @BRCMF_MGMT_TX_SEND_FRAME: mgmt frame tx is in progres
+ * @BRCMF_MGMT_TX_SEND_FRAME: mgmt frame tx is in progress
  */
 enum brcmf_mgmt_tx_status {
 	BRCMF_MGMT_TX_ACK,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 4adc0d0e4251..0675b2ddeb9f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1109,7 +1109,7 @@ static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
 	cc = list_first_entry(&chip->cores, struct brcmf_core_priv, list);
 	base = cc->pub.base;
 
-	/* get chipcommon capabilites */
+	/* get chipcommon capabilities */
 	pub->cc_caps = chip->ops->read32(chip->ctx,
 					 CORE_CC_REG(base, capabilities));
 	pub->cc_caps_ext = chip->ops->read32(chip->ctx,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 813cc15d8b87..56e5f188a9a6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -699,7 +699,7 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 	switch (search_state) {
 	case WL_P2P_DISC_ST_SEARCH:
 		/*
-		 * If we in SEARCH STATE, we don't need to set SSID explictly
+		 * If we in SEARCH STATE, we don't need to set SSID explicitly
 		 * because dongle use P2P WILDCARD internally by default, use
 		 * null ssid, which it is already due to kzalloc.
 		 */
@@ -1360,7 +1360,7 @@ brcmf_p2p_stop_wait_next_action_frame(struct brcmf_cfg80211_info *cfg)
  * @p2p: p2p device info struct.
  * @mac: MAC address.
  *
- * return true if recevied action frame is to be dropped.
+ * return true if received action frame is to be dropped.
  */
 static bool
 brcmf_p2p_gon_req_collision(struct brcmf_p2p_info *p2p, u8 *mac)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 55f4d7b970f2..bed3b56d8982 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -118,7 +118,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 
 #define BRCMF_PCIE_REG_MAP_SIZE			(32 * 1024)
 
-/* backplane addres space accessed by BAR0 */
+/* backplane address space accessed by BAR0 */
 #define	BRCMF_PCIE_BAR0_WINDOW			0x80
 #define BRCMF_PCIE_BAR0_REG_SIZE		0x1000
 #define	BRCMF_PCIE_BAR0_WRAPPERBASE		0x70
@@ -2174,7 +2174,7 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 
 	/* Some of the firmwares have the size of the memory of the device
 	 * defined inside the firmware. This is because part of the memory in
-	 * the device is shared and the devision is determined by FW. Parse
+	 * the device is shared and the division is determined by FW. Parse
 	 * the firmware and adjust the chip memory size now.
 	 */
 	brcmf_pcie_adjust_ramsize(devinfo, (u8 *)fw->data, fw->size);
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 2b8a23865bfb..31cee76d7aeb 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5328,7 +5328,7 @@ struct ipw2100_wep_key {
 	u8 key[13];
 };
 
-/* Macros to ease up priting WEP keys */
+/* Macros to ease up printing WEP keys */
 #define WEP_FMT_64  "%02X%02X%02X%02X-%02X"
 #define WEP_FMT_128 "%02X%02X%02X%02X-%02X%02X%02X%02X-%02X%02X%02X"
 #define WEP_STR_64(x) x[0],x[1],x[2],x[3],x[4]
@@ -8090,7 +8090,7 @@ static struct iw_statistics *ipw2100_wx_wireless_stats(struct net_device *dev)
 	/* if hw is disabled, then ipw2100_get_ordinal() can't be called.
 	 * ipw2100_wx_wireless_stats seems to be called before fw is
 	 * initialized.  STATUS_ASSOCIATED will only be set if the hw is up
-	 * and associated; if not associcated, the values are all meaningless
+	 * and associated; if not associated, the values are all meaningless
 	 * anyway, so set them all to NULL and INVALID */
 	if (!(priv->status & STATUS_ASSOCIATED)) {
 		wstats->miss.beacon = 0;
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.h b/drivers/net/wireless/intel/ipw2x00/ipw2100.h
index 6f81f509b9cb..a6d944b1f958 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.h
@@ -982,7 +982,7 @@ typedef enum _ORDINAL_TABLE_1 {	// NS - means Not Supported by FW
 	IPW_ORD_STAT_PSP_SUSPENSION = 137,	// # of times adapter suspended
 	IPW_ORD_STAT_PSP_BCN_TIMEOUT,	// # of beacon timeout
 	IPW_ORD_STAT_PSP_POLL_TIMEOUT,	// # of poll response timeouts
-	IPW_ORD_STAT_PSP_NONDIR_TIMEOUT,	// # of timeouts waiting for last broadcast/muticast pkt
+	IPW_ORD_STAT_PSP_NONDIR_TIMEOUT,	// # of timeouts waiting for last broadcast/multicast pkt
 	IPW_ORD_STAT_PSP_RX_DTIMS,	// # of PSP DTIMs received
 	IPW_ORD_STAT_PSP_RX_TIMS,	// # of PSP TIMs received
 	IPW_ORD_STAT_PSP_STATION_ID,	// PSP Station ID
@@ -1023,7 +1023,7 @@ typedef enum _ORDINAL_TABLE_1 {	// NS - means Not Supported by FW
 // Other statistics
 	IPW_ORD_RSSI_AVG_CURR = 173,	// Current avg RSSI
 	IPW_ORD_STEST_RESULTS_CURR,	//NS // Current self test results word
-	IPW_ORD_STEST_RESULTS_CUM,	//NS // Cummulative self test results word
+	IPW_ORD_STEST_RESULTS_CUM,	//NS // Cumulative self test results word
 	IPW_ORD_SELF_TEST_STATUS,	//NS //
 	IPW_ORD_POWER_MGMT_MODE,	// Power mode - 0=CAM, 1=PSP
 	IPW_ORD_POWER_MGMT_INDEX,	//NS //
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 4bc9bb406e8e..412d80819bf0 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -747,7 +747,7 @@ static int ipw_get_ordinal(struct ipw_priv *priv, u32 ord, void *val, u32 * len)
 		 *
 		 * This table consist of six values, each containing
 		 *     - dword containing the starting offset of the data
-		 *     - dword containing the lengh in the first 16bits
+		 *     - dword containing the length in the first 16bits
 		 *       and the count in the second 16bits
 		 */
 
@@ -9967,7 +9967,7 @@ static struct iw_statistics *ipw_get_wireless_stats(struct net_device *dev)
 	/* if hw is disabled, then ipw_get_ordinal() can't be called.
 	 * netdev->get_wireless_stats seems to be called before fw is
 	 * initialized.  STATUS_ASSOCIATED will only be set if the hw is up
-	 * and associated; if not associcated, the values are all meaningless
+	 * and associated; if not associated, the values are all meaningless
 	 * anyway, so set them all to NULL and INVALID */
 	if (!(priv->status & STATUS_ASSOCIATED)) {
 		wstats->miss.beacon = 0;
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index cbaf250626c5..30c4e1154c1b 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -2559,7 +2559,7 @@ il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	}
 
 	/*
-	 * If active scaning is requested but a certain channel is marked
+	 * If active scanning is requested but a certain channel is marked
 	 * passive, we can do active scanning if we detect transmissions. For
 	 * passive only scanning disable switching to active on any channel.
 	 */
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 18bb55682643..458956744e82 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -3360,7 +3360,7 @@ il4965_set_tkip_dynamic_key_info(struct il_priv *il,
 
 	il->stations[sta_id].sta.key.key_flags = key_flags;
 
-	/* This copy is acutally not needed: we get the key with each TX */
+	/* This copy is actually not needed: we get the key with each TX */
 	memcpy(il->stations[sta_id].keyinfo.key, keyconf->key, 16);
 
 	memcpy(il->stations[sta_id].sta.key.key, keyconf->key, 16);
diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wireless/intersil/p54/p54pci.c
index 6588f5477762..68e929fa213c 100644
--- a/drivers/net/wireless/intersil/p54/p54pci.c
+++ b/drivers/net/wireless/intersil/p54/p54pci.c
@@ -534,7 +534,7 @@ static void p54p_firmware_step2(const struct firmware *fw,
 		/*
 		 * This will indirectly result in a call to p54p_remove.
 		 * Hence, we don't need to bother with freeing any
-		 * allocated ressources at all.
+		 * allocated resources at all.
 		 */
 		device_release_driver(&pdev->dev);
 
diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index b85c6d783bf7..0017738d8687 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -314,7 +314,7 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 		lbtf_deb_usb2(&cardp->udev->dev, "Downloading FW JUMP BLOCK\n");
 
 		/* Host has finished FW downloading
-		 * Donwloading FW JUMP BLOCK
+		 * Downloading FW JUMP BLOCK
 		 */
 		cardp->fwfinalblk = 1;
 	}
diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index b1af02180341..b5c9e7f8c296 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -2040,7 +2040,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 		} else {
 			/* Defer calling mwl8k_start_stream so that the current
 			 * skb can go out before the ADDBA request.  This
-			 * prevents sequence number mismatch at the recepient
+			 * prevents sequence number mismatch at the recipient
 			 * as described above.
 			 */
 			if (mwl8k_ampdu_allowed(sta, tid)) {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index b846fe589c2b..db282f70f83e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -395,7 +395,7 @@ static void rt2400pci_config_ant(struct rt2x00_dev *rt2x00dev,
 
 	/*
 	 * We should never come here because rt2x00lib is supposed
-	 * to catch this and send us the correct antenna explicitely.
+	 * to catch this and send us the correct antenna explicitly.
 	 */
 	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
 	       ant->tx == ANTENNA_SW_DIVERSITY);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index be9df35acc33..c34d03c8487e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -402,7 +402,7 @@ static void rt2500pci_config_ant(struct rt2x00_dev *rt2x00dev,
 
 	/*
 	 * We should never come here because rt2x00lib is supposed
-	 * to catch this and send us the correct antenna explicitely.
+	 * to catch this and send us the correct antenna explicitly.
 	 */
 	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
 	       ant->tx == ANTENNA_SW_DIVERSITY);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index 58728df6666c..38ca366642b5 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -507,7 +507,7 @@ static void rt2500usb_config_ant(struct rt2x00_dev *rt2x00dev,
 
 	/*
 	 * We should never come here because rt2x00lib is supposed
-	 * to catch this and send us the correct antenna explicitely.
+	 * to catch this and send us the correct antenna explicitly.
 	 */
 	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
 	       ant->tx == ANTENNA_SW_DIVERSITY);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 2e2e382b6247..9c1f7dd22aa6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4095,7 +4095,7 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 		cal = 0;
 	rt2800_bbp_write(rt2x00dev, 159, cal);
 
-	/* FIXME: possible RX0, RX1 callibration ? */
+	/* FIXME: possible RX0, RX1 calibration ? */
 
 	/* RF IQ compensation control */
 	rt2800_bbp_write(rt2x00dev, 158, 0x04);
@@ -11275,7 +11275,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Determine external LNA informations.
+	 * Determine external LNA information.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_LNA_5G))
 		__set_bit(CAPABILITY_EXTERNAL_LNA_A, &rt2x00dev->cap_flags);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index 45775ecdf221..61ebe470c32c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -160,7 +160,7 @@ void rt2800mmio_fill_rxdone(struct queue_entry *entry,
 		} else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {
 			/*
 			 * In order to check the Michael Mic, the packet must have
-			 * been decrypted.  Mac80211 doesnt check the MMIC failure 
+			 * been decrypted.  Mac80211 doesn't check the MMIC failure 
 			 * flag to initiate MMIC countermeasures if the decoded flag
 			 * has not been set.
 			 */
@@ -294,7 +294,7 @@ static void rt2800mmio_fetch_txstatus(struct rt2x00_dev *rt2x00dev)
 	 * interrupt fires again during tx status processing).
 	 *
 	 * We also read statuses from tx status timeout timer, use
-	 * lock to prevent concurent writes to fifo.
+	 * lock to prevent concurrent writes to fifo.
 	 */
 
 	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 15de3db12429..c6f6d0083d1e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -549,7 +549,7 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 		} else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {
 			/*
 			 * In order to check the Michael Mic, the packet must have
-			 * been decrypted.  Mac80211 doesnt check the MMIC failure
+			 * been decrypted.  Mac80211 doesn't check the MMIC failure
 			 * flag to initiate MMIC countermeasures if the decoded flag
 			 * has not been set.
 			 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c b/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
index f895f560a185..ce1c76ac3383 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
@@ -113,7 +113,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * we must update the ANTENNA_RX_DIVERSITY flag to
 	 * enable the antenna diversity in the link tuner.
 	 *
-	 * Secondly, we must guarentee we never send the
+	 * Secondly, we must guarantee we never send the
 	 * software antenna diversity command to the driver.
 	 */
 	if (!(ant->flags & ANTENNA_RX_DIVERSITY)) {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 4d94b7062f44..2f406bfd830c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -840,7 +840,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 
 	/* Ensure that all fields of rx_status are initialized
 	 * properly. The skb->cb array was used for driver
-	 * specific informations, so rx_status might contain
+	 * specific information, so rx_status might contain
 	 * garbage.
 	 */
 	memset(rx_status, 0, sizeof(*rx_status));
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index d4783658b2c5..93cb728878d9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -710,7 +710,7 @@ static void rt61pci_config_ant(struct rt2x00_dev *rt2x00dev,
 
 	/*
 	 * We should never come here because rt2x00lib is supposed
-	 * to catch this and send us the correct antenna explicitely.
+	 * to catch this and send us the correct antenna explicitly.
 	 */
 	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
 	       ant->tx == ANTENNA_SW_DIVERSITY);
@@ -2467,7 +2467,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
 
 	/*
-	 * Read external LNA informations.
+	 * Read external LNA information.
 	 */
 	eeprom = rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.h b/drivers/net/wireless/ralink/rt2x00/rt61pci.h
index d72d0ffd1127..35c8627ccd52 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.h
@@ -893,7 +893,7 @@ struct hw_pairwise_ta_entry {
 #define TX_CNTL_CSR_ABORT_TX_MGMT	FIELD32(0x00100000)
 
 /*
- * LOAD_TX_RING_CSR: Load RX desriptor
+ * LOAD_TX_RING_CSR: Load RX descriptor
  */
 #define LOAD_TX_RING_CSR		0x3434
 #define LOAD_TX_RING_CSR_LOAD_TXD_AC0	FIELD32(0x00000001)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
index d6b7174d087a..c97ab451b1e5 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -691,7 +691,7 @@ static void rt73usb_config_ant(struct rt2x00_dev *rt2x00dev,
 
 	/*
 	 * We should never come here because rt2x00lib is supposed
-	 * to catch this and send us the correct antenna explicitely.
+	 * to catch this and send us the correct antenna explicitly.
 	 */
 	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
 	       ant->tx == ANTENNA_SW_DIVERSITY);
@@ -1900,7 +1900,7 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
 
 	/*
-	 * Read external LNA informations.
+	 * Read external LNA information.
 	 */
 	eeprom = rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC);
 
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index 4a5989172a5e..f8c6afc02d08 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -568,7 +568,7 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	 */
 	wmb();
 	entry->flags = cpu_to_le32(tx_flags);
-	/* We must be sure this has been written before followings HW
+	/* We must be sure this has been written before following HW
 	 * register write, because this write will made the HW attempts
 	 * to DMA the just-written data
 	 */
@@ -931,7 +931,7 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		rtl818x_iowrite16(priv, ARFR, 0xFFF);
 		rtl818x_ioread16(priv, ARFR);
 
-		/* stop unused queus (no dma alloc) */
+		/* stop unused queues (no dma alloc) */
 		rtl818x_iowrite8(priv, &priv->map->TPPOLL_STOP,
 			       RTL818x_TPPOLL_STOP_MG | RTL818x_TPPOLL_STOP_HI);
 
@@ -973,7 +973,7 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		reg32 |= 0xb8000054;
 		rtl818x_iowrite32(priv, &priv->map->RF_PARA, reg32);
 	} else
-		/* stop unused queus (no dma alloc) */
+		/* stop unused queues (no dma alloc) */
 		rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING,
 			    (1<<1) | (1<<2));
 
@@ -1151,7 +1151,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	rtl8180_int_enable(dev);
 
 	/* in rtl8187se at MAR regs offset there is the management
-	 * TX descriptor DMA addres..
+	 * TX descriptor DMA address..
 	 */
 	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8187SE) {
 		rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
diff --git a/drivers/net/wireless/st/cw1200/cw1200_sdio.c b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
index 2b6afe221268..da5e545400f6 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
@@ -55,7 +55,7 @@ static const struct sdio_device_id cw1200_sdio_ids[] = {
 };
 MODULE_DEVICE_TABLE(sdio, cw1200_sdio_ids);
 
-/* hwbus_ops implemetation */
+/* hwbus_ops implementation */
 
 static int cw1200_sdio_memcpy_fromio(struct hwbus_priv *self,
 				     unsigned int addr,
diff --git a/drivers/net/wireless/st/cw1200/wsm.h b/drivers/net/wireless/st/cw1200/wsm.h
index 89fdc9115e9d..ad1c0140ab57 100644
--- a/drivers/net/wireless/st/cw1200/wsm.h
+++ b/drivers/net/wireless/st/cw1200/wsm.h
@@ -878,7 +878,7 @@ struct cw1200_wsm_event {
 };
 
 /* 3.18 - 3.22 */
-/* Measurement. Skipped for now. Irrelevent. */
+/* Measurement. Skipped for now. Irrelevant. */
 
 typedef void (*wsm_event_cb) (struct cw1200_common *priv,
 			      struct wsm_event *arg);
@@ -1151,7 +1151,7 @@ int wsm_set_uapsd_param(struct cw1200_common *priv,
 			const struct wsm_edca_params *arg);
 
 /* 3.38 */
-/* Set-System info. Skipped for now. Irrelevent. */
+/* Set-System info. Skipped for now. Irrelevant. */
 
 /* 3.40 */
 #define WSM_SWITCH_CHANNEL_REQ_ID 0x0016
diff --git a/drivers/net/wireless/ti/wl1251/acx.h b/drivers/net/wireless/ti/wl1251/acx.h
index efe1f61f89bc..cefcd8e12782 100644
--- a/drivers/net/wireless/ti/wl1251/acx.h
+++ b/drivers/net/wireless/ti/wl1251/acx.h
@@ -592,7 +592,7 @@ struct acx_bt_wlan_coex_param {
 	/* range 400-10000(Usec) default: 3000 */
 	u16 next_bt_lp_packet;
 
-	/* Deafult: worst case for BT DH5 traffic */
+	/* Default: worst case for BT DH5 traffic */
 	u16 wake_up_beacon;
 
 	/* range: 0-50000(Usec) default: 1050 */
diff --git a/drivers/net/wireless/ti/wl1251/init.h b/drivers/net/wireless/ti/wl1251/init.h
index d56e5d2e52aa..cc757d17a56a 100644
--- a/drivers/net/wireless/ti/wl1251/init.h
+++ b/drivers/net/wireless/ti/wl1251/init.h
@@ -29,7 +29,7 @@ enum {
 	NUM_ACCESS_CATEGORIES = 4
 };
 
-/* following are defult values for the IE fields*/
+/* following are default values for the IE fields*/
 #define CWMIN_BK  15
 #define CWMIN_BE  15
 #define CWMIN_VI  7
diff --git a/drivers/net/wireless/ti/wl1251/reg.h b/drivers/net/wireless/ti/wl1251/reg.h
index bfe35754f33a..72f25c5edfc1 100644
--- a/drivers/net/wireless/ti/wl1251/reg.h
+++ b/drivers/net/wireless/ti/wl1251/reg.h
@@ -174,7 +174,7 @@ enum wl12xx_acx_int_reg {
  register to clear (acknowledge) the corresp.
  interrupt status bits in the HINT_STS_CLR and
  HINT_STS_ND registers, thus making the
- assotiated interrupt inactive. (0-no effect)
+ associated interrupt inactive. (0-no effect)
 ==============================================*/
 	ACX_REG_INTERRUPT_ACK,
 
diff --git a/drivers/net/wireless/ti/wl12xx/reg.h b/drivers/net/wireless/ti/wl12xx/reg.h
index 601305a26141..f3970c49f122 100644
--- a/drivers/net/wireless/ti/wl12xx/reg.h
+++ b/drivers/net/wireless/ti/wl12xx/reg.h
@@ -124,7 +124,7 @@
  register to clear (acknowledge) the corresp.
  interrupt status bits in the HINT_STS_CLR and
  HINT_STS_ND registers, thus making the
- assotiated interrupt inactive. (0-no effect)
+ associated interrupt inactive. (0-no effect)
 ==============================================*/
 #define WL12XX_REG_INTERRUPT_ACK          (REGISTERS_BASE + 0x04F0)
 
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index d087d9c72f91..efb03f26de5a 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -38,7 +38,7 @@ static char *board_type_param = NULL;
 static bool checksum_param = false;
 static int num_rx_desc_param = -1;
 
-/* phy paramters */
+/* phy parameters */
 static int dc2dc_param = -1;
 static int n_antennas_2_param = -1;
 static int n_antennas_5_param = -1;
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index aa59ddd520f9..a8c21db3a73b 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -498,7 +498,7 @@ static int wl1271_set_ba_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	return wl12xx_acx_set_ba_initiator_policy(wl, wlvif);
 }
 
-/* vif-specifc initialization */
+/* vif-specific initialization */
 static int wl12xx_init_sta_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_chip.h b/drivers/net/wireless/zydas/zd1211rw/zd_chip.h
index 70a1548eb48b..eeb18b546e9a 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_chip.h
@@ -671,7 +671,7 @@ enum {
 #define E2P_PWR_INT_GUARD		8
 #define E2P_CHANNEL_COUNT		14
 
-/* If you compare this addresses with the ZYDAS orignal driver, please notify
+/* If you compare this addresses with the ZYDAS original driver, please notify
  * that we use word mapping for the EEPROM.
  */
 
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 210f46494065..7ec638a9a47c 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -607,7 +607,7 @@
 #define SSB_SPROM8_BWDUPPO		0x0198
 
 /* Values for boardflags_lo read from SPROM */
-#define SSB_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistance */
+#define SSB_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistence */
 #define SSB_BFL_PACTRL			0x0002	/* GPIO 9 controlling the PA */
 #define SSB_BFL_AIRLINEMODE		0x0004	/* implements GPIO 13 radio disable indication */
 #define SSB_BFL_RSSI			0x0008	/* software calculates nrssi slope. */
-- 
2.48.1

