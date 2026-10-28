Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.255.227.203
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207865;
	b=K0+97qyotfn25D4TBQd6R+UV0Al7uKFe6WO9yBdTyow2MNU0QpnNgTjDsIAUQ9/1B9nZ
	 XLK737XDeQcowiYvjiItYU2Nan/bdVHk3bUTjVM2+Lyf++D+0vlv0xTUHdL8V9YVkK4kr
	 5ha8QTJ+HS8m72Cpdqa7cFVcurdPdjI6dYxjLu/ROpuAYdi1Ao87qMZ7buIQSU40wc8qF
	 UeScucUTqtaqBV45WQ4R7QOlR/e1dk0Ydr/WedhO7Cit7Ixy9aYwf2xG1WBqCfrv+2quJ
	 aTo6DPxCBip/oFFze4nCTgfJDfvBeU9ZyPZvAwjVhofLP/QX3jt3k+PUlek5oC8JkZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207865;
	h=DMARC-Filter:Received:DKIM-Signature:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ThreatScanner-Verdict:X-IPAS-Result:IronPort-PHdr:
	 IronPort-Data:IronPort-HdrOrdr:X-Talos-CUID:X-Talos-MUID:
	 X-IronPort-Anti-Spam-Filtered:X-IronPort-AV:Received:Received:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hzV/ZJGd94HL5X5mqltv4CJEN+vCU91tSnLK6kAjKrE=;
	b=0JHd2TTJV/+C1gbdSwEzH0zylf1sbvJCoUkKnVZw61yBYQik8HTI0TxvjGgxnkzGWl0J
	 nwI5dKxpDoULJ0sZfthNOGmMTg7m5V7iZekEpXaFpvJbJwxAQUphJHJBNOdjnU8ILPcdD
	 i9vtcqS/gMeVGL1p6zN+LthQV4ygU4856fO7deS7lsXamZN6PAyTy5qwXbPLxYK4/j9tx
	 nN3ZijiUR6n+XzG2NC3tpyQy+mce2OvjGPsRhNWcnsH9oRb96UCTXMdo31edvG4tO6Qfm
	 tCT1uGqOq9195tfULeYRt2PmmGGiOXJCCMoj8CB/OgEcu4KgiTRKs7GYbfdeIlLdChA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=pobox.sk;
	spf=pass smtp.mailfrom=pobox.sk;
	dkim=pass header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b="AIHZ/u6G";
	arc=none smtp.remote-ip=46.255.227.203
