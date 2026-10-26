Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993051;
	b=AvrppmQBqsGH7D3DMvNZ/l1KuYJlUFlTL/Hx201WM6gHGBHksZMNom7YKK5oLi1rL3wi
	 biRta+hgL1BtCwi+rDnCXXP8WN0kozt/PojfSAN5jRt1qI9kdVotvMcENK+8Gk6uJIVYy
	 nuMjicPakA0cgYeu9+8nAUn8xnQd0qO0fS26L0YrMKNDw9eJ84TsMtWj0ufoGWD1Ha8WV
	 A1FT22krX2+tE3ER60TnAibJtAd3zy1HGhpI/AIfylQGZQxV9q6rDDsHyeW1fWVlq05K5
	 XiZq6U3S0TeKLVVZCoGktu/i1i6JOxZuNY9LO0RAHcpN/xFSKniuGEVFgiAW4ozHFdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993051;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zzY09t8y+jy+Ilnq+453JPfhX/+Ylhy72YIlTe29roA=;
	b=cSL2GyQmaS3N3rfnPR+bE2E1NUejsyIKSW/c7+15sTBehrWPtFHPK9WiT8+tbYSb8e7c
	 4afQoWsKlDaabxZCIGPvmLI+oLyj9HHLZRJcPnZI4dNo4LFNTvBf2VMGjoZaUS2b0apmp
	 nRKTppo86Ea8RuSIr8obc42XWwW2WL+I16iDleEi3I9rwLFb3lHO5t7iK9hr0n2BSmJBx
	 bYV6juBawTa9rugg59MxgTgcrAgsKVv07ntYTfDGSYFhZ0nzwZQREeQuZZhTV07yYJiTa
	 pZwqO1X8DxOH7On4JFQbHOfOoKSrvysijH80yMilqEqbu8j4sfLt7k0yDIGXrezYYeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lH6m8r1G;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E37060A3804
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E37060A3804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lH6m8r1G
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-88cfa501c5cso812467b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993050; x=1793597850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zzY09t8y+jy+Ilnq+453JPfhX/+Ylhy72YIlTe29roA=;
        b=lH6m8r1GMyWayyvb3qU7cHXDK+DkvBca+3oZ6qls8MYeT529KWgn9gCJV/3dpSCx/U
         zvVjBL/b8DeueJZoEzdjiVdSAKS+p04UZqPzM3ZwtbAhw1AWmyyjVoC7qKT37Z0ElBxF
         i5LRN2sDfTG4vCQSmBUnFisVXNVPLjVKXHNA8C17hUXdwMF6nMPzEAX1/EVGxRHA//G1
         +5Xnj9eh+s5ptZpkcy1TSmYCXVGlHgF62kZ38qCMqj1FqQsKRdwatF2RWEUbQbPNUrEU
         kpG1T/TJpPjWugZVA/RurzYZ5dRU40sUR4KAEQ8H0J8/VEV3XzlkI+qOFicz4pvc1kmv
         v3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993050; x=1793597850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zzY09t8y+jy+Ilnq+453JPfhX/+Ylhy72YIlTe29roA=;
        b=G+jZXFHb6o+qw0mpYyqHkNjKwmPIPG7r+QhYupyQ0Rwpa5VToDsAV1cYq56WuC3DZY
         f6iAMtDGV4Kew7C4k2KcsxX7s199KdNe5ePjx9twzMiZXlZCwKbO5Fp644Cc1zQ5pkml
         iSWm+YWgfcwotc772/5UXN1lHRK7cj0PU4uC7lq0hnwK+cIOt7n2Jc739jeIA05ORl5U
         Okn7vdveSywB8BtyLIntTy+oji5ODfoTYTuUejMYlyw5fsT7FLkXHt+znTS42on0GA7Q
         2/B5dEgj0IEoOnH+vPYCCH4WWj4xpjvXfHBZv3u1u4HTmdCaWJYgmHjPjvRY4RfYLOdh
         bspg==
X-Gm-Message-State: AFq9FYK1lpuOET+EOrpdy72tw4Jj3tAzDNLRt1rx/xnFiICf9blcTFA1
	E4ppOmBeTDsvHu+MED4AMgjoLr1AoU4GXKoP0AyFDyv8fZGlnYWdcL1bV7kUSqCoWGTl+w==
