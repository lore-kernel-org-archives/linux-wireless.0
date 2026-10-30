Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793397594;
	b=DghXicX/tBA2WcHouY0eqU+Irvy9HUGUPq62mU4ZDJpOviTNakAdrakRWum2DXcMMLx6
	 c6jmASrlRtp/djVnqiPm3pldctkCeZUF+Fc2AEI5wyb6unC+EK5vH01mTUGBMePanl29g
	 UoZy7KMceDVXQO+iK3GBsFIo1eDKL5zHoJL4B6br+ateVYNTEKAa5iIaL8ka7FLtiN3b7
	 7VN3WOUJYcFjDcwpm7t9ljhlCVH7r5Y5ZiAdSIOEOsR+iu/Eb5kuLtqtVPtX53R1q9z1E
	 HxaCTi6EqvXPQPP7o/uqKBOh9VhOYrENNVtNw0GLDkj7fh/Pgvm5iSiQrNb/SJYYUeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793397594;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QltZYn6auahTUDtzxOtywDg1k8+vm4MZICPJZD5dPW4=;
	b=Skbr6uRe4w8Jdkhs/FcKnY3TwMTXjHVVFF5AjCLCdba2Rc8N8ADZ5trzFokVZ0ggva0w
	 LSHeYyNdVvRP9NUuO0cfasvbf9X4g4Tf3UmSczBErXqL3s8qnHZ4Kr7pme4SCUY5iZMg/
	 vTgxHeCyx8k55vAmZVpFiHbe3wAb2/Vtqk2H+1G9MgZXZZBa4/mrrWs1n4fxb7LZrKzcd
	 dO1MfgzdspEDMHIwdwcNxI/Wt2bR5H2JfTMD0PMAFmFpPbh2QoqQbBcyeauXHoMz9dEaR
	 mLcUhKYHkOwGBOWS9yXvIbh47Xq8C74aCpezFBnXqayUrc33KXWQtZhJdvtKtVnEX5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hizwtS13;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FB8606A320
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 21:59:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15FB8606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hizwtS13
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a215e64962so11863605e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 14:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793397592; x=1794002392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QltZYn6auahTUDtzxOtywDg1k8+vm4MZICPJZD5dPW4=;
        b=hizwtS136f4+TNn3viT1XFdGGrZdkOybQnQ4sX2m64ESiaQhjw+8x91QauVq+8veu+
         iOl2Km/NutN9rYMEYxl7CDwHk/U7G04++d4UIzZ7O3av0/HfNCqhsQDHKlQPXt3PLVRL
         rr0BkCPRUVxzMAnCNuxHU5uEbRaUfycAiIZRXHEyHj9JUaqqjPcGMHAR7uqzC5cL0hHl
         Qi8oQHNxTEl23acaSZHWw+ZGxYbYeN5BfaGYaM89Hzwi8zUU1KvxrtEBJjj+Fyjq5Mdr
         F7dHp0lKMlPu2BpGYC+AhcEUgMb11LucOxO3DgDYW3VuYL/0kPxzegbcm3xDfjZgXLaC
         DB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793397592; x=1794002392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QltZYn6auahTUDtzxOtywDg1k8+vm4MZICPJZD5dPW4=;
        b=V+H8EZKP/ntG4kAAcjFHWSO9jLMP9QthsoDvMFetPMQadQUXd2/XvQHwWgRdjEiiM9
         60luuCK3eBCazjKhpgR8uf0m5TnEIy/RKwvWZkGRRjaJHDlcPS3biG8XTm1RIoeRJ5Lu
         148s8By5XQ4nrsN6JmDglRYs4G5ZkYhepqtySV+2nILj//QnwzVDuETUq8Pgz5J/akST
         g0pUzSoo/G1HNrefmxjuu1zV9GzF/xlAtApMpDMMyG8V0N+UgnmpfcfrMB6XavXxQu4s
         TioEv1w3nx0NX9qop/Y2gcWIOPGEkHUuw3CH5QFq4awYnD5/mDAseTZS2AaFSge4C5FZ
         K2hw==
X-Forwarded-Encrypted: i=1; AKwUvByDRqsOpKt/nDZhDGHbMDMnkfNad0zJatPvfzxSposP+spECqdSA/TsPMA+ROG68gZGwTR1XtIHGCrNm7M36A==@vger.kernel.org
X-Gm-Message-State: AFq9FYLUuywbsRVuysGFeYftsi7KmyylOsLJevlcNZkepnSLg0trJjfl
	IihOjBdat7YsmJ7z8ubQTb1e8QiG+Q9QHq08ubHzGtzt9o4ql7ikfF5IkNjjHZR0mG3ycw==