Received: from gmmr-2.centrum.cz (gmmr-2.centrum.cz [46.255.227.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7955B606A333;
	Wed, 28 Oct 2026 17:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7955B606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pobox.sk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.sk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b=AIHZ/u6G
Received: from gmmr-2.centrum.cz (localhost [127.0.0.1])
	by gmmr-2.centrum.cz (Postfix) with ESMTP id 39B0A2015CCC;
	Wed, 28 Oct 2026 18:17:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.sk; s=mail;
	t=1793207857; bh=hzV/ZJGd94HL5X5mqltv4CJEN+vCU91tSnLK6kAjKrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIHZ/u6GvG82RgUIX7ap5qJxUHr3sjKq2fa1QkkiwrZ2LQZG3XoGYrM4dxqJyQelR
	 FSTV+c8iojppIbkUKrx2ra7p+gpJJdQleZKiOyhONpDuiS6LMTOUnHPoPStgV623nv
	 Q8RW0KrE4zBFvwe6Nx/UsnhgMmjF0OpeE4GQ0iPE=
Received: from antispam96.centrum.cz (antispam96.cent [10.30.208.96])
	by gmmr-2.centrum.cz (Postfix) with ESMTP id 37756200B34A;
	Wed, 28 Oct 2026 18:17:37 +0100 (CET)
X-CSE-ConnectionGUID: 9PGTwW1HRPqDFqy7uWKuBg==
X-CSE-MsgGUID: qvYBplllSWCrqR8jRApZTg==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2FOAgBBLeJq/0vj/y5agRKBR4JXgmGWTIEWimWSJIF+D?=
 =?us-ascii?q?wEBAQEBAQEBAQlRBAEBPw+ENwKOHSc2Bw4BAgQDAgMBAQEBAQEBAQEBAQsBA?=
 =?us-ascii?q?QYBAQEBAQEGBgECgR2GCVOMGgGEAAYnCwFGEBg5VgYTgwKCOgEDN7dGMxoCZ?=
 =?us-ascii?q?dx/FjUZZoFoAQsUAYE4jWN2hH2CC0SBFYJzdoQKhn4Egy6WREiBHgNZLAFVE?=
 =?us-ascii?q?w0KCwcFgWgDNRIqFW4yHYEjPheBBxsGBYEdgR6BGYEHXYErKWABISdhgXYCg?=
 =?us-ascii?q?lGCAAIBSUEOB0VTCSVDEkckIggSCQETGi4LgRo1PAkmQRUMZAsaBWIIAg0Md?=
 =?us-ascii?q?jkQMSAmMgQDCRgNSBEsNxUZBD5uB5FMgw4WeIEDgWPGdweEIYRznGkaM4FKl?=
 =?us-ascii?q?jQDkm6ZCKRahGmBbwmCBk2DWlMZjj0W0ht4PwcCBw8CkXM0gUwBAQ?=
IronPort-PHdr: A9a23:NrLxABNpurLx8Sf4Wlsl6naVChdPi9zP1u491JMrhvp0f7i5+Ny6Z
 QqDvqsr1AWCBNuDuqMMotGVmp6jcFRI2YyGvnEGfc4EfD4+ouJSsioeReWoMgnFFsPsdDEwB
 89YVVVorDmROElRH9viNRWJ+iXhpTEdFQ/iOgVrO+/7BpDdj9it1+C15pbffxhEiCCybL58L
 Ri6txndutcZjYd/K6s91h/Er39VcOlK2G1kIk6ekBn76sqs5pBo7j5eu+gm985OUKX6e7o3Q
 LlFBzk4MG47+dPmuwDbQQWA/nUTXXwanwRHDQbY9B31UYv/vSX8tupmxSmVJtb2QqwuWTSj9
 KhkVhnlgzoaOjEj8WHXjstwjL9HoB+kuhdyzZLYbJ2TOfFjZa7WY88USnRdUcZQTyxBA52zb
 40TD+oaIO1Uq5Dxq0YSoReiAAWhAv7kxD1ViX/sxaA00/ovHB/b0gIuHNwAt3bbrNv6O6kdS
 u250KrFwC/fY/5MxTvx9I7FeQ0hr/GWWrJwdNLcx1coFwPAlFqQspHuMS2S1uQLs2iU9fdgV
 fmxhG49tgp8pSSvyt0wionOgIIVykrL9ThiwIkrP921U1Z7Ydm/H5tXuCCWLZB2QsA7Tmxup
 S01xaEIt4ShcygW1JQo2QTfa/qffoaG/x7uW/qcLSl8iX94ZL+zmha8/Eehx+D9SMW50FJHo
 ylEn9fCqHwByh/e59SbRvZg4kqs1jaC2x3d5+xZL045k7fQJZ05wrMomZcesF7PEjH2lUj2l
 qOaaFso9+qy5+nlYrjqvoKQOox3hw3kL6gjm86yDf4lPgUAXWWX4/mw2b3n8ED/Xb5ElOc5k
 rPDv5DfPckbo6m5DBJL3Ys78Ba/Cium0MwfnXkaMFJJYBKHgJbtO1HJOP34AvK/j023kDdu2
 /DGJqDtDonXInffjrjhe6p961RByAo219xQ+5NVBqkAIPL1REDxqMTVAxA4PgCu3erqCNVw2
 pkAVW6RAKKVKqHfvF+Q6uIqOeaMZYsVuDjnK/gi4v7jlWM5lUUBfamu25sXaGq3Hul9I0qHe
 3rhmc8BEWARsQo5Q+3mkkaCUT1La3aoQ608/i07CJ6hDYrbQICim6GO0Ty9HpJNe29KEFaMH
 m3td4qaQ/sMcj6dItd9kjwYUrisU5Mh2QuytA/9zbpnLvDb+jADtZ39zth4/PXTlRYp+jxzA
 MWRyXqNT2JskmMSWzA2xLx/oVB6ylqbzah4hP9YGsJI6vNVVQc6NoDTw/ZnBNDxQg7BZMuGS
 E66QtW6BjE8VtYxw94IY0ZgFNSulxPD0DSwA78TibOLAIc58rzT33fvPcZx0XXG27c7j1kgX
 MRPMXeqhqll9wjcH4LJiVmWl762daQA2y7A7GODzWuIvEFFXw98SKvEXXEFZkTIqdT2+FjCT
 6S1BLQ5PQtO19SCJrFJatL3l1VGQunsONDEb2K2gWewCg6ExrWXY4XyYWUSwD3dCFQYkwAU5
 XuLNRAyCTqio2LfCTxjDUrhbUzi/udgtH22Ukk6wxmXYE1kzbW14AIaiOSERf0KxrwKt3Rpl
 zIhIFG+0pr2oAqBowNncOB+ygMn71pBzm/f/1hhOZ+tB7xlhVNYfwch7G300BAiNoJFmNNik
 HQszANvMq+CmAddMS+f25D5J6baMEHq+xqoe+jN2QeNg56t5q4T5aFg+B3YtwazGx9nqi0/u
 +Q=
IronPort-Data: A9a23:s7EdUKPb0BdeJtXvrR24lsFynXyQoLVcMsEvi/4bfWQNrUp31jMBz
 GVLXGjTP6rYNmr2Kd0lOdji80sP6MCHzNVkSnM5pCpnJ55oRWspJjg7wmPYZX76whjrFRo/h
 ykmQoCeaphyEjmE/0nF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZg6mJTqYb/WVzlV
 e/a+ZWFZgb9gW4sbgr41orawP9RlKWv0N8nlgNmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwOhxIktl
 YoX5fRcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQq2pYjqhljJBheAGEWxgp4KTB22
 sAHF2ktVCiaq8yv0e2mdcpxrMt2eaEHPKtH0p1h5T7cSO0jXYiaG+PB6NlExio1wMtcdRrcT
 5ZHL2AyMVKaOUIJZQp/5JEWxY9EglHjNSFfrlKcuLE6+UDLywZ2wP72M7I5f/TTFJ0OxhzC+
 DuuE2LRGw8rHsSbzT6+zVm2n9WfnxnSQLAuG+jtnhJtqBjJroAJMzUQX1eTp/O1zEi3Xt83A
 1BS5i0oraEv70GxZsH6VRqo5mWH1jYAXNldO/E96wzLxqm8ywKYAHUUCz1MctorsOcoSjEwk
 FyEhdXkAXpoqrL9YXac8KqE6CyzIyURIHQZTTELQBFD4NT5pow3yBXVQb5e/LWd0oOzQ2yth
 WrQ825h2t3/kPI26klyxnif6xrEm3QDZlRdCtn/No590j5EWQ==
IronPort-HdrOrdr: A9a23:gVLbQa8p9g+DBP9ywwxuk+DPI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINgPN
 9bE5RDNA==
X-Talos-CUID: 9a23:RcTN6W4iha9o8cvYctsspXY7Jt8aK13n9G78DVapVntWa6C/RgrF
X-Talos-MUID: =?us-ascii?q?9a23=3A7SwDFQ+jrKiHZz4pEhEbGwqQf9520o62DEQJqqo?=
 =?us-ascii?q?todC+ZS5KEi+vsDviFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.27,183,1787004000"; 
   d="scan'208";a="190302261"
Received: from unknown (HELO gm-smtp10.centrum.cz) ([46.255.227.75])
  by antispam96.centrum.cz with ESMTP; 28 Oct 2026 18:17:36 +0100
Received: from blackbox.p10 (188-167-137-159.dynamic.chello.sk [188.167.137.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gm-smtp10.centrum.cz (Postfix) with ESMTPSA id A47671011FBFB;
	Wed, 28 Oct 2026 18:17:36 +0100 (CET)
From: Tomas Tonhauser <t.tonhauser@pobox.sk>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	linux-kernel@vger.kernel.org,
	Tomas Tonhauser <t.tonhauser@pobox.sk>
Subject: [PATCH v2 1/2] wifi: ath9k: clear destination mask for non-aggregate frames
Date: Wed, 28 Oct 2026 18:16:51 +0100
Message-ID: <20261028171652.1125692-2-t.tonhauser@pobox.sk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028171652.1125692-1-t.tonhauser@pobox.sk>
References: <20261028171652.1125692-1-t.tonhauser@pobox.sk>
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

Frames to stations without an A-MPDU session (e.g. non-WMM/non-HT
clients) use the non-aggregate path. The hardware may complete such
frames with ATH9K_TXERR_FILT while the station is awake. They are
then reported to mac80211 as IEEE80211_TX_STAT_TX_FILTERED, and
ieee80211_handle_filtered_frame() retries them only once for a
station that is not in powersave.

The aggregate path re-queues filtered subframes on tid->retry_q and
sets tid->clear_ps_filter, so they are retransmitted until they get
through.

The result is downlink loss to awake non-WMM stations, while WMM/HT
stations on the same radio are unaffected. On a QCA9563 AP with
ESP8266 clients this caused 20-40% ping loss.

Set CLRDMASK on every non-aggregate frame. This restores the
behaviour from before commit 5519541d5a5f ("ath9k: fix powersave
frame filtering/buffering in AP mode") for the non-aggregate path
only. The trade-off is that non-aggregate frames already queued in
hardware when a station enters powersave may be sent to the sleeping
station instead of being filtered.

Assisted-by: LLM
Signed-off-by: Tomas Tonhauser <t.tonhauser@pobox.sk>
---

Notes:
    v2: code unchanged, commit message updated

 drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3413bb4906d4..913aa280ae2a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1432,7 +1432,7 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 			if (!sc->tx99_state)
 				info.flags = ATH9K_TXDESC_INTREQ;
 			if ((tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) ||
-			    txq == sc->tx.uapsdq)
+			    txq == sc->tx.uapsdq || !aggr)
 				info.flags |= ATH9K_TXDESC_CLRDMASK;
 
 			if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
-- 
2.34.1