X-Gm-Gg: AYBFou0Tw6zaSjqxuWPi9+NmVmZjjgaUPxnOn1dmlUXmp0iUij4YzpmoXhXzLrkR644
	7fMMPdA7Ysh/ZdBZBgJNLk3M6EUCVF35S/Y7M5eNUFp0gpLBYftrqrisBzq0+X++zXKd5307+qE
	iYLcB/WVOY1bE9a06XEh+j0Zc7oghgpbepG/UxIU+1OFYpk1VIn2DLe3SMF+cU0flDODSdRvjmj
	nRydh/+6tTMSaWOaRa2Xll3eMfPGMv/+KnQw/OIOJ3s0Y3tRuhRqUH2qs2yzuAFsA0MQFD7si50
	OlhEf14KSAx+NbAXiTN/WckzQ7pJEB1ae/jqqKGoOoTtHEGOskIBznOIV5ZqsgovwEyvmEfoVd1
	CxH/nTxYMvV4xvJAOlc2osYpMcvzUwcvD+KwSMHZw3vpYYt3gteoZvNeJSKLLT7WdpbinfZWgEA
	0l3XV1ksleO/MUaBYKasUkpQbYaWyCGx4vzqW/xfbtDTCboouk/tsn4Zy81w3kt6jWgZelDDQK4
	cKkTBwVzEOxjN1BuGlaQTmomXwfzvbrsy0ls83n3s/ZlBS6Og2L7yBmZNT+LMdITQsQz+NEdHfv
	9JMH
X-Received: by 2002:a05:6a00:3901:b0:89f:7a1b:2bf4 with SMTP id d2e1a72fcca58-8a3661c5268mr4676396b3a.16.1792993050026;
        Sun, 25 Oct 2026 22:37:30 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:29 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com
Subject: [RFC PATCH wireless-next 11/17] wifi: bcm4323x: add the shared definitions
Date: Mon, 26 Oct 2026 13:36:17 +0800
Message-ID: <20261026053633.361454-12-ragulbaby@gmail.com>
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

Add the definitions for the BCM4323x devices.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../broadcom/brcm80211/bcm4323x/bcm4323x.h    | 258 ++++++++++++++++++
 1 file changed, 258 insertions(+)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x.h

