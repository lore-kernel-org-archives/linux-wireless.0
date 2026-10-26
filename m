Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993064;
	b=A0CUVm/drYi7IunvFRaKlrJKBJ0Bq2uMVCwjLxoB6j2NonM3FNQ5Ef4Y5UwUBjwsJWUo
	 z1h/EM939oyrUCHJw3dQnA4LuFceanz3o7aIXpLcpjZ/fkXnBsTCGPK0LkO3g7FSfPKkS
	 ATaZqb+ZE/Gnbmz+sXMdLvu7M0IKWzjQb9V0RVmr6iVKz18CCMDWUv+CyJFkt6ITuKGbE
	 CHCGWGfPTVh2nk9IJonB2HTAVhWNlMx5peR6G5nK6IUKkNG76lF+Cb90QazIOCB3/MJN7
	 BTv6EA3BOgqu5vP3FItsMnZe13NIpuJvnMqeXWi+4TCpiLL2C1ygJg4ioHXqW3PMQzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993064;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qquegQDD8ytRkA7MaJEt+CTkxfx+zzl+Rd/dLHZ47mo=;
	b=SYYKEik61UAbqhbbEBby8SAhQICcHvjxBBVbsH+wCxw3XSk0vqDy2me7bhqkwD6JfKW1
	 ZdSbeetLqMutFZaDhDSpAUfPUntT1pzDgUkUVUuoL9/Kzs8wMT+DSX6jg9d+XtVtAL2PP
	 5ATfHUonF+Sf7qnSdN6cvRuk95lYodMqbm34NUQDMww4xQKNoJuvy8skDT4V6xz0nrF0I
	 OaqvaNc4zwpFj15tJ/20LI/VvqqERFeayErfSOVW+Q3ABctThDM/lUXlonB4HliM45rQN
	 WAkJZp/Tb52r7f7IChcCxWgruLTHrWrCHCRDFFHfp86B72j7SOUM7mBmAGvjHNyVx0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="s/qAXiST";
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86B260A261F
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A86B260A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=s/qAXiST
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-89ff475a152so924510b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993062; x=1793597862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qquegQDD8ytRkA7MaJEt+CTkxfx+zzl+Rd/dLHZ47mo=;
        b=s/qAXiST74fgCFyJELnSY7GsJcw4POHBc7mQDBWnqVSDknOYkHfyEjL6zjQqVlYGOO
         LtYV6OVHLbQR5uEJ/LZ0hXkPCwMew7b4DAmmKKIrqCDWJ1B4QusfrCGKtyijgZV3vcJ/
         YHOBVTpTvQ+kR8EiMUY4kCZL8k3E0R3u4SyowdLdE2S7W0tqOhPLtCXD2vr6evHNNwRV
         TurqG36puFosj/hI/x1M2v1DmLzlwjJYiyBA1eUgsSWLleprhxkAWjeeAp3eJ3XnDHWX
         cspOikQYB5/Nj++on4kNfD/RhUfa7L5Rah8UnZUsQvsmNad3fSg25MW1AvPRbh9ITwG+
         Tm5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993062; x=1793597862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qquegQDD8ytRkA7MaJEt+CTkxfx+zzl+Rd/dLHZ47mo=;
        b=wMIiTNeGhUEfQG/TCZgO9wTO/PREGzUFIwB6u8TKEtl6ZTvtNVB9AvRbYxRyf0ldwH
         HVXr4XpKbeqm1yLhMIGPW93tSYjJJcXpjdyqbQpLFmqk/f6/L4XNszmjiwoRqzsq75pg
         xIcWw8x7zzSUffBeGxge43YRYH/0lIRHS22OxBJkaZhOOJZi2DLrviencUWjvOkq8A1n
         8tWsR05ybJdseQJ3WSq30Mg4ncRldjz1Qr4hok9AcZ9KJo90ZL/KUvtuq/4RvAk/yHBT
         Sgb1Ad3Nox32ka6qpUflGWV0OQsLcTcsHLtt5JIz9ZauJEiG3Zp/c4nys4Ufozh++CSD
         XUEg==
X-Gm-Message-State: AFq9FYJaCU3VhA5hpRWeSpUe33p8F7EOZojqYsbyU0O7rtMsZiAvBsm3
	u87C+fjYqkF/2d8vRJ+1o4Z/l45mEGmd/3BGVKHxGOcqTtXCY+dQe5nit1tOpHs4/687gg==
X-Gm-Gg: AYBFou3/Q8UVXuv1TjPZ5fSgeLewflg0hmWymwwmaaby/IPpjZ5HUO7r8SOrwMkcxls
	CglRlA4ZTLvl+LpX/xVDEKRA3p3y2Zz7FVG+HfLObMfBzLF6Iu2tZb3nCRVo3atrjSYGtRUIb5p
	2zGkcPFgTpq/ReFcAPZ2li+Bm1NDS3JID00zwhCJ0fSr1Hi7fEvnC547/XjZnlfoP76J05TVqwJ
	da13/2nrFgd23xsNxFVI1bZTRZnXoV+kM3foSzzTDDuvIPK3Et5EfeXaBA0CnsPgwV3Hb9HGoHy
	gqreNAFm5klSlxm0ek+q88o+RGZzwEYSGX8sG6fFfZ52Ty8gAPXjJU3vHGdHK82ArMmw/CGnHZ7
	dpyE6+w42ZkAuTa20B5zf3umRBoaKPW6wptwBI0jlrYP05eVmEoeCOo91L8jfK3nLY8bnFlcvgy
	EXAHMDdQsTjwIbEcAWJrauwASX5Opni3KaGro6ud2gqRqnA320mL96qQRtvRIQYH/1Oyf8tjc4l
	jUUZM3ZEhlXJXjjmXoCzDdNBxlhL6ZYNdfxXmdA08YY17pybp+xRQTpBjsPj856CYFoF7szVEtB
	yh2D
X-Received: by 2002:a05:6a00:338d:b0:89f:9ea6:1ddb with SMTP id d2e1a72fcca58-8a3684d27c6mr4130128b3a.23.1792993061601;
        Sun, 25 Oct 2026 22:37:41 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:41 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com
Subject: [RFC PATCH wireless-next 14/17] wifi: bcm4323x: add the transmit path
Date: Mon, 26 Oct 2026 13:36:20 +0800
Message-ID: <20261026053633.361454-15-ragulbaby@gmail.com>
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

Adds the TX part of the device. Supports TX aggregation.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../broadcom/brcm80211/bcm4323x/bcm4323x_tx.c | 1386 +++++++++++++++++
 1 file changed, 1386 insertions(+)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_tx.c

