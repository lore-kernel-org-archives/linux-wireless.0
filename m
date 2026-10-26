Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993068;
	b=SpSxiGsfQb5IJfT8Jh7JYAQmOFIBD80tkXk+prCzqZmBB2hljtC0Xwj35HGw0OLzelpH
	 EjqQpoA09wfWhpjvB99snyCfylPEFb3jsJyVKsb4+l8LXkYg5TP/pvCWQns4bUHQde2zP
	 P3rUUC5e2Pma8zcwjpOa97NxsT+6vXwav+cxDDj87d0I07pAsNzbsaHR4QUHmPMG1tfhA
	 3vobb/JKEINrVs0OjflKTgMUd9/yAuedNpUa4YWEMnzBRxSJlV0uDp9VBagmhQKY30ms/
	 uwhcLrRgsi+rKW6BtTZJwICmQogD94LE90QRwrpb8hgK1n/7wYWvUL4Pb8zOeCpPVQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1yXPL49ClVkXXl8I0Wy7ORZCiDuvKwi0VxTF33zDcME=;
	b=jMVrKGtziRClU67nHr/xYBAmgYWLltCbQuY95mGmefNlTXbnASLPKnAoYVV/5ZygEt5T
	 S8b3+wXhJ7C4XJEMwURoulmQg26BGpXeLIWFdmBk0j+cPfn8U0bLtxon8FSA2kgdLKPJQ
	 u21Y++XvsZGIbj9M0/E+WEmTGdnbmpuiDck0fnluobbmoohS89EmQ0UtcB8/DQHpa0a8b
	 l+4QS6wRSoYEJ2NRTRtKiyvz3DcaJGNqyA3WHzLs1IdnwczAUn5vI3M4LuURGmbeRpqck
	 akEJEcRBtZavwKHgcIV67/nuFDDlvEWU2OWat0izyS3/Ho3vx9YSHUiA8XaoISK61cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QdA1b9tG;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED55D60A2630
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED55D60A2630
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QdA1b9tG
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a39e5161c1so817834b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993066; x=1793597866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1yXPL49ClVkXXl8I0Wy7ORZCiDuvKwi0VxTF33zDcME=;
        b=QdA1b9tGP80wQe/5CJylX/+O7i1kAaimOIecuQjSF5R/RQw93T8s+U5NCsmfzpOWPE
         nE430zQdqS8L3Tg2nQubKUwzrCAedseA1MVaI1SsEbFABJKwtv4mQ8I5xCZe6bQmch/C
         3iCXQ7WL9eAHs5eJWh+8RnoAaYD1CYwq+bb5gYea4s9TOzZrKhL7pxJqo/WKSt2ZE9yU
         xo5iA56WjaovqfHSlWzhY7Ifa8MsidtuvHzR323ZR2i5JjdiGGDyt74tyv8MzO0HQnCo
         qFGQ5UQXx+xWICw/apPsFYXw43tv4T5MdPgoW3sjj5WwQ4NS1HBN1zzr1A2y4VTQ0poy
         Ks3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993066; x=1793597866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1yXPL49ClVkXXl8I0Wy7ORZCiDuvKwi0VxTF33zDcME=;
        b=gEIx/W6QPD0k98aKgjJbuv9C0tGI5XqRzq8nO6HSN+pv+tVILlASKzoMkHD0ImbzOi
         Ja/ygPSTylNrCARLwVCWJw793vsgZW2+odamrX5P7WKD+S4ibvOOZ47oYHUrnxjeT+Cl
         NE+a+riZ76YnqJiSmmaDyGLRDUbn9A3HlRKnvEQrWBmKyOTpSM6ZHL+QVFV4olbAs3P3
         9JjnY4akHIcWeFcwumLlSLXCkOk1f5ooFgbHCJL5Xk+zVq69Liip6CJwLrMmyDrCAZxm
         AgfgFMDT3IAIMtJB8In9zVUXqSGoCkJI2whZbHML5weZABd9/nW1FuYAqcK9bgCKv54Y
         A40g==
X-Gm-Message-State: AFq9FYIsHJiGRbhkVgkVdaiB81KeNSGXtO4uEseSlKq84ndGlmsfL90e
	3fcUPYA6ERG67Q8Vzljtdcu5U26Gr6pScPUSykfYJ2orWJ7TNTdJCFe/AMo/ehFlv9NRHQ==
X-Gm-Gg: AYBFou3bnIbcgVNi966UJfcD9y7pqys5Q70/f6PCSq041VQkQ3ylhVZTnVU8Yqm1yyn
	FkfZfKR3asuL4IzkeDMiWs57GbWeYW3fzy2gFcXWPsS0h/xpoAazmxTy7OldldMdCxBXObHGwR5
	TMryJocOfgBqRDoYre3yDg1/6BtWNkg/B3wF9kfC9t99P6UvSl+C4ixV4NBUBGTLle89mh9Z6g2
	yr2kdy1wqFxiZHS83UYZ1z6nNjdtcytm+rubXrgFqx39bpuKrciSbApT6HaoRhYr/vmjnEzm0Gd
	cenRtqoGYzySvjH6QGdLj3Q/+FmiDa0KFtNeDhsec146/sUL65sKUjdO6Q/ccoH2JuE4JeIUbvL
	g9KAJpW8D/tCqayMfIiDuf3HkSPz0Zav4Wim4q0VjXTfhasgvvgl6HXAt4vBrTR99Yn4pCxySX2
	QvtIM9NMsMZmEjFkYGII0nhTE2NO9vF+ASNDElbgvOxG+R3cvKHT+l3g65QXWE5mFdef57f8AZg
	pFOCM2UfI+G40MBgUUVyjJMs7eA5fE7IVnVnfrXXdDozNiH0PD1n1kOVmyBNJD6J8Dt5VTCy+1T
	ACEw
X-Received: by 2002:a05:6a00:a0a:b0:89e:d76c:327f with SMTP id d2e1a72fcca58-8a367a2d5c5mr4479424b3a.34.1792993066002;
        Sun, 25 Oct 2026 22:37:46 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:45 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com
Subject: [RFC PATCH wireless-next 15/17] wifi: bcm4323x: add the mac80211 operations
Date: Mon, 26 Oct 2026 13:36:21 +0800
Message-ID: <20261026053633.361454-16-ragulbaby@gmail.com>
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
Content-Transfer-Encoding: 8bit

Add the mac80211 side of the device driver.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../brcm80211/bcm4323x/bcm4323x_mac.c         | 1495 +++++++++++++++++
 1 file changed, 1495 insertions(+)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_mac.c

