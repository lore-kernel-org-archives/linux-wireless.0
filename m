Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6953343893
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792198322; cv=none; b=pIr5B2PnbU5Jw9k59bv+iV6TPsgTTac+cYfuyqJcCsltX3yzFzXmS4YaABYVdmtFjjjfT5cnEqvlSVTBXMdz1q5zeC5FdWMTZJ2nsDRA4JNNNI87P4lCtAnKWNs6OSoOFHhAoDcBvLLgD8UUrSGsci581dKrsZArn1eSFt6bmmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792198322; c=relaxed/simple;
	bh=w59jMPfZDFQC4ZsKveP6HDHJAZPKM+F/uDhBudfMTas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TAldsngG8zjY0x+DlOIxO+Sx+bBH3y5bxLQ7Esv0vgP06+MjIsDK7pdO4mv1XShmtpnhr1HIa/wHfx/rj+ukrASFE3AbqMtbUEVaB+tvuANsdjyZhV7EtMHQlTIqaVXsQTh0/TabXup4N4eHAVmNoJBWjxPVqood3bV7JKmPE5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AJPEXnM8; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJPEXnM8"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so454788a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 17:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792198319; x=1792803119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pS9vsZjnoYZ5Z/rGHYsRUA9k6Kk3CgYA5qQssv3k9eI=;
        b=AJPEXnM8LEhTiny5qoN/ZoFiBTbg9fiApv6qexeXpW6RIP7QDFbMhH1XtFDOsHFG1n
         XAKxE5Ytr/Abkyhtd9pcmvAGZVY7BCqWDYVV2UAmxMhCc7Ks12wxg20PS/lavfT9URmX
         u3fuB/ov65KREqqgOIwiM4EWtbDDWG+DUp/8s7nceRfAIrsubutBE/vIuGYFRam3Ozno
         K3F3lxOw1kdZGD/CFRQFMkzePVsjehVLkjJp77Z6roXZSvZQyIEyjfjGjpkKhVki1eOw
         uvRjexl8sQJNFQUVkR8qVg9XMws6+kjQJLor1gHZiv1aD81VTHvX3g0+purM7bBnVJpL
         /DaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792198319; x=1792803119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pS9vsZjnoYZ5Z/rGHYsRUA9k6Kk3CgYA5qQssv3k9eI=;
        b=zgT1/IH+felvNrMUnWikknfxJXJtSt5GDJH0paobQXF0IITtpnUoa2mF4oCkLrgK4M
         h18ch16UTstXLX6koDXL63uw6IhB5ORPlfFXHdd1VUJ8logW+5uaaCHqDBPaD7dRTYKS
         ULA7rYVL+JUYztsg3zpiC0SkOBZDFzxEkxIFzeDLo0eCYxw+glIEaG4tldcFvXtox5QM
         SDBrs6/na3tuVw2FBNcUasMYY4OV/ZOJ+yd6y9Y4mJ23LDsiVlPPwU96guuPDE2kfrHN
         j1ode2AphKAWhtbTdRLV1Dhoguvg1KSW13xwep/f2GiRmx/NxruNEAVW9/BAYtcftbO/
         FQcg==
X-Gm-Message-State: AFq9FYI6wwU5se8PoqdNvAojZOEBAhp0JYh7ZfaAm2/vaKtLhejg3HUx
	p4SIyY4Gheh0DowyuU1HHYJ6wo8CVYTU8TDHyuu6xQlwdcyfsSii0BwEUaGKcJKG
X-Gm-Gg: AYBFou1SGrGbvjyFGFORvAFeEjlVDDx8EOc/RlNW4CummMambNbC3sZEcCkTohiIKvZ
	frwKcV+gvQjTf9DNp1Qjbw2UZYrVptxujlBsuJYAqe6Qa0582CiTi0p0yWFZy9p47rQ6SCEkeN/
	tDh5irolN1XhKYXtw93Lxw470e3O1poEHe6dkd7kNlkl4yQByd1moQ76CFjCi7R3KyrrN13SPyB
	7si40BRAV9TQrivKy8zLVJS5F5xofLpY8QQ6MOxwnG0A/YKzp/hWxp92wCIb1/p/wPI9J7ezNTr
	Q6LFpRsykW9RVUiyYsLK/iGwYLZNdAg1sCPoV8akY0hRrRwxMCKo2V5shhB4socdOuCsh8zOrPN
	GsgGJK9/1iyAlYqcmkVDiD3ztorvkPz1P/FX54JSSN8vQDid+/Yeg7dalkSZBU6wCgIbe6fQBih
	tPH4FGHzwmYOiu2CeEG0r9hHT4JF2sO86uNt8tOJiSOgxJDJe2sUM5bV+zg6heUKxrJVIf2Kw14
	FGkXn2o9cqUG+p6VD15eA6H5jI40XvcXcEQQlXjJbSd6Xuwd59P2YKlBB7iDSmCjMcsyo5KKKP2
	i4el5ARZmpyVeVJUbhHaVB0Udtbv5cmalbgN7HoSr5OSvmpmoAei88wDeTg=