diff --git a/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x.h b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x.h
new file mode 100644
index 000000000..cd1c83dd4
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x.h
@@ -0,0 +1,258 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef BCM4323X_H
+#define BCM4323X_H
+
+#include <linux/atomic.h>
+#include <linux/bitfield.h>
+#include <linux/completion.h>
+#include <linux/etherdevice.h>
+#include <linux/ieee80211.h>
+#include <linux/input.h>
+#include <linux/kfifo.h>
+#include <linux/led-class-multicolor.h>
+#include <linux/leds.h>
+#include <linux/mutex.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <net/mac80211.h>
+
+#include <brcmu_rate.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
+#include <d11.h>
+
+#define BCM4323X_RX_SIZE 16384
+#define BCM4323X_RX_URBS 8
+#define BCM4323X_RPC_CLASS_MASK GENMASK(31, 24)
+#define BCM4323X_RPC_SESSION_MASK GENMASK(23, 16)
+#define BCM4323X_RPC_XID_MASK GENMASK(15, 0)
+#define BCM4323X_RPC_CLASS_DATA 1
+#define BCM4323X_RPC_CLASS_CONTROL 2
+#define BCM4323X_RPC_CLASS_TRANSPORT 3
+#define BCM4323X_RPC_SESSION 0x69
+#define BCM4323X_RPC_PROC_VERSION 1
+#define BCM4323X_RPC_PROC_CHIP 2
+#define BCM4323X_RPC_PROC_CHIP_ACK 3
+#define BCM4323X_RPC_VERSION 0x0564442e
+/* brcmsmac's bcma_read16() or bcma_read32() of a d11 register: {offset, size} */
+#define BCM4323X_RPC_PROC_REG_READ 0x01
+#define BCM4323X_RPC_PROC_LED_BLINK 0x76
+#define BCM4323X_RPC_PROC_GPIO_OUT 0x77
+/* brcmsmac's brcms_c_watchdog(), which the firmware answers while it runs */
+#define BCM4323X_RPC_PROC_WATCHDOG 0x99
+#define BCM4323X_NUM_2GHZ_CHANNELS 14
+#define BCM4323X_NUM_5GHZ_CHANNELS 24
+#define BCM4323X_NUM_CHANNELS (BCM4323X_NUM_2GHZ_CHANNELS + BCM4323X_NUM_5GHZ_CHANNELS)
+#define BCM4323X_ANTENNAS (BIT(0) | BIT(1))
+
+#define BCM4323X_HW_PAIRWISE_BASE 4
+#define BCM4323X_HW_KEYS M_SECKINDXALGO_BLK_SZ
+
+#define BCM4323X_NUM_CCK_RATES 4
+#define BCM4323X_NUM_OFDM_RATES 8
+#define BCM4323X_NUM_RATES (BCM4323X_NUM_CCK_RATES + BCM4323X_NUM_OFDM_RATES)
+#define BCM4323X_NUM_MCS 16
+#define BCM4323X_TX_STATUSES 8
+/* The index of the staged batch in tx_batches[], after the committed ones */
+#define BCM4323X_TX_STAGED 2
+
+struct bcm4323x_rpc_header {
+	__le32 length;
+	__le32 xid_class;
+	__le32 procedure;
+} __packed;
+
+/* The length word counts the bytes that follow it. */
+static inline __le32 bcm4323x_rpc_length(size_t body_length)
+{
+	return cpu_to_le32(sizeof(struct bcm4323x_rpc_header) - sizeof(__le32) + body_length);
+}
+
+static inline __le32 bcm4323x_rpc_xid_class(u8 rpc_class, u16 xid)
+{
+	return cpu_to_le32(FIELD_PREP(BCM4323X_RPC_CLASS_MASK, rpc_class) |
+			   FIELD_PREP(BCM4323X_RPC_SESSION_MASK, BCM4323X_RPC_SESSION) |
+			   FIELD_PREP(BCM4323X_RPC_XID_MASK, xid));
+}
+
+/* Procedure 0x52 */
+struct bcm4323x_tx_status {
+	/* from brcmsmac: struct tx_status, in little endian and in another order */
+	__le16 reserved0;
+	__le16 frameid;
+	__le16 status;
+	__le16 sequence;
+	__le32 lasttxtime;
+	__le16 phyerr;
+	__le16 ackphyrxsh;
+	__le32 reserved1[2];
+	/* The second status package of an aggregate, as in brcmsmac */
+	__le32 s1;
+	__le32 s2;
+} __packed;
+
+struct bcm4323x_txq {
+	struct sk_buff_head frames;
+	u8 ampdu_window;
+};
+
+/* Board/chip specific data*/
+struct bcm4323x_chip {
+	bool has_5ghz;
+	u8 channel_data_2ghz[3];
+	/* Hardcoded to green on GPIO 2 and red on GPIO 3 for now*/
+	bool has_wps_led;
+	/* Hardcoded to GPIO 10 for now */
+	bool has_wps_button;
+};
+
+struct bcm4323x {
+	struct ieee80211_hw *hw;
+	struct ieee80211_supported_band bands[2];
+	struct ieee80211_channel channels[BCM4323X_NUM_CHANNELS];
+	const struct bcm4323x_chip *chip;
+	struct usb_device *udev;
+	struct usb_interface *intf;
+	bool running;
+	/* Set when firmware hangs, different from running */
+	unsigned int dead;
+
+	/* Serializes the I/O buffer, transaction IDs and control responses. */
+	struct mutex io_mutex;
+
+	/* Shared USB transfer buffer */
+	u8 *io_buffer;
+	/* USB packet serial number */
+	u16 rpc_xid;
+	struct completion handshake_done;
+	__le32 handshake_chip;
+
+	struct delayed_work watchdog_work;
+	unsigned int watchdog_failures;
+	unsigned long phy_cal_expires;
+
+	struct urb *rx_urbs[BCM4323X_RX_URBS];
+	/* Only the first sub-frame in an A-MPDU have PLCP, save it for later frames */
+	u8 rx_ht_plcp[4];
+
+	u16 chanspec;
+	bool band_switched;
+	u16 ss_algo_channel;
+	int tx_power;
+	bool scanning;
+	s8 noise[BCM4323X_NUM_CHANNELS];
+	u32 filter_flags;
+
+	unsigned int tx_pipe;
+	struct usb_anchor tx_anchor;
+	wait_queue_head_t tx_wait;
+	struct sk_buff_head tx_queue;
+	struct work_struct tx_work;
+	DECLARE_KFIFO(tx_statuses, struct bcm4323x_tx_status, BCM4323X_TX_STATUSES);
+
+	/* Serializes the TX work with pausing, and protects the fields below. */
+	struct mutex tx_mutex;
+	u16 tx_sequence;
+
+	struct sk_buff_head tx_batches[BCM4323X_TX_STAGED + 1];
+	struct urb *tx_commit;
+	unsigned int tx_owned;
+	unsigned long tx_expires;
+	bool tx_paused;
+
+	struct ieee80211_vif __rcu *active_vif;
+
+	DECLARE_BITMAP(keys, BCM4323X_HW_KEYS);
+	u8 key_peers[BCM4323X_HW_KEYS][ETH_ALEN];
+
+	struct led_classdev led;
+	char led_name[32];
+	struct led_classdev_mc wps_led;
+	struct mc_subled wps_subleds[2];
+	char wps_led_name[40];
+	struct input_dev *wps_button;
+	char wps_button_phys[32];
+};
+
+/* Whether mac80211 started the device and the firmware still works */
+static inline bool bcm4323x_active(struct bcm4323x *dev)
+{
+	return READ_ONCE(dev->running) && !READ_ONCE(dev->dead);
+}
+
+int bcm4323x_rpc_send(struct bcm4323x *dev, u32 procedure, const void *body, size_t body_length);
+int bcm4323x_rpc_call(struct bcm4323x *dev, u32 procedure, const void *body, size_t body_length,
+		      void *response, size_t response_length);
+
+/* Sends a data procedure whose body is the arguments, as little-endian words */
+#define bcm4323x_rpc_send_u32(dev, procedure, ...) ({				\
+	u32 __body[] = { __VA_ARGS__ };						\
+										\
+	cpu_to_le32_array(__body, ARRAY_SIZE(__body));				\
+	bcm4323x_rpc_send(dev, procedure, __body, sizeof(__body));		\
+})
+
+/* Calls a control procedure the same way, with a word of response if any */
+#define bcm4323x_rpc_call_u32(dev, procedure, response, ...) ({			\
+	u32 __body[] = { __VA_ARGS__ };						\
+										\
+	cpu_to_le32_array(__body, ARRAY_SIZE(__body));				\
+	bcm4323x_rpc_call(dev, procedure, __body, sizeof(__body), response,	\
+			  sizeof(__le32));					\
+})
+
+void bcm4323x_fatal_error(struct bcm4323x *dev);
+int bcm4323x_start_rx_urbs(struct bcm4323x *dev);
+void bcm4323x_kill_rx_urbs(struct bcm4323x *dev);
+
+#ifdef CONFIG_MAC80211_LEDS
+void bcm4323x_led_init(struct bcm4323x *dev);
+void bcm4323x_led_register(struct bcm4323x *dev);
+void bcm4323x_led_unregister(struct bcm4323x *dev);
+#else
+static inline void bcm4323x_led_init(struct bcm4323x *dev) {}
+static inline void bcm4323x_led_register(struct bcm4323x *dev) {}
+static inline void bcm4323x_led_unregister(struct bcm4323x *dev) {}
+#endif
+
+extern struct ieee80211_rate bcm4323x_rates[BCM4323X_NUM_RATES];
+
+static inline unsigned int bcm4323x_first_rate(enum nl80211_band band)
+{
+	return band == NL80211_BAND_5GHZ ? BCM4323X_NUM_CCK_RATES : 0;
+}
+
+extern const struct ieee80211_ops bcm4323x_ops;
+int bcm4323x_register_hw(struct bcm4323x *dev);
+int bcm4323x_write_shm(struct bcm4323x *dev, u32 offset, u16 value);
+int bcm4323x_read_shm(struct bcm4323x *dev, u32 offset, u16 *value);
+int bcm4323x_init_mac(struct bcm4323x *dev);
+
+void bcm4323x_rx_complete(struct urb *urb);
+
+void bcm4323x_init_tx(struct bcm4323x *dev);
+void bcm4323x_init_basic_rate(u8 *basic_rate, enum nl80211_band band, u32 basic_rates);
+u8 bcm4323x_stf_mode(u16 ss_algo_channel);
+u8 bcm4323x_ac_to_fifo(u8 ac);
+void bcm4323x_tx_status(struct bcm4323x *dev, const u8 *body, size_t body_length);
+void bcm4323x_check_tx(struct bcm4323x *dev);
+void bcm4323x_set_tx_paused(struct bcm4323x *dev, bool paused);
+bool bcm4323x_quiesce_tx(struct bcm4323x *dev);
+void bcm4323x_flush_tx(struct bcm4323x *dev);
+void bcm4323x_retire_key(struct bcm4323x *dev, u8 key_index, struct ieee80211_sta *sta);
+void bcm4323x_init_txq(struct ieee80211_txq *txq);
+void bcm4323x_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+		 struct sk_buff *skb);
+void bcm4323x_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
+int bcm4323x_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta, enum ieee80211_sta_state old_state,
+		       enum ieee80211_sta_state new_state);
+void bcm4323x_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u32 queues, bool drop);
+int bcm4323x_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_ampdu_params *params);
+
+#endif /* BCM4323X_H */
-- 
2.53.0

