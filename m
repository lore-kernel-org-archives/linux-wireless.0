Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D79037AA83
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 04:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756545; cv=none; b=mCsY/JQdekQAAUSns40sEBvZggn3hpKPWkKggHHrLTwU+15G9+U3wOUWhBDqRu9riBmTNk0W05vY34xGEUxBHUOGF6DAv30qSEPHfcnslOsQiLqGKqqFwp8WvE2H/SZq4gZTGar3V0+kIzKkrn+tMZH8IyyZRcj7VV6p7bilezY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756545; c=relaxed/simple;
	bh=OTWeinFxhmjlwulGB8wbk3RtLZzKYIecs8IPu/kgE1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceLOA4qvelhfOtprIn5u3fqVmNiKsOQsXmim54CSJKhdBboAXQZmTmtlmuHnv02iuiLSb8SLSZK12AetwuBKkzt0qfd60K1UIfoKISklMl3sa/QqUlFiYPooIZuzArkAxMEiIjX7knJ2S5Ljx0YB+uawNA5nFQXM/AGSKQLO9EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K6LHaBEG; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K6LHaBEG"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-398b3c37877so2827030a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 21:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788756541; x=1789361341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vhyvD9fCpWqq4OsEnj3/ALyODrV7AoA0amIXqGb74Uw=;
        b=K6LHaBEGfvD7NSrNObq+EOWGeo6sTTxweKeqFb5pHaleHLbcBJfVEECBWK5ylyjxS9
         oDloHpOOm9CDG278phfhW/96oE2ZD+xi1VPrJuLpARZZ3cmxHvYm9ETffOoG8qMMWM01
         SBBtawEetTmJ9vMF10U6jXWuP16uSesImVujpBHHhnpoQEIvrKKSQK5oh2GOmF17xP9X
         mIGPyZA2/53kEKdkhMR6xLAYN0ZbfW7xG+QIaJ1o716jzNqdjttizu0tp/D1RCfDEj18
         v05x9WMU5TUHhk+ZN13TYvuG1zickLDNvn13WxAV0k1TMx5M4tzyJE1ckO06bKkxFzHF
         UaoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788756541; x=1789361341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vhyvD9fCpWqq4OsEnj3/ALyODrV7AoA0amIXqGb74Uw=;
        b=mWlUBMRlaLuwcTmaWR1nkcUp+ZCZiSFiOo8uZfMlfymqq2KtZ6VOoPC16SuiGYzosB
         Zf8/KezwBkzfXHYnhKT4X9Z3zxhY72BHxGBonyqwOg37gkV6l/2uxBQ91cWkTgXSbuIg
         /PW9xi/5Rjl1rqrVQlBZrQD2lOm49Il3OinZZrqIIWP2UIksYVLHOqiBlIlHW9nFfaZs
         1L9E7Bnr93JT75dDSrWJntrLmvyTiEC1j002YNfEvsE5YNOfnU5jfmhV2HHWvC3kr/ei
         wL9+ueeEKku7kWxip9sXw73GfymCbCHWcCqURvohdNvOdvM1Bc7TO71SuX4p5ZU6nMkK
         yXMw==
X-Gm-Message-State: AFuF++nM2x13wDbOGuqDwfXL5KJOHWurCM6hO2V6j5Ubzxt5W9cKRlAw
	5h+i9cVpAOTE4qOjhfpGQszp7Urj16jPHAOolcWgYE7K+bYq1YQSVlPm4a7MRt5wkpc=
X-Gm-Gg: AYBFou3qQyd2eI4Qx668PE/6wH7Vo3BwA3G7itPJ7+7J9ETaop+BKfAoksKn+HE78Sr
	BEIWZrh8dcVTe39sVFMLiY40+4amc7MHhyuMh6KFr5PE2irOf6CAZrQ0rTvRCehKtDL4QHIhPZ2
	YZoCqF5w4c1vg74karEm3GTei2mjo2HXRLpC/CKsp7cQ2yiaxd5oAgnRxUNTkxapjBknIO1aV+7
	VZGp/WNCk/izE7TQWup7S0tQVe6ymmyFFKvVBG+gMh56robfIdsyqY2PvP4MD4mt0pr+u1NyjFd
	GVJqPuYRlAkPayYxPwpKJ1JY1xp3b3M5vSz3+4i8hV+Ouhm+0pve9db8mn1AT4W8tuciXohsJvb
	vj0JQm1cUWuf8otNOXXzxzuRwY13234NQvUbERJjOX2qiq1CKvAdvRUrI9Qb0KKFozYh1o10KaH
	mX8PgecYFhXGaAP+OyrGAUc6dCceONYuJHmN1Fp4HtsHY8Ctur1RXDK+8Kqu42namic8pZb44qb
	82esZ69+d3FyA==