X-Received: by 2002:a17:90b:4acc:b0:39e:6d82:dca with SMTP id 98e67ed59e1d1-3acef0c8872mr1364594a91.30.1792198318796;
        Fri, 16 Oct 2026 17:51:58 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947cf9a5sm11053970a91.15.2026.10.16.17.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 17:51:57 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org (open list:B43 WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH wireless] wifi: b43: keep the N-PHY TX power control from drifting while idle
Date: Fri, 16 Oct 2026 17:51:56 -0700
Message-ID: <20261017005156.1260496-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On N-PHY rev 3 and later, the hardware TX power control moves the base
gain index of each core according to the power it estimates for the
frames sent. CCK frames do not update the estimate, but the loop keeps
stepping on them with the last one. An access point with no traffic
only sends CCK beacons, and when the last estimate is below the target,
each beacon adds gain.

On an ASUS RT-N16 (N-PHY rev 5, external PAs), both cores sit at base
index 76-79 while OFDM frames go out, and walk down to index 0, maximum
gain, within 20 s (core 2) and 60 s (core 1) after traffic stops, with
the estimates frozen at 71 and 73 against a target of 74. The OFDM
frames sent after that overdrive the PAs, so the higher rates fail
until the loop has caught up: after 45 s of idle, only 2 of 8 pings
to an 802.11g station got through.

Remember the base indices while OFDM frames are being sent, and when
sending starts again after half a second without, load them back
through the base index register. The loaded value only takes while the
load bit is set as frames go out, so keep it set until OFDM frames have
been sent for a while. Until then, the base indices stay where they
were loaded instead of drifting. Forget the indices when the power
control is set up again or the channel changes.

With this, the base indices stay at 75-79 over idle periods, and all
pings after them get through. Throughput is unchanged.

Fixes: c7d643103508 ("b43: N-PHY: determine various PHY params")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/broadcom/b43/main.c  | 20 +++++++
 drivers/net/wireless/broadcom/b43/phy_n.c | 64 +++++++++++++++++++++++
 drivers/net/wireless/broadcom/b43/phy_n.h | 12 +++++
 3 files changed, 96 insertions(+)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 3825b6ad9f4f..a205db22a07d 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -3589,11 +3589,27 @@ static int b43_rng_init(struct b43_wl *wl)
 	return err;
 }
 
