Received: from mail-ed2-f6.google.com (mail-ed2-f6.google.com [74.125.228.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37D354CF41
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875613; cv=none; b=ZolRcSK/Awcn4RIaVcV1ROnE8C+HYWs3IQ2QRVMz18XpKd0DXpG16g9RqtETYPMRHPYIm6xxuO5hZIStanYI2kgx7EOAK/AOrtELXbirwMijs6kYkpG1IpKJXKvDFq9Ko2Jin1OIhrVkG2knHbgF8uOEUjYx4VbrLkiKlOhosvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875613; c=relaxed/simple;
	bh=LhiHO7vfxCWeNipvbNCnJmQk1D8sjUp31Cf5gk2GcJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Iyd9DIqIt9gnxeQU44RxgicRMkIUr8Sd2ScCh135xwWaL/HL8pCQBlsQSxM3ajrsN/N9RhQ/NRZp147QEll3wg8+3qaL3vGY8iblo6WHKj+LPN8uW0lVQj0Wju1Z4+HY2Dvdwc7khDrzUYnEjGOzfxVEb4BjkHw9MUjk6WhARBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=chdNlpLa; arc=none smtp.client-ip=74.125.228.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="chdNlpLa"
Received: by mail-ed2-f6.google.com with SMTP id 4fb4d7f45d1cf-6a406d7afa8so2139494a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875597; x=1789480397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jLbvcyq3q/pbF30deRaLGbbCTJlJfhASYsjhDtA/Jsc=;
        b=chdNlpLaTgIRfwok0xc/Tqcx6b+qrXWY95P+XDIYNP+9IU+cqz7pSyg7vbQcLna1SS
         2TDmYYwbGwM9n+AokwYg48OAEHEn4q/Oj9iXE+aoSdSDuA6Y1vwKnMmgJG4h/a3m+HYl
         CkZlQg/HQucXv14r7Wti96eDhofwJacriPw5K8y/bAo3//HWFLZPwr6/8Zg9foRROtua
         9b9f9mTgknpKz6P4FdWg890giUaTjiORUMcmrHRleX2NYZrRN6nnfCthbfKlVCWElYWN
         UvleunVota+OyOsnoNfQ92pJKEeWStl6/ICyqOxRoTr1lHNgQgSNEpv3gwWgouCl5fWs
         ooQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875597; x=1789480397;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jLbvcyq3q/pbF30deRaLGbbCTJlJfhASYsjhDtA/Jsc=;
        b=bC9n7gHBD+Rvzp6TKuoiy0IipyB2+g8wMqnsqQtP/IbkpwmtJG0JiGij88r0xTu0Kq
         YtzEoEBPZAQSXHRUyvNI56/IP+9SrZ7SrYyob3oLm9pk+UzNmJxIu7450ROP8lX00LvD
         rrvuuUb5lq78gDS+f3wly8onJ4QWeRDoeZdEiVy6epP2G2wd/Se6CX449rGEuo4MpN2j
         WbREb8CCfXpd7kKDCBVOztW2Jts95PmBxNj+mCKK2tDIWyNO5BpczoZwPS2MEB0Fb2yq
         Ra8KUPwlbWeEqTdBEB/J7H2ik5XP4v7y9lzsE1cei9mwuSKGe9F46XtapkiRZXaaK1zl
         POtg==
X-Forwarded-Encrypted: i=1; AKwUvBw9g6TkYbNo5j29YcX3iSG97/hW9bejphTW373NllNtTlcRnpx/hM3p4LjDa+ArfTZST3tr3f2O9hHMNBwewA==@vger.kernel.org
X-Gm-Message-State: AFuF++lwcIIli4vfO55ZnvshOlk8Q5Tv6pP6+YxE1OhUt+32bz8AESy/
	PtsEBB/9pS+w6rZ18vyN8chEu8dwc/ZHUcXP0uoYZ7a20Ab8FwYVtWwGLfHFzrWdmg==
X-Gm-Gg: AYBFou3LKOo3caiD3mYGgp9YVCGwQw1xmlMJ0NPWcS+IpQldIaJHqdfDQLNOHpHcaoy
	SOa6RIumQHCygHSuqfYQVFzLcq5Aitn2cWghriMJFc0HAYDButTIXNKXT7PCRpRZS4m/0W8PXnX
	t4NZFNSCkSdyaQcXFyuyUEUpctlkXYQRo9jwHp4Mtg4tVtyZP43Hozg+RyPZzZPzQVHfhFKRmO5
	zO3dLgFz8w32is3Li0ZZKhWe4ljH6RvAwVqkkPy2G6/cmK4pVhrSYfvSe3hvjtQtvi+g083+J/o
	EF/pidtDhaS5qX6wCROxUlHmXx6ItpUnt0g7TWK8OopT2u5IvKG8uk/oKfVot/rmRpoyn6DLX1Q
	hQCJT52M3LqZk+Kabp2jZ7wkCAOpSVsWet+l0oUQQXqH1IeTSJJySsnM3XAswEU/WyaDiE3cYzu
	KQt5YVDPcCMoRR74La8+5xT9hEvQy+PypixvROHaLqHSdVeBEs66aTVu0Q6COUGFvFh7luX0Km9
	OE982P5IjDStu+BqX/K5a61yIhOrgsZKGRl1G7PxibNH+14ehC1vIH4QBiO9gaaiOrp7Wumbam5
	//737oF1xa/OIENqqX2R0AaiYNKs/qj/3ew5XMk2H1PAbfOfAFN241Owf9qfT+Hvn17a0/pfbfQ
	BE06nZEA/GCa03Ylt8tZEXcQsIYC+l2XoCpOfehK3mS+zfCtGgT5hec4L116/COlS7axKK+viIp
	H8HrTlsjlePTOM
X-Received: by 2002:a05:6402:3241:b0:6a7:f207:278e with SMTP id 4fb4d7f45d1cf-6a7f2072851mr6378442a12.15.1788875597050;
        Tue, 08 Sep 2026 06:53:17 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e68a6e19sm5519140a12.10.2026.09.08.06.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:16 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: johannes@sipsolutions.net
Cc: toke@toke.dk,
	jjohnson@kernel.org,
	ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] wifi: mac80211: scale the airtime queue limit by the station's weight
Date: Tue,  8 Sep 2026 15:53:14 +0200
Message-ID: <20260908135315.754126-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A driver that hands every frame it dequeues to the hardware at once
holds nothing back but the airtime queue limit, so every station keeps
its full limit in flight and the hardware picks the next transmitter
among them. The order in which ieee80211_next_txq() serves the queues
never reaches the air, and the airtime weight has no effect on the
airtime a station gets. ath11k is such a driver.

Add IEEE80211_HW_TX_NO_PUSHBACK for a driver to say so, and scale the
per-station limits by the weight when it is set. A station with twice
the default weight may keep twice the limit in flight. The scaled value
is capped at aql_threshold and never drops below the configured limit.
A driver without the flag is not affected.

Measured on an IPQ8074 AP with ath11k, a 2x2 HE160 and a 1x1 VHT80
client both saturated downstream, BE aql_txq_limit 500/1000 us, 15 s
runs, three per setting. Share of the tx airtime taken by the HE160
client in per cent, at weights 256:256, 1024:256 and 256:1024:

  without the flag  55.2, 54.1, 52.8  55.9, 51.9, 59.8  54.8, 56.3, 59.2
  with the flag     57.8, 57.5, 55.1  73.8, 76.7, 74.4  22.6, 22.7, 22.4

Mid-run the favoured client holds 1.2 to 3.2 ms in flight and the
other stays at the configured 1 ms.

Ping from the AP to the HE160 client under the same load is 4.8 to
7.4 ms mean at equal weights and 18.1 to 25.1 ms at 1024:256, where it
is the favoured client: the deeper queue costs it that latency.

The scaled limit takes effect only where the configured one binds. At
the default 5000/12000 us both clients hold several milliseconds in
flight, neither queue runs empty between transmissions, and the weight
does not move the split.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
v2:
- gate on a new hw flag, IEEE80211_HW_TX_NO_PUSHBACK, so a driver that
  pulls when the hardware has room is not affected. The flag is set by
  the driver rather than derived from the use of
  ieee80211_handle_wake_tx_queue(): a driver with its own callback can
  push everything it dequeues just the same, and ath11k does once it
  schedules its TXQs itself
- add the ath11k patch that sets the flag as 2/2
- rewrite the message
- v1: https://lore.kernel.org/linux-wireless/20260824142435.1757391-1-julius@bairaktaris.de/

Measured with the ath11k series "wifi: ath11k: airtime queue limits,
fairness and a driver TXQ scheduler" v4 applied, which advertises AQL
and airtime fairness on ath11k, and with "wifi: mac80211: keep the TXQ
scheduling round number across a closed round" applied.

 include/net/mac80211.h |  7 +++++++
 net/mac80211/debugfs.c |  1 +
 net/mac80211/tx.c      | 21 +++++++++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7bb4618065b6..80381c7abd84 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3086,6 +3086,12 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SUPPORTS_NDP_BLOCKACK: HW can transmit/receive S1G NDP
  *	BlockAck frames.
  *
+ * @IEEE80211_HW_TX_NO_PUSHBACK: The driver hands every frame it dequeues
+ *	to the hardware at once, and the hardware picks the station it serves
+ *	next, so the order in which mac80211 schedules the queues does not
+ *	reach the air. mac80211 then applies the airtime weight to the
+ *	airtime queue limit instead.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -3147,6 +3153,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_HANDLES_QUIET_CSA,
 	IEEE80211_HW_STRICT,
 	IEEE80211_HW_SUPPORTS_NDP_BLOCKACK,
+	IEEE80211_HW_TX_NO_PUSHBACK,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 8946b027782c..ddbfa991ec74 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -462,6 +462,7 @@ static const char *hw_flag_names[] = {
 	FLAG(HANDLES_QUIET_CSA),
 	FLAG(STRICT),
 	FLAG(SUPPORTS_NDP_BLOCKACK),
+	FLAG(TX_NO_PUSHBACK),
 #undef FLAG
 };
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c33092960df2..c94efff48d74 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4217,6 +4217,21 @@ EXPORT_SYMBOL(__ieee80211_schedule_txq);
 
 DEFINE_STATIC_KEY_FALSE(aql_disable);
 
+static u32 ieee80211_aql_sta_limit(struct ieee80211_local *local,
+				   struct sta_info *sta, u32 limit)
+{
+	u32 scaled;
+
+	if (!ieee80211_hw_check(&local->hw, TX_NO_PUSHBACK) ||
+	    sta->airtime_weight == IEEE80211_DEFAULT_AIRTIME_WEIGHT)
+		return limit;
+
+	scaled = mult_frac(limit, sta->airtime_weight,
+			   IEEE80211_DEFAULT_AIRTIME_WEIGHT);
+
+	return min(scaled, max(limit, local->aql_threshold));
+}
+
 bool ieee80211_txq_airtime_check(struct ieee80211_hw *hw,
 				 struct ieee80211_txq *txq)
 {
@@ -4238,13 +4253,15 @@ bool ieee80211_txq_airtime_check(struct ieee80211_hw *hw,
 
 	sta = container_of(txq->sta, struct sta_info, sta);
 	if (atomic_read(&sta->airtime[txq->ac].aql_tx_pending) <
-	    sta->airtime[txq->ac].aql_limit_low)
+	    ieee80211_aql_sta_limit(local, sta,
+				    sta->airtime[txq->ac].aql_limit_low))
 		return true;
 
 	if (atomic_read(&local->aql_total_pending_airtime) <
 	    local->aql_threshold &&
 	    atomic_read(&sta->airtime[txq->ac].aql_tx_pending) <
-	    sta->airtime[txq->ac].aql_limit_high)
+	    ieee80211_aql_sta_limit(local, sta,
+				    sta->airtime[txq->ac].aql_limit_high))
 		return true;
 
 	return false;
-- 
2.53.0

