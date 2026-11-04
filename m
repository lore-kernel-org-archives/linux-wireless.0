Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793802477;
	b=1wIqXq8lpquDOaUrFZgalNb2iIqPjhe5V+TP0PYLLwAM7gD6noUqPQuJjbJkDd/2TweH
	 EDBpaztQhjvzhHfdkVscKpLcxqt8udCFzwqD8Zeh5aYGq4O3zdJAEx72R4Cn3moM+HoZG
	 qiM04cO+AORRkqFzSszWw0HdT4534shX75rXhuqI9X6aPdoHS/aaHlwZp8XGAk6m5+3sp
	 7XMYBa3jFFo8j0iWTDH0Bk65dk/Ywli7qqkvAoawmObgYTofSE8kK1R83kcZRgtyD2FFX
	 brH0ga2tMKMX6rWSDn+s7/kBO9aO7vNKUyyiuKFjJqJqZcwpbQFglPEwromC4jko//w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793802477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RCbnvskndM4HyM/U/wv9olKZU1ADpK80ces2ych6agU=;
	b=TJg4fEMmOLvnNtZOXBVnx/AQmBPgWXNfu+6XgrF1WcDCq015F8wYbJdTDpZsf/QjPbsF
	 +tuXmtdDZHlJycG6Dh8kdP9N8HTFxqDRFt4y/cYvtjjgt/39FsNv5tMrqmL9flV05u4BI
	 ZUjs3rth+/9MMPYmkY9cydw3s3gQ4rZAukoXZNIwJSt0Z4kdfN0jyllApZFmq+KJ5Oywx
	 3QS636RrHZUNrJnag0hXmJAjOmoUWuTw08QCWdCrFNzHID6O31o+BfUdl4gW+MRbbZjgE
	 v2O6HxC3tRWFMWLCDSD3HFgobvXnM7mj7mmEEPLAwZRYLe6qf9kw3xmnu1xJDnMFprw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mtu.edu;
	spf=pass smtp.mailfrom=mtu.edu;
	dkim=pass header.d=mtu.edu header.i=@mtu.edu header.a=rsa-sha256 header.s=google header.b=Ub919Eg7;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51A6606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 14:27:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E51A6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mtu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mtu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mtu.edu header.i=@mtu.edu header.a=rsa-sha256 header.s=google header.b=Ub919Eg7
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b315dd057bso3596587b3.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 06:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mtu.edu; s=google; t=1793802475; x=1794407275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RCbnvskndM4HyM/U/wv9olKZU1ADpK80ces2ych6agU=;
        b=Ub919Eg7msyn0gQKWJnuo00qRQqbfRM+FKxJ4JUb3Zoj3kyo2aJFPYmYDM3PLj1ZmK
         bQ4aSNb3nEZuGDD6as1dLCELhulPpBCtF3hNOJivvE9vABSeZHUZ0jpDNMiWf4mFZ5Hr
         /TfQyUug9EVWWvD3dOCMdedAZ14I+5kdw2eqr624jZgrplbfuoRLHwLogrh2sQdBiIkL
         g2ntpfwWsy6uNZYOYc1i0+CqlPMdCBIvEhOGBqEwy5Gi0hK0L5nFYG2wM0GgDD+zAumD
         4++yA4uNnBwS18GBmj4rTILe0xiJtFAZ52DMDXETRdFLH+OnFvafq+52eSXUFP0fBjWq
         jjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793802475; x=1794407275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RCbnvskndM4HyM/U/wv9olKZU1ADpK80ces2ych6agU=;
        b=RSayL9/9nOuJx+Fo77sPARwI/DQALkr9DFlKcOck0+swIcQhiAwPXLnSRtcRHMkklC
         3cVtWXdMpkstdu5gSc6S/nAfUuMQlK8qkZL068OAl8n8rll3omC22mgGeKcclvjcoQMP
         ua+DbRHLuEY8w0bb1zMezoSN/9ss7EwQLWOLJ++8eIV0kjMJgGFBdtTRWJqLMVJ456hj
         ePHsL0xdgnsVtMmPa8+c8xHqK5TOBUdM4hqa8Ak3cPqFYTBOUNpyqsdvBoIdN2nYuWvi
         cY4ItKktIkFPLQgM/vq0mjTPo390zYCvIfzDqnfKJOReEKie1nu8I80p48KZAM9XZBF2
         XBCQ==
X-Forwarded-Encrypted: i=1; AKwUvBwLgTgNQ5MdpcQHhxfpUA8zjTVf6s7lHTcPopU/uabrZQjTxqUdSk2mDa7Sc59Qx8Oi2r27WfT+FrdAqFy3mQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/L4vye8SIVV2fqjuTEfwAyj76BT9FEGbYbFBglG1JePGNglOWR
	0+rlGuoXNOyt/h3p5D1BXsW8vS/IA3wnswcOwH5ALszv3QGQj7Po37sc8sCoCchYIg==
