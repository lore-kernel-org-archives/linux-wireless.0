Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAA3311973
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 15:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991917; cv=none; b=eMO4VlzEt35d2393i9SfYtT9NfduY8BdK/2yUNwylRPvMVcyfwKwLdFw/n44mwIbjCKe93TlBbthAURTIKlSMt9b49BjkLfjqYsP894fBqxd69FaLDBMsQQQlbmLgwHMy06pBz/gt73byzcHH3dPG5G0aj5/hzRgtkVoKx6nMKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991917; c=relaxed/simple;
	bh=vgM08NrAE9TlDEJZ5tJ8HWawfu8k4tIcRJkpqjYuA/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3NkEArvSIdZWdfADodPDoZ69wIV9TiJLsHYTppDRKjNC0RuPuUTmDOASEy0OfQCsHm8GDJfAwW94w1eZTKFoc06ydgODqzRLTlnRwIxVlOZ0OEbmeGjc2je1ruXVMHOiwQxsUyb1+SpStD6Rv3uUXeWfTjWW95M+0dSeHpBY4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MRuUsJyg; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MRuUsJyg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784991909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m28sztYDzqde2Ce97j3YDvGo94KxPFT6h2Wy/q/fR2M=;
	b=MRuUsJygVQrW/Hk/GWSMp7+/h6HXmTeLePdBoEmO5aUSqr1iy6D6WWwFh5UL9odtleSRm7
	86Ol7+co5cBEzywFQG6vqYgYaihQfCo8kyKx0jPN+z/T4HXlB4TaZ/ZrvgVIX90Z2m8ier
	EFEJkADfKh1F+J1Mc94vfIdUrN+rQTI=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 11/11] wifi: rtw88: run the RTL8723BS association register sequence
Date: Sat, 25 Jul 2026 17:04:27 +0200
Message-ID: <20260725150427.93887-12-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-1-luka.gejak@linux.dev>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The RTL8723BS firmware does not derive the BSS parameters itself. The
vendor start_clnt_join() programs them directly around authentication,
and without that the station either fails to authenticate or is dropped
by the AP shortly after associating.

Reproduce that sequence: restrict the receive filter to the target BSSID
for the join window, program the basic and response rates from the BSS
rate elements, apply the preamble and slot time from the BSS capability,
enable TSF update, and wait for a beacon from the target before sending
the authentication frame. Restore the receive filter and response rates
on disconnect.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 496 +++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/main.h     |   2 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   2 +
 drivers/net/wireless/realtek/rtw88/sec.h      |   1 +
 4 files changed, 498 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index ff0f4f0bdc7b..2bb969e88381 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -46,6 +46,432 @@ void rtw8723bs_auth_sync_rx(struct rtw_dev *rtwdev,
 }
 EXPORT_SYMBOL(rtw8723bs_auth_sync_rx);
 