X-Received: by 2002:a17:90b:4c44:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-39b261cdb38mr29994345a91.13.1788756541037;
        Sun, 06 Sep 2026 21:49:01 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa33e96sm23834001eec.12.2026.09.06.21.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:49:00 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] wifi: rtlwifi: fix typos in comments
Date: Mon,  7 Sep 2026 10:18:51 +0530
Message-ID: <20260907044851.9884-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907044851.9884-1-hemanth.selam@gmail.com>
References: <20260907044851.9884-1-hemanth.selam@gmail.com>
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

Since v1 this is split out of a single "wifi: realtek:" patch, and the
single-line comments it touches now carry exactly one space after "/*"
and before "*/", as Ping-Ke Shih asked.  Comment blocks are left alone.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c        |  2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |  2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |  2 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  4 ++--
 drivers/net/wireless/realtek/rtlwifi/debug.h       |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.h   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/reg.h   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192d/reg.h    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192du/phy.c   |  4 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |  4 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   | 10 +++++-----
 .../net/wireless/realtek/rtlwifi/rtl8192se/reg.h   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |  4 ++--
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |  2 +-
 .../wireless/realtek/rtlwifi/rtl8723be/pwrseq.h    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/reg.h   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |  4 ++--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    | 12 ++++++------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  2 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h    |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/reg.h   | 14 +++++++-------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |  2 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  6 +++---
 41 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 9e98c01bb90e..b6dcdd03535a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1271,7 +1271,7 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 			tcb_desc->disable_ratefallback = 1;
 		} else {
 			/*
-			 *because hw will nerver use hw_rate
+			 *because hw will never use hw_rate
 			 *when tcb_desc->use_driver_rate = false
 			 *so we never set highest N rate here,
 			 *and N rate will all be controlled by FW
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index edcd3c879f7f..7bece8765c7f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -1667,7 +1667,7 @@ static void btc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 		n = 3;
 		wait_cnt = 0;
 	} else {
-		/* accquire the BT TRx retry count from BT_Info byte2 */
+		/* acquire the BT TRx retry count from BT_Info byte2 */
 		retry_cnt = coex_sta->bt_retry_cnt;
 		rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			"[BTCoex], retry_cnt = %d\n", retry_cnt);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 7a71f063015a..dac0568f6fd8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1894,7 +1894,7 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 		result = 0;
 		wait_count = 0;
 	} else {
-		/*accquire the BT TRx retry count from BT_Info byte2*/
+		/* acquire the BT TRx retry count from BT_Info byte2 */
 		retry_count = coex_sta->bt_retry_cnt;
 
 		if ((coex_sta->low_priority_tx) > 1050 ||
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index c5b8df58d4a2..e9045551e89f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1780,7 +1780,7 @@ static void btc8821a2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 		result = 0;
 		wait_count = 0;
 	} else {
-		/* accquire the BT TRx retry count from BT_Info byte2 */
+		/* acquire the BT TRx retry count from BT_Info byte2 */
 		retry_count = coex_sta->bt_retry_cnt;
 		rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			"[BTCoex], retry_count = %d\n", retry_count);
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 22633c301564..e971132fee14 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -608,7 +608,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
 			/* sleep here is must, or we may recv the beacon and
 			 * cause mac80211 into wrong ps state, this will cause
 			 * power save nullfunc send fail, and further cause
-			 * pkt loss, So sleep must quickly but not immediatly
+			 * pkt loss, So sleep must quickly but not immediately
 			 * because that will cause nullfunc send by mac80211
 			 * fail, and cause pkt loss, we have tested that 5mA
 			 * is worked very well */
@@ -1711,7 +1711,7 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
 }
 
 /* this function is called by mac80211 to flush tx buffer
- * before switch channle or power save, or tx buffer packet
+ * before switch channel or power save, or tx buffer packet
  * maybe send after offchannel or rf sleep, this may cause
  * dis-association by AP */
 static void rtl_op_flush(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index 1c0bcf8ec1a9..afed6ac36afc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -18,7 +18,7 @@
 /*#define DBG_EMERG			0 */
 
 /*
- *Abnormal, rare, or unexpeted cases.
+ *Abnormal, rare, or unexpected cases.
  *For example, Packet/IO Ctl canceled,
  *device suprisely unremoved and so on.
  */
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
index f749d19ec5f5..d9132d90feb1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
@@ -879,7 +879,7 @@ static void dm_txpower_track_cb_therm(struct ieee80211_hw *hw)
 		{0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 25, 25, 25}
 	};
 