+/* Whether an N-PHY device sends @skb with OFDM or HT modulation */
+static bool b43_tx_is_ofdm(struct b43_wldev *dev, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	const struct ieee80211_rate *rate;
+
+	if (dev->phy.type != B43_PHYTYPE_N)
+		return false;
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
+		return true;
+	rate = ieee80211_get_tx_rate(dev->wl->hw, info);
+
+	return rate && b43_is_ofdm_rate(rate->hw_value);
+}
+
 static void b43_tx_work(struct work_struct *work)
 {
 	struct b43_wl *wl = container_of(work, struct b43_wl, tx_work);
 	struct b43_wldev *dev;
 	struct sk_buff *skb;
+	bool ofdm_seen = false;
 	int queue_num;
 	int err = 0;
 
@@ -3607,6 +3623,10 @@ static void b43_tx_work(struct work_struct *work)
 	for (queue_num = 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
 		while (skb_queue_len(&wl->tx_queue[queue_num])) {
 			skb = skb_dequeue(&wl->tx_queue[queue_num]);
+			if (!ofdm_seen && b43_tx_is_ofdm(dev, skb)) {
+				b43_nphy_txpctl_ofdm_tx(dev);
+				ofdm_seen = true;
+			}
 			if (b43_using_pio_transfers(dev))
 				err = b43_pio_tx(dev, skb);
 			else
diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 22359bd9db47..b5fca1d20bfb 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -3605,6 +3605,11 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
 	nphy->txpwrctrl = enable;
+	nphy->txpctl_bidx_valid = false;
+	if (nphy->txpctl_bidx_loaded) {
+		b43_phy_write(dev, B43_NPHY_TXPCTL_BIDX, 0);
+		nphy->txpctl_bidx_loaded = false;
+	}
 	if (!enable) {
 		if (dev->phy.rev >= 3 &&
 		    (b43_phy_read(dev, B43_NPHY_TXPCTL_CMD) &
@@ -6326,6 +6331,60 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 		b43_nphy_spur_workaround(dev);
 }
 
+/*
+ * Called before OFDM or HT frames are queued for transmission.
+ *
+ * The hardware TX power control adjusts the base index of each core with
+ * the power it estimates for transmitted frames. CCK frames do not update
+ * the estimate, but the loop still steps on them with the last one. Once
+ * an AP has only beacons to send, that drives the base index all the way
+ * to maximum gain, within 20-60 s on an ASUS RT-N16, and the first OFDM
+ * frames after that compress the external PA: 16-QAM and 64-QAM fail
+ * until the loop has caught up again.
+ *
+ * Remember the base indices while OFDM frames are being sent, and load
+ * them back when sending starts again after a pause. The base indices
+ * only take the loaded values while the load bit is set as frames go
+ * out, so it stays set until frames have been sent for a while. Until
+ * then, the base indices stay where they were loaded.
+ */
+void b43_nphy_txpctl_ofdm_tx(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	unsigned long now = jiffies;
+	u16 c1, c2;
+
+	if (dev->phy.rev < 3 || !nphy->txpwrctrl)
+		return;
+
+	if (nphy->txpctl_bidx_valid &&
+	    time_after(now, nphy->txpctl_last_tx + HZ / 2)) {
+		b43_phy_write(dev, B43_NPHY_TXPCTL_BIDX,
+			      B43_NPHY_TXPCTL_BIDX_LOAD | nphy->txpctl_bidx);
+		nphy->txpctl_bidx_loaded = true;
+		nphy->txpctl_last_sample = now;
+	} else if (nphy->txpctl_bidx_loaded) {
+		if (time_after(now, nphy->txpctl_last_sample + HZ / 50)) {
+			b43_phy_write(dev, B43_NPHY_TXPCTL_BIDX,
+				      nphy->txpctl_bidx);
+			nphy->txpctl_bidx_loaded = false;
+			nphy->txpctl_last_sample = now;
+		}
+	} else if (time_before(now, nphy->txpctl_last_tx + HZ / 20) &&
+		   (!nphy->txpctl_bidx_valid ||
+		    time_after(now, nphy->txpctl_last_sample + HZ / 5))) {
+		c1 = b43_phy_read(dev, B43_NPHY_C1_TXPCTL_STAT);
+		c2 = b43_phy_read(dev, B43_NPHY_C2_TXPCTL_STAT);
+		nphy->txpctl_bidx = (c1 & B43_NPHY_TXPCTL_STAT_BIDX) >>
+				    B43_NPHY_TXPCTL_STAT_BIDX_SHIFT;
+		nphy->txpctl_bidx |= c2 & B43_NPHY_TXPCTL_STAT_BIDX;
+		nphy->txpctl_bidx_valid = true;
+		nphy->txpctl_last_sample = now;
+	}
+
+	nphy->txpctl_last_tx = now;
+}
+
 /* https://bcm-v4.sipsolutions.net/802.11/PHY/N/SetChanspec */
 static int b43_nphy_set_channel(struct b43_wldev *dev,
 				struct ieee80211_channel *channel,
@@ -6363,6 +6422,11 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 	/* Channel is set later in common code, but we need to set it on our
 	   own to let this function's subcalls work properly. */
 	phy->channel = channel->hw_value;
+	dev->phy.n->txpctl_bidx_valid = false;
+	if (dev->phy.n->txpctl_bidx_loaded) {
+		b43_phy_write(dev, B43_NPHY_TXPCTL_BIDX, 0);
+		dev->phy.n->txpctl_bidx_loaded = false;
+	}
 
 #if 0
 	if (b43_channel_type_is_40mhz(phy->channel_type) !=
diff --git a/drivers/net/wireless/broadcom/b43/phy_n.h b/drivers/net/wireless/broadcom/b43/phy_n.h
index b96ded0ef539..787ad3e9b5ac 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.h
+++ b/drivers/net/wireless/broadcom/b43/phy_n.h
@@ -973,6 +973,16 @@ struct b43_phy_n {
 	u16 tx_pwr_last_recalc_freq;
 	int tx_pwr_last_recalc_limit;
 
+	/*
+	 * Base indices of the hardware TX power control while OFDM frames
+	 * were sent, to restore them when sending starts again after idle.
+	 */
+	bool txpctl_bidx_valid;
+	bool txpctl_bidx_loaded;
+	u16 txpctl_bidx;
+	unsigned long txpctl_last_tx;
+	unsigned long txpctl_last_sample;
+
 	u8 txrx_chain;
 	u16 tx_rx_cal_phy_saveregs[11];
 	u16 tx_rx_cal_radio_saveregs[22];
@@ -1005,4 +1015,6 @@ struct b43_phy_n {
 struct b43_phy_operations;
 extern const struct b43_phy_operations b43_phyops_n;
 
+void b43_nphy_txpctl_ofdm_tx(struct b43_wldev *dev);
+
 #endif /* B43_NPHY_H_ */
-- 
2.56.0