diff --git a/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_mac.c b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_mac.c
new file mode 100644
index 000000000..4864c5d12
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_mac.c
@@ -0,0 +1,1495 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/args.h>
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+
+#include "bcm4323x.h"
+
+/* from brcmsmac: phy_hal.h */
+#define BRCMS_TXPWR_DB_FACTOR	4
+#define BRCMS_TXPWR_MAX		(127)	/* ~32 dBm = 1,500 mW */
+#define PHY_PERICAL_JOIN_BSS	4
+
+/* from brcmsmac: phy_shim.h */
+#define WL_TX_POWER_MCS20_SISO_FIRST   20
+#define WL_TX_POWER_MCS20_CDD_FIRST    28
+#define WL_TX_POWER_MCS20_STBC_FIRST   36
+#define WL_TX_POWER_MCS40_SISO_FIRST   68
+#define WL_TX_POWER_MCS40_CDD_FIRST    76
+#define WL_TX_POWER_MCS40_STBC_FIRST   84
+
+#define BCM4323X_RPC_PROC_REG_WRITE 0x02
+#define BCM4323X_RPC_PROC_HOST_FLAGS 0x03
+#define BCM4323X_RPC_PROC_NOISE 0x1f
+#define BCM4323X_RPC_PROC_PHY_CAL 0x20
+#define BCM4323X_RPC_PROC_TX_POWER 0x22
+#define BCM4323X_RPC_PROC_SHM_COPY 0x28
+#define BCM4323X_RPC_PROC_RADIO_SYNC 0x29
+#define BCM4323X_RPC_PROC_MAC_CONTROL 0x2a
+#define BCM4323X_RPC_PROC_SHM_READ 0x2c
+#define BCM4323X_RPC_PROC_RX_ADDRESS 0x2e
+#define BCM4323X_RPC_PROC_KEY_PEER 0x30
+#define BCM4323X_RPC_PROC_SHM_FILL 0x31
+#define BCM4323X_RPC_PROC_CHANNEL_PREP 0x32
+#define BCM4323X_RPC_PROC_SHM_WRITE 0x33
+#define BCM4323X_RPC_PROC_TEMPLATE 0x34
+#define BCM4323X_RPC_PROC_MAC 0x38
+#define BCM4323X_RPC_PROC_CHANNEL_DATA 0x3a
+#define BCM4323X_RPC_PROC_SHORT_SLOT 0x41
+#define BCM4323X_RPC_PROC_TX_POWER_REPORT 0x43
+#define BCM4323X_RPC_PROC_STF_MODE 0x47
+
+#define BCM4323X_KEY_TABLE_BASE 0x0ea4
+#define BCM4323X_MHF1_DEFKEYS 0x4000
+
+#define BCM4323X_SHM_TUNE 0x0076
+#define BCM4323X_SHM_TUNE_VALUE 0x36
+
+#define BCM4323X_TX_POWER_RATES 153
+#define BCM4323X_WATCHDOG_INTERVAL HZ
+#define BCM4323X_WATCHDOG_FAILURES 3
+#define BCM4323X_PHY_CAL_INTERVAL (60 * HZ)
+
+/* from brcmsmac */
+#define EDCF_AIFSN_MASK 0x0f
+#define EDCF_AIFSN_MAX 15
+#define EDCF_TXOP2USEC(txop) ((txop) << 5)
+#define MAXFRAMEBURST_TXOP 10000
+#define RFDISABLE_DEFAULT 10000000
+
+/* The fields of the M_AC_TXLMT_ADDR() words */
+#define EDCF_SHORT GENMASK(3, 0)
+#define EDCF_SFB GENMASK(7, 4)
+#define EDCF_LONG GENMASK(11, 8)
+#define EDCF_LFB GENMASK(15, 12)
+#define RETRY_SHORT_FB 3
+#define RETRY_LONG_FB 2
+
+/* from brcmsmac */
+#define MAC_FILTERS (FIF_ALLMULTI | \
+	FIF_FCSFAIL | \
+	FIF_CONTROL | \
+	FIF_OTHER_BSS | \
+	FIF_BCN_PRBRESP_PROMISC | \
+	FIF_PSPOLL)
+
+/* The bits of maccontrol that bcm4323x_set_maccontrol() sets or clears */
+#define BCM4323X_MCTL_RECEIVE (MCTL_DISCARD_PMQ | MCTL_AP | MCTL_INFRA | MCTL_PROMISC | \
+			       MCTL_BCNS_PROMISC | MCTL_KEEPCONTROL | MCTL_KEEPBADFCS | \
+			       MCTL_HPS | MCTL_WAKE)
+
+/* Procedure 0x28 */
+struct bcm4323x_shm_copy {
+	__le32 offset;
+	__le32 length;
+	/* The data, at most the parameters of an EDCF queue, then the memory selector */
+	u8 data[M_EDCF_QLEN + sizeof(__le32)];
+} __packed;
+
+static_assert(sizeof(struct shm_acparams) <= M_EDCF_QLEN);
+
+/* Procedures 0x2e and 0x30 */
+struct bcm4323x_slot_address {
+	__le32 slot;
+	u8 addr[ETH_ALEN];
+	__le16 pad;
+} __packed;
+
+/* Procedure 0x34: brcms_b_write_template_ram() */
+struct bcm4323x_ba_template {
+	__le32 offset;
+	__le32 length;
+	u8 data[T_RAM_ACCESS_SZ * 2];
+} __packed;
+
+/* Procedure 0x3a */
+struct bcm4323x_channel_data {
+	__le32 chanspec;
+	__le32 reserved;
+	u8 values[156];
+} __packed;
+
+/* from brcmsmac: struct tx_power */
+struct bcm4323x_tx_power_report {
+	__le32 flags;
+	__le16 chanspec;
+	__le16 local_chanspec;
+	u8 local_max;
+	u8 local_constraint;
+	s8 antgain[2];
+	u8 rf_cores;
+	u8 est_Pout[4];
+	u8 est_Pout_act[4];
+	u8 est_Pout_cck;
+	u8 tx_power_max[4];
+	u8 tx_power_max_rate_ind[4];
+	u8 user_limit[BCM4323X_TX_POWER_RATES];
+	u8 reg_limit[BCM4323X_TX_POWER_RATES];
+	u8 board_limit[BCM4323X_TX_POWER_RATES];
+	u8 target[BCM4323X_TX_POWER_RATES];
+	u8 pad[2];
+} __packed;
+
+static_assert(sizeof(struct bcm4323x_tx_power_report) == 644);
+
+/* Procedure 0x43 */
+struct bcm4323x_tx_power_query {
+	__le32 channel;
+	struct bcm4323x_tx_power_report power;
+} __packed;
+
+/* from brcmsmac */
+#define RATE(rate100m, _flags) { \
+	.bitrate = (rate100m), \
+	.flags = (_flags), \
+	.hw_value = (rate100m / 5), \
+}
+
+/* from brcmsmac: legacy_ratetable  */
+struct ieee80211_rate bcm4323x_rates[BCM4323X_NUM_RATES] = {
+	RATE(10, 0),
+	RATE(20, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(55, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(110, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(60, 0),
+	RATE(90, 0),
+	RATE(120, 0),
+	RATE(180, 0),
+	RATE(240, 0),
+	RATE(360, 0),
+	RATE(480, 0),
+	RATE(540, 0),
+};
+
+/* from brcmsmac, leaving the maximum power to the regulatory domain */
+#define CHAN2GHZ(channel, frequency, chflags)  { \
+	.band = NL80211_BAND_2GHZ, \
+	.center_freq = (frequency), \
+	.hw_value = (channel), \
+	.flags = chflags, \
+}
+
+#define CHAN5GHZ(channel, chflags)  { \
+	.band = NL80211_BAND_5GHZ, \
+	.center_freq = 5000 + 5 * (channel), \
+	.hw_value = (channel), \
+	.flags = chflags, \
+}
+
+/* from brcmsmac: brcms_2ghz_chantable */
+static const struct ieee80211_channel bcm4323x_2ghz_channels[BCM4323X_NUM_2GHZ_CHANNELS] = {
+	CHAN2GHZ(1, 2412, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN2GHZ(2, 2417, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN2GHZ(3, 2422, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN2GHZ(4, 2427, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN2GHZ(5, 2432, 0),
+	CHAN2GHZ(6, 2437, 0),
+	CHAN2GHZ(7, 2442, 0),
+	CHAN2GHZ(8, 2447, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(9, 2452, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(10, 2457, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(11, 2462, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(12, 2467,
+		 IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(13, 2472,
+		 IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(14, 2484,
+		 IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS |
+		 IEEE80211_CHAN_NO_OFDM)
+};
+
+/* from brcmsmac: brcms_5ghz_nphy_chantable */
+static const struct ieee80211_channel bcm4323x_5ghz_channels[BCM4323X_NUM_5GHZ_CHANNELS] = {
+	/* UNII-1 */
+	CHAN5GHZ(36, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(40, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(44, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(48, IEEE80211_CHAN_NO_HT40PLUS),
+	/* UNII-2 */
+	CHAN5GHZ(52,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(56,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(60,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(64,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40PLUS),
+	/* MID */
+	CHAN5GHZ(100,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(104,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(108,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(112,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(116,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(120,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(124,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(128,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(132,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(136,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(140,
+		 IEEE80211_CHAN_RADAR |
+		 IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_NO_HT40PLUS |
+		 IEEE80211_CHAN_NO_HT40MINUS),
+	/* UNII-3 */
+	CHAN5GHZ(149, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(153, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(157, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(161, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(165, IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
+};
+
+/* From USB captures of the windows driver */
+static void bcm4323x_channel_data(const struct bcm4323x_chip *chip,
+				  struct bcm4323x_channel_data *data, u16 chanspec)
+{
+	unsigned int channel = CHSPEC_CHANNEL(chanspec);
+	u8 *values = data->values;
+	u8 value;
+	u8 last;
+
+	memset(data, 0, sizeof(*data));
+	data->chanspec = cpu_to_le32(chanspec);
+	if (channel > 14) {
+		memset(values + 4, channel < 149 ? 0x38 : 0x44, 24);
+		memset(values + 28, channel < 149 ? 0x28 : 0x3c, 24);
+		memset(values + 52, channel < 149 ? 0x30 : 0x3c, 49);
+		return;
+	}
+	if (chip->channel_data_2ghz[0]) {
+		memset(values, chip->channel_data_2ghz[0], 28);
+		memset(values + 28, chip->channel_data_2ghz[1], 24);
+		memset(values + 52, chip->channel_data_2ghz[2], 49);
+		return;
+	}
+	memset(values, 0x4c, 28);
+
+	switch (channel) {
+	case 12:
+	case 13:
+	case 14:
+	case 11:
+		memset(values + 4, 0x42, 24);
+		fallthrough;
+	case 1:
+		memset(values + 28, 0x38, 24);
+		return;
+	case 2:
+	case 10:
+		memset(values + 28, 0x40, 24);
+		return;
+	case 3:
+		value = 0x34;
+		break;
+	case 9:
+		value = 0x30;
+		break;
+	default:
+		value = 0x38;
+		break;
+	}
+	last = value + (channel == 8 ? 6 : 10);
+	memset(values + 28, 0x4c, 24);
+	memset(values + 52, last, 8);
+	memset(values + 60, value, 6);
+	memset(values + 66, value + 4, 2);
+	memset(values + 68, last, 8);
+	memset(values + 76, value, 5);
+	memset(values + 81, value + 4, 3);
+	memset(values + 84, value, 5);
+	memset(values + 89, value + 4, 7);
+	memset(values + 96, value + 6, 4);
+	values[100] = last;
+}
+
+/* from brcmsmac: brcms_c_stf_ss_algo_channel_get */
+static int bcm4323x_stf_ss_algo_channel_get(struct bcm4323x *dev, u16 *ss_algo_channel,
+					    u16 chanspec)
+{
+	struct bcm4323x_tx_power_query *query;
+	struct bcm4323x_tx_power_report *power;
+	u8 siso_mcs_id, cdd_mcs_id, stbc_mcs_id;
+	int ret;
+
+	/* Clear previous settings */
+	*ss_algo_channel = 0;
+
+	/* The response overwrites the query only after it is sent. */
+	query = kzalloc_obj(*query);
+	if (!query)
+		return -ENOMEM;
+	query->channel = cpu_to_le32(CHSPEC_CHANNEL(chanspec));
+	power = &query->power;
+	ret = bcm4323x_rpc_call(dev, BCM4323X_RPC_PROC_TX_POWER_REPORT, query, sizeof(*query),
+				power, sizeof(*power));
+	if (ret)
+		goto out;
+
+	siso_mcs_id = (CHSPEC_IS40(chanspec)) ?
+	    WL_TX_POWER_MCS40_SISO_FIRST : WL_TX_POWER_MCS20_SISO_FIRST;
+	cdd_mcs_id = (CHSPEC_IS40(chanspec)) ?
+	    WL_TX_POWER_MCS40_CDD_FIRST : WL_TX_POWER_MCS20_CDD_FIRST;
+	stbc_mcs_id = (CHSPEC_IS40(chanspec)) ?
+	    WL_TX_POWER_MCS40_STBC_FIRST : WL_TX_POWER_MCS20_STBC_FIRST;
+
+	/* criteria to choose stf mode */
+
+	/*
+	 * the "+3dbm (12 0.25db units)" is to account for the fact that with
+	 * CDD, tx occurs on both chains
+	 */
+	if (power->target[siso_mcs_id] > (power->target[cdd_mcs_id] + 12))
+		setbit(ss_algo_channel, PHY_TXC1_MODE_SISO);
+	else
+		setbit(ss_algo_channel, PHY_TXC1_MODE_CDD);
+
+	/*
+	 * STBC is ORed into to algo channel as STBC requires per-packet SCB
+	 * capability check so cannot be default mode of operation. One of
+	 * SISO, CDD have to be set
+	 */
+	if (power->target[siso_mcs_id] <= (power->target[stbc_mcs_id] + 12))
+		setbit(ss_algo_channel, PHY_TXC1_MODE_STBC);
+out:
+	kfree(query);
+	return ret;
+}
+
+/* from brcmsmac: brcms_c_stf_ss_update */
+static int bcm4323x_stf_ss_update(struct bcm4323x *dev, u16 ss_algo_channel)
+{
+	u8 upd_stf_ss = bcm4323x_stf_mode(ss_algo_channel);
+	int ret = 0;
+
+	/* Only the BCM4323 trace sets a mode, so the first selection always does. */
+	if (!dev->ss_algo_channel || bcm4323x_stf_mode(dev->ss_algo_channel) != upd_stf_ss)
+		ret = bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_STF_MODE, upd_stf_ss);
+	if (!ret)
+		WRITE_ONCE(dev->ss_algo_channel, ss_algo_channel);
+	return ret;
+}
+
+/* Procedure 0x33: brcms_b_write_shm() */
+int bcm4323x_write_shm(struct bcm4323x *dev, u32 offset, u16 value)
+{
+	return bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_SHM_WRITE, offset, value);
+}
+
+/* Procedure 0x2c: brcms_b_read_shm() */
+int bcm4323x_read_shm(struct bcm4323x *dev, u32 offset, u16 *value)
+{
+	__le32 response;
+	int ret;
+
+	ret = bcm4323x_rpc_call_u32(dev, BCM4323X_RPC_PROC_SHM_READ, &response, offset);
+	if (!ret)
+		*value = le32_to_cpu(response);
+	return ret;
+}
+
+/* Procedure 0x2a: brcms_b_mctrl() */
+static int bcm4323x_set_mac_control(struct bcm4323x *dev, u32 mask, u32 value)
+{
+	return bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_MAC_CONTROL, mask, value);
+}
+
+static int bcm4323x_read_reg(struct bcm4323x *dev, u32 offset, u32 size, u32 *value)
+{
+	__le32 response;
+	int ret;
+
+	ret = bcm4323x_rpc_call_u32(dev, BCM4323X_RPC_PROC_REG_READ, &response, offset, size);
+	if (!ret)
+		*value = le32_to_cpu(response);
+	return ret;
+}
+
+/* Procedure 0x02: bcma_write16() or bcma_write32() by @size */
+static int bcm4323x_write_reg(struct bcm4323x *dev, u32 offset, u32 value, u32 size)
+{
+	return bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_REG_WRITE, offset, value, size);
+}
+
+/* Procedure 0x03: brcms_b_mhf() */
+static int bcm4323x_mhf(struct bcm4323x *dev, u8 idx, u16 mask, u16 val, int bands)
+{
+	return bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_HOST_FLAGS, idx, mask, val, bands);
+}
+
+static void bcm4323x_warn(struct bcm4323x *dev, int ret, const char *what)
+{
+	if (ret && ret != -ENODEV)
+		dev_warn(&dev->intf->dev, "failed to %s: %d\n", what, ret);
+}
+
+static int bcm4323x_tune(struct bcm4323x *dev, u16 chanspec)
+{
+	struct bcm4323x_channel_data body;
+	u16 ss_algo_channel;
+	int ret;
+
+	ret = bcm4323x_rpc_send(dev, BCM4323X_RPC_PROC_CHANNEL_PREP, NULL, 0);
+	if (ret)
+		return ret;
+	bcm4323x_channel_data(dev->chip, &body, chanspec);
+	ret = bcm4323x_rpc_send(dev, BCM4323X_RPC_PROC_CHANNEL_DATA, &body, sizeof(body));
+	if (ret)
+		return ret;
+	ret = bcm4323x_stf_ss_algo_channel_get(dev, &ss_algo_channel, chanspec);
+	if (ret)
+		return ret;
+	ret = bcm4323x_stf_ss_update(dev, ss_algo_channel);
+	if (ret)
+		return ret;
+	return bcm4323x_write_shm(dev, BCM4323X_SHM_TUNE, BCM4323X_SHM_TUNE_VALUE);
+}
+
+/* from brcmsmac: brcms_c_set_channel */
+static int bcm4323x_set_channel(struct bcm4323x *dev, u16 chanspec)
+{
+	int enable_ret;
+	int ret;
+
+	if (chanspec == dev->chanspec)
+		return 0;
+	/* A chanspec of 0 has no band, so the first switch also counts. */
+	if (CHSPEC_BAND(chanspec) != CHSPEC_BAND(dev->chanspec))
+		dev->band_switched = true;
+	WRITE_ONCE(dev->chanspec, 0);
+
+	ret = bcm4323x_set_mac_control(dev, MCTL_EN_MAC, 0);
+	if (ret)
+		return ret;
+	ret = bcm4323x_tune(dev, chanspec);
+	enable_ret = bcm4323x_set_mac_control(dev, MCTL_EN_MAC, MCTL_EN_MAC);
+	ret = ret ?: enable_ret;
+	if (!ret)
+		WRITE_ONCE(dev->chanspec, chanspec);
+	return ret;
+}
+
+/* @offset is in bytes: brcmsmac's brcms_b_write_objmem() selects word @offset / 4. */
+static int bcm4323x_copy_to_objmem(struct bcm4323x *dev, u32 offset, const void *buf, u32 length,
+				   u32 objsel)
+{
+	struct bcm4323x_shm_copy body = {
+		.offset = cpu_to_le32(offset),
+		.length = cpu_to_le32(length),
+	};
+	__le32 sel = cpu_to_le32(objsel);
+
+	memcpy(body.data, buf, length);
+	memcpy(body.data + length, &sel, sizeof(sel));
+	return bcm4323x_rpc_send(dev, BCM4323X_RPC_PROC_SHM_COPY, &body,
+				 offsetof(struct bcm4323x_shm_copy, data) + length + sizeof(sel));
+}
+
+static int bcm4323x_copy_to_shm(struct bcm4323x *dev, u32 offset, const void *buf, u32 length)
+{
+	return bcm4323x_copy_to_objmem(dev, offset, buf, length, OBJADDR_SHM_SEL);
+}
+
+/*
+ * from brcmsmac: brcms_c_set_rate_limit, brcms_b_retrylimit_upd and
+ * brcms_c_wme_retries_write
+ */
+static int bcm4323x_set_retry_limits(struct bcm4323x *dev, u8 srl, u8 lrl)
+{
+	__le16 limit;
+	u16 txlmt;
+	int ac;
+	int ret;
+
+	srl = min_t(u8, srl, FIELD_MAX(EDCF_SHORT));
+	lrl = min_t(u8, lrl, FIELD_MAX(EDCF_LONG));
+	limit = cpu_to_le16(srl);
+	ret = bcm4323x_copy_to_objmem(dev, S_DOT11_SRC_LMT * sizeof(u32), &limit, sizeof(limit),
+				      OBJADDR_SCR_SEL);
+	if (ret)
+		return ret;
+	limit = cpu_to_le16(lrl);
+	ret = bcm4323x_copy_to_objmem(dev, S_DOT11_LRC_LMT * sizeof(u32), &limit, sizeof(limit),
+				      OBJADDR_SCR_SEL);
+	if (ret)
+		return ret;
+	txlmt = FIELD_PREP(EDCF_SHORT, srl) | FIELD_PREP(EDCF_SFB, RETRY_SHORT_FB) |
+		FIELD_PREP(EDCF_LONG, lrl) | FIELD_PREP(EDCF_LFB, RETRY_LONG_FB);
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		ret = bcm4323x_write_shm(dev, M_AC_TXLMT_ADDR(ac), txlmt);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int bcm4323x_set_slot_address(struct bcm4323x *dev, u32 procedure, u32 slot,
+				     const u8 *addr)
+{
+	struct bcm4323x_slot_address body = { .slot = cpu_to_le32(slot) };
+
+	if (addr)
+		ether_addr_copy(body.addr, addr);
+	return bcm4323x_rpc_send(dev, procedure, &body, sizeof(body));
+}
+
+/* from brcmsmac: brcms_c_ampdu_macaddr_upd */
+static int bcm4323x_ampdu_macaddr_upd(struct bcm4323x *dev, const u8 *addr)
+{
+	/* the transmitter address is at offset 16 */
+	struct bcm4323x_ba_template body = {
+		.offset = cpu_to_le32(T_BA_TPL_BASE + 16),
+		.length = cpu_to_le32(sizeof(body.data)),
+	};
+
+	ether_addr_copy(body.data, addr);
+	return bcm4323x_rpc_send(dev, BCM4323X_RPC_PROC_TEMPLATE, &body, sizeof(body));
+}
+
+static int bcm4323x_radio_sync(struct bcm4323x *dev)
+{
+	return bcm4323x_rpc_send(dev, BCM4323X_RPC_PROC_RADIO_SYNC, NULL, 0);
+}
+
+/* Procedure 0x41: brcms_b_set_shortslot() */
+static int bcm4323x_set_shortslot(struct bcm4323x *dev, bool shortslot)
+{
+	return bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_SHORT_SLOT, shortslot);
+}
+
+/* from brcmsmac: brcms_c_write_rate_shm */
+static int bcm4323x_write_rate_shm(struct bcm4323x *dev, u8 rate, u8 basic_rate)
+{
+	u8 phy_rate, index;
+	u8 basic_phy_rate, basic_index;
+	u16 dir_table, basic_table;
+	u16 basic_ptr;
+	int ret;
+
+	/* Shared memory address for the table we are reading */
+	dir_table = is_ofdm_rate(basic_rate) ? M_RT_DIRMAP_A : M_RT_DIRMAP_B;
+
+	/* Shared memory address for the table we are writing */
+	basic_table = is_ofdm_rate(rate) ? M_RT_BBRSMAP_A : M_RT_BBRSMAP_B;
+
+	/*
+	 * for a given rate, the LS-nibble of the PLCP SIGNAL field is
+	 * the index into the rate table.
+	 */
+	phy_rate = brcmu_rate_info[rate] & BRCMS_RATE_MASK;
+	basic_phy_rate = brcmu_rate_info[basic_rate] & BRCMS_RATE_MASK;
+	index = phy_rate & 0xf;
+	basic_index = basic_phy_rate & 0xf;
+
+	/* Find the SHM pointer to the ACK rate entry by looking in the
+	 * Direct-map Table
+	 */
+	ret = bcm4323x_read_shm(dev, dir_table + basic_index * 2, &basic_ptr);
+	if (ret)
+		return ret;
+
+	/* Update the SHM BSS-basic-rate-set mapping table with the pointer
+	 * to the correct basic rate for the given incoming rate
+	 */
+	return bcm4323x_write_shm(dev, basic_table + index * 2, basic_ptr);
+}
+
+/* from brcmsmac: brcms_c_bsinit and brcms_c_set_ratetable */
+static int bcm4323x_set_ratetable(struct bcm4323x *dev, enum nl80211_band band, u32 basic_rates)
+{
+	u8 br[BRCM_MAXRATE + 1];
+	u8 rate, basic_rate;
+	uint i;
+	int ret = 0;
+
+	bcm4323x_init_basic_rate(br, band, basic_rates);
+	/* walk the phy rate table and update SHM basic rate lookup table */
+	for (i = bcm4323x_first_rate(band); i < BCM4323X_NUM_RATES && !ret; i++) {
+		rate = bcm4323x_rates[i].hw_value;
+		basic_rate = brcmu_basic_rate(br, rate);
+		ret = bcm4323x_write_rate_shm(dev, rate, basic_rate);
+	}
+	return ret;
+}
+
+/* from brcmsmac: brcms_c_bsinit */
+static int bcm4323x_bsinit(struct bcm4323x *dev)
+{
+	struct ieee80211_vif *vif = wiphy_dereference(dev->hw->wiphy, dev->active_vif);
+	const struct ieee80211_channel *bss_chan = vif ? vif->bss_conf.chanreq.oper.chan : NULL;
+	enum nl80211_band band = dev->hw->conf.chandef.chan->band;
+	int ret;
+
+	if (!dev->band_switched || dev->scanning)
+		return 0;
+	dev->band_switched = false;
+	if (!bss_chan || bss_chan->band != band || !vif->cfg.assoc)
+		return 0;
+	ret = bcm4323x_set_ratetable(dev, band, vif->bss_conf.basic_rates);
+	if (ret)
+		return ret;
+	return bcm4323x_set_shortslot(dev, band == NL80211_BAND_5GHZ ||
+					   vif->bss_conf.use_short_slot);
+}
+
+/* Procedure 0x22, wlc_phy_txpower_set() */
+static int bcm4323x_write_tx_power(struct bcm4323x *dev, int qdbm)
+{
+	int ret;
+
+	ret = bcm4323x_radio_sync(dev);
+	if (ret)
+		return ret;
+	ret = bcm4323x_rpc_call_u32(dev, BCM4323X_RPC_PROC_TX_POWER, NULL, qdbm, 0);
+	if (!ret)
+		dev->tx_power = qdbm;
+	return ret;
+}
+
+static int bcm4323x_qdbm(int dbm)
+{
+	return clamp(dbm * BRCMS_TXPWR_DB_FACTOR, 0, BRCMS_TXPWR_MAX);
+}
+
+/* from brcmsmac: brcms_c_set_tx_power */
+static int bcm4323x_set_tx_power(struct bcm4323x *dev, int qdbm)
+{
+	return qdbm == dev->tx_power ? 0 : bcm4323x_write_tx_power(dev, qdbm);
+}
+
+/* from brcmsmac: brcms_c_mac_promisc */
+static u32 bcm4323x_mac_promisc(uint filter_flags)
+{
+	u32 promisc_bits = 0;
+
+	if (filter_flags & FIF_OTHER_BSS)
+		promisc_bits |= MCTL_PROMISC;
+
+	if (filter_flags & FIF_BCN_PRBRESP_PROMISC)
+		promisc_bits |= MCTL_BCNS_PROMISC;
+
+	if (filter_flags & FIF_FCSFAIL)
+		promisc_bits |= MCTL_KEEPBADFCS;
+
+	if (filter_flags & (FIF_CONTROL | FIF_PSPOLL))
+		promisc_bits |= MCTL_KEEPCONTROL;
+
+	return promisc_bits;
+}
+
+static int bcm4323x_set_maccontrol(struct bcm4323x *dev)
+{
+	u32 maccontrol = MCTL_DISCARD_PMQ | MCTL_INFRA | MCTL_WAKE |
+			 bcm4323x_mac_promisc(dev->filter_flags);
+
+	return bcm4323x_set_mac_control(dev, BCM4323X_MCTL_RECEIVE, maccontrol);
+}
+
+static int bcm4323x_set_receive(struct bcm4323x *dev)
+{
+	struct ieee80211_vif *vif = wiphy_dereference(dev->hw->wiphy, dev->active_vif);
+	const u8 *addr;
+	int ret;
+
+	ret = bcm4323x_set_slot_address(dev, BCM4323X_RPC_PROC_RX_ADDRESS, RCM_BSSID_OFFSET,
+					vif && !dev->scanning ? vif->bss_conf.bssid : NULL);
+	if (ret)
+		return ret;
+	addr = vif && vif->addr_valid ? vif->addr : NULL;
+	ret = bcm4323x_set_slot_address(dev, BCM4323X_RPC_PROC_RX_ADDRESS, RCM_MAC_OFFSET, addr);
+	if (!ret && addr)
+		ret = bcm4323x_ampdu_macaddr_upd(dev, addr);
+	if (ret)
+		return ret;
+	ret = bcm4323x_set_maccontrol(dev);
+	if (ret)
+		return ret;
+	return bcm4323x_radio_sync(dev);
+}
+
+/* The device is lost once firmware misses several watchdog calls in a row. */
+static void bcm4323x_watchdog_rpc(struct bcm4323x *dev)
+{
+	int ret = bcm4323x_rpc_call(dev, BCM4323X_RPC_PROC_WATCHDOG, NULL, 0, NULL, 0);
+
+	if (!ret) {
+		dev->watchdog_failures = 0;
+	} else if (ret != -ENODEV && ++dev->watchdog_failures >= BCM4323X_WATCHDOG_FAILURES) {
+		dev_err(&dev->intf->dev, "firmware stopped answering: %d\n", ret);
+		bcm4323x_fatal_error(dev);
+	} else {
+		dev_dbg_ratelimited(&dev->intf->dev, "watchdog failed: %d\n", ret);
+	}
+}
+
+/*
+ * Procedure 0x20: wlc_phy_cal_perical(). The firmware calibrates on its own
+ * about every 123s, and sending aggregates during the calibration will crash
+ * it. Avoid this by explicitly calibrating and stopping TX while doing so.
+ */
+static bool bcm4323x_phy_cal(struct bcm4323x *dev)
+{
+	dev->phy_cal_expires = jiffies + BCM4323X_PHY_CAL_INTERVAL;
+	if (!bcm4323x_quiesce_tx(dev))
+		return false;
+	bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_PHY_CAL, PHY_PERICAL_JOIN_BSS);
+	return true;
+}
+
+static void bcm4323x_watchdog_worker(struct work_struct *work)
+{
+	struct bcm4323x *dev = container_of(to_delayed_work(work), struct bcm4323x, watchdog_work);
+	bool paused;
+
+	if (READ_ONCE(dev->dead))
+		return;
+	bcm4323x_check_tx(dev);
+	if (!READ_ONCE(dev->scanning)) {
+		paused = time_after_eq(jiffies, dev->phy_cal_expires);
+		if (paused && !bcm4323x_phy_cal(dev))
+			dev_warn(&dev->intf->dev, "TX not drained for the PHY calibration\n");
+		/* answered after the calibration */
+		bcm4323x_watchdog_rpc(dev);
+		if (paused)
+			bcm4323x_set_tx_paused(dev, false);
+	}
+	queue_delayed_work(system_dfl_wq, &dev->watchdog_work, BCM4323X_WATCHDOG_INTERVAL);
+}
+
+static int bcm4323x_start(struct ieee80211_hw *hw)
+{
+	struct bcm4323x *dev = hw->priv;
+	int ret;
+
+	ret = bcm4323x_set_receive(dev);
+	if (ret)
+		return ret;
+	ret = bcm4323x_set_retry_limits(dev, hw->conf.short_frame_max_tx_count,
+					hw->conf.long_frame_max_tx_count);
+	if (ret)
+		return ret;
+	WRITE_ONCE(dev->running, true);
+	ret = bcm4323x_start_rx_urbs(dev);
+	if (ret) {
+		WRITE_ONCE(dev->running, false);
+		return ret;
+	}
+	dev->watchdog_failures = 0;
+	dev->phy_cal_expires = jiffies;
+	queue_delayed_work(system_dfl_wq, &dev->watchdog_work, BCM4323X_WATCHDOG_INTERVAL);
+	return 0;
+}
+
+static void bcm4323x_stop(struct ieee80211_hw *hw, bool suspend)
+{
+	struct bcm4323x *dev = hw->priv;
+
+	WRITE_ONCE(dev->running, false);
+	cancel_delayed_work_sync(&dev->watchdog_work);
+	bcm4323x_kill_rx_urbs(dev);
+	bcm4323x_flush_tx(dev);
+}
+
+static int bcm4323x_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct bcm4323x *dev = hw->priv;
+	int ret;
+
+	if (rcu_access_pointer(dev->active_vif))
+		return -EBUSY;
+	if (vif->txq)
+		bcm4323x_init_txq(vif->txq);
+	rcu_assign_pointer(dev->active_vif, vif);
+	ret = bcm4323x_set_receive(dev);
+	if (ret)
+		RCU_INIT_POINTER(dev->active_vif, NULL);
+	return ret;
+}
+
+static void bcm4323x_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct bcm4323x *dev = hw->priv;
+
+	RCU_INIT_POINTER(dev->active_vif, NULL);
+}
+
+static u16 bcm4323x_chanspec(const struct cfg80211_chan_def *chandef)
+{
+	unsigned int channel = chandef->chan->hw_value;
+	u16 chanspec = ch20mhz_chspec(channel);
+	unsigned int center;
+
+	if (chandef->width != NL80211_CHAN_WIDTH_40)
+		return chanspec;
+	center = ieee80211_frequency_to_channel(chandef->center_freq1);
+	return CHSPEC_BAND(chanspec) | WL_CHANSPEC_BW_40 | center |
+	       (channel < center ? WL_CHANSPEC_CTL_SB_LOWER : WL_CHANSPEC_CTL_SB_UPPER);
+}
+
+/* Switches to the configured channel, with the TX power @qdbm. */
+static int bcm4323x_config_channel(struct bcm4323x *dev, int qdbm)
+{
+	const struct cfg80211_chan_def *chandef = &dev->hw->conf.chandef;
+	int ret;
+
+	ret = bcm4323x_set_channel(dev, bcm4323x_chanspec(chandef));
+	if (ret)
+		return ret;
+	ret = bcm4323x_set_receive(dev);
+	if (ret)
+		return ret;
+	ret = bcm4323x_bsinit(dev);
+	if (ret)
+		return ret;
+	/*
+	 * After a switch, the receiver stays deaf until the device transmits or
+	 * the power is set again
+	 */
+	ret = qdbm < 0 ? bcm4323x_radio_sync(dev) : bcm4323x_write_tx_power(dev, qdbm);
+	if (ret || !dev->scanning)
+		return ret;
+
+	return bcm4323x_rpc_send(dev, BCM4323X_RPC_PROC_NOISE, NULL, 0);
+}
+
+static int bcm4323x_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
+{
+	struct bcm4323x *dev = hw->priv;
+	int qdbm = dev->tx_power;
+	int ret;
+
+	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
+		ret = bcm4323x_set_retry_limits(dev, hw->conf.short_frame_max_tx_count,
+						hw->conf.long_frame_max_tx_count);
+		if (ret)
+			return ret;
+	}
+	if (changed & IEEE80211_CONF_CHANGE_POWER)
+		qdbm = bcm4323x_qdbm(hw->conf.power_level);
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
+		return bcm4323x_config_channel(dev, qdbm);
+	if (changed & IEEE80211_CONF_CHANGE_POWER)
+		return bcm4323x_set_tx_power(dev, qdbm);
+	return 0;
+}
+
+/* from brcmsmac: brcms_c_get_tx_power */
+static int bcm4323x_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+				unsigned int link_id, int *dbm)
+{
+	struct bcm4323x *dev = hw->priv;
+
+	if (dev->tx_power < 0)
+		return -EINVAL;
+	*dbm = dev->tx_power / BRCMS_TXPWR_DB_FACTOR;
+	return 0;
+}
+
+static void bcm4323x_sw_scan_start(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+				   const u8 *mac_addr)
+{
+	struct bcm4323x *dev = hw->priv;
+
+	WRITE_ONCE(dev->scanning, true);
+}
+
+static void bcm4323x_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct bcm4323x *dev = hw->priv;
+	int ret;
+
+	WRITE_ONCE(dev->scanning, false);
+	ret = bcm4323x_set_receive(dev);
+	if (!ret)
+		ret = bcm4323x_bsinit(dev);
+	bcm4323x_warn(dev, ret, "leave scan mode cleanly");
+}
+
+static void bcm4323x_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+				      struct ieee80211_bss_conf *info, u64 changed)
+{
+	struct bcm4323x *dev = hw->priv;
+	const struct ieee80211_channel *chan = info->chanreq.oper.chan ?: hw->conf.chandef.chan;
+
+	if (changed & BSS_CHANGED_BSSID)
+		bcm4323x_warn(dev, bcm4323x_set_receive(dev), "program receive addresses");
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		bcm4323x_warn(dev, bcm4323x_set_ratetable(dev, chan->band, info->basic_rates),
+			      "set the response rates");
+	if (changed & BSS_CHANGED_ERP_SLOT)
+		bcm4323x_warn(dev, bcm4323x_set_shortslot(dev, info->use_short_slot),
+			      "set the slot time");
+	if ((changed & BSS_CHANGED_TXPOWER) && info->txpower != INT_MIN)
+		bcm4323x_warn(dev, bcm4323x_set_tx_power(dev, bcm4323x_qdbm(info->txpower)),
+			      "set the TX power");
+}
+
+/* from brcmsmac: brcms_c_wme_setparams */
+static int bcm4323x_wme_setparams(struct bcm4323x *dev, u16 aci,
+				  const struct ieee80211_tx_queue_params *params)
+{
+	u32 base = M_EDCF_QINFO + bcm4323x_ac_to_fifo(aci) * M_EDCF_QLEN;
+	struct shm_acparams acp_shm = {};
+	__le16 words[sizeof(acp_shm) / sizeof(u16)];
+	u16 *shm_entry;
+	unsigned int i;
+
+	/* convert from units of 32us to us for ucode */
+	acp_shm.txop = min_t(u32, EDCF_TXOP2USEC(params->txop), U16_MAX);
+	acp_shm.aifs = (params->aifs & EDCF_AIFSN_MASK);
+
+	if (aci == IEEE80211_AC_VI && acp_shm.txop == 0 &&
+	    acp_shm.aifs < EDCF_AIFSN_MAX)
+		acp_shm.aifs++;
+
+	acp_shm.cwmin = params->cw_min;
+	acp_shm.cwmax = params->cw_max;
+	acp_shm.cwcur = acp_shm.cwmin;
+
+	/* Unlike brcmsmac, take the random backoff from the kernel, not from tsf_random. */
+	acp_shm.bslots = get_random_u16() & acp_shm.cwcur;
+	acp_shm.reggap = acp_shm.bslots + acp_shm.aifs;
+	/*
+	 * Indicate the new params to the ucode, without reading the status word
+	 * first as brcmsmac does: it holds nothing else.
+	 */
+	acp_shm.status = WME_STATUS_NEWAC;
+
+	/* Fill in shm acparam table */
+	shm_entry = (u16 *)&acp_shm;
+	for (i = 0; i < ARRAY_SIZE(words); i++)
+		words[i] = cpu_to_le16(shm_entry[i]);
+	return bcm4323x_copy_to_shm(dev, base, words, sizeof(words));
+}
+
+static int bcm4323x_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    unsigned int link_id, u16 aci,
+			    const struct ieee80211_tx_queue_params *params)
+{
+	return bcm4323x_wme_setparams(hw->priv, aci, params);
+}
+
+/* from brcmsmac: brcms_ops_configure_filter */
+static void bcm4323x_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
+				      unsigned int *total_flags, u64 multicast)
+{
+	struct bcm4323x *dev = hw->priv;
+
+	*total_flags &= MAC_FILTERS;
+	dev->filter_flags = *total_flags;
+	if (changed_flags & MAC_FILTERS)
+		bcm4323x_warn(dev, bcm4323x_set_maccontrol(dev), "configure receive filter");
+}
+
+static int bcm4323x_program_key(struct bcm4323x *dev, u8 index, const u8 *peer,
+				const struct ieee80211_key_conf *key)
+{
+	u8 material[WLAN_KEY_LEN_CCMP] = {};
+	bool pairwise = index >= BCM4323X_HW_PAIRWISE_BASE;
+	u8 slot = index - BCM4323X_HW_PAIRWISE_BASE;
+	int ret = 0;
+
+	if (key)
+		memcpy(material, key->key, sizeof(material));
+	if (pairwise)
+		ret = bcm4323x_set_slot_address(dev, BCM4323X_RPC_PROC_KEY_PEER, slot, NULL);
+	if (!ret)
+		ret = bcm4323x_write_shm(dev, M_SECKINDXALGO_BLK + index * sizeof(u16),
+					 key ? FIELD_PREP(SKL_INDEX_MASK, index) |
+					       FIELD_PREP(SKL_ALGO_MASK, WSEC_ALGO_AES) : 0);
+	if (!ret)
+		ret = bcm4323x_copy_to_shm(dev, BCM4323X_KEY_TABLE_BASE + index * sizeof(material),
+					   material, sizeof(material));
+	if (!ret && pairwise && key)
+		ret = bcm4323x_set_slot_address(dev, BCM4323X_RPC_PROC_KEY_PEER, slot, peer);
+	return ret;
+}
+
+static int bcm4323x_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			    struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+			    struct ieee80211_key_conf *key)
+{
+	struct bcm4323x *dev = hw->priv;
+	bool pairwise = key->flags & IEEE80211_KEY_FLAG_PAIRWISE;
+	unsigned int index;
+	int ret;
+
+	/* TODO: WEP and TKIP */
+	if (key->cipher != WLAN_CIPHER_SUITE_CCMP)
+		return -EOPNOTSUPP;
+	if (!pairwise && key->keyidx >= BCM4323X_HW_PAIRWISE_BASE)
+		return -ENOSPC;
+
+	switch (cmd) {
+	case SET_KEY:
+		if (pairwise) {
+			/* The wiphy mutex serializes the calls, so a free slot stays free. */
+			index = find_next_zero_bit(dev->keys, BCM4323X_HW_KEYS,
+						   BCM4323X_HW_PAIRWISE_BASE);
+			if (index == BCM4323X_HW_KEYS)
+				return -ENOSPC;
+			ether_addr_copy(dev->key_peers[index], sta->addr);
+		} else {
+			index = key->keyidx;
+		}
+		ret = bcm4323x_program_key(dev, index, pairwise ? sta->addr : NULL, key);
+		if (ret) {
+			bcm4323x_program_key(dev, index, NULL, NULL);
+			return ret;
+		}
+
+		key->hw_key_idx = index;
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
+		/* Pairs with test_bit_acquire() in bcm4323x_rx_key_match(). */
+		smp_mb__before_atomic();
+		set_bit(index, dev->keys);
+		return 0;
+	case DISABLE_KEY:
+		bcm4323x_retire_key(dev, key->hw_key_idx, sta);
+		bcm4323x_program_key(dev, key->hw_key_idx, NULL, NULL);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+/* Only the channels scanned so far have a noise measurement. */
+static int bcm4323x_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
+{
+	struct bcm4323x *dev = hw->priv;
+	s8 noise;
+
+	if (idx >= BCM4323X_NUM_2GHZ_CHANNELS + dev->bands[NL80211_BAND_5GHZ].n_channels)
+		return -ENOENT;
+
+	survey->channel = &dev->channels[idx];
+	survey->filled = 0;
+
+	if (survey->channel == hw->conf.chandef.chan)
+		survey->filled |= SURVEY_INFO_IN_USE;
+
+	noise = READ_ONCE(dev->noise[idx]);
+	if (noise) {
+		survey->noise = noise;
+		survey->filled |= SURVEY_INFO_NOISE_DBM;
+	}
+	return 0;
+}
+
+const struct ieee80211_ops bcm4323x_ops = {
+	.tx = bcm4323x_tx,
+	.start = bcm4323x_start,
+	.stop = bcm4323x_stop,
+	.add_interface = bcm4323x_add_interface,
+	.remove_interface = bcm4323x_remove_interface,
+	.config = bcm4323x_config,
+	.bss_info_changed = bcm4323x_bss_info_changed,
+	.configure_filter = bcm4323x_configure_filter,
+	.set_key = bcm4323x_set_key,
+	.sw_scan_start = bcm4323x_sw_scan_start,
+	.sw_scan_complete = bcm4323x_sw_scan_complete,
+	.sta_state = bcm4323x_sta_state,
+	.conf_tx = bcm4323x_conf_tx,
+	.ampdu_action = bcm4323x_ampdu_action,
+	.get_survey = bcm4323x_get_survey,
+	.flush = bcm4323x_flush,
+	.add_chanctx = ieee80211_emulate_add_chanctx,
+	.remove_chanctx = ieee80211_emulate_remove_chanctx,
+	.change_chanctx = ieee80211_emulate_change_chanctx,
+	.switch_vif_chanctx = ieee80211_emulate_switch_vif_chanctx,
+	.get_txpower = bcm4323x_get_txpower,
+	.wake_tx_queue = bcm4323x_wake_tx_queue,
+};
+
+enum bcm4323x_init_chip {
+	BCM4323X_INIT_BOTH,
+	BCM4323X_INIT_BCM43231,
+	BCM4323X_INIT_BCM4323,
+};
+
+struct bcm4323x_init_call {
+	u8 procedure;
+	/* Whether to wait for the response */
+	bool control;
+	u8 chip;
+	u8 words;
+	u32 body[5];
+};
+
+#define BCM4323X_INIT_DATA(_procedure, ...) {					\
+	.procedure = (_procedure),						\
+	.words = COUNT_ARGS(__VA_ARGS__),					\
+	.body = { __VA_ARGS__ },						\
+}
+
+#define BCM4323X_INIT_CONTROL(_procedure, ...) {				\
+	.procedure = (_procedure),						\
+	.control = true,							\
+	.words = COUNT_ARGS(__VA_ARGS__),					\
+	.body = { __VA_ARGS__ },						\
+}
+
+/* The reference driver initializes the firmware on channel 11. */
+#define BCM4323X_INIT_CHANNEL 11
+#define BCM4323X_INIT_CHANSPEC (WL_CHANSPEC_BAND_2G | WL_CHANSPEC_BW_20 | \
+				WL_CHANSPEC_CTL_SB_NONE | BCM4323X_INIT_CHANNEL)
+
+/* The reference driver's calls first part */
+static const struct bcm4323x_init_call bcm4323x_attach_calls[] = {
+	BCM4323X_INIT_CONTROL(0x4b),
+	BCM4323X_INIT_CONTROL(0x4c),
+	BCM4323X_INIT_CONTROL(0x4d, 0),
+	BCM4323X_INIT_CONTROL(0x4d, 1),
+	BCM4323X_INIT_CONTROL(0x4d, 2),
+	BCM4323X_INIT_CONTROL(0x4d, 3),
+	BCM4323X_INIT_CONTROL(0x4d, 4),
+	BCM4323X_INIT_CONTROL(0x4d, 5),
+	/* the NVRAM text */
+	BCM4323X_INIT_CONTROL(0x5b),
+	BCM4323X_INIT_DATA(0x3b, 0xc0),
+	BCM4323X_INIT_DATA(0x57, 3, 3),
+	BCM4323X_INIT_CONTROL(0xa1),
+};
+
+/*
+ * Captured from the reference driver. Similar to what
+ * brcmsmac's brcms_c_init() does
+ */
+static const struct bcm4323x_init_call bcm4323x_up_calls[] = {
+	BCM4323X_INIT_DATA(0x3b, 0xc0),
+	BCM4323X_INIT_DATA(0x3c, 0),
+	BCM4323X_INIT_CONTROL(0x44),
+	{
+		.procedure = BCM4323X_RPC_PROC_STF_MODE,
+		.chip = BCM4323X_INIT_BCM4323,
+		.words = 1,
+		.body = { PHY_TXC1_MODE_CDD },
+	},
+	BCM4323X_INIT_DATA(BCM4323X_RPC_PROC_HOST_FLAGS, MHF4, 0x40, 0x40, BRCM_BAND_AUTO),
+	BCM4323X_INIT_DATA(BCM4323X_RPC_PROC_HOST_FLAGS, MHF4, 0x40, 0x40, BRCM_BAND_AUTO),
+	{ .procedure = 0x8b, .chip = BCM4323X_INIT_BCM4323, .words = 1, .body = { 1 } },
+	{ .procedure = 0x4a, .control = true, .chip = BCM4323X_INIT_BCM4323, .words = 1,
+	  .body = { 1 } },
+	BCM4323X_INIT_CONTROL(0x4a, 2),
+	BCM4323X_INIT_DATA(0x55, 0),
+	BCM4323X_INIT_DATA(0x9a, 0),
+	BCM4323X_INIT_DATA(0x0e, 1),
+	BCM4323X_INIT_CONTROL(0x5d, 8),
+	BCM4323X_INIT_CONTROL(0x6e, 3, 4, 0, 4, 4),
+	BCM4323X_INIT_DATA(0x86, 0x64),
+	BCM4323X_INIT_DATA(0x6d, 0),
+	{ .procedure = 0x68, .chip = BCM4323X_INIT_BCM43231, .words = 1, .body = { 0x7 } },
+	{ .procedure = 0x68, .chip = BCM4323X_INIT_BCM4323, .words = 1, .body = { 0xf } },
+	BCM4323X_INIT_DATA(0x85),
+	BCM4323X_INIT_DATA(BCM4323X_RPC_PROC_HOST_FLAGS, MHF5, 0x80, 0x80, BRCM_BAND_ALL),
+	BCM4323X_INIT_CONTROL(0x05),
+	/* from brcmsmac: brcms_c_up */
+	BCM4323X_INIT_DATA(BCM4323X_RPC_PROC_HOST_FLAGS, MHF1, MHF1_EDCF, MHF1_EDCF, BRCM_BAND_ALL),
+	BCM4323X_INIT_DATA(0x0a),
+	BCM4323X_INIT_DATA(0x3b, 0xc0),
+	BCM4323X_INIT_DATA(0x1a, 3),
+	BCM4323X_INIT_DATA(0x12, BCM4323X_INIT_CHANSPEC, 0),
+	BCM4323X_INIT_CONTROL(0x5e),
+	BCM4323X_INIT_CONTROL(0x60),
+};
+
+/* The reference driver's last calls, some for the LEDs */
+static const struct bcm4323x_init_call bcm4323x_finish_calls[] = {
+	BCM4323X_INIT_DATA(0x3b, 0xc0),
+	BCM4323X_INIT_DATA(0x9d, 0),
+	BCM4323X_INIT_DATA(BCM4323X_RPC_PROC_GPIO_OUT, BIT(0), 0, 1),
+	BCM4323X_INIT_DATA(BCM4323X_RPC_PROC_LED_BLINK, 1, 500, 500),
+	BCM4323X_INIT_DATA(0x88, 2),
+	{ .procedure = BCM4323X_RPC_PROC_GPIO_OUT, .chip = BCM4323X_INIT_BCM43231, .words = 3,
+	  .body = { BIT(2), BIT(2), 1 } },
+	{ .procedure = BCM4323X_RPC_PROC_GPIO_OUT, .chip = BCM4323X_INIT_BCM4323, .words = 3,
+	  .body = { BIT(2), 0, 1 } },
+	{ .procedure = BCM4323X_RPC_PROC_GPIO_OUT, .chip = BCM4323X_INIT_BCM4323, .words = 3,
+	  .body = { BIT(3), 0, 1 } },
+	BCM4323X_INIT_DATA(0x74, 1),
+};
+
+/* from brcmsmac: brcms_c_edcf_setparams */
+static const struct ieee80211_tx_queue_params bcm4323x_edcf_defaults[IEEE80211_NUM_ACS] = {
+	[IEEE80211_AC_VO] = { .txop = 0x2f, .cw_min = 3, .cw_max = 7, .aifs = 2 },
+	[IEEE80211_AC_VI] = { .txop = 0x5e, .cw_min = 7, .cw_max = 15, .aifs = 2 },
+	[IEEE80211_AC_BE] = { .cw_min = 15, .cw_max = 1023, .aifs = 3 },
+	[IEEE80211_AC_BK] = { .cw_min = 15, .cw_max = 1023, .aifs = 7 },
+};
+
+static int bcm4323x_send_init_calls(struct bcm4323x *dev, const struct bcm4323x_init_call *calls,
+				    size_t count)
+{
+	u8 chip = dev->chip->has_5ghz ? BCM4323X_INIT_BCM4323 : BCM4323X_INIT_BCM43231;
+	const struct bcm4323x_init_call *call;
+
+	for (call = calls; call < calls + count; call++) {
+		u32 body[ARRAY_SIZE(call->body)];
+		size_t length = call->words * sizeof(*body);
+		int ret;
+
+		if (call->chip && call->chip != chip)
+			continue;
+		memcpy(body, call->body, length);
+		cpu_to_le32_array(body, call->words);
+		if (call->control)
+			ret = bcm4323x_rpc_call(dev, call->procedure, body, length, NULL, 0);
+		else
+			ret = bcm4323x_rpc_send(dev, call->procedure, body, length);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/* from b43: b43_security_init and b43_clear_keys */
+static int bcm4323x_clear_keys(struct bcm4323x *dev)
+{
+	unsigned int i;
+	int ret;
+
+	/* Procedure 0x31 fills shared memory. */
+	ret = bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_SHM_FILL, BCM4323X_KEY_TABLE_BASE, 0,
+				    BCM4323X_HW_KEYS * WLAN_KEY_LEN_CCMP);
+	for (i = 0; i < BCM4323X_HW_KEYS && !ret; i++)
+		ret = bcm4323x_write_shm(dev, M_SECKINDXALGO_BLK + i * sizeof(u16), 0);
+	for (i = 0; i < BCM4323X_HW_KEYS - BCM4323X_HW_PAIRWISE_BASE && !ret; i++)
+		ret = bcm4323x_set_slot_address(dev, BCM4323X_RPC_PROC_KEY_PEER, i, NULL);
+	if (!ret)
+		ret = bcm4323x_write_reg(dev, D11REGOFFS(rcmta_size),
+					 BCM4323X_HW_KEYS - BCM4323X_HW_PAIRWISE_BASE, sizeof(u16));
+	if (!ret)
+		ret = bcm4323x_mhf(dev, MHF1, BCM4323X_MHF1_DEFKEYS, 0, BRCM_BAND_ALL);
+	return ret;
+}
+
+/*
+ * from brcmsmac: brcms_c_bandinit_ordered and brcms_c_set_phy_chanspec, without
+ * the power report
+ */
+static int bcm4323x_init_chanspec(struct bcm4323x *dev)
+{
+	struct bcm4323x_channel_data data;
+	int ret;
+
+	/* the reference driver's, with the channel first in 0x8c */
+	ret = bcm4323x_rpc_send_u32(dev, 0x8d, 1);
+	if (!ret)
+		ret = bcm4323x_rpc_send_u32(dev, 0x8c, BCM4323X_INIT_CHANNEL, 0, 1, 0);
+	bcm4323x_channel_data(dev->chip, &data, BCM4323X_INIT_CHANSPEC);
+	if (!ret)
+		ret = bcm4323x_rpc_send(dev, BCM4323X_RPC_PROC_CHANNEL_DATA, &data, sizeof(data));
+	/* The reference driver starts the BCM4323 in SISO; the first selection updates it. */
+	if (!ret && dev->chip->has_5ghz)
+		ret = bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_STF_MODE, PHY_TXC1_MODE_SISO);
+	if (!ret)
+		ret = bcm4323x_mhf(dev, MHF4, 0x40, 0x40, BRCM_BAND_AUTO);
+	return ret;
+}
+
+/*
+ * from brcmsmac: brcms_c_up and brcms_c_init, amid the reference driver's
+ * calls, which leave the firmware on channel 11
+ */
+int bcm4323x_init_mac(struct bcm4323x *dev)
+{
+	u8 *addr = dev->hw->wiphy->perm_addr;
+	u16 major, minor;
+	u32 ifs_ctl;
+	int ac;
+	int ret;
+
+	ret = bcm4323x_send_init_calls(dev, bcm4323x_attach_calls,
+				       ARRAY_SIZE(bcm4323x_attach_calls));
+	if (!ret)
+		ret = bcm4323x_rpc_call(dev, BCM4323X_RPC_PROC_MAC, NULL, 0, addr, ETH_ALEN);
+	if (ret)
+		return ret;
+	if (!is_valid_ether_addr(addr))
+		return -ENODEV;
+	ret = bcm4323x_send_init_calls(dev, bcm4323x_up_calls, ARRAY_SIZE(bcm4323x_up_calls));
+	/* from brcmsmac: brcms_c_bcn_li_upd, waking up every DTIM */
+	if (!ret)
+		ret = bcm4323x_write_shm(dev, M_BCN_LI, 0);
+	if (!ret)
+		ret = bcm4323x_clear_keys(dev);
+	/* from brcmsmac: brcms_c_set_mac and brcms_c_set_bssid */
+	if (!ret)
+		ret = bcm4323x_set_slot_address(dev, BCM4323X_RPC_PROC_RX_ADDRESS, RCM_MAC_OFFSET,
+						addr);
+	if (!ret)
+		ret = bcm4323x_ampdu_macaddr_upd(dev, addr);
+	if (!ret)
+		ret = bcm4323x_set_slot_address(dev, BCM4323X_RPC_PROC_RX_ADDRESS,
+						RCM_BSSID_OFFSET, NULL);
+	if (!ret)
+		ret = bcm4323x_init_chanspec(dev);
+	/* init probe response timeout: disabled */
+	if (!ret)
+		ret = bcm4323x_write_shm(dev, M_PRS_MAXTIME, 0);
+	/* init max burst txop (framebursting) */
+	if (!ret)
+		ret = bcm4323x_write_shm(dev, M_MBURST_TXOP, MAXFRAMEBURST_TXOP);
+	/* the reference driver's */
+	if (!ret)
+		ret = bcm4323x_rpc_send_u32(dev, 0x5a, 0);
+	/* from brcmsmac: brcms_c_duty_cycle_set, without a duty cycle limit */
+	if (!ret)
+		ret = bcm4323x_write_shm(dev, M_TX_IDLE_BUSY_RATIO_X_16_OFDM, 0);
+	if (!ret)
+		ret = bcm4323x_write_shm(dev, M_TX_IDLE_BUSY_RATIO_X_16_CCK, 0);
+	/* from brcmsmac: brcms_c_ampdu_shm_upd */
+	if (!ret)
+		ret = bcm4323x_write_shm(dev, M_MIMO_MAXSYM, MIMO_MAXSYM_MAX);
+	if (!ret)
+		ret = bcm4323x_write_shm(dev, M_WATCHDOG_8TU, WATCHDOG_8TU_MAX);
+	/* from brcmsmac: brcms_c_bsinit, with the basic rates of the default rate set */
+	if (!ret)
+		ret = bcm4323x_set_ratetable(dev, NL80211_BAND_2GHZ,
+					     GENMASK(BCM4323X_NUM_CCK_RATES - 1, 0));
+	/* Enable EDCF mode (while the MAC is suspended) */
+	if (!ret)
+		ret = bcm4323x_read_reg(dev, D11REGOFFS(ifs_ctl), sizeof(u16), &ifs_ctl);
+	if (!ret)
+		ret = bcm4323x_write_reg(dev, D11REGOFFS(ifs_ctl), ifs_ctl | IFS_USEEDCF,
+					 sizeof(u16));
+	/* from brcmsmac: brcms_c_edcf_setparams, for monitor interfaces, which get no conf_tx() */
+	for (ac = 0; ac < IEEE80211_NUM_ACS && !ret; ac++)
+		ret = bcm4323x_wme_setparams(dev, ac, &bcm4323x_edcf_defaults[ac]);
+	/* read the ucode version */
+	if (!ret)
+		ret = bcm4323x_read_shm(dev, M_BOM_REV_MAJOR, &major);
+	if (!ret)
+		ret = bcm4323x_read_shm(dev, M_BOM_REV_MINOR, &minor);
+	if (ret)
+		return ret;
+	snprintf(dev->hw->wiphy->fw_version, sizeof(dev->hw->wiphy->fw_version), "%u.%u", major,
+		 minor);
+	/* from brcmsmac: brcms_c_enable_mac */
+	ret = bcm4323x_radio_sync(dev);
+	if (!ret)
+		ret = bcm4323x_set_mac_control(dev, MCTL_WAKE, 0);
+	/* enable the RF Disable Delay timer */
+	if (!ret)
+		ret = bcm4323x_write_reg(dev, D11REGOFFS(rfdisabledly), RFDISABLE_DEFAULT,
+					 sizeof(u32));
+	/* the reference driver's */
+	if (!ret)
+		ret = bcm4323x_rpc_call(dev, BCM4323X_RPC_PROC_WATCHDOG, NULL, 0, NULL, 0);
+	if (!ret)
+		ret = bcm4323x_rpc_send(dev, BCM4323X_RPC_PROC_CHANNEL_PREP, NULL, 0);
+	if (!ret)
+		ret = bcm4323x_write_shm(dev, M_AGING_THRSH, 0x320);
+	if (!ret)
+		ret = bcm4323x_mhf(dev, MHF4, 0x20, 0x20, BRCM_BAND_ALL);
+	if (!ret)
+		ret = bcm4323x_radio_sync(dev);
+	if (!ret)
+		ret = bcm4323x_rpc_call(dev, 0x06, NULL, 0, NULL, 0);
+	if (!ret)
+		ret = bcm4323x_send_init_calls(dev, bcm4323x_finish_calls,
+					       ARRAY_SIZE(bcm4323x_finish_calls));
+	return ret;
+}
+
+int bcm4323x_register_hw(struct bcm4323x *dev)
+{
+	struct ieee80211_hw *hw = dev->hw;
+
+	INIT_DELAYED_WORK(&dev->watchdog_work, bcm4323x_watchdog_worker);
+	dev->tx_power = -1;
+	memcpy(dev->channels, bcm4323x_2ghz_channels, sizeof(bcm4323x_2ghz_channels));
+	memcpy(dev->channels + BCM4323X_NUM_2GHZ_CHANNELS, bcm4323x_5ghz_channels,
+	       sizeof(bcm4323x_5ghz_channels));
+	dev->bands[NL80211_BAND_2GHZ] = (struct ieee80211_supported_band) {
+		.channels = dev->channels,
+		.n_channels = BCM4323X_NUM_2GHZ_CHANNELS,
+		.bitrates = bcm4323x_rates,
+		.n_bitrates = BCM4323X_NUM_RATES,
+		.ht_cap = {
+			.ht_supported = true,
+			.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_SGI_20 |
+			       IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_TX_STBC |
+			       IEEE80211_HT_CAP_MAX_AMSDU | IEEE80211_HT_CAP_DSSSCCK40,
+			.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
+			.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8,
+			.mcs = {
+				.rx_mask = { 0xff, 0xff },
+				.rx_highest = cpu_to_le16(300),
+				.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
+			},
+		},
+	};
+	hw->wiphy->bands[NL80211_BAND_2GHZ] = &dev->bands[NL80211_BAND_2GHZ];
+	if (dev->chip->has_5ghz) {
+		dev->bands[NL80211_BAND_5GHZ] = (struct ieee80211_supported_band) {
+			.channels = dev->channels + BCM4323X_NUM_2GHZ_CHANNELS,
+			.n_channels = BCM4323X_NUM_5GHZ_CHANNELS,
+			.bitrates = bcm4323x_rates + BCM4323X_NUM_CCK_RATES,
+			.n_bitrates = BCM4323X_NUM_OFDM_RATES,
+			.ht_cap = dev->bands[NL80211_BAND_2GHZ].ht_cap,
+		};
+		hw->wiphy->bands[NL80211_BAND_5GHZ] = &dev->bands[NL80211_BAND_5GHZ];
+	}
+
+	hw->wiphy->available_antennas_tx = BCM4323X_ANTENNAS;
+	hw->wiphy->available_antennas_rx = BCM4323X_ANTENNAS;
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				     BIT(NL80211_IFTYPE_MONITOR);
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
+
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CAN_REPLACE_PTK0);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT);
+
+	hw->queues = IEEE80211_NUM_ACS;
+	hw->max_rates = 2;
+	hw->max_rate_tries = 1;
+	hw->txq_data_size = sizeof(struct bcm4323x_txq);
+	hw->max_listen_interval = 10;
+	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_STBC;
+
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(hw, TX_AMSDU);
+	ieee80211_hw_set(hw, TX_FRAG_LIST);
+	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, SPECTRUM_MGMT);
+	ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
+
+	SET_IEEE80211_DEV(hw, &dev->intf->dev);
+	bcm4323x_led_init(dev);
+	return ieee80211_register_hw(hw);
+}
-- 
2.53.0