-	/*Initilization (7 steps in total) */
+	/* Initialization (7 steps in total) */
 	rtlpriv->dm.txpower_trackinginit = true;
 	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 		"%s\n", __func__);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 53c32e1de7e4..321c395f85e5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1090,7 +1090,7 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 	rtl88e_phy_mac_config(hw);
 	/* because last function modify RCR, so we update
 	 * rcr var here, or TP will unstable for receive_config
-	 * is wrong, RX RCR_ACRC32 will cause TP unstabel & Rx
+	 * is wrong, RX RCR_ACRC32 will cause TP unstable & Rx
 	 * RCR_APP_ICV will cause mac80211 unassoc for cisco 1252
 	 */
 	rtlpci->receive_config &= ~(RCR_ACRC32 | RCR_AICV);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 0fab3a0c7d49..754ca8549c76 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -1891,7 +1891,7 @@ static void _rtl88e_phy_set_rfpath_switch(struct ieee80211_hw *hw,
 		rtl_set_bbreg(hw, 0x914, MASKLWORD, 0x0201);
 
 		/* We use the RF definition of MAIN and AUX,
-		 * left antenna and right antenna repectively.
+		 * left antenna and right antenna respectively.
 		 * Default output at AUX.
 		 */
 		if (bmain) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
index 8157ef419eeb..3fef46e67501 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
@@ -5,7 +5,7 @@
 #define __RTL92C_PHY_H__
 
 /* MAX_TX_COUNT must always set to 4, otherwise read efuse
- * table secquence will be wrong.
+ * table sequence will be wrong.
  */
 #define		MAX_TX_COUNT				4
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
index 42e222c1795f..d34c50a4285e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
@@ -14,7 +14,7 @@
  *	4: LPS--Low Power State
  *	5: SUS--Suspend
  *
- *	The transision from different states are defined below
+ *	The transition from different states are defined below
  *	TRANS_CARDEMU_TO_ACT
  *	TRANS_ACT_TO_CARDEMU
  *	TRANS_CARDEMU_TO_SUS
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
index 0fc8db8916fa..d23da11c2f8e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
@@ -609,7 +609,7 @@
 #define	HWSET_MAX_SIZE				512
 #define   EFUSE_MAX_SECTION			64
 #define   EFUSE_REAL_CONTENT_LEN			256
-/* PG data exclude header, dummy 7 bytes frome CP test and reserved 1byte.*/
+/* PG data exclude header, dummy 7 bytes from CP test and reserved 1byte. */
 #define		EFUSE_OOB_PROTECT_BYTES		18
 
 #define	EEPROM_DEFAULT_TSSI					0x0
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index d094163a9a71..ce19b09e36be 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -432,7 +432,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 
 	/* hw will set status->decrypted true, if it finds the
 	 * frame is open data frame or mgmt frame.
-	 * So hw will not decryption robust managment frame
+	 * So hw will not decryption robust management frame
 	 * for IEEE80211w but still set status->decrypted
 	 * true, so here we should set it back to undecrypted
 	 * for IEEE80211w frame, and mac80211 sw will help
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index 4354ae67a379..942ffea27547 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -952,7 +952,7 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 	rtl92c_phy_mac_config(hw);
 	/* because last function modify RCR, so we update
 	 * rcr var here, or TP will unstable for receive_config
-	 * is wrong, RX RCR_ACRC32 will cause TP unstabel & Rx
+	 * is wrong, RX RCR_ACRC32 will cause TP unstable & Rx
 	 * RCR_APP_ICV will cause mac80211 unassoc for cisco 1252*/
 	rtlpci->receive_config = rtl_read_dword(rtlpriv, REG_RCR);
 	rtlpci->receive_config &= ~(RCR_ACRC32 | RCR_AICV);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index ed151754fc6e..99472053ccff 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -302,7 +302,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 
 	/* hw will set stats->decrypted true, if it finds the
 	 * frame is open data frame or mgmt frame.
-	 * So hw will not decryption robust managment frame
+	 * So hw will not decryption robust management frame
 	 * for IEEE80211w but still set status->decrypted
 	 * true, so here we should set it back to undecrypted
 	 * for IEEE80211w frame, and mac80211 sw will help
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/reg.h
index b5b906b799cb..639aa0d92e05 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/reg.h
@@ -1051,7 +1051,7 @@
 /* 2. 0x800/0x900/0xA00/0xC00/0xD00/0xE00 */
 /* 3. RF register 0x00-2E */
 /* 4. Bit Mask for BB/RF register */
-/* 5. Other defintion for BB/RF R/W */
+/* 5. Other definition for BB/RF R/W */
 
 /* 3. Page8(0x800) */
 #define	RFPGA0_RFMOD				0x800
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index 03f4314bdb2e..d7f48f2bde7a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -644,7 +644,7 @@ int rtl92de_hw_init(struct ieee80211_hw *hw)
 	rtl92d_phy_mac_config(hw);
 	/* because last function modify RCR, so we update
 	 * rcr var here, or TP will unstable for receive_config
-	 * is wrong, RX RCR_ACRC32 will cause TP unstabel & Rx
+	 * is wrong, RX RCR_ACRC32 will cause TP unstable & Rx
 	 * RCR_APP_ICV will cause mac80211 unassoc for cisco 1252*/
 	rtlpci->receive_config = rtl_read_dword(rtlpriv, REG_RCR);
 	rtlpci->receive_config &= ~(RCR_ACRC32 | RCR_AICV);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/phy.c
index 8c2167cc1f13..fe3af3e8e345 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/phy.c
@@ -764,7 +764,7 @@ static void _rtl92du_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 		    rtlhal->interfaceindex == 1) {
 			need_pwr_down = rtl92du_phy_enable_anotherphy(hw, false);
 			rtlhal->during_mac1init_radioa = true;
-			/* asume no this case */
+			/* assume no this case */
 			if (need_pwr_down)
 				rtl92d_phy_enable_rf_env(hw, path,
 							 &u4regvalue);
@@ -2248,7 +2248,7 @@ static void _rtl92du_phy_reload_lck_setting(struct ieee80211_hw *hw, u8 channel)
 			bneed_powerdown_radio =
 				rtl92du_phy_enable_anotherphy(hw, false);
 			rtlpriv->rtlhal.during_mac1init_radioa = true;
-			/* asume no this case */
+			/* assume no this case */
 			if (bneed_powerdown_radio)
 				rtl92d_phy_enable_rf_env(hw, erfpath,
 							 &u4regvalue);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 88b7a715f4c5..3728e3ec2c25 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -762,7 +762,7 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 	}
 }
 