X-Gm-Gg: AYBFou1J+fDLxJ8FrTtMSck0R6Mgl4b3FO668FIct4qw/jkyvePmC/+Iu+zNadN+/ip
	Qsu2JetMNd1LnUXqvWoA+hr0jYESVYZ0VfS1MVjplJ5XxahtPZTJcrj03m4KRG4UdF235AvwfHn
	aGg4yN4qVNUUDL+EB1cHJ/FByMZjm+F350IUseXlPki+aq0LPWyy17go81UGsM2a9aM3QURTm/9
	3YISRnJAv2HF921Wk1SSEtezQgnq5EilOY86VJd43YBueZwj9r6GsT2FL4J4hFaxx6JkutJyaFI
	1It0nDiMuuXBiW4KxqJqho6lt94MW75CI+4fzPk/mRdpqFQlcruxEgiqnYG9AXRo2VC2HV2YOTe
	dkuBZCSmlKJ5nyL74JJbI/UEKW3Q0VfzCsADQWug+xbqgOGufj3kjm93z9v16VuE0jk7VPaYLqo
	tFBpO+1PeNfTtwETA48WNhdyZIJ0ATLHYBV13c1rI3xLcHyU+fxDWJjpXuGMIZQ6L+PIskeny21
	Us+lvAqj05wFgOozkis0K5GMdD651CNxMEMP09neFp6D4hxMx0opTq/KQHTxWGVm3KtUE4sFfmK
	siPHPgkWZ4466b0tSkC2/Iti69LkD7Ju8TB9Wo4JkK8ImfgZ6sS+n41j0w==
X-Received: by 2002:a05:690c:e013:10b0:8b3:2352:cc72 with SMTP id 00721157ae682-8b32352d42cmr3066537b3.39.1793802474565;
        Wed, 04 Nov 2026 06:27:54 -0800 (PST)
Received: from agent-virtualbox.mtu.edu ([47.6.6.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b30993945bsm19389467b3.21.2026.11.04.06.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 06:27:54 -0800 (PST)
From: Aaron Beckendorf <albecken@mtu.edu>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Devin <lucid_duck@justthetip.ca>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Aaron Beckendorf <albecken@mtu.edu>
Subject: [PATCH v2] wifi: mt76: connac: honour injected HT/VHT rate and bandwidth
Date: Wed,  4 Nov 2026 09:26:22 -0500
Message-ID: <20261104142737.186484-1-albecken@mtu.edu>
X-Mailer: git-send-email 2.53.0
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

On connac2 parts the fixed-rate TXD path uses the basic rate from
mt76_connac2_mac_tx_rate_val() and ignores the rate carried in an
injected frame's radiotap header, so monitor-mode injection always goes
out at a legacy 20 MHz rate and cannot choose the modulation or channel
width.

When info->control.rates[0] contains an HT or VHT MCS, set the TXD6 rate
from it instead: mode (HT/VHT), MCS, NSS, and the channel width from the
rate flags; for HT the whole MCS index is used, as mt7615 does. Legacy
injection and the normal (non-fixed-rate) data path are unchanged.

This makes 20/40/80 MHz HT/VHT injection work on mt7921u. mt7925 and
mt7996 build their own TX descriptor and are not affected.

Signed-off-by: Aaron Beckendorf <albecken@mtu.edu>
---
v2:
 - HT: use the whole MCS index in the rate index field; the v1 mask
   (tr->idx & 0x7) dropped the second spatial stream, so HT MCS 8-15
   went out as 0-7.  Caught in review by Devin <lucid_duck@justthetip.ca>.
 - Also set the 160 MHz width; the shared mt76_connac2_mac_write_txwi()
   is used by the 160-capable mt7915 family and mt7922, matching mt7615.
 - Drop the mt7925u claim; mt7925 has its own mt7925_mac_write_txwi()
   and never reaches this path.

 .../wireless/mediatek/mt76/mt76_connac_mac.c  | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 8481eac8d783..e62d39cb1ba5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -602,6 +602,43 @@ void mt76_connac2_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 		u32 val = MT_TXD6_FIXED_BW;
 		u8 spe_idx = mt76_connac_spe_idx(mphy->antenna_mask);
 
+		/* Honour an injected HT/VHT rate and bandwidth from radiotap:
+		 * connac otherwise transmits at the basic rate picked by
+		 * mt76_connac2_mac_tx_rate_val(), so monitor injection cannot
+		 * select the modulation or channel width.
+		 */
+		if (info->control.rates[0].idx >= 0 &&
+		    (info->control.rates[0].flags &
+		     (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS))) {
+			struct ieee80211_tx_rate *tr = &info->control.rates[0];
+			u8 mode, mcs, nss = 0, bw = 0;
+
+			if (tr->flags & IEEE80211_TX_RC_VHT_MCS) {
+				mode = MT_PHY_TYPE_VHT;
+				mcs = ieee80211_rate_get_vht_mcs(tr);
+				nss = ieee80211_rate_get_vht_nss(tr) - 1;
+			} else {
+				mode = MT_PHY_TYPE_HT;
+				/* the HT rate index encodes NSS in its upper
+				 * bits, so pass it whole, as mt7615 does
+				 */
+				mcs = tr->idx;
+				nss = tr->idx >> 3;
+			}
+
+			if (tr->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+				bw = 2;
+			else if (tr->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+				bw = 1;
+			else if (tr->flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+				bw = 3;
+
+			rate = FIELD_PREP(MT_TX_RATE_MODE, mode) |
+			       FIELD_PREP(MT_TX_RATE_IDX, mcs) |
+			       FIELD_PREP(MT_TX_RATE_NSS, nss);
+			val = MT_TXD6_FIXED_BW | FIELD_PREP(MT_TXD6_BW, bw);
+		}
+
 		/* hardware won't add HTC for mgmt/ctrl frame */
 		txwi[2] |= cpu_to_le32(MT_TXD2_HTC_VLD);
 

base-commit: 991a73f4909f1348ffb4b38765cdb522a775e4c2
-- 
2.53.0

