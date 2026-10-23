Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=194.126.200.66
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792778041;
	b=rtPX7Qd7p1+WppKBn7/QDQS+Uqi+KAXxrHyTuvT/Yv3pc88JKQ4374RTe8xGucuERluF
	 2zGIQFMzqbTXSLwo48LSLmSXm8866JxjzDe4sk8tHIzERdPFvuDRG/wKiz2FvI0yF5XLn
	 bnmKeUNvJ3RJ4xxhfKV8p8QMgKUAxQ+ce9khCGb1+Wf4oa41AuNwXVWBH5fAtntOI2f3Q
	 1w9VHfdsbzcTNFAAqdjeDcvSZshqi66Hm0fIYcWuDcwJkxJVoQFrYCCZ9Dv+fE3t0a27W
	 y36Lzc/zgRCo1KqJqSdNfznNm7a91rjGcnK9SY1z00cfWFGUgCxA7trZNzWrLvDKpdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792778041;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Message-ID:Date:
	 MIME-Version:User-Agent:From:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender;
	bh=mex1VNRAzB6AdRypwLTafPsp6+YLM9I467IH3rE0fBg=;
	b=j0kSe9UTwpyZ+5KTmtb0fhqzvaqjNX6UERpYbhe/FOWjCETDwVhPV1ZWLIufjbjLrw9E
	 0So9kA5kFVomk5btaCunXu4+2Sr9zPwwO8PWyaaG2PwCUBHq1sqIzkoAU7s/yGgE1C6Rm
	 6qLEp5TERd1CDf0H9NMtFELKvq7urMtLFfdWWHrS2EIXalECT451TU1U2JqnLNpdPPG+J
	 TvWFkzIvFPpXDYmxhbdc87Wjrch9t7nj4dW2WWxKKPZl5upJgy+AGTlGHqvbI34mHEPbj
	 7tqGw3+zxXpdJSkh2qJx6tmbyh+iwRLt+ezKifWxAmm77a+Cphqnmb0kZA1o9/+2Zvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=davidmestre.net;
	spf=pass smtp.mailfrom=davidmestre.net;
	dkim=pass header.d=davidmestre.net header.i=@davidmestre.net header.a=rsa-sha256 header.s=default header.b=vTT1Px5S;
	arc=none smtp.remote-ip=194.126.200.66
Received: from mail-gateway-shared13.cyon.net (mail-gateway-shared13.cyon.net [194.126.200.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA8606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 17:54:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EDA8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidmestre.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidmestre.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=davidmestre.net header.i=@davidmestre.net header.a=rsa-sha256 header.s=default header.b=vTT1Px5S
Received: from s143.cyon.net ([149.126.4.152])
	by mail-gateway-shared13.cyon.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim)
	(envelope-from <dev@davidmestre.net>)
	id 1xKJSm-00Cu2a-0u
	for linux-wireless@vger.kernel.org;
	Fri, 23 Oct 2026 19:53:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=davidmestre.net; s=default; h=Content-Transfer-Encoding:Content-Type:Cc:To:
	Subject:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description; bh=mex1VNRAzB6AdRypwLTafPsp6+YLM9I467IH3rE0fBg=; b=vTT1P
	x5SD7yViy90d9yBdtIRDusw/2SQtqLTfEoBWj2c6aJ7xyX2G0rIf9Fznq6lVov9ONxRV8O1isqBqd
	TJxZObrkEizxaTqPxWxVajvUgcfDPOC7EyfDBS6W/bX/tjjAMby7CvXxyUgVN4L+GTVERHYUTupqb
	EKSBUWZVCPCLh0FNACdINB/GaTechCCWZSWRrVC3FZMyPjqTfONElTd1y6SrEYKEapEELWJzvE115
	0wOiPjNf2Mk0d43OKy9pqobeBloJLgbRU2JROOMwtzyyJXhTaYpV2MPjsZ4sS5b6hYjvRAufgGL95
	mCc/PupwQjzm8tfxZf4YDsfQONaOA==;
Received: from [10.20.10.54] (port=58994 helo=mail.cyon.ch)
	by s143.cyon.net with esmtpa (Exim 4.100.1)
	(envelope-from <dev@davidmestre.net>)
	id 1xKJSi-00000000HRp-43Gw;
	Fri, 23 Oct 2026 19:53:51 +0200
Message-ID: <48a5fb10-92ba-4be9-9df5-d92392c968f6@davidmestre.net>
Date: Fri, 23 Oct 2026 19:53:51 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Mestre <dev@davidmestre.net>
Subject: [PATCH] wifi: mt76: mt7996: handle station airtime counter resets
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s143.cyon.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - davidmestre.net
X-Get-Message-Sender-Via: s143.cyon.net: authenticated_id: dev@davidmestre.net
X-Authenticated-Sender: s143.cyon.net: dev@davidmestre.net

If a WTBL airtime counter resets while the cached baseline remains,
subtracting the old value produces a large unsigned airtime delta.
The cached counters are also cleared even when the hardware clear
operation fails.

Handle backwards counters while preserving normal modular wraparound.
Clear the cached counters only after a successful hardware clear.

Signed-off-by: David Mestre <dev@davidmestre.net>
---
  .../net/wireless/mediatek/mt76/mt7996/mac.c   | 27 ++++++++++++++-----
  1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c 
b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index f36da54..f8cde54 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -72,6 +72,21 @@ u32 mt7996_mac_wtbl_lmac_addr(struct mt7996_dev *dev, 
u16 wcid, u8 dw)
  	return MT_WTBL_LMAC_OFFS(wcid, dw);
  }

+static u32 mt7996_airtime_delta(u32 curr, u32 previous)
+{
+	u32 delta = curr - previous;
+
+	/* WTBL counters can be cleared while the link's cached baseline
+	 * remains. Do not charge an unsigned underflow as airtime. Normal
+	 * counters are cleared at BIT(30); genuine wrap still has a small
+	 * modular delta and is preserved.
+	 */
+	if (curr < previous && delta > BIT(31))
+		return curr;
+
+	return delta;
+}
+
  static void mt7996_mac_sta_poll(struct mt7996_dev *dev)
  {
  	static const u8 ac_to_tid[] = {
@@ -126,8 +141,10 @@ static void mt7996_mac_sta_poll(struct mt7996_dev *dev)
  			msta_link->airtime_ac[i] = mt76_rr(dev, addr);
  			msta_link->airtime_ac[i + 4] = mt76_rr(dev, addr + 4);

-			tx_time[i] = msta_link->airtime_ac[i] - tx_last;
-			rx_time[i] = msta_link->airtime_ac[i + 4] - rx_last;
+			tx_time[i] = mt7996_airtime_delta(msta_link->airtime_ac[i],
+							  tx_last);
+			rx_time[i] = mt7996_airtime_delta(msta_link->airtime_ac[i + 4],
+							  rx_last);

  			if ((tx_last | rx_last) & BIT(30))
  				clear = true;
@@ -135,12 +152,10 @@ static void mt7996_mac_sta_poll(struct mt7996_dev 
*dev)
  			addr += 8;
  		}

-		if (clear) {
-			mt7996_mac_wtbl_update(dev, idx,
-					       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
+		if (clear && mt7996_mac_wtbl_update(dev, idx,
+						    MT_WTBL_UPDATE_ADM_COUNT_CLEAR))
  			memset(msta_link->airtime_ac, 0,
  			       sizeof(msta_link->airtime_ac));
-		}

  		if (!wcid->sta)
  			continue;
base-commit: 637f84201a14c659221f0e265e4946acdd5c3b1a
-- 
2.56.0.windows.1