+/* ---- 8723BS SDIO association sequence (vendor start_clnt_join) ---- */
+
+#define RTW8723BS_JOIN_RETRY_LIMIT		0x30
+#define RTW8723BS_AUTH_SYNC_WAIT_FALLBACK_MS	120
+#define RTW8723BS_AUTH_SYNC_WAIT_MIN_MS		80
+#define RTW8723BS_AUTH_SYNC_WAIT_MAX_MS		160
+#define RTW8723BS_ACK_PREAMBLE_SHORT		BIT(7)
+#define RTW8723BS_SHORT_SLOT_TIME		9
+#define RTW8723BS_LONG_SLOT_TIME		20
+#define RTW8723BS_RRSR_1M			BIT(0)
+#define RTW8723BS_RRSR_2M			BIT(1)
+#define RTW8723BS_RRSR_5_5M			BIT(2)
+#define RTW8723BS_RRSR_11M			BIT(3)
+#define RTW8723BS_RRSR_6M			BIT(4)
+#define RTW8723BS_RRSR_9M			BIT(5)
+#define RTW8723BS_RRSR_12M			BIT(6)
+#define RTW8723BS_RRSR_18M			BIT(7)
+#define RTW8723BS_RRSR_24M			BIT(8)
+#define RTW8723BS_RRSR_36M			BIT(9)
+#define RTW8723BS_RRSR_48M			BIT(10)
+#define RTW8723BS_RRSR_54M			BIT(11)
+#define RTW8723BS_RRSR_CCK_RATES \
+	(RTW8723BS_RRSR_1M | RTW8723BS_RRSR_2M | \
+	 RTW8723BS_RRSR_5_5M | RTW8723BS_RRSR_11M)
+#define RTW8723BS_RRSR_2G_FORCE			RTW8723BS_RRSR_CCK_RATES
+#define RTW8723BS_RRSR_2G_ALLOW \
+	(RTW8723BS_RRSR_CCK_RATES | RTW8723BS_RRSR_6M | \
+	 RTW8723BS_RRSR_12M | RTW8723BS_RRSR_24M)
+
+/* Keep the RCR at the vendor target-only state (AMF + CBSSID) across the whole
+ * connect window, matching the vendor STA path. accept_all is kept only for the
+ * caller's intent; both paths converge the filter to target-only.
+ */
+static void rtw8723bs_auth_rx_filter(struct rtw_dev *rtwdev, bool accept_all)
+{
+	rtwdev->hal.rcr |= BIT_AMF | BIT_CBSSID_DATA | BIT_CBSSID_BCN;
+	rtwdev->hal.rcr &= ~BIT_AAP;
+	rtw_write32(rtwdev, REG_RCR, rtwdev->hal.rcr);
+}
+
+static void rtw8723bs_config_sec_cfg(struct rtw_dev *rtwdev)
+{
+	u16 sec = rtw_read16(rtwdev, RTW_SEC_CONFIG);
+
+	sec |= RTW_SEC_CHK_KEYID | RTW_SEC_TX_DEC_EN | RTW_SEC_RX_DEC_EN;
+	rtw_write16(rtwdev, RTW_SEC_CONFIG, sec);
+}
+
+static void rtw8723bs_config_default_key_search(struct rtw_dev *rtwdev,
+						bool enable)
+{
+	u16 sec = rtw_read16(rtwdev, RTW_SEC_CONFIG);
+
+	if (enable)
+		sec |= RTW_SEC_TX_BC_USE_DK | RTW_SEC_TX_UNI_USE_DK |
+		       RTW_SEC_RX_UNI_USE_DK;
+	else
+		sec &= ~(RTW_SEC_TX_UNI_USE_DK | RTW_SEC_RX_UNI_USE_DK |
+			 RTW_SEC_TX_BC_USE_DK | RTW_SEC_RX_BC_USE_DK);
+	rtw_write16(rtwdev, RTW_SEC_CONFIG, sec);
+}
+
+static void rtw8723bs_enable_tsf_update(struct rtw_dev *rtwdev)
+{
+	rtw_write8_clr(rtwdev, REG_BCN_CTRL, BIT_DIS_TSF_UDT);
+}
+
+static void rtw8723bs_set_ack_preamble(struct rtw_dev *rtwdev,
+				       bool short_preamble)
+{
+	u8 val = rtw_read8(rtwdev, REG_RRSR + 2) & ~RTW8723BS_ACK_PREAMBLE_SHORT;
+
+	if (short_preamble)
+		val |= RTW8723BS_ACK_PREAMBLE_SHORT;
+	rtw_write8(rtwdev, REG_RRSR + 2, val);
+}
+
+static void rtw8723bs_set_slot_time(struct rtw_dev *rtwdev, bool short_slot)
+{
+	rtw_write8(rtwdev, REG_SLOT,
+		   short_slot ? RTW8723BS_SHORT_SLOT_TIME :
+				RTW8723BS_LONG_SLOT_TIME);
+}
+
+static u16 rtw8723bs_rrsr_from_ie_rate(u8 rate)
+{
+	switch (rate & 0x7f) {
+	case 2:   return RTW8723BS_RRSR_1M;
+	case 4:   return RTW8723BS_RRSR_2M;
+	case 11:  return RTW8723BS_RRSR_5_5M;
+	case 22:  return RTW8723BS_RRSR_11M;
+	case 12:  return RTW8723BS_RRSR_6M;
+	case 18:  return RTW8723BS_RRSR_9M;
+	case 24:  return RTW8723BS_RRSR_12M;
+	case 36:  return RTW8723BS_RRSR_18M;
+	case 48:  return RTW8723BS_RRSR_24M;
+	case 72:  return RTW8723BS_RRSR_36M;
+	case 96:  return RTW8723BS_RRSR_48M;
+	case 108: return RTW8723BS_RRSR_54M;
+	default:  return 0;
+	}
+}
+
+static void rtw8723bs_collect_basic_rates(const u8 *ie, u16 *basic_rates,
+					  bool *valid)
+{
+	int i;
+
+	if (!ie)
+		return;
+
+	for (i = 0; i < ie[1]; i++) {
+		u16 r;
+
+		if (!(ie[i + 2] & 0x80))
+			continue;
+		r = rtw8723bs_rrsr_from_ie_rate(ie[i + 2]);
+		if (!r)
+			continue;
+		*basic_rates |= r;
+		*valid = true;
+	}
+}
+
+static void rtw8723bs_reset_response_rates(struct rtw_dev *rtwdev)
+{
+	rtw_write32(rtwdev, REG_RRSR, 0xffff1);
+	rtwdev->dm_info.rrsr_val_init = 0xffff1;
+}
+
+static void rtw8723bs_apply_basic_rates(struct rtw_dev *rtwdev,
+					struct ieee80211_vif *vif,
+					const u8 *bssid)
+{
+	struct ieee80211_bss_conf *conf = &vif->bss_conf;
+	struct cfg80211_bss *lookup_bss = NULL;
+	struct cfg80211_bss *bss = NULL;
+	bool valid = false;
+	u16 basic_rates = 0;
+
+	if (!rtw_is_8723bs(rtwdev) || vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (conf->bss) {
+		bss = conf->bss;
+	} else if (bssid && is_valid_ether_addr(bssid)) {
+		lookup_bss = cfg80211_get_bss(rtwdev->hw->wiphy, NULL,
+					      bssid, NULL, 0,
+					      IEEE80211_BSS_TYPE_ESS,
+					      IEEE80211_PRIVACY_ANY);
+		bss = lookup_bss;
+	}
+
+	if (bss) {
+		const u8 *rates, *ext;
+
+		rcu_read_lock();
+		rates = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
+		ext = ieee80211_bss_get_ie(bss, WLAN_EID_EXT_SUPP_RATES);
+		rtw8723bs_collect_basic_rates(rates, &basic_rates, &valid);
+		rtw8723bs_collect_basic_rates(ext, &basic_rates, &valid);
+		rcu_read_unlock();
+	}
+
+	if (valid) {
+		basic_rates |= RTW8723BS_RRSR_2G_FORCE;
+		basic_rates &= RTW8723BS_RRSR_2G_ALLOW;
+		rtw_write16(rtwdev, REG_RRSR, basic_rates);
+		rtw_write8(rtwdev, REG_RRSR + 2,
+			   rtw_read8(rtwdev, REG_RRSR + 2) & 0xf0);
+		rtwdev->dm_info.rrsr_val_init = basic_rates;
+	}
+
+	if (lookup_bss)
+		cfg80211_put_bss(rtwdev->hw->wiphy, lookup_bss);
+}
+
+/* Program response slot time (and, when set_preamble, the ACK preamble) from
+ * the selected scan BSS capabilities; the AP capabilities are not yet in
+ * bss_conf at mgd_prepare_tx() time.
+ */
+static void rtw8723bs_apply_bss_cap(struct rtw_dev *rtwdev,
+				    struct ieee80211_vif *vif,
+				    const u8 *bssid, bool set_preamble)
+{
+	struct ieee80211_bss_conf *conf = &vif->bss_conf;
+	struct cfg80211_bss *lookup_bss = NULL;
+	struct cfg80211_bss *bss = NULL;
+	bool short_preamble, short_slot;
+	u16 cap = 0;
+
+	if (!rtw_is_8723bs(rtwdev) || vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (conf->bss) {
+		bss = conf->bss;
+	} else if (bssid && is_valid_ether_addr(bssid)) {
+		lookup_bss = cfg80211_get_bss(rtwdev->hw->wiphy, NULL,
+					      bssid, NULL, 0,
+					      IEEE80211_BSS_TYPE_ESS,
+					      IEEE80211_PRIVACY_ANY);
+		bss = lookup_bss;
+	}
+
+	if (bss) {
+		cap = bss->capability;
+	} else if (conf->assoc_capability) {
+		cap = conf->assoc_capability;
+	} else {
+		short_preamble = conf->use_short_preamble;
+		short_slot = conf->use_short_slot;
+		goto program;
+	}
+	short_preamble = !!(cap & WLAN_CAPABILITY_SHORT_PREAMBLE);
+	short_slot = !!(cap & WLAN_CAPABILITY_SHORT_SLOT_TIME);
+
+program:
+	if (set_preamble)
+		rtw8723bs_set_ack_preamble(rtwdev, short_preamble);
+	rtw8723bs_set_slot_time(rtwdev, short_slot);
+
+	if (lookup_bss)
+		cfg80211_put_bss(rtwdev->hw->wiphy, lookup_bss);
+}
+
+static unsigned int rtw8723bs_auth_sync_wait_ms(struct ieee80211_vif *vif)
+{
+	u16 beacon_int = vif->bss_conf.beacon_int;
+	unsigned int wait_ms;
+
+	if (!beacon_int)
+		return RTW8723BS_AUTH_SYNC_WAIT_FALLBACK_MS;
+
+	wait_ms = DIV_ROUND_UP(beacon_int * 1024, 1000) + 20;
+	return clamp_t(unsigned int, wait_ms, RTW8723BS_AUTH_SYNC_WAIT_MIN_MS,
+		       RTW8723BS_AUTH_SYNC_WAIT_MAX_MS);
+}
+
+static void rtw8723bs_auth_sync_start(struct rtw_dev *rtwdev, const u8 *bssid)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sync->lock, flags);
+	ether_addr_copy(sync->bssid, bssid);
+	sync->seen = false;
+	sync->seen_count = 0;
+	sync->active = true;
+	spin_unlock_irqrestore(&sync->lock, flags);
+}
+
+static void rtw8723bs_auth_sync_stop(struct rtw_dev *rtwdev)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sync->lock, flags);
+	sync->active = false;
+	spin_unlock_irqrestore(&sync->lock, flags);
+}
+
+static bool rtw8723bs_auth_sync_seen(struct rtw_dev *rtwdev)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+	unsigned long flags;
+	bool seen;
+
+	spin_lock_irqsave(&sync->lock, flags);
+	seen = sync->seen;
+	spin_unlock_irqrestore(&sync->lock, flags);
+
+	return seen;
+}
+
+static bool rtw8723bs_auth_sync_wait(struct rtw_dev *rtwdev,
+				     unsigned int wait_ms)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+
+	return wait_event_timeout(sync->wait, rtw8723bs_auth_sync_seen(rtwdev),
+				  msecs_to_jiffies(wait_ms)) > 0;
+}
+
+static bool rtw8723bs_mgd_prepare_is_auth(struct rtw_dev *rtwdev,
+					  struct ieee80211_prep_tx_info *info)
+{
+	return rtw_is_8723bs(rtwdev) && info &&
+	       info->subtype == IEEE80211_STYPE_AUTH;
+}
+
+/* Replicate the vendor start_clnt_join() register programming right before
+ * auth. Returns true for a fresh join (BSSID changed).
+ */
+static bool rtw8723bs_mgd_prepare_join(struct rtw_dev *rtwdev,
+				       struct ieee80211_vif *vif,
+				       const u8 *bssid)
+{
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+	bool fresh_join;
+	u16 retry_limit;
+
+	if (!is_valid_ether_addr(bssid))
+		return false;
+
+	fresh_join = !ether_addr_equal(rtwvif->bssid, bssid);
+
+	ether_addr_copy(rtwvif->bssid, bssid);
+	rtwvif->aid = 0;
+	rtwvif->net_type = RTW_NET_MGD_LINKED;
+	rtw_vif_port_config(rtwdev, rtwvif,
+			    PORT_SET_BSSID | PORT_SET_AID | PORT_SET_NET_TYPE);
+
+	/* Do not narrow RRSR or switch to short-preamble responses before the
+	 * exchange: the whole auth/assoc runs on the init response set
+	 * (0xffff1, long preamble). Only slot time is programmed early.
+	 */
+	rtw8723bs_apply_bss_cap(rtwdev, vif, bssid, false);
+
+	rtw_fw_beacon_filter_config(rtwdev, false, vif);
+
+	/* Match the vendor start_clnt_join() TX state (set_msr directly, keep
+	 * BCN_CTRL / BCNQ_DL set, reassert TBTT/RESP_SIFS every join).
+	 */
+	rtw_write8(rtwdev, REG_BCN_CTRL,
+		   BIT_DIS_TSF_UDT | BIT_EN_BCN_FUNCTION);
+	rtw_write32_set(rtwdev, REG_FWHW_TXQ_CTRL, BIT_EN_BCNQ_DL);
+	rtw_write8(rtwdev, REG_TBTT_PROHIBIT + 1, 0x64 & 0xff);
+	rtw_write8(rtwdev, REG_TBTT_PROHIBIT + 2,
+		   (rtw_read8(rtwdev, REG_TBTT_PROHIBIT + 2) & 0xf0) | (0x64 >> 8));
+	rtw_write16(rtwdev, REG_RESP_SIFS_CCK, 0x0808);
+	rtw_write16(rtwdev, REG_RESP_SIFS_OFDM, 0x0a0a);
+
+	rtw_write16(rtwdev, REG_RXFLTMAP0, 0xffff);
+	rtw_write16(rtwdev, REG_RXFLTMAP2, 0xffff);
+	rtw8723bs_auth_rx_filter(rtwdev, true);
+
+	retry_limit = (RTW8723BS_JOIN_RETRY_LIMIT << 8) |
+		      RTW8723BS_JOIN_RETRY_LIMIT;
+	rtw_write16(rtwdev, REG_RETRY_LIMIT, retry_limit);
+
+	rtw8723bs_config_sec_cfg(rtwdev);
+
+	return fresh_join;
+}
+
+/* The vendor sends a deauth to the target before auth to clear stale AP-side
+ * state; synthesize and TX one, then let the AP settle.
+ */
+static void rtw8723bs_tx_pre_auth_deauth(struct rtw_dev *rtwdev,
+					 struct ieee80211_vif *vif,
+					 const u8 *bssid)
+{
+	struct ieee80211_tx_control control = {};
+	struct ieee80211_tx_info *info;
+	struct ieee80211_mgmt *mgmt;
+	struct sk_buff *skb;
+	unsigned int frame_len, headroom;
+
+	frame_len = sizeof(struct ieee80211_hdr_3addr) + sizeof(mgmt->u.deauth);
+	headroom = rtwdev->chip->tx_pkt_desc_sz + 8;
+
+	skb = dev_alloc_skb(headroom + frame_len);
+	if (!skb)
+		return;
+
+	skb_reserve(skb, headroom);
+	mgmt = skb_put_zero(skb, frame_len);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_DEAUTH);
+	memcpy(mgmt->da, bssid, ETH_ALEN);
+	memcpy(mgmt->sa, vif->addr, ETH_ALEN);
+	memcpy(mgmt->bssid, bssid, ETH_ALEN);
+	mgmt->u.deauth.reason_code = cpu_to_le16(WLAN_REASON_DEAUTH_LEAVING);
+
+	info = IEEE80211_SKB_CB(skb);
+	memset(info, 0, sizeof(*info));
+	info->control.vif = vif;
+
+	rtw_tx(rtwdev, &control, skb);
+	msleep(100);
+}
+
+/* Orchestrate the pre-auth join: program the vendor join state, send the
+ * pre-auth deauth, wait for a beacon from the target, then replay the
+ * pre-auth coex H2Cs - once per fresh BSSID.
+ */
+static void rtw8723bs_mgd_prepare_auth_join(struct rtw_dev *rtwdev,
+					    struct ieee80211_vif *vif,
+					    struct ieee80211_prep_tx_info *info)
+{
+	struct rtw_vif *rtwvif;
+	const u8 *bssid = NULL;
+	bool fresh_join;
+
+	if (!rtw8723bs_mgd_prepare_is_auth(rtwdev, info) || !vif ||
+	    test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
+		return;
+
+	rtwvif = (struct rtw_vif *)vif->drv_priv;
+
+	if (!is_zero_ether_addr(vif->cfg.ap_addr))
+		bssid = vif->cfg.ap_addr;
+	else if (vif->bss_conf.bssid && !is_zero_ether_addr(vif->bss_conf.bssid))
+		bssid = vif->bss_conf.bssid;
+
+	if (!bssid)
+		return;
+
+	fresh_join = rtw8723bs_mgd_prepare_join(rtwdev, vif, bssid);
+
+	if (fresh_join || !rtwvif->pre_auth_join_done) {
+		unsigned int wait_ms = rtw8723bs_auth_sync_wait_ms(vif);
+
+		rtw8723bs_auth_sync_start(rtwdev, bssid);
+		rtw8723bs_tx_pre_auth_deauth(rtwdev, vif, bssid);
+		rtw8723bs_auth_sync_wait(rtwdev, wait_ms);
+		rtw8723bs_auth_sync_stop(rtwdev);
+		rtwvif->pre_auth_join_done = true;
+	}
+
+	if (!rtwvif->pre_auth_h2c_sent) {
+		rtw_coex_8723bs_pre_auth_h2c(rtwdev);
+		rtwvif->pre_auth_h2c_sent = true;
+	}
+}
+
 static void rtw_ops_tx(struct ieee80211_hw *hw,
 		       struct ieee80211_tx_control *control,
 		       struct sk_buff *skb)
@@ -424,6 +850,13 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC) {
 		rtw_vif_assoc_changed(rtwvif, conf);
 		if (vif->cfg.assoc) {
+			if (rtw_is_8723bs(rtwdev) &&
+			    vif->type == NL80211_IFTYPE_STATION) {
+				rtw8723bs_auth_rx_filter(rtwdev, false);
+				rtw8723bs_apply_basic_rates(rtwdev, vif, NULL);
+				rtw8723bs_enable_tsf_update(rtwdev);
+			}
+
 			rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_FINISH);
 
 			rtw_fw_download_rsvd_page(rtwdev);
@@ -445,6 +878,13 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 			if (test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
 				rtw_hw_scan_abort(rtwdev);
 
+			if (rtw_is_8723bs(rtwdev) &&
+			    vif->type == NL80211_IFTYPE_STATION) {
+				rtw8723bs_auth_rx_filter(rtwdev, false);
+				rtw8723bs_reset_response_rates(rtwdev);
+				rtwvif->pre_auth_h2c_sent = false;
+				rtwvif->pre_auth_join_done = false;
+			}
 		}
 
 		config |= PORT_SET_NET_TYPE;
@@ -452,8 +892,26 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
+		bool bssid_cleared = is_zero_ether_addr(conf->bssid);
+		bool bssid_changed = !ether_addr_equal(rtwvif->bssid,
+						       conf->bssid);
+
+		if (rtw_is_8723bs(rtwdev) &&
+		    vif->type == NL80211_IFTYPE_STATION && bssid_changed) {
+			rtwvif->pre_auth_h2c_sent = false;
+			rtwvif->pre_auth_join_done = false;
+		}
 		ether_addr_copy(rtwvif->bssid, conf->bssid);
 		config |= PORT_SET_BSSID;
+		if (rtw_is_8723bs(rtwdev) &&
+		    vif->type == NL80211_IFTYPE_STATION && bssid_cleared) {
+			rtwvif->aid = 0;
+			rtwvif->net_type = RTW_NET_NO_LINK;
+			config |= PORT_SET_NET_TYPE | PORT_SET_AID;
+			rtw_write8(rtwdev, REG_BCN_CTRL,
+				   BIT_DIS_TSF_UDT | BIT_EN_BCN_FUNCTION |
+				   BIT_DIS_ATIM);
+		}
 		if (!rtw_core_check_sta_active(rtwdev))
 			rtw_clear_op_chan(rtwdev);
 		else
@@ -485,8 +943,17 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_MU_GROUPS)
 		rtw_chip_set_gid_table(rtwdev, vif, conf);
 