-/*Shoud check FW support p2p or not.*/
+/* Should check FW support p2p or not. */
 static void rtl92ee_set_p2p_ctw_period_cmd(struct ieee80211_hw *hw, u8 ctwindow)
 {
 	u8 u1_ctwindow_period[1] = {ctwindow};
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index 1e7f0cd1c86e..2435d457e520 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -2733,7 +2733,7 @@ static void _rtl92ee_phy_set_rfpath_switch(struct ieee80211_hw *hw,
 		rtl_set_bbreg(hw, 0x914, MASKLWORD, 0x0201);
 
 		/* We use the RF definition of MAIN and AUX,
-		 * left antenna and right antenna repectively.
+		 * left antenna and right antenna respectively.
 		 * Default output at AUX.
 		 */
 		if (bmain) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
index 2ae8347f7ebb..09f12b5a41ba 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
@@ -15,7 +15,7 @@
  *	4: LPS--Low Power State
  *	5: SUS--Suspend
  *
- *	The transision from different states are defined below
+ *	The transition from different states are defined below
  *	TRANS_CARDEMU_TO_ACT
  *	TRANS_ACT_TO_CARDEMU
  *	TRANS_CARDEMU_TO_SUS
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 16589e18494b..658591badd8e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -385,7 +385,7 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 
 	/* hw will set status->decrypted true, if it finds the
 	 * frame is open data frame or mgmt frame.
-	 * So hw will not decryption robust managment frame
+	 * So hw will not decryption robust management frame
 	 * for IEEE80211w but still set status->decrypted
 	 * true, so here we should set it back to undecrypted
 	 * for IEEE80211w frame, and mac80211 sw will help
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index e5775b94f04e..272c1b3b576d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -982,7 +982,7 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 	/* because last function modify RCR, so we update
 	 * rcr var here, or TP will unstable for receive_config
-	 * is wrong, RX RCR_ACRC32 will cause TP unstabel & Rx
+	 * is wrong, RX RCR_ACRC32 will cause TP unstable & Rx
 	 * RCR_APP_ICV will cause mac80211 unassoc for cisco 1252
 	 */
 	rtlpci->receive_config = rtl_read_dword(rtlpriv, RCR);
@@ -2367,7 +2367,7 @@ bool rtl92se_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
 }
 
 /* Is_wepkey just used for WEP used as group & pairwise key
- * if pairwise is AES ang group is WEP Is_wepkey == false.*/
+ * if pairwise is AES and group is WEP Is_wepkey == false.*/
 void rtl92se_set_key(struct ieee80211_hw *hw, u32 key_index, u8 *p_macaddr,
 	bool is_group, u8 enc_algo, bool is_wepkey, bool clear_all)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index d9ef7e1da1db..11e783f9b4c2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -689,7 +689,7 @@ static void _rtl92s_phy_init_register_definition(struct ieee80211_hw *hw)
 	rtlphy->phyreg_def[RF90_PATH_C].rfintfe = RFPGA0_XC_RFINTERFACEOE;
 	rtlphy->phyreg_def[RF90_PATH_D].rfintfe = RFPGA0_XD_RFINTERFACEOE;
 
-	/* Addr of LSSI. Wirte RF register by driver */
+	/* Addr of LSSI. Write RF register by driver */
 	rtlphy->phyreg_def[RF90_PATH_A].rf3wire_offset =
 						 RFPGA0_XA_LSSIPARAMETER;
 	rtlphy->phyreg_def[RF90_PATH_B].rf3wire_offset =
@@ -711,13 +711,13 @@ static void _rtl92s_phy_init_register_definition(struct ieee80211_hw *hw)
 	rtlphy->phyreg_def[RF90_PATH_C].rftxgain_stage = RFPGA0_TXGAINSTAGE;
 	rtlphy->phyreg_def[RF90_PATH_D].rftxgain_stage = RFPGA0_TXGAINSTAGE;
 
-	/* Tranceiver A~D HSSI Parameter-1 */
+	/* Transceiver A~D HSSI Parameter-1 */
 	rtlphy->phyreg_def[RF90_PATH_A].rfhssi_para1 = RFPGA0_XA_HSSIPARAMETER1;
 	rtlphy->phyreg_def[RF90_PATH_B].rfhssi_para1 = RFPGA0_XB_HSSIPARAMETER1;
 	rtlphy->phyreg_def[RF90_PATH_C].rfhssi_para1 = RFPGA0_XC_HSSIPARAMETER1;
 	rtlphy->phyreg_def[RF90_PATH_D].rfhssi_para1 = RFPGA0_XD_HSSIPARAMETER1;
 
-	/* Tranceiver A~D HSSI Parameter-2 */
+	/* Transceiver A~D HSSI Parameter-2 */
 	rtlphy->phyreg_def[RF90_PATH_A].rfhssi_para2 = RFPGA0_XA_HSSIPARAMETER2;
 	rtlphy->phyreg_def[RF90_PATH_B].rfhssi_para2 = RFPGA0_XB_HSSIPARAMETER2;
 	rtlphy->phyreg_def[RF90_PATH_C].rfhssi_para2 = RFPGA0_XC_HSSIPARAMETER2;
@@ -765,13 +765,13 @@ static void _rtl92s_phy_init_register_definition(struct ieee80211_hw *hw)
 	rtlphy->phyreg_def[RF90_PATH_C].rftx_afe = ROFDM0_XCTXAFE;
 	rtlphy->phyreg_def[RF90_PATH_D].rftx_afe = ROFDM0_XDTXAFE;
 
-	/* Tranceiver LSSI Readback */
+	/* Transceiver LSSI Readback */
 	rtlphy->phyreg_def[RF90_PATH_A].rf_rb = RFPGA0_XA_LSSIREADBACK;
 	rtlphy->phyreg_def[RF90_PATH_B].rf_rb = RFPGA0_XB_LSSIREADBACK;
 	rtlphy->phyreg_def[RF90_PATH_C].rf_rb = RFPGA0_XC_LSSIREADBACK;
 	rtlphy->phyreg_def[RF90_PATH_D].rf_rb = RFPGA0_XD_LSSIREADBACK;
 
-	/* Tranceiver LSSI Readback PI mode  */
+	/* Transceiver LSSI Readback PI mode */
 	rtlphy->phyreg_def[RF90_PATH_A].rf_rbpi = TRANSCEIVERA_HSPI_READBACK;
 	rtlphy->phyreg_def[RF90_PATH_B].rf_rbpi = TRANSCEIVERB_HSPI_READBACK;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
index 45f968e0e57c..bd43d91bc146 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
@@ -303,7 +303,7 @@
 
 #define	RPWM					PCI_RPWM
 
-/* Regsiter Bit and Content definition  */
+/* Register Bit and Content definition */
 
 #define	ISO_MD2PP				BIT(0)
 #define	ISO_PA2PCIE				BIT(3)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
index f104cdb649f8..b057d035a3a8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
@@ -276,7 +276,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 
 	/* hw will set stats->decrypted true, if it finds the
 	 * frame is open data frame or mgmt frame,
-	 * hw will not decrypt robust managment frame
+	 * hw will not decrypt robust management frame
 	 * for IEEE80211w but still set stats->decrypted
 	 * true, so here we should set it back to undecrypted
 	 * for IEEE80211w frame, and mac80211 sw will help
@@ -466,7 +466,7 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		/* Alwasy enable all rate fallback range */
 		set_tx_desc_data_rate_fb_limit(pdesc, 0x1F);
 
-		/* Fix: I don't kown why hw use 6.5M to tx when set it */
+		/* Fix: I don't known why hw use 6.5M to tx when set it */
 		set_tx_desc_user_rate(pdesc,
 				      ptcb_desc->use_driver_rate ? 1 : 0);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
index b34dffc6a30c..b36f958a7363 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
@@ -889,7 +889,7 @@ void rtl8723e_dm_bt_set_bt_dm(struct ieee80211_hw *hw,
 
 	/* Note:
 	 * We should add delay for making sure
-	 *	sw DacSwing can be set sucessfully.
+	 *	sw DacSwing can be set successfully.
 	 * because of that rtl8723e_dm_bt_set_fw_2_ant_hid()
 	 *	and rtl8723e_dm_bt_set_fw_tdma_ctrl()
 	 * will overwrite the reg 0x880.
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
index d9247a8f3039..4835fb17c5e1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
@@ -15,7 +15,7 @@
  *	4: LPS--Low Power State
  *	5: SUS--Suspend
  *
- *	The transision from different states are defined below
+ *	The transition from different states are defined below
  *	TRANS_CARDEMU_TO_ACT
  *	TRANS_ACT_TO_CARDEMU
  *	TRANS_CARDEMU_TO_SUS
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index 65bfc14702f4..f40b0efebe3a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -305,7 +305,7 @@ bool rtl8723e_rx_query_desc(struct ieee80211_hw *hw,
 
 	/* hw will set status->decrypted true, if it finds the
 	 * frame is open data frame or mgmt frame.
-	 * So hw will not decryption robust managment frame
+	 * So hw will not decryption robust management frame
 	 * for IEEE80211w but still set status->decrypted
 	 * true, so here we should set it back to undecrypted
 	 * for IEEE80211w frame, and mac80211 sw will help
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
index c65d14fb914f..82e6202fca38 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
@@ -742,7 +742,7 @@ static void rtl8723be_dm_txpower_tracking_callback_thermalmeter(
 		5, 6, 6, 6, 6, 7, 7, 7, 8, 8,  9,
 		9, 10, 10, 11, 12, 13, 14, 15};
 
-	/*Initilization ( 7 steps in total )*/
+	/* Initialization ( 7 steps in total ) */
 	rtlpriv->dm.txpower_trackinginit = true;
 	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 		"%s\n", __func__);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h
index 57eac4864184..94f7ab48cab2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h
@@ -15,7 +15,7 @@
  *	4: LPS--Low Power State
  *	5: SUS--Suspend
  *
- *	The transision from different states are defined below
+ *	The transition from different states are defined below
  *	TRANS_CARDEMU_TO_ACT
  *	TRANS_ACT_TO_CARDEMU
  *	TRANS_CARDEMU_TO_SUS
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h
index 28fd22b2a792..35c96d33e8e0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h
@@ -603,7 +603,7 @@
 #define EFUSE_MAX_SECTION		64
 #define EFUSE_REAL_CONTENT_LEN		256
 #define EFUSE_OOB_PROTECT_BYTES		18 /* PG data exclude header,
-					    * dummy 7 bytes frome CP test
+					    * dummy 7 bytes from CP test
 					    * and reserved 1byte.
 					    */
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index 8b6352f7f93b..b6029bfaedac 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -220,7 +220,7 @@ static void _rtl8723be_translate_rx_signal_stuff(struct ieee80211_hw *hw,
 	    (ether_addr_equal(praddr, rtlefuse->dev_addr));
 
 	/* YP: packet_beacon is not initialized,
-	 * this assignment is neccesary,
+	 * this assignment is necessary,
 	 * otherwise it counld be true in this case
 	 * the situation is much worse in Kernel 3.10
 	 */
@@ -360,7 +360,7 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 
 	/* hw will set status->decrypted true, if it finds the
 	 * frame is open data frame or mgmt frame.
-	 * So hw will not decryption robust managment frame
+	 * So hw will not decryption robust management frame
 	 * for IEEE80211w but still set status->decrypted
 	 * true, so here we should set it back to undecrypted
 	 * for IEEE80211w frame, and mac80211 sw will help
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index f8b159c74658..0e8547a29f0a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -1150,7 +1150,7 @@ u8 rtl8821ae_hw_rate_to_mrate(struct ieee80211_hw *hw, u8 rate)
 /*-----------------------------------------------------------------------------
  * Function:	odm_TxPwrTrackSetPwr88E()
  *
- * Overview:	88E change all channel tx power accordign to flag.
+ * Overview:	88E change all channel tx power according to flag.
  *				OFDM & CCK are all different.
  *
  * Input:		NONE
@@ -1459,7 +1459,7 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 	const u8 *delta_swing_table_idx_tup_b;
 	const u8 *delta_swing_table_idx_tdown_b;
 
-	/*2. Initialization ( 7 steps in total )*/
+	/* 2. Initialization ( 7 steps in total ) */
 	rtl8812ae_get_delta_swing_table(hw,
 		&delta_swing_table_idx_tup_a,
 		&delta_swing_table_idx_tdown_a,
@@ -1546,7 +1546,7 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 
 	if (delta > 0 && rtldm->txpower_track_control) {
 		/* "delta" here is used to record the
-		 * absolute value of differrence.
+		 * absolute value of difference.
 		 */
 		delta = thermal_value > rtlefuse->eeprom_thermalmeter ?
 			(thermal_value - rtlefuse->eeprom_thermalmeter) :
@@ -1829,7 +1829,7 @@ static void rtl8821ae_get_delta_swing_table(struct ieee80211_hw *hw,
 /*-----------------------------------------------------------------------------
  * Function:	odm_TxPwrTrackSetPwr88E()
  *
- * Overview:	88E change all channel tx power accordign to flag.
+ * Overview:	88E change all channel tx power according to flag.
  *				OFDM & CCK are all different.
  *
  * Input:		NONE
@@ -2029,7 +2029,7 @@ void rtl8821ae_dm_txpower_tracking_callback_thermalmeter(
 	const u8 *delta_swing_table_idx_tup_a;
 	const u8 *delta_swing_table_idx_tdown_a;
 
-	/*2. Initilization ( 7 steps in total )*/
+	/* 2. Initialization ( 7 steps in total ) */
 	rtl8821ae_get_delta_swing_table(hw,
 					&delta_swing_table_idx_tup_a,
 					&delta_swing_table_idx_tdown_a);
@@ -2111,7 +2111,7 @@ void rtl8821ae_dm_txpower_tracking_callback_thermalmeter(
 
 	if (delta > 0 && rtldm->txpower_track_control) {
 		/*"delta" here is used to record the
-		 * absolute value of differrence.
+		 * absolute value of difference.
 		 */
 		delta = thermal_value > rtlefuse->eeprom_thermalmeter ?
 			(thermal_value - rtlefuse->eeprom_thermalmeter) :
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 1ae56e15ca7f..4facbc0bff4e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -654,7 +654,7 @@ void rtl8821ae_set_fw_keep_alive_cmd(struct ieee80211_hw *hw,
 	rtl_dbg(rtlpriv, COMP_POWER, DBG_LOUD, "Enable(%d)\n", func_en);
 
 	SET_8812_H2CCMD_KEEP_ALIVE_ENABLE(keep_alive_info, func_en);
-	/* 1: the period is controled by driver, 0: by Fw default */
+	/* 1: the period is controlled by driver, 0: by Fw default */
 	SET_8812_H2CCMD_KEEP_ALIVE_ACCPEPT_USER_DEFINED(keep_alive_info, 1);
 	SET_8812_H2CCMD_KEEP_ALIVE_PERIOD(keep_alive_info, 10); /* 10 sec */
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 1ba53e671207..98d9bf370079 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1019,7 +1019,7 @@ static void _rtl8821ae_hw_configure(struct ieee80211_hw *hw)
 	/* ARFB table 12 for 11ac 24G 1SS */
 	rtl_write_dword(rtlpriv, REG_ARFR3, 0x00000015);
 	rtl_write_dword(rtlpriv, REG_ARFR3 + 4, 0xffcff000);
-	/* 0x420[7] = 0 , enable retry AMPDU in new AMPD not singal MPDU. */
+	/* 0x420[7] = 0 , enable retry AMPDU in new AMPD not signal MPDU. */
 	rtl_write_word(rtlpriv, REG_FWHW_TXQ_CTRL, 0x1F00);
 	rtl_write_byte(rtlpriv, REG_AMPDU_MAX_TIME, 0x70);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
index d6f3cbab4abc..7297733c7710 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
@@ -343,7 +343,7 @@ extern struct wlan_pwr_cfg  rtl8812_leave_lps_flow
  *	4: LPS--Low Power State
  *	5: SUS--Suspend
  *
- *	The transision from different states are defined below
+ *	The transition from different states are defined below
  *	TRANS_CARDEMU_TO_ACT
  *	TRANS_ACT_TO_CARDEMU
  *	TRANS_CARDEMU_TO_SUS
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
index 7d833b72c7ed..ceddd72e2581 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
@@ -631,7 +631,7 @@
 #define	HWSET_MAX_SIZE				512
 #define   EFUSE_MAX_SECTION			64
 #define   EFUSE_REAL_CONTENT_LEN		256
-/* PG data exclude header, dummy 7 bytes frome CP test and reserved 1byte.*/
+/* PG data exclude header, dummy 7 bytes from CP test and reserved 1byte. */
 #define		EFUSE_OOB_PROTECT_BYTES		18
 
 #define	EEPROM_DEFAULT_TSSI			0x0
@@ -1523,7 +1523,7 @@
 #define	ROFDM0_TXCOEFF5			0xcb4
 #define	ROFDM0_TXCOEFF6			0xcb8
 
-/*Path_A RFE cotrol */
+/* Path_A RFE control */
 #define	RA_RFE_CTRL_8812		0xcb8
 /*Path_B RFE control*/
 #define	RB_RFE_CTRL_8812		0xeb8
@@ -2336,7 +2336,7 @@
 
 #define	REG_UN_used_register		0x01bf
 
-/* Path_A RFE cotrol pinmux*/
+/* Path_A RFE control pinmux */
 #define		RA_RFE_PINMUX		0xcb0
 /* Path_B RFE control pinmux*/
 #define		RB_RFE_PINMUX		0xeb0
@@ -2345,17 +2345,17 @@
 #define		RB_RFE_INV		0xeb4
 
 /* RXIQC */
-/*RxIQ imblance matrix coeff. A & B*/
+/* RxIQ imbalance matrix coeff. A & B */
 #define RA_RXIQC_AB			0xc10
-/*RxIQ imblance matrix coeff. C & D*/
+/* RxIQ imbalance matrix coeff. C & D */
 #define	RA_RXIQC_CD			0xc14
 /* Pah_A TX scaling factor*/
 #define	RA_TXSCALE			0xc1c
 /* Path_B TX scaling factor*/
 #define	RB_TXSCALE			0xe1c
-/*RxIQ imblance matrix coeff. A & B*/
+/* RxIQ imbalance matrix coeff. A & B */
 #define	RB_RXIQC_AB			0xe10
-/*RxIQ imblance matrix coeff. C & D*/
+/* RxIQ imbalance matrix coeff. C & D */
 #define	RB_RXIQC_CD			0xe14
 /*bit mask for IQC matrix element A & C*/
 #define	RXIQC_AC			0x02ff
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index bd71592fe26a..12a8341d2f1c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -512,7 +512,7 @@ bool rtl8821ae_rx_query_desc(struct ieee80211_hw *hw,
 
 	/* hw will set status->decrypted true, if it finds the
 	 * frame is open data frame or mgmt frame.
-	 * So hw will not decryption robust managment frame
+	 * So hw will not decryption robust management frame
 	 * for IEEE80211w but still set status->decrypted
 	 * true, so here we should set it back to undecrypted
 	 * for IEEE80211w frame, and mac80211 sw will help
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 9a64df9eed39..d013e5986948 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -43,7 +43,7 @@ static void _usbctrl_vendorreq_sync(struct usb_device *udev, u8 reqtype,
 					 reqtype, value, REALTEK_USB_VENQT_CMD_IDX,
 					 pdata, len, 1000);
 		if (status < 0) {
-			/* firmware download is checksumed, don't retry */
+			/* firmware download is checksummed, don't retry */
 			if ((value >= FW_8192C_START_ADDRESS &&
 			    value <= FW_8192C_END_ADDRESS))
 				break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index f1830ddcdd8c..23697704ffee 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -744,7 +744,7 @@ enum rtl_var_map {
 	RTL_IMR_BDOK,		/*Beacon Queue DMA OK Interrup */
 	RTL_IMR_HIGHDOK,	/*High Queue DMA OK Interrupt */
 	RTL_IMR_COMDOK,		/*Command Queue DMA OK Interrupt*/
-	RTL_IMR_TBDOK,		/*Transmit Beacon OK interrup */
+	RTL_IMR_TBDOK,		/* Transmit Beacon OK interrupt */
 	RTL_IMR_MGNTDOK,	/*Management Queue DMA OK Interrupt */
 	RTL_IMR_TBDER,		/*For 92C,Transmit Beacon Error Interrupt */
 	RTL_IMR_BKDOK,		/*AC_BK DMA OK Interrupt */
@@ -2693,7 +2693,7 @@ struct rtl_priv {
 	int max_fw_size;
 
 	/* hal_cfg : for diff cards
-	 * intf_ops : for diff interrface usb/pcie
+	 * intf_ops : for diff interface usb/pcie
 	 */
 	const struct rtl_hal_cfg *cfg;
 	const struct rtl_intf_ops *intf_ops;
@@ -2841,7 +2841,7 @@ enum bt_radio_shared {
 #define	RT_RF_PS_LEVEL_ALWAYS_ASPM	BIT(6)
 /* no matter RFOFF or SLEEP we set PS_ASPM_LEVL*/
 #define	RT_PS_LEVEL_ASPM		BIT(7)
-/*When LPS is on, disable 2R if no packet is received or transmittd.*/
+/* When LPS is on, disable 2R if no packet is received or transmitted. */
 #define	RT_RF_LPS_DISALBE_2R		BIT(30)
 #define	RT_RF_LPS_LEVEL_ASPM		BIT(31)	/*LPS with ASPM */
 #define	RT_IN_PS_LEVEL(ppsc, _ps_flg)		\