X-Gm-Gg: AYBFou1ualKaGy9pS/z+aSzSczhnM922uHG9JcXaPa4d3IO0XbzUehtZbS2jcP+datq
	oc7QH/YBLyaMZy+mR4uroRD7XoPIYSmI9TCtdmizrLKevSsv5fVEFcC6fz5BBY4fSjOjZu/RKv+
	spQlcbRejwBVICyUTpspDQ9kGup45UW923saiH5qXPf543oySb0C/yh5dYjPc9zdhE4UwjSVZCS
	Vexdvv/3A5Y1B2oXEK4Vd+BnfOpq1DaXfhCIGyWp+97judVI1W/c6XNXLxonGskt0kUMqcgfrWh
	eoaz0WHNcLk3GWMEGL3JW0tVe4T7UUC//SfmYsQMYwUz6ujNXUijBqtNnK3v14hePQtUfZZA88L
	/MltloOfzJtY0dos2S0t9rMo2FI8jPo6HjoyVxglEtn2cMl0fz/N3y/6JxT2JF45sWNbrNXg0sT
	+rXoN8yZ/hbxjVY+yX4Q1Egq7OtmEqf5U5iP5gm3ZbNqK8V6+Gk1oTNaDhdBABbxApMRTqYoAHU
	YaedRp75ctr/nC3/lpKYyg8UrCcBEWI5jahzASD12SHOePxbhhrHsvXRzo2uPBo405YpfAhhbIy
	0oNVEU/btGH1vI1XuVjqfmAqMhnMv9vQHkXzsy1Zy6ge
X-Received: by 2002:a05:600c:a012:b0:4a2:150f:1609 with SMTP id 5b1f17b1804b1-4ac17b2cdffmr76571995e9.8.1793397592474;
        Fri, 30 Oct 2026 14:59:52 -0700 (PDT)
Received: from linux-virtualbox ([176.123.27.73])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf723b5dcsm87207155e9.14.2026.10.30.14.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 14:59:52 -0700 (PDT)
From: Salah Ahmed <haddad2inc@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wifi: mac80211: count the tpt LED trigger from delivered data only
Date: Sat, 31 Oct 2026 00:59:36 +0300
Message-ID: <20261030215937.18103-2-haddad2inc@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030215937.18103-1-haddad2inc@gmail.com>
References: <20261030215937.18103-1-haddad2inc@gmail.com>
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

The phy tpt trigger adds every received frame with the data-present bit
set to its RX byte count in ieee80211_rx_list(), before the frame is
matched to a BSS or delivered to an interface. On a busy band an access
point with zero associated clients still hears data frames from
neighbouring networks, so the throughput LED blinks continuously and
gives no indication of actual transfer. Management frames such as
beacons are already excluded by the data-present check, and the TX side
only counts data submitted through the interface transmit paths, so
overheard data is the only remaining source of idle blinking.

Move the RX count to the two places where a frame is actually handed to
an interface, right next to the dev_sw_netstats_rx_add() calls in
ieee80211_deliver_skb() and ieee80211_rx_8023() (the latter also covers
the fast-RX and the 802.3-offload delivery paths). The trigger then
counts exactly the data delivered to the wiphy's interfaces, in every
mode - AP, client or mesh - which matches what the per-interface
counters report and what users read from a throughput LED.

This scopes the RX side only. The TX side is untouched, and an access
point still transmits the broadcast and multicast it bridges with zero
associated stations - measured at roughly 2 KiB/s on a quiet LAN - which
keeps the counter moving and the blink table stepping, so an idle radio is
not solid yet. Treating a rate below an idle floor as no traffic is a
separate change.

Monitor copies are deliberately not counted: they are clones of frames
whose original delivery is already counted once at its own interface,
and counting them would double the reported rate whenever a monitor
interface is up.

The deleted block was the only user of the local hdr pointer in
ieee80211_rx_list(), so drop its declaration too - mac80211 is built
with -Werror=unused-variable and the file would not compile otherwise.

Signed-off-by: Salah Ahmed <haddad2inc@gmail.com>
---
 net/mac80211/rx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 905fd7049..559cc2101 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2756,6 +2756,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	xmit_skb = NULL;
 
 	dev_sw_netstats_rx_add(dev, skb->len);
+	ieee80211_tpt_led_trig_rx(rx->local, skb->len);
 
 	if (rx->sta) {
 		/* The seqno index has the same property as needed
@@ -4970,6 +4971,7 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 	skb->dev = fast_rx->dev;
 
 	dev_sw_netstats_rx_add(fast_rx->dev, skb->len);
+	ieee80211_tpt_led_trig_rx(rx->local, skb->len);
 
 	/* The seqno index has the same property as needed
 	 * for the rx_msdu field, i.e. it is IEEE80211_NUM_TIDS
@@ -5583,7 +5585,6 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 	struct ieee80211_rate *rate = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -5727,10 +5728,6 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 	if (!(status->flag & RX_FLAG_8023))
 		skb = ieee80211_rx_monitor(local, skb, rate);
 	if (skb) {
-		if ((status->flag & RX_FLAG_8023) ||
-			ieee80211_is_data_present(hdr->frame_control))
-			ieee80211_tpt_led_trig_rx(local, skb->len);
-
 		if (status->flag & RX_FLAG_8023)
 			__ieee80211_rx_handle_8023(hw, link_pubsta, skb, list);
 		else
-- 
2.53.0