-	if (changed & BSS_CHANGED_ERP_SLOT)
+	if (changed & BSS_CHANGED_ERP_PREAMBLE &&
+	    rtw_is_8723bs(rtwdev) &&
+	    vif->type == NL80211_IFTYPE_STATION)
+		rtw8723bs_set_ack_preamble(rtwdev, conf->use_short_preamble);
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (rtw_is_8723bs(rtwdev) &&
+		    vif->type == NL80211_IFTYPE_STATION)
+			rtw8723bs_set_slot_time(rtwdev, conf->use_short_slot);
 		rtw_conf_tx(rtwdev, rtwvif);
+	}
 
 	if (changed & BSS_CHANGED_PS)
 		rtw_recalc_lps(rtwdev, NULL);
@@ -646,11 +1113,19 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key->hw_key_idx = hw_key_idx;
 		rtw_sec_write_cam(rtwdev, sec, sta, key,
 				  hw_key_type, hw_key_idx);
+		if (rtw_is_8723bs(rtwdev) && vif &&
+		    vif->type == NL80211_IFTYPE_STATION &&
+		    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+			rtw8723bs_config_default_key_search(rtwdev, true);
 		break;
 	case DISABLE_KEY:
 		rtw_hci_flush_all_queues(rtwdev, false);
 		rtw_mac_flush_all_queues(rtwdev, false);
 		rtw_sec_clear_cam(rtwdev, sec, key->hw_key_idx);
+		if (rtw_is_8723bs(rtwdev) && vif &&
+		    vif->type == NL80211_IFTYPE_STATION &&
+		    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+			rtw8723bs_config_default_key_search(rtwdev, false);
 		break;
 	}
 
@@ -740,8 +1215,23 @@ static void rtw_ops_mgd_prepare_tx(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_leave_lps_deep(rtwdev);
-	rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
-	rtw_chip_prepare_tx(rtwdev);
+
+	if (rtw_is_8723bs(rtwdev)) {
+		/* Wake from soft IPS and run the vendor join sequence. The RFK
+		 * is handled by the once-only power-on IQK plus the ps.c
+		 * post-IPS RF-bus recovery, not a fresh calibration here.
+		 */
+		if (rtw_leave_ips(rtwdev)) {
+			rtw_err(rtwdev, "failed to leave idle state for mgd tx\n");
+			goto out;
+		}
+		rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
+		rtw8723bs_mgd_prepare_auth_join(rtwdev, vif, info);
+	} else {
+		rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
+		rtw_chip_prepare_tx(rtwdev);
+	}
+out:
 	mutex_unlock(&rtwdev->mutex);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 4d3d1d99e305..6e0cb58259e1 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -829,6 +829,8 @@ struct rtw_vif {
 	u8 bssid[ETH_ALEN];
 	u8 port;
 	u8 bcn_ctrl;
+	bool pre_auth_h2c_sent;
+	bool pre_auth_join_done;
 	struct list_head rsvd_page_list;
 	struct ieee80211_tx_queue_params tx_params[IEEE80211_NUM_ACS];
 	const struct rtw_vif_port *conf;
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index b82a8de66e84..b6d4e8ed98c7 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -479,6 +479,7 @@
 #define BIT_DIS_TSF_UDT		BIT(4)
 #define BIT_EN_BCN_FUNCTION	BIT(3)
 #define BIT_EN_TXBCN_RPT	BIT(2)
+#define BIT_DIS_ATIM		BIT(0)
 #define REG_BCN_CTRL_CLINT0	0x0551
 #define REG_DRVERLYINT		0x0558
 #define REG_BCNDMATIM		0x0559
@@ -518,6 +519,7 @@
 #define BIT_UC_MD_EN		BIT(16)
 #define BIT_RXSK_PERPKT		BIT(15)
 #define BIT_HTC_LOC_CTRL	BIT(14)
+#define BIT_AMF			BIT(13)
 #define BIT_RPFM_CAM_ENABLE	BIT(12)
 #define BIT_TA_BCN		BIT(11)
 #define BIT_RCR_ADF		BIT(11)
diff --git a/drivers/net/wireless/realtek/rtw88/sec.h b/drivers/net/wireless/realtek/rtw88/sec.h
index efcf45433999..73f2af66effe 100644
--- a/drivers/net/wireless/realtek/rtw88/sec.h
+++ b/drivers/net/wireless/realtek/rtw88/sec.h
@@ -22,6 +22,7 @@
 #define RTW_SEC_RX_DEC_EN		BIT(3)
 #define RTW_SEC_TX_BC_USE_DK		BIT(6)
 #define RTW_SEC_RX_BC_USE_DK		BIT(7)
+#define RTW_SEC_CHK_KEYID		BIT(8)
 
 #define RTW_SEC_ENGINE_EN		BIT(9)
 
-- 
2.55.0