diff --git a/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_tx.c b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_tx.c
new file mode 100644
index 000000000..3b3bc8ee3
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_tx.c
@@ -0,0 +1,1386 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/bitfield.h>
+#include <linux/jiffies.h>
+#include <linux/kfifo.h>
+#include <linux/netdevice.h>
+#include <linux/slab.h>
+
+#include "bcm4323x.h"
+
+#define BCM4323X_RPC_PROC_TX 0x3d
+
+#define BCM4323X_TX_BATCH_FRAMES 16
+#define BCM4323X_TX_BATCH_BYTES 26624
+#define BCM4323X_AMPDU_PRIMARY_ATTEMPTS 3
+#define BCM4323X_TX_TIMEOUT (2 * HZ)
+
+#define BCM4323X_TX_WAIT (BCM4323X_TX_TIMEOUT + 2 * HZ)
+#define BCM4323X_TX_DRAIN_MS 1000
+
+/* SIFS plus the acknowledgment */
+/* 24 Mbit/s OFDM */
+#define BCM4323X_OFDM_ACK_DURATION_US 44
+/* 1 Mbit/s CCK */
+#define BCM4323X_CCK_ACK_DURATION_US 314
+/* 6 Mbit/s OFDM on 5 GHz */
+#define BCM4323X_OFDM6_ACK_DURATION_US 60
+#define BCM4323X_MAX_DURATION_US 32767
+
+/* from brcmsmac */
+#define	AMPDU_MAX_DUR			5
+#define AMPDU_DEF_RETRY_LIMIT		5
+#define AMPDU_DELIMITER_LEN	4
+
+#define BCM4323X_TX_META_KEY BIT(0)
+#define BCM4323X_TX_META_AMPDU BIT(1)
+
+/* From driver captures */
+#define BCM4323X_TX_ARG2 0xffff
+#define BCM4323X_TX_WEIGHT 1
+#define BCM4323X_TX_WEIGHT_AMPDU 2
+#define BCM4323X_TX_FLAGS_MGMT 0
+#define BCM4323X_TX_FLAGS_DATA 1
+
+/* from brcmsmac: struct d11txh and PLCP header */
+struct bcm4323x_txh {
+	struct d11txh d11;
+	u8 plcp[D11_PHY_HDR_LEN];
+} __packed __aligned(2);
+
+static_assert(sizeof(struct bcm4323x_txh) == D11_TXH_LEN + D11_PHY_HDR_LEN);
+
+/* Procedure 0x3d */
+struct bcm4323x_tx_call {
+	__le32 fifo;
+	/* Set once per aggregate, on its last MPDU, and on unaggregated frames */
+	__le32 commit;
+	__le32 arg2;
+	/* Firmware credit charged on commit */
+	__le32 weight;
+	__le32 flags;
+	__le32 arg5;
+	/* Length of the TX header and the frame */
+	__le32 packet_length;
+	struct bcm4323x_txh txh;
+	u8 frame[];
+} __packed __aligned(2);
+
+struct bcm4323x_tx_meta {
+	u8 flags;
+	u16 frame_id;
+	u8 ampdu_retries;
+	/* Set when the aggregate is built */
+	u8 null_delimiters;
+	u8 key_index;
+	u8 iv_length;
+	u8 icv_length;
+};
+
+static struct bcm4323x_tx_meta *bcm4323x_tx_meta(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	BUILD_BUG_ON(sizeof(struct bcm4323x_tx_meta) > IEEE80211_TX_INFO_RATE_DRIVER_DATA_SIZE);
+	return (void *)info->rate_driver_data;
+}
+
+static struct bcm4323x_txq *to_bcm4323x_txq(struct ieee80211_txq *txq)
+{
+	return (void *)txq->drv_priv;
+}
+
+/*
+ * Moves an aggregated MPDU to the fallback rate after the primary attempts that
+ * rate control asks for, at most BCM4323X_AMPDU_PRIMARY_ATTEMPTS, as multi-rate
+ * retry hardware would.
+ */
+static void bcm4323x_tx_fallback(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *rates = info->control.rates;
+
+	if (bcm4323x_tx_meta(skb)->ampdu_retries !=
+	    clamp_t(u8, rates[0].count, 1, BCM4323X_AMPDU_PRIMARY_ATTEMPTS) ||
+	    !(rates[1].flags & IEEE80211_TX_RC_MCS) || rates[1].idx < 0 || !rates[1].count)
+		return;
+	/* Protection stays as rate control chose it for the primary rate. */
+	rates[0].idx = rates[1].idx;
+	rates[0].flags ^= (rates[0].flags ^ rates[1].flags) & IEEE80211_TX_RC_SHORT_GI;
+	/* The remaining attempts no longer sample the primary rate. */
+	info->flags &= ~IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+}
+
+static void bcm4323x_schedule_tx_work(struct bcm4323x *dev)
+{
+	if (bcm4323x_active(dev))
+		queue_work(system_long_wq, &dev->tx_work);
+}
+
+/*
+ * mac80211 counts a lost aggregated MPDU only when its status carries an
+ * aggregate transmission, in @ampdu.
+ */
+static void bcm4323x_report_tx(struct bcm4323x *dev, struct sk_buff *skb, bool transmitted,
+			       bool acked, const struct ieee80211_tx_info *ampdu)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct bcm4323x_tx_meta *metadata = bcm4323x_tx_meta(skb);
+	u8 attempts = metadata->ampdu_retries + 1;
+	bool no_ack = info->flags & IEEE80211_TX_CTL_NO_ACK;
+
+	/*
+	 * Clear the driver data and report only the last rate, as rate control
+	 * ignores aggregated MPDUs without an aggregate.
+	 */
+	ieee80211_tx_info_clear_status(info);
+	if (ampdu) {
+		info->flags |= IEEE80211_TX_STAT_AMPDU;
+		info->status = ampdu->status;
+	} else {
+		info->status.rates[0].count = attempts;
+		info->status.rates[1].idx = -1;
+	}
+	/*
+	 * Let mac80211 advance the peer's BA window after a lost MPDU, also one
+	 * sent unaggregated, as at a CCK rate.
+	 */
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && transmitted && !acked)
+		info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+	if (acked)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	else if (transmitted && no_ack)
+		info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+	ieee80211_tx_status_ni(dev->hw, skb);
+}
+
+/*
+ * A-MSDUs at CCK rates went unacknowledged at 1 Mbit/s, and at 5.5 Mbit/s were
+ * lost though acknowledged, so they use their MCS fallback.
+ */
+static void bcm4323x_amsdu_rate(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *rates = info->control.rates;
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+
+	if (!(rates[0].flags & IEEE80211_TX_RC_MCS) && (rates[1].flags & IEEE80211_TX_RC_MCS) &&
+	    rates[1].idx >= 0 && ieee80211_is_data_qos(hdr->frame_control) &&
+	    (*ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_A_MSDU_PRESENT)) {
+		rates[0].idx = rates[1].idx;
+		rates[0].flags = rates[1].flags;
+		info->flags &= ~IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+	}
+}
+
+/* Returns false, after dropping the frame, if its key was removed. */
+static bool bcm4323x_prepare_tx(struct bcm4323x *dev, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_key_conf *key = info->control.hw_key;
+	struct bcm4323x_tx_meta metadata = {};
+
+	bcm4323x_amsdu_rate(skb);
+	/*
+	 * mac80211 marks the frames of an operational aggregation session as it
+	 * dequeues them, and unacknowledged MPDUs return to the TX queue.
+	 */
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
+	    (info->control.rates[0].flags & IEEE80211_TX_RC_MCS))
+		metadata.flags |= BCM4323X_TX_META_AMPDU;
+
+	if (key) {
+		if (!test_bit(key->hw_key_idx, dev->keys)) {
+			ieee80211_free_txskb(dev->hw, skb);
+			return false;
+		}
+		metadata.flags |= BCM4323X_TX_META_KEY;
+		metadata.key_index = key->hw_key_idx;
+		metadata.iv_length = key->iv_len;
+		metadata.icv_length = key->icv_len;
+	}
+	/* The metadata overlays control.vif and control.hw_key. */
+	memcpy(bcm4323x_tx_meta(skb), &metadata, sizeof(metadata));
+	return true;
+}
+
+/*
+ * Once the device stops, the frames are dropped, as mac80211 cancelled the work
+ * that a failed management frame would schedule.
+ */
+static void bcm4323x_fail_batch(struct bcm4323x *dev, struct sk_buff_head *batch)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(batch))) {
+		if (READ_ONCE(dev->running))
+			bcm4323x_report_tx(dev, skb, false, false, NULL);
+		else
+			ieee80211_free_txskb(dev->hw, skb);
+	}
+}
+
+/* Fails the frames that firmware owns. */
+static void bcm4323x_fail_pending(struct bcm4323x *dev)
+{
+	unsigned int i;
+
+	usb_free_urb(dev->tx_commit);
+	dev->tx_commit = NULL;
+	for (i = 0; i < ARRAY_SIZE(dev->tx_batches); i++)
+		bcm4323x_fail_batch(dev, &dev->tx_batches[i]);
+	WRITE_ONCE(dev->tx_owned, 0);
+}
+
+/* The status arrives with the receive stream, and the TX work processes it. */
+void bcm4323x_tx_status(struct bcm4323x *dev, const u8 *body, size_t body_length)
+{
+	if (body_length < sizeof(struct bcm4323x_tx_status))
+		return;
+	if (!kfifo_put(&dev->tx_statuses, *(const struct bcm4323x_tx_status *)body))
+		dev_warn_ratelimited(&dev->intf->dev, "TX status dropped\n");
+	bcm4323x_schedule_tx_work(dev);
+}
+
+/*
+ * Moves the committed batch holding a frame to @batch, as batches in different
+ * FIFOs complete in either order.
+ */
+static bool bcm4323x_take_committed(struct bcm4323x *dev, u16 frame_id,
+				    struct sk_buff_head *batch)
+{
+	struct sk_buff_head *committed = dev->tx_batches;
+	struct sk_buff *skb;
+	unsigned int i;
+
+	for (i = 0; i < BCM4323X_TX_STAGED; i++)
+		skb_queue_walk(&committed[i], skb)
+			if (bcm4323x_tx_meta(skb)->frame_id == frame_id)
+				goto found;
+	return false;
+
+found:
+	skb_queue_splice_init(&committed[i], batch);
+	/* A batch still committed becomes the older one. */
+	skb_queue_splice_init(&committed[1], &committed[0]);
+	WRITE_ONCE(dev->tx_owned, dev->tx_owned - skb_queue_len(batch));
+	if (!skb_queue_empty(&committed[0]))
+		dev->tx_expires = jiffies + BCM4323X_TX_TIMEOUT;
+	return true;
+}
+
+/* from brcmsmac: brcms_c_ampdu_dotxstatus_complete, the block acknowledgment bitmap */
+static u64 bcm4323x_ba_bitmap(const struct bcm4323x_tx_status *txs, u16 status)
+{
+	u32 s1 = le32_to_cpu(txs->s1);
+
+	if (!(status & TX_STATUS_ACK_RCV) || !(status & TX_STATUS_AMPDU))
+		return 0;
+	return FIELD_GET(TX_STATUS_BA_BMAP03_MASK, status) |
+	       (s1 & TX_STATUS_BA_BMAP47_MASK) << TX_STATUS_BA_BMAP47_SHIFT |
+	       (s1 & GENMASK(31, 8)) | (u64)le32_to_cpu(txs->s2) << 32;
+}
+
+/* What rate control learns of an aggregate, whose MPDUs share its rate */
+static void bcm4323x_ampdu_rate_info(struct ieee80211_tx_info *rate_info,
+				     const struct ieee80211_tx_info *info)
+{
+	rate_info->band = info->band;
+	rate_info->flags = IEEE80211_TX_STAT_AMPDU |
+			   (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
+	rate_info->status.rates[0] = info->control.rates[0];
+	rate_info->status.rates[0].count = 1;
+	rate_info->status.rates[1].idx = -1;
+}
+
+/*
+ * from brcmsmac: brcms_c_ampdu_dotxstatus_complete
+ *
+ * One status completes a committed batch, returning unacknowledged MPDUs to
+ * their TX queue ahead of newer frames, and tells rate control of the aggregate
+ * transmission.
+ */
+static void bcm4323x_complete_tx(struct bcm4323x *dev, const struct bcm4323x_tx_status *txs)
+{
+	u16 status = le16_to_cpu(txs->status);
+	u16 start_seq = IEEE80211_SEQ_TO_SN(le16_to_cpu(txs->sequence));
+	bool suppressed = status & TX_STATUS_SUPR_MASK;
+	struct sk_buff_head batch;
+	struct sk_buff_head retries;
+	struct sk_buff *skb;
+	struct sk_buff *lost = NULL;
+	struct bcm4323x_tx_meta *metadata;
+	struct ieee80211_hdr *hdr;
+	u64 bitmap;
+	struct ieee80211_tx_info rate_info = {};
+	struct ieee80211_sta *sta;
+	struct ieee80211_txq *txq = NULL;
+
+	__skb_queue_head_init(&batch);
+	if (!bcm4323x_take_committed(dev, le16_to_cpu(txs->frameid), &batch))
+		return;
+	skb = skb_peek(&batch);
+	if (!(bcm4323x_tx_meta(skb)->flags & BCM4323X_TX_META_AMPDU)) {
+		/* Only aggregates have more than one frame. */
+		bcm4323x_report_tx(dev, __skb_dequeue(&batch), !suppressed,
+				   status & TX_STATUS_ACK_RCV, NULL);
+		return;
+	}
+	bitmap = bcm4323x_ba_bitmap(txs, status);
+
+	/* All MPDUs of an aggregate share its rate, receiver and TID. */
+	bcm4323x_ampdu_rate_info(&rate_info, IEEE80211_SKB_CB(skb));
+	hdr = (void *)skb->data;
+	/* A station that is no longer found does not get its TX queues back. */
+	rcu_read_lock();
+	sta = ieee80211_find_sta_by_ifaddr(dev->hw, hdr->addr1, NULL);
+	if (sta && !dev->tx_paused && !suppressed)
+		txq = sta->txq[ieee80211_get_tid(hdr)];
+
+	__skb_queue_head_init(&retries);
+	while ((skb = __skb_dequeue(&batch))) {
+		u16 bindex;
+		bool acked;
+
+		hdr = (void *)skb->data;
+		metadata = bcm4323x_tx_meta(skb);
+		bindex = ieee80211_sn_sub(ieee80211_get_sn(hdr), start_seq);
+		acked = bindex < IEEE80211_MAX_AMPDU_BUF_HT && (bitmap & BIT_ULL(bindex));
+		rate_info.status.ampdu_len++;
+		rate_info.status.ampdu_ack_len += acked;
+		if (acked) {
+			bcm4323x_report_tx(dev, skb, true, true, NULL);
+		} else if (txq && metadata->ampdu_retries < AMPDU_DEF_RETRY_LIMIT) {
+			metadata->ampdu_retries++;
+			bcm4323x_tx_fallback(skb);
+			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_RETRY);
+			__skb_queue_tail(&retries, skb);
+		} else {
+			/*
+			 * Only the last MPDU given up is reported as
+			 * transmitted, so that a single block-ack request moves
+			 * the recipient's window past all of them.
+			 */
+			if (lost)
+				bcm4323x_report_tx(dev, lost, false, false, NULL);
+			lost = skb;
+		}
+	}
+	if (!skb_queue_empty(&retries)) {
+		skb_queue_splice(&retries, &to_bcm4323x_txq(txq)->frames);
+		ieee80211_schedule_txq(dev->hw, txq);
+	}
+
+	if (lost)
+		bcm4323x_report_tx(dev, lost, true, false, suppressed ? NULL : &rate_info);
+	else if (sta && !suppressed)
+		ieee80211_tx_rate_update(dev->hw, sta, &rate_info);
+	rcu_read_unlock();
+}
+
+/* Mapping of ieee80211 AC numbers to tx fifos */
+/* from brcmsmac: ac_to_fifo_mapping */
+static const u8 ac_to_fifo_mapping[IEEE80211_NUM_ACS] = {
+	[IEEE80211_AC_VO]	= TX_AC_VO_FIFO,
+	[IEEE80211_AC_VI]	= TX_AC_VI_FIFO,
+	[IEEE80211_AC_BE]	= TX_AC_BE_FIFO,
+	[IEEE80211_AC_BK]	= TX_AC_BK_FIFO,
+};
+
+/* from brcmsmac: brcms_ac_to_fifo */
+u8 bcm4323x_ac_to_fifo(u8 ac)
+{
+	if (ac >= ARRAY_SIZE(ac_to_fifo_mapping))
+		return TX_AC_BE_FIFO;
+	return ac_to_fifo_mapping[ac];
+}
+
+/* from brcmsmac: frametype */
+static u16 bcm4323x_frametype(u32 rspec, u8 mimoframe)
+{
+	if (is_mcs_rate(rspec))
+		return mimoframe;
+	return is_cck_rate(rspec) ? FT_CCK : FT_OFDM;
+}
+
+/* from: brcmsmac */
+static int bcm4323x_bandtype(enum nl80211_band band)
+{
+	return band == NL80211_BAND_5GHZ ? BRCM_BAND_5G : BRCM_BAND_2G;
+}
+
+/* Fills brcmsmac's basic_rate[] table of a band, for the basic rates of a BSS. */
+void bcm4323x_init_basic_rate(u8 *basic_rate, enum nl80211_band band, u32 basic_rates)
+{
+	unsigned int first = bcm4323x_first_rate(band);
+	struct brcms_c_rateset hw_rateset = {};
+	struct brcms_c_rateset rateset = {};
+	unsigned int i;
+
+	for (i = first; i < BCM4323X_NUM_RATES; i++) {
+		u8 rate = bcm4323x_rates[i].hw_value;
+
+		hw_rateset.rates[hw_rateset.count++] = rate;
+		rateset.rates[rateset.count++] = rate | (basic_rates & BIT(i - first) ?
+							 BRCMS_RATE_FLAG : 0);
+	}
+	brcmu_rate_lookup_init(basic_rate, &hw_rateset, &rateset);
+}
+
+static unsigned int bcm4323x_tx_kbps(struct sk_buff *skb)
+{
+	const struct ieee80211_tx_rate *rate = &IEEE80211_SKB_CB(skb)->control.rates[0];
+
+	return mcs_2_rate(rate->idx, rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH,
+			  rate->flags & IEEE80211_TX_RC_SHORT_GI);
+}
+
+/* from brcmsmac: brcms_c_d11hdrs_mac80211 */
+static u16 bcm4323x_ctlchbw(u16 chanspec)
+{
+	return CHSPEC_SB_UPPER(chanspec) ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
+}
+
+/* from brcmsmac: brcms_c_stf_ss_update */
+u8 bcm4323x_stf_mode(u16 ss_algo_channel)
+{
+	return isset(&ss_algo_channel, PHY_TXC1_MODE_SISO) ? PHY_TXC1_MODE_SISO :
+							      PHY_TXC1_MODE_CDD;
+}
+
+/*
+ * Completes a ratespec as brcms_c_d11hdrs_mac80211() does: MCS frames to 40 MHz
+ * peers (@ht40) take the whole of a 40 MHz channel and other frames its control
+ * sideband, with the single-stream mode for OFDM, and STBC or that mode for
+ * single-stream MCS.
+ */
+static u32 bcm4323x_rspec(u32 rspec, u8 stf_mode, bool stbc, u16 chanspec, bool ht40)
+{
+	u16 bw = bcm4323x_ctlchbw(chanspec);
+
+	if (is_mcs_rate(rspec) && ht40 && CHSPEC_IS40(chanspec))
+		bw = PHY_TXC1_BW_40MHZ;
+	if (is_cck_rate(rspec)) {
+		stf_mode = PHY_TXC1_MODE_SISO;
+	} else if (is_mcs_rate(rspec) && !is_single_stream(rspec & RSPEC_RATE_MASK)) {
+		stf_mode = PHY_TXC1_MODE_SDM;
+	} else if (is_mcs_rate(rspec) && stbc) {
+		stf_mode = PHY_TXC1_MODE_STBC;
+		/* Nss for single stream is always 1 */
+		rspec |= 1 << RSPEC_STC_SHIFT;
+	}
+	return rspec | (bw << RSPEC_BW_SHIFT) | (stf_mode << RSPEC_STF_SHIFT);
+}
+
+static unsigned int bcm4323x_tx_phy_length(struct sk_buff *skb)
+{
+	/* from b43: b43_generate_txhdr, the hardware appends the ICV */
+	return skb->len + FCS_LEN + bcm4323x_tx_meta(skb)->icv_length;
+}
+
+/* What protection needs of the BSS, read as each frame is built */
+struct bcm4323x_protection {
+	/* brcmsmac's band type, and basic_rate[] table for the basic rates of the BSS */
+	int bandtype;
+	u8 basic_rate[BRCM_MAXRATE + 1];
+	bool short_preamble;
+	/* the RTS or CTS-to-self of a frame or aggregate, both short if any */
+	bool cts_only;
+	u32 rts_rspec[2];
+};
+
+/*
+ * from brcmsmac: brcms_c_d11hdrs_mac80211
+ *
+ * The RTS or CTS-to-self of a frame, or of an aggregate of @frame_len bytes
+ * (@ampdu), at the rates of prot->rts_rspec
+ */
+static void bcm4323x_build_rts(struct d11txh *txh, const struct ieee80211_hdr *h,
+			       const struct bcm4323x_protection *prot, const u32 *rspec,
+			       const u8 *preamble_type, uint frame_len, bool ampdu)
+{
+	const u32 *rts_rspec = prot->rts_rspec;
+	struct ieee80211_rts *rts = &txh->rts_frame;
+	u16 mcl = le16_to_cpu(txh->MacTxControlLow);
+	u16 mch = le16_to_cpu(txh->MacTxControlHigh);
+	u16 xfts = le16_to_cpu(txh->XtraFrameTypes);
+	uint rts_phylen;
+	u16 durid[2];
+	unsigned int k;
+
+	/* RTS/CTS additions to MacTxControlLow */
+	if (prot->cts_only)
+		mcl |= TXC_SENDCTS;
+	else
+		mcl |= TXC_SENDRTS | TXC_LONGFRAME;
+
+	/* RTS PLCP header */
+	rts_phylen = (prot->cts_only ? sizeof(struct ieee80211_cts) : sizeof(*rts)) + FCS_LEN;
+	brcmu_compute_plcp(rts_rspec[0], rts_phylen, txh->RTSPhyHeader);
+	/* fallback rate version of RTS PLCP header */
+	brcmu_compute_plcp(rts_rspec[1], rts_phylen, txh->RTSPLCPFallback);
+
+	/* RTS frame fields... */
+	for (k = 0; k < 2; k++) {
+		u8 rts_preamble_type = BRCMS_LONG_PREAMBLE;
+		uint dur;
+
+		/* Unlike brcmsmac, short only if the BSS allows it */
+		if (is_cck_rate(rts_rspec[k]) && prot->short_preamble &&
+		    rspec2rate(rts_rspec[k]) != BRCM_RATE_1M) {
+			rts_preamble_type = BRCMS_SHORT_PREAMBLE;
+			mch |= k ? TXC_PREAMBLE_RTS_FB_SHORT : TXC_PREAMBLE_RTS_MAIN_SHORT;
+		}
+		dur = brcmu_compute_rtscts_dur(prot->bandtype, prot->basic_rate, prot->cts_only,
+					       rts_rspec[k], rspec[k], rts_preamble_type,
+					       preamble_type[k], frame_len, ampdu);
+		durid[k] = min_t(uint, dur, BCM4323X_MAX_DURATION_US);
+	}
+	rts->duration = cpu_to_le16(durid[0]);
+	/* fallback rate version of RTS DUR field */
+	txh->RTSDurFallback = cpu_to_le16(durid[1]);
+	if (prot->cts_only) {
+		rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
+		ether_addr_copy(rts->ra, h->addr2);
+	} else {
+		rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
+		ether_addr_copy(rts->ra, h->addr1);
+		ether_addr_copy(rts->ta, h->addr2);
+	}
+	/*
+	 * Unlike brcmsmac, also without a TXOP limit, as the reference driver
+	 * does for aggregates
+	 */
+	if (ampdu) {
+		txh->TxFesTimeNormal = cpu_to_le16(durid[0]);
+		txh->TxFesTimeFallback = cpu_to_le16(durid[1]);
+	}
+
+	/*
+	 * mainrate
+	 *    low 8 bits: main frag rate/mcs,
+	 *    high 8 bits: rts/cts rate/mcs
+	 */
+	txh->MainRates |= cpu_to_le16((is_ofdm_rate(rts_rspec[0]) ?
+				       D11A_PHY_HDR_GRATE((struct ofdm_phy_hdr *)
+							  txh->RTSPhyHeader) :
+				       txh->RTSPhyHeader[0]) << 8);
+	xfts &= ~((3 << XFTS_RTS_FT_SHIFT) | (3 << XFTS_FBRRTS_FT_SHIFT));
+	xfts |= bcm4323x_frametype(rts_rspec[0], FT_HT) << XFTS_RTS_FT_SHIFT;
+	xfts |= bcm4323x_frametype(rts_rspec[1], FT_HT) << XFTS_FBRRTS_FT_SHIFT;
+	txh->XtraFrameTypes = cpu_to_le16(xfts);
+	txh->PhyTxControlWord_1_Rts = cpu_to_le16(brcmu_phytxctl1_calc(PHY_TYPE_N, rts_rspec[0]));
+	txh->PhyTxControlWord_1_FbrRts =
+		cpu_to_le16(brcmu_phytxctl1_calc(PHY_TYPE_N, rts_rspec[1]));
+	txh->MacTxControlLow = cpu_to_le16(mcl);
+	txh->MacTxControlHigh = cpu_to_le16(mch);
+}
+
+/* from brcmsmac: brcms_c_ampdu_finalize */
+static void bcm4323x_ampdu_finalize(struct d11txh *txh, u8 *plcp, const u32 *rspec,
+				    uint ampdu_len)
+{
+	u16 mcl = le16_to_cpu(txh->MacTxControlLow);
+
+	mcl |= TXC_STARTMSDU;
+	if (is_mcs_rate(rspec[0])) {
+		BRCMS_SET_MIMO_PLCP_LEN(plcp, ampdu_len);
+		/* mark plcp to indicate ampdu */
+		BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
+	}
+
+	/* reset the mixed mode header durations */
+	if (txh->MModeLen)
+		txh->MModeLen = cpu_to_le16(brcmu_calc_lsig_len(rspec[0], ampdu_len));
+	if (txh->MModeFbrLen)
+		txh->MModeFbrLen = cpu_to_le16(brcmu_calc_lsig_len(rspec[1], ampdu_len));
+	txh->MacTxControlLow = cpu_to_le16(mcl);
+}
+
+/* from brcmsmac: brcms_ops_bss_info_changed */
+static bool bcm4323x_n_protection(const struct ieee80211_bss_conf *bss_conf)
+{
+	switch (bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION) {
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * Whether rate control or HT protection asks to protect the frame, and how, an
+ * aggregate through its first MPDU
+ */
+static bool bcm4323x_protection(struct bcm4323x *dev, const struct ieee80211_tx_info *tx_info,
+				const struct ieee80211_hdr *h, const u32 *rspec, u8 stf_mode,
+				u16 chanspec, struct bcm4323x_protection *prot)
+{
+	u32 flags = tx_info->control.rates[0].flags;
+	struct ieee80211_vif *vif;
+	u32 basic_rates = 0;
+	bool g_protection = false;
+	bool n_protection = false;
+	unsigned int k;
+
+	rcu_read_lock();
+	vif = rcu_dereference(dev->active_vif);
+	if (vif) {
+		basic_rates = vif->bss_conf.basic_rates;
+		prot->short_preamble = vif->bss_conf.use_short_preamble;
+		g_protection = vif->bss_conf.use_cts_prot && tx_info->band == NL80211_BAND_2GHZ;
+		n_protection = (flags & IEEE80211_TX_RC_MCS) &&
+			       bcm4323x_n_protection(&vif->bss_conf);
+	}
+	rcu_read_unlock();
+	if (!(flags & (IEEE80211_TX_RC_USE_RTS_CTS | IEEE80211_TX_RC_USE_CTS_PROTECT)) &&
+	    !n_protection)
+		return false;
+	/* Nothing would answer the RTS of a group-addressed frame. */
+	prot->cts_only = !(flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
+			 is_multicast_ether_addr(h->addr1) ||
+			 (tx_info->flags & IEEE80211_TX_CTL_NO_ACK);
+	prot->bandtype = bcm4323x_bandtype(tx_info->band);
+	bcm4323x_init_basic_rate(prot->basic_rate, tx_info->band, basic_rates);
+	/* from brcmsmac: brcms_c_rspec_to_rts_rspec */
+	for (k = 0; k < 2; k++) {
+		u32 rts_rspec;
+
+		if (g_protection && !is_cck_rate(rspec[k]))
+			rts_rspec = brcmu_basic_rate(prot->basic_rate, BRCM_RATE_11M);
+		else
+			rts_rspec = brcmu_basic_rate(prot->basic_rate, rspec[k]);
+		rts_rspec = bcm4323x_rspec(rts_rspec, stf_mode, false, chanspec, false);
+		if (rspec_is40mhz(rspec[k]) && !is_cck_rate(rts_rspec))
+			rts_rspec = (rts_rspec & ~RSPEC_BW_MASK) |
+				    (PHY_TXC1_BW_40MHZ_DUP << RSPEC_BW_SHIFT);
+		prot->rts_rspec[k] = rts_rspec;
+	}
+	return true;
+}
+
+/* from brcmsmac: brcms_c_d11hdrs_mac80211 */
+static void bcm4323x_tx_rspecs(const struct ieee80211_tx_info *tx_info, bool ampdu,
+			       u16 chanspec, u16 ss_algo_channel, u32 *rspec, u8 *preamble_type)
+{
+	const struct ieee80211_tx_rate *rate = &tx_info->control.rates[0];
+	bool band_5ghz = tx_info->band == NL80211_BAND_5GHZ;
+	u8 stf_mode = bcm4323x_stf_mode(ss_algo_channel);
+	bool stbc;
+	unsigned int k;
+
+	if (rate->flags & IEEE80211_TX_RC_MCS)
+		rspec[0] = RSPEC_MIMORATE | rate->idx |
+			   (rate->flags & IEEE80211_TX_RC_SHORT_GI ? RSPEC_SHORT_GI : 0);
+	else
+		rspec[0] = bcm4323x_rates[bcm4323x_first_rate(tx_info->band) + rate->idx].hw_value;
+	/*
+	 * Aggregated MPDUs, and unlike brcmsmac MCS frames on 5 GHz as in the
+	 * vendor driver, fall back to one spatial stream or MCS 0, and others
+	 * to 1 Mbit/s or to 6 Mbit/s on 5 GHz, as legacy OFDM fallbacks were
+	 * reported acknowledged yet never received.
+	 */
+	if (ampdu || (band_5ghz && (rate->flags & IEEE80211_TX_RC_MCS)))
+		rspec[1] = RSPEC_MIMORATE | (is_single_stream(rate->idx) ? 0 :
+					     rate->idx - (HIGHEST_SINGLE_STREAM_MCS + 1));
+	else
+		rspec[1] = band_5ghz ? BRCM_RATE_6M : BRCM_RATE_1M;
+
+	/* from brcmsmac: BRCMS_STF_SS_STBC_TX */
+	stbc = (tx_info->flags & IEEE80211_TX_CTL_STBC) &&
+	       isset(&ss_algo_channel, PHY_TXC1_MODE_STBC);
+	for (k = 0; k < 2; k++) {
+		rspec[k] = bcm4323x_rspec(rspec[k], stf_mode, stbc, chanspec,
+					  rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH);
+		preamble_type[k] = is_mcs_rate(rspec[k]) ? BRCMS_MM_PREAMBLE : BRCMS_LONG_PREAMBLE;
+	}
+	if (is_cck_rate(rspec[0]) && (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE) &&
+	    rspec2rate(rspec[0]) != BRCM_RATE_1M)
+		preamble_type[0] = BRCMS_SHORT_PREAMBLE;
+}
+
+/* from brcmsmac: brcms_c_d11hdrs_mac80211, MacTxControlLow */
+static u16 bcm4323x_tx_mcl(const struct ieee80211_tx_info *tx_info, struct ieee80211_hdr *h,
+			   struct d11txh *txh, const u32 *rspec, bool ampdu, u8 ampdu_position,
+			   u16 chanspec)
+{
+	bool band_5ghz = tx_info->band == NL80211_BAND_5GHZ;
+	u16 mcl = TXC_STARTMSDU;
+
+	if (band_5ghz)
+		mcl |= TXC_FREQBAND_5G;
+	if (CHSPEC_IS40(chanspec))
+		mcl |= TXC_BW_40;
+	if (!is_multicast_ether_addr(h->addr1) && !(tx_info->flags & IEEE80211_TX_CTL_NO_ACK))
+		mcl |= TXC_IMMEDACK;
+	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		mcl |= TXC_HWSEQ;
+	if (ampdu) {
+		mcl &= ~TXC_STARTMSDU;
+		mcl |= (ampdu_position << TXC_AMPDU_SHIFT) | TXC_LONGFRAME;
+		h->duration_id = cpu_to_le16(BCM4323X_OFDM_ACK_DURATION_US);
+		txh->FragDurFallback = cpu_to_le16(BCM4323X_OFDM_ACK_DURATION_US);
+	} else if (mcl & TXC_IMMEDACK) {
+		/* mac80211 leaves the duration of MCS and fast-xmit frames to the driver. */
+		if (ieee80211_is_data(h->frame_control) && !h->duration_id)
+			h->duration_id = cpu_to_le16(is_cck_rate(rspec[0]) ?
+						     BCM4323X_CCK_ACK_DURATION_US :
+						     BCM4323X_OFDM_ACK_DURATION_US);
+		if (is_mcs_rate(rspec[1]))
+			txh->FragDurFallback = cpu_to_le16(BCM4323X_OFDM_ACK_DURATION_US);
+		else
+			txh->FragDurFallback = cpu_to_le16(band_5ghz ?
+							   BCM4323X_OFDM6_ACK_DURATION_US :
+							   BCM4323X_CCK_ACK_DURATION_US);
+	}
+	return mcl;
+}
+
+/*
+ * from brcmsmac: brcms_c_d11hdrs_mac80211
+ *
+ * @ampdu_len is the length of the aggregate on its first MPDU, and 0 otherwise.
+ */
+static void bcm4323x_build_txh(struct bcm4323x *dev, struct sk_buff *skb,
+			       struct bcm4323x_txh *tx_header, u8 ampdu_position,
+			       unsigned int ampdu_len)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct bcm4323x_tx_meta *metadata = bcm4323x_tx_meta(skb);
+	bool ampdu = metadata->flags & BCM4323X_TX_META_AMPDU;
+	bool hardware_key = metadata->flags & BCM4323X_TX_META_KEY;
+	struct ieee80211_hdr *h = (void *)skb->data;
+	unsigned int phylen = bcm4323x_tx_phy_length(skb);
+	u16 chanspec = READ_ONCE(dev->chanspec);
+	u16 ss_algo_channel = READ_ONCE(dev->ss_algo_channel);
+	struct d11txh *txh = &tx_header->d11;
+	u8 *plcp = tx_header->plcp;
+	struct bcm4323x_protection prot = {};
+	bool protect = false;
+	u32 rspec[2];
+	u8 preamble_type[2];
+	u16 mch = 0;
+	u16 phyctl = PHY_TXC_ANT_0_1;
+	u16 mainrates;
+	u16 xfts;
+
+	memset(tx_header, 0, sizeof(*tx_header));
+	bcm4323x_tx_rspecs(tx_info, ampdu, chanspec, ss_algo_channel, rspec, preamble_type);
+	if (!ampdu || ampdu_len)
+		protect = bcm4323x_protection(dev, tx_info, h, rspec,
+					      bcm4323x_stf_mode(ss_algo_channel), chanspec, &prot);
+	txh->MacTxControlLow = cpu_to_le16(bcm4323x_tx_mcl(tx_info, h, txh, rspec, ampdu,
+							   ampdu_position, chanspec));
+	if (hardware_key)
+		mch = FIELD_PREP(TXC_SECKEY_MASK, metadata->key_index) |
+		      FIELD_PREP(TXC_SECTYPE_MASK, WSEC_ALGO_AES);
+
+	brcmu_compute_plcp(rspec[0], phylen, plcp);
+	brcmu_compute_plcp(rspec[1], phylen, txh->FragPLCPFallback);
+	/* Length field now put in CCK FBR CRC field */
+	if (is_cck_rate(rspec[1])) {
+		txh->FragPLCPFallback[4] = phylen & 0xff;
+		txh->FragPLCPFallback[5] = (phylen & 0xff00) >> 8;
+	}
+	mainrates = is_ofdm_rate(rspec[0]) ?
+		    D11A_PHY_HDR_GRATE((struct ofdm_phy_hdr *)plcp) : plcp[0];
+	xfts = bcm4323x_frametype(rspec[1], FT_HT) | (FT_OFDM << XFTS_RTS_FT_SHIFT) |
+	       (FT_OFDM << XFTS_FBRRTS_FT_SHIFT) |
+	       (CHSPEC_CHANNEL(chanspec) << XFTS_CHANNEL_SHIFT);
+	phyctl |= bcm4323x_frametype(rspec[0], FT_HT);
+	if (preamble_type[0] == BRCMS_SHORT_PREAMBLE)
+		phyctl |= PHY_TXC_SHORT_HDR;
+	if (is_mcs_rate(rspec[0]))
+		txh->MModeLen = cpu_to_le16(brcmu_calc_lsig_len(rspec[0], phylen));
+	if (is_mcs_rate(rspec[1]))
+		txh->MModeFbrLen = cpu_to_le16(brcmu_calc_lsig_len(rspec[1], phylen));
+
+	txh->MacTxControlHigh = cpu_to_le16(mch);
+	txh->MacFrameControl = h->frame_control;
+	txh->PhyTxControlWord = cpu_to_le16(phyctl);
+	txh->PhyTxControlWord_1 = cpu_to_le16(brcmu_phytxctl1_calc(PHY_TYPE_N, rspec[0]));
+	txh->PhyTxControlWord_1_Fbr = cpu_to_le16(brcmu_phytxctl1_calc(PHY_TYPE_N, rspec[1]));
+	txh->MainRates = cpu_to_le16(mainrates);
+	txh->XtraFrameTypes = cpu_to_le16(xfts);
+	if (hardware_key && ieee80211_has_protected(h->frame_control))
+		memcpy(txh->IV, skb->data + ieee80211_hdrlen(h->frame_control),
+		       min_t(size_t, metadata->iv_length, sizeof(txh->IV)));
+	ether_addr_copy(txh->TxFrameRA, h->addr1);
+	txh->TxFrameID = cpu_to_le16(metadata->frame_id);
+	if (ampdu_len)
+		bcm4323x_ampdu_finalize(txh, plcp, rspec, ampdu_len);
+	if (protect)
+		bcm4323x_build_rts(txh, h, &prot, rspec, preamble_type, ampdu_len ?: phylen,
+				   ampdu_len);
+	/* add null delimiter count, none after the last MPDU */
+	if (ampdu)
+		txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM] =
+			ampdu_position == TXC_AMPDU_LAST ? 0 : metadata->null_delimiters;
+}
+
+static void bcm4323x_tx_complete(struct urb *urb)
+{
+	struct bcm4323x *dev = urb->context;
+
+	if (urb->status == -ENOENT || urb->status == -ECONNRESET || urb->status == -ESHUTDOWN)
+		return;
+
+	if (urb->status) {
+		dev_err_ratelimited(&dev->intf->dev, "TX URB failed: %d\n", urb->status);
+		bcm4323x_fatal_error(dev);
+	}
+}
+
+/* @density is the minimum MPDU start spacing of the recipient. */
+static u8 bcm4323x_ampdu_null_delimiters(struct sk_buff *skb, u8 density)
+{
+	u64 spacing_ns;
+	unsigned int minimum_bytes;
+	unsigned int occupied_bytes;
+
+	if (!density)
+		return 0;
+	spacing_ns = 250ULL << (density - 1);
+	minimum_bytes = DIV_ROUND_UP_ULL((u64)bcm4323x_tx_kbps(skb) * spacing_ns, 8000000);
+	occupied_bytes = AMPDU_DELIMITER_LEN + ALIGN(bcm4323x_tx_phy_length(skb), 4);
+	if (minimum_bytes <= occupied_bytes)
+		return 0;
+	return min_t(unsigned int, DIV_ROUND_UP(minimum_bytes - occupied_bytes, 4), U8_MAX);
+}
+
+static bool bcm4323x_ampdu_compatible(struct sk_buff *first, struct sk_buff *next)
+{
+	struct ieee80211_tx_info *first_info = IEEE80211_SKB_CB(first);
+	struct ieee80211_tx_info *next_info = IEEE80211_SKB_CB(next);
+	struct bcm4323x_tx_meta *first_meta = bcm4323x_tx_meta(first);
+	struct bcm4323x_tx_meta *next_meta = bcm4323x_tx_meta(next);
+
+	return first_meta->flags == next_meta->flags &&
+	       first_meta->key_index == next_meta->key_index &&
+	       !((first_info->flags ^ next_info->flags) & IEEE80211_TX_CTL_RATE_CTRL_PROBE) &&
+	       first_info->control.rates[0].idx == next_info->control.rates[0].idx &&
+	       first_info->control.rates[0].flags == next_info->control.rates[0].flags;
+}
+
+static struct urb *bcm4323x_tx_urb(struct bcm4323x *dev, struct sk_buff *skb, unsigned int index,
+				   unsigned int count, unsigned int aggregate_length)
+{
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct bcm4323x_tx_meta *metadata = bcm4323x_tx_meta(skb);
+	bool ampdu = metadata->flags & BCM4323X_TX_META_AMPDU;
+	struct bcm4323x_rpc_header *rpc;
+	struct bcm4323x_tx_call *call;
+	size_t body_length;
+	size_t total_length;
+	struct urb *urb;
+	u32 fifo;
+	u8 ampdu_position = TXC_AMPDU_NONE;
+
+	body_length = ALIGN(struct_size(call, frame, skb->len), sizeof(__le32));
+	total_length = sizeof(*rpc) + body_length;
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!urb)
+		return NULL;
+	urb->transfer_flags |= URB_FREE_BUFFER | URB_ZERO_PACKET;
+	urb->transfer_buffer = kzalloc(total_length, GFP_KERNEL);
+	if (!urb->transfer_buffer) {
+		usb_free_urb(urb);
+		return NULL;
+	}
+
+	fifo = bcm4323x_ac_to_fifo(skb_get_queue_mapping(skb));
+	dev->tx_sequence++;
+	metadata->frame_id = ((dev->tx_sequence << TXFID_SEQ_SHIFT) & TXFID_SEQ_MASK) |
+			     (fifo & TXFID_QUEUE_MASK);
+
+	if (aggregate_length && index == count - 1)
+		ampdu_position = TXC_AMPDU_LAST;
+	else if (aggregate_length)
+		ampdu_position = index ? TXC_AMPDU_MIDDLE : TXC_AMPDU_FIRST;
+
+	rpc = urb->transfer_buffer;
+	call = (void *)(rpc + 1);
+	call->fifo = cpu_to_le32(fifo);
+	/* Last one of the aggregate */
+	call->commit = cpu_to_le32(!aggregate_length || index == count - 1);
+	call->arg2 = cpu_to_le32(BCM4323X_TX_ARG2);
+	call->weight = cpu_to_le32(ampdu ? BCM4323X_TX_WEIGHT_AMPDU : BCM4323X_TX_WEIGHT);
+	call->flags = cpu_to_le32(ieee80211_is_data(hdr->frame_control) ? BCM4323X_TX_FLAGS_DATA :
+								   BCM4323X_TX_FLAGS_MGMT);
+	call->packet_length = cpu_to_le32(sizeof(call->txh) + skb->len);
+	bcm4323x_build_txh(dev, skb, &call->txh, ampdu_position, index ? 0 : aggregate_length);
+	/* A-MSDU subframes after the first are chained on the frag list. */
+	skb_copy_bits(skb, 0, call->frame, skb->len);
+	rpc->length = bcm4323x_rpc_length(body_length);
+	rpc->procedure = cpu_to_le32(BCM4323X_RPC_PROC_TX);
+	usb_fill_bulk_urb(urb, dev->udev, dev->tx_pipe,
+			  urb->transfer_buffer, total_length, bcm4323x_tx_complete, dev);
+	return urb;
+}
+
+static int bcm4323x_submit_tx_urb(struct bcm4323x *dev, struct urb *urb)
+{
+	struct bcm4323x_rpc_header *rpc = urb->transfer_buffer;
+	int ret;
+
+	lockdep_assert_held(&dev->io_mutex);
+	rpc->xid_class = bcm4323x_rpc_xid_class(BCM4323X_RPC_CLASS_DATA, dev->rpc_xid);
+	usb_anchor_urb(urb, &dev->tx_anchor);
+	ret = usb_submit_urb(urb, GFP_KERNEL);
+	if (ret)
+		usb_unanchor_urb(urb);
+	else
+		dev->rpc_xid++;
+	return ret;
+}
+
+/*
+ * The firmware MAC stalls with two multi-frame batches committed, so
+ * avoid committing two batches.
+ */
+static bool bcm4323x_may_commit(struct bcm4323x *dev, unsigned int count)
+{
+	unsigned int older = skb_queue_len(&dev->tx_batches[0]);
+
+	return !older || (skb_queue_empty(&dev->tx_batches[1]) && (count == 1 || older == 1));
+}
+
+static void bcm4323x_add_committed(struct bcm4323x *dev, struct sk_buff_head *batch)
+{
+	unsigned int slot = !skb_queue_empty(&dev->tx_batches[0]);
+
+	if (!slot)
+		dev->tx_expires = jiffies + BCM4323X_TX_TIMEOUT;
+	skb_queue_splice_tail_init(batch, &dev->tx_batches[slot]);
+}
+
+static int bcm4323x_tx_urbs(struct bcm4323x *dev, struct sk_buff_head *batch,
+			    unsigned int aggregate_length, struct urb **urbs)
+{
+	unsigned int count = skb_queue_len(batch);
+	unsigned int index = 0;
+	struct sk_buff *skb;
+
+	skb_queue_walk(batch, skb) {
+		urbs[index] = bcm4323x_tx_urb(dev, skb, index, count, aggregate_length);
+		if (!urbs[index])
+			return -ENOMEM;
+		index++;
+	}
+	return 0;
+}
+
+/*
+ * Since the firmware will crash when committing two batches, we commit the
+ * first one, put the data of the second one in the device, then wait
+ * for the first one to complete before completing the second one. This allows
+ * overlapping transmit and usb tx, making things faster
+ */
+static void bcm4323x_tx_batch(struct bcm4323x *dev, struct sk_buff_head *batch,
+			      unsigned int aggregate_length)
+{
+	unsigned int count = skb_queue_len(batch);
+	bool staged = !bcm4323x_may_commit(dev, count);
+	/* A staged batch keeps back its last call. */
+	unsigned int to_submit = staged ? count - 1 : count;
+	struct urb *urbs[BCM4323X_TX_BATCH_FRAMES] = {};
+	unsigned int submitted = 0;
+	unsigned int index;
+	int ret;
+
+	ret = bcm4323x_tx_urbs(dev, batch, aggregate_length, urbs);
+	if (ret)
+		goto out;
+	mutex_lock(&dev->io_mutex);
+	while (submitted < to_submit) {
+		ret = bcm4323x_submit_tx_urb(dev, urbs[submitted]);
+		if (ret)
+			break;
+		submitted++;
+	}
+	mutex_unlock(&dev->io_mutex);
+	if (!ret && staged)
+		swap(dev->tx_commit, urbs[count - 1]);
+
+out:
+	for (index = 0; index < count; index++)
+		usb_free_urb(urbs[index]);
+	if (!ret) {
+		WRITE_ONCE(dev->tx_owned, dev->tx_owned + count);
+		if (staged)
+			skb_queue_splice_tail_init(batch, &dev->tx_batches[BCM4323X_TX_STAGED]);
+		else
+			bcm4323x_add_committed(dev, batch);
+		return;
+	}
+	/* Firmware holds back later RPCs until it receives a missing ID. */
+	if (submitted) {
+		dev_err_ratelimited(&dev->intf->dev, "incomplete A-MPDU submission\n");
+		bcm4323x_fatal_error(dev);
+	}
+	bcm4323x_fail_batch(dev, batch);
+}
+
+/* Submits the last call of the staged batch, which commits it. */
+static void bcm4323x_commit_staged(struct bcm4323x *dev)
+{
+	struct urb *urb = dev->tx_commit;
+	int ret;
+
+	dev->tx_commit = NULL;
+	mutex_lock(&dev->io_mutex);
+	ret = bcm4323x_submit_tx_urb(dev, urb);
+	mutex_unlock(&dev->io_mutex);
+	usb_free_urb(urb);
+	bcm4323x_add_committed(dev, &dev->tx_batches[BCM4323X_TX_STAGED]);
+	if (ret) {
+		dev_err_ratelimited(&dev->intf->dev, "TX commit failed: %d\n", ret);
+		bcm4323x_fatal_error(dev);
+		bcm4323x_fail_pending(dev);
+	}
+}
+
+static struct sk_buff *bcm4323x_txq_dequeue(struct bcm4323x *dev, struct ieee80211_txq *txq)
+{
+	struct sk_buff *skb = __skb_dequeue(&to_bcm4323x_txq(txq)->frames);
+
+	if (skb)
+		return skb;
+	while ((skb = ieee80211_tx_dequeue_ni(dev->hw, txq)))
+		if (bcm4323x_prepare_tx(dev, skb))
+			break;
+	return skb;
+}
+
+static u16 bcm4323x_window_start(struct bcm4323x *dev, struct sk_buff *first)
+{
+	struct ieee80211_hdr *hdr = (void *)first->data;
+	u16 start = ieee80211_get_sn(hdr);
+	struct sk_buff *skb;
+	unsigned int i;
+
+	for (i = 0; i < BCM4323X_TX_STAGED; i++) {
+		skb_queue_walk(&dev->tx_batches[i], skb) {
+			struct ieee80211_hdr *owned_hdr = (void *)skb->data;
+
+			if ((bcm4323x_tx_meta(skb)->flags & BCM4323X_TX_META_AMPDU) &&
+			    ether_addr_equal(owned_hdr->addr1, hdr->addr1) &&
+			    ieee80211_get_tid(owned_hdr) == ieee80211_get_tid(hdr) &&
+			    ieee80211_sn_less(ieee80211_get_sn(owned_hdr), start))
+				start = ieee80211_get_sn(owned_hdr);
+		}
+	}
+	return start;
+}
+
+static unsigned int bcm4323x_ampdu_grow(struct sk_buff *last, struct sk_buff *next,
+					unsigned int length, u8 density)
+{
+	unsigned int next_length = AMPDU_DELIMITER_LEN + bcm4323x_tx_phy_length(next);
+	struct bcm4323x_tx_meta *metadata;
+
+	if (!last)
+		return next_length;
+	metadata = bcm4323x_tx_meta(last);
+	metadata->null_delimiters = bcm4323x_ampdu_null_delimiters(last, density);
+	return roundup(length, 4) + metadata->null_delimiters * AMPDU_DELIMITER_LEN + next_length;
+}
+
+/* from brcmsmac: brcms_c_ampdu_add_frame, brcms_c_scb_ampdu_update_max_txlen */
+static unsigned int bcm4323x_txq_batch(struct bcm4323x *dev, struct ieee80211_txq *txq,
+				       struct sk_buff_head *batch)
+{
+	struct bcm4323x_txq *txq_priv = to_bcm4323x_txq(txq);
+	struct sk_buff *first = bcm4323x_txq_dequeue(dev, txq);
+	struct ieee80211_sta_ht_cap *ht_cap;
+	u8 window;
+	u16 start;
+	unsigned int max_bytes;
+	unsigned int max_frames;
+	struct sk_buff *next = first;
+	struct sk_buff *last = NULL;
+	unsigned int aggregate_length = 0;
+
+	if (!first)
+		return 0;
+	if (!(bcm4323x_tx_meta(first)->flags & BCM4323X_TX_META_AMPDU)) {
+		__skb_queue_tail(batch, first);
+		return 0;
+	}
+
+	ht_cap = &txq->sta->deflink.ht_cap;
+	window = READ_ONCE(txq_priv->ampdu_window) ?: 1;
+	start = bcm4323x_window_start(dev, first);
+	max_bytes = min3((1U << (IEEE80211_HT_MAX_AMPDU_FACTOR + ht_cap->ampdu_factor)) - 1,
+			 bcm4323x_tx_kbps(first) * AMPDU_MAX_DUR / 8,
+			 BCM4323X_TX_BATCH_BYTES);
+	max_frames = min(window, BCM4323X_TX_BATCH_FRAMES);
+	do {
+		unsigned int length = bcm4323x_ampdu_grow(last, next, aggregate_length,
+							  ht_cap->ampdu_density);
+
+		if (ieee80211_sn_sub(ieee80211_get_sn((void *)next->data), start) >= window ||
+		    (last && (!bcm4323x_ampdu_compatible(first, next) || length > max_bytes))) {
+			__skb_queue_head(&txq_priv->frames, next);
+			break;
+		}
+		__skb_queue_tail(batch, next);
+		aggregate_length = length;
+		last = next;
+	} while (skb_queue_len(batch) < max_frames && (next = bcm4323x_txq_dequeue(dev, txq)));
+	return aggregate_length;
+}
+
+static unsigned int bcm4323x_next_batch(struct bcm4323x *dev, struct sk_buff_head *batch)
+{
+	struct ieee80211_hw *hw = dev->hw;
+	unsigned int aggregate_length = 0;
+	struct ieee80211_txq *txq;
+	struct sk_buff *skb;
+	u8 ac;
+
+	skb = skb_dequeue(&dev->tx_queue);
+	if (skb) {
+		__skb_queue_tail(batch, skb);
+		return 0;
+	}
+	/* RCU protects pointers in a dequeued frame until bcm4323x_prepare_tx(). */
+	rcu_read_lock();
+	for (ac = IEEE80211_AC_VO; ac < IEEE80211_NUM_ACS && skb_queue_empty(batch); ac++) {
+		ieee80211_txq_schedule_start(hw, ac);
+		while (skb_queue_empty(batch) && (txq = ieee80211_next_txq(hw, ac))) {
+			struct bcm4323x_txq *txq_priv = to_bcm4323x_txq(txq);
+
+			aggregate_length = bcm4323x_txq_batch(dev, txq, batch);
+			ieee80211_return_txq(hw, txq, !skb_queue_empty(&txq_priv->frames));
+		}
+		ieee80211_txq_schedule_end(hw, ac);
+	}
+	rcu_read_unlock();
+	return aggregate_length;
+}
+
+static void bcm4323x_tx_worker(struct work_struct *work)
+{
+	struct bcm4323x *dev = container_of(work, struct bcm4323x, tx_work);
+	struct sk_buff_head *staged = &dev->tx_batches[BCM4323X_TX_STAGED];
+	struct bcm4323x_tx_status txs;
+	unsigned int aggregate_length;
+	struct sk_buff_head batch;
+
+	__skb_queue_head_init(&batch);
+	mutex_lock(&dev->tx_mutex);
+	while (kfifo_get(&dev->tx_statuses, &txs))
+		bcm4323x_complete_tx(dev, &txs);
+	while (bcm4323x_active(dev)) {
+		if (!skb_queue_empty(staged) && bcm4323x_may_commit(dev, skb_queue_len(staged)))
+			bcm4323x_commit_staged(dev);
+		if (dev->tx_paused || !skb_queue_empty(staged))
+			break;
+		aggregate_length = bcm4323x_next_batch(dev, &batch);
+		if (skb_queue_empty(&batch))
+			break;
+		bcm4323x_tx_batch(dev, &batch, aggregate_length);
+	}
+	mutex_unlock(&dev->tx_mutex);
+	wake_up_all(&dev->tx_wait);
+}
+
+void bcm4323x_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control, struct sk_buff *skb)
+{
+	struct bcm4323x *dev = hw->priv;
+
+	if (!bcm4323x_prepare_tx(dev, skb))
+		return;
+	skb_queue_tail(&dev->tx_queue, skb);
+	bcm4323x_schedule_tx_work(dev);
+}
+
+void bcm4323x_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+{
+	bcm4323x_schedule_tx_work(hw->priv);
+}
+
+void bcm4323x_check_tx(struct bcm4323x *dev)
+{
+	mutex_lock(&dev->tx_mutex);
+	if (kfifo_is_empty(&dev->tx_statuses) && !skb_queue_empty(&dev->tx_batches[0]) &&
+	    time_after(jiffies, dev->tx_expires)) {
+		dev_err(&dev->intf->dev, "firmware TX status timeout\n");
+		bcm4323x_fatal_error(dev);
+		bcm4323x_fail_pending(dev);
+	}
+	mutex_unlock(&dev->tx_mutex);
+	wake_up_all(&dev->tx_wait);
+}
+
+/* Drops the frames of a queue that use a key slot. */
+static void bcm4323x_drop_tx(struct bcm4323x *dev, struct sk_buff_head *queue, u8 key_index)
+{
+	struct sk_buff_head dropped;
+	struct sk_buff *skb;
+	struct sk_buff *tmp;
+	unsigned long flags;
+
+	__skb_queue_head_init(&dropped);
+	spin_lock_irqsave(&queue->lock, flags);
+	skb_queue_walk_safe(queue, skb, tmp) {
+		struct bcm4323x_tx_meta *metadata = bcm4323x_tx_meta(skb);
+
+		if ((metadata->flags & BCM4323X_TX_META_KEY) && metadata->key_index == key_index) {
+			__skb_unlink(skb, queue);
+			__skb_queue_tail(&dropped, skb);
+		}
+	}
+	spin_unlock_irqrestore(&queue->lock, flags);
+	ieee80211_purge_tx_queue(dev->hw, &dropped);
+}
+
+void bcm4323x_flush_tx(struct bcm4323x *dev)
+{
+	cancel_work_sync(&dev->tx_work);
+	/* Flush the firmware buffers */
+	if (dev->tx_commit && !READ_ONCE(dev->dead))
+		bcm4323x_commit_staged(dev);
+	/* A killed URB can leave its transaction ID unsent; let submissions finish. */
+	usb_wait_anchor_empty_timeout(&dev->tx_anchor, BCM4323X_TX_DRAIN_MS);
+	usb_kill_anchored_urbs(&dev->tx_anchor);
+	kfifo_reset(&dev->tx_statuses);
+	ieee80211_purge_tx_queue(dev->hw, &dev->tx_queue);
+	bcm4323x_fail_pending(dev);
+}
+
+void bcm4323x_set_tx_paused(struct bcm4323x *dev, bool paused)
+{
+	mutex_lock(&dev->tx_mutex);
+	dev->tx_paused = paused;
+	mutex_unlock(&dev->tx_mutex);
+	if (!paused)
+		bcm4323x_schedule_tx_work(dev);
+}
+
+bool bcm4323x_quiesce_tx(struct bcm4323x *dev)
+{
+	bcm4323x_set_tx_paused(dev, true);
+	return wait_event_timeout(dev->tx_wait, !READ_ONCE(dev->tx_owned) || READ_ONCE(dev->dead),
+				  BCM4323X_TX_WAIT);
+}
+
+/* Drain queued frames which use the key slot that is currently requested to be dropped */
+void bcm4323x_retire_key(struct bcm4323x *dev, u8 key_index, struct ieee80211_sta *sta)
+{
+	unsigned int i;
+
+	clear_bit(key_index, dev->keys);
+	/* Frames prepared from now on are dropped. */
+	synchronize_net();
+	/* Frames that are being buffered must not go out without their key. */
+	if (!bcm4323x_quiesce_tx(dev))
+		bcm4323x_fatal_error(dev);
+	bcm4323x_drop_tx(dev, &dev->tx_queue, key_index);
+	for (i = 0; sta && i < IEEE80211_NUM_TIDS; i++)
+		bcm4323x_drop_tx(dev, &to_bcm4323x_txq(sta->txq[i])->frames, key_index);
+	bcm4323x_set_tx_paused(dev, false);
+}
+
+static bool bcm4323x_tx_idle(struct bcm4323x *dev)
+{
+	if (!bcm4323x_active(dev))
+		return true;
+
+	return skb_queue_empty_lockless(&dev->tx_queue) && !READ_ONCE(dev->tx_owned) &&
+	       !mutex_is_locked(&dev->tx_mutex);
+}
+
+void bcm4323x_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u32 queues, bool drop)
+{
+	struct bcm4323x *dev = hw->priv;
+	struct sk_buff *skb;
+	bool idle;
+
+	if (drop) {
+		idle = bcm4323x_quiesce_tx(dev);
+		/* bcm4323x_tx() may still be queueing a frame. */
+		while ((skb = skb_dequeue(&dev->tx_queue)))
+			ieee80211_free_txskb(hw, skb);
+		bcm4323x_set_tx_paused(dev, false);
+	} else {
+		idle = wait_event_timeout(dev->tx_wait, bcm4323x_tx_idle(dev), BCM4323X_TX_WAIT);
+	}
+	if (!idle)
+		dev_warn(&dev->intf->dev, "TX flush timed out\n");
+}
+
+/* from brcmsmac: brcms_ops_ampdu_action */
+int bcm4323x_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_ampdu_params *params)
+{
+	struct bcm4323x *dev = hw->priv;
+	struct ieee80211_txq *txq = params->sta->txq[params->tid];
+	struct sk_buff_head *frames = &to_bcm4323x_txq(txq)->frames;
+	struct sk_buff *skb;
+
+	switch (params->action) {
+	case IEEE80211_AMPDU_RX_START:
+	case IEEE80211_AMPDU_RX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		return 0;
+	case IEEE80211_AMPDU_TX_START:
+		return IEEE80211_AMPDU_TX_START_IMMEDIATE;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		WRITE_ONCE(to_bcm4323x_txq(txq)->ampdu_window, params->buf_size);
+		return 0;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+		bcm4323x_quiesce_tx(dev);
+		/* While TX is paused, the TX work leaves the TX queues alone. */
+		skb_queue_walk(frames, skb)
+			bcm4323x_tx_meta(skb)->flags &= ~BCM4323X_TX_META_AMPDU;
+		bcm4323x_set_tx_paused(dev, false);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, params->sta->addr, params->tid);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+void bcm4323x_init_txq(struct ieee80211_txq *txq)
+{
+	skb_queue_head_init(&to_bcm4323x_txq(txq)->frames);
+}
+
+int bcm4323x_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta, enum ieee80211_sta_state old_state,
+		       enum ieee80211_sta_state new_state)
+{
+	struct bcm4323x *dev = hw->priv;
+	unsigned int i;
+
+	if (old_state == IEEE80211_STA_NOTEXIST) {
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++)
+			bcm4323x_init_txq(sta->txq[i]);
+	} else if (new_state == IEEE80211_STA_NOTEXIST) {
+		mutex_lock(&dev->tx_mutex);
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++)
+			ieee80211_purge_tx_queue(hw, &to_bcm4323x_txq(sta->txq[i])->frames);
+		mutex_unlock(&dev->tx_mutex);
+	}
+	return 0;
+}
+
+void bcm4323x_init_tx(struct bcm4323x *dev)
+{
+	unsigned int i;
+
+	init_usb_anchor(&dev->tx_anchor);
+	init_waitqueue_head(&dev->tx_wait);
+	skb_queue_head_init(&dev->tx_queue);
+	INIT_WORK(&dev->tx_work, bcm4323x_tx_worker);
+	INIT_KFIFO(dev->tx_statuses);
+	mutex_init(&dev->tx_mutex);
+	for (i = 0; i < ARRAY_SIZE(dev->tx_batches); i++)
+		__skb_queue_head_init(&dev->tx_batches[i]);
+}
-- 
2.53.0

