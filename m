Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD44E3D9DC0
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 22:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789167307; cv=none; b=ayNFX6HofAwj30ky6UhA65JqR8Kh8KNIu2emwqcoUAnlNW9dJQ9VGtKgsSdidts9mEaTb1Fnzp5XvFBVR83FNk3mSsSuqCekPUaUFgXwos9bvgKD3bZMBJ31PbDCdZUsQYbOHzYP/Fg3Zuh/j99HzqqF7ZfjG3qkN4eg3owSzJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789167307; c=relaxed/simple;
	bh=ygmd3j6naMUaRn4wqyNNGRB13xqTwwz24n2v15rlARI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M8a67eJzq6woORN3etQVRAy7q7X9/9C0sGGODAWjLRr5FgjnuLsxSJemgEhoLW+2gl/FU9XbwojD4ovwVl8XCR587rE/zpqdtzIeDpdwM6lXhuUgoS4F0PZu9rAYY2FuES77zGqlqCk/5plzN6yK0hRH5QyThlIa5fD9MIDZj3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MBRsWiCm; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBRsWiCm"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4858303de5dso1468593f8f.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 15:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789167304; x=1789772104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/9BcpZ28ZB9TTbclwwCoyiL9EEzb27cEjQfU6Vw/HG0=;
        b=MBRsWiCmi0fEj7OSTp4/UNjzV4KHQaG2fULn4mueB+4HBo1napOnWGNttx0e1FzMUU
         pf0C/A+lS42pNVAk0OOSUCkF3JOshtCDNaRAfcfJdHxlYbLTWs8tUuDKOGNW+/pbh1i+
         AgSP3L1bPWMdOq2t9iLdHPnmo699qmu5s5FJTUjsqS2tW3WGcnLhpBntssyaAJDCrBwx
         +n25l8b/ZU4CKg0j6MOzTgxW0+MtzKJiyz1PBsXmocfvKrPE2BrEgS0g/4d8iWDIlLii
         VvaLiCwOa/mTw5vhfmAy5RNfffJ9RR6BZ+xk2OTGBYKjrtAdS/Kqv+WpCXIdeqEbZn/4
         4DNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789167304; x=1789772104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/9BcpZ28ZB9TTbclwwCoyiL9EEzb27cEjQfU6Vw/HG0=;
        b=nJ4x+ZLW/o2BG8NNkTdQVvz2w/fgbLwuHOmyKnBh0yhjgP4yjzRcfoAlA1149Peof5
         CIdsAlao3mMnhWLyMcz3+n6Yui5nAFJksEDNyLPDlvYxLBf/UC/nPXinq4UUWjDh9flA
         +wk1V3mS+EkhpnrA/u9gTloA7qP9JjgwPDb4exCu8mvXuCPMCTxMjJdb5dpreAOqwwg1
         8WZXCiP6o8dFLCkowYYQWTEBhrIIUM7iTO1VgJHf0n4ghvhwDUfIftNJbrW6eTDtq83A
         2X5JqdRLSTEzEAe0MBekHbr3+eY94RGVtS5IMvC9e9SAkmL3GSZ9XBjDtirkVp5Lr0kH
         A8Iw==
X-Forwarded-Encrypted: i=1; AKwUvBwblqr7XR17k4R8BcjFs77laC3Kzkg19MEcPRxTi3fTfv5TiWT1ysdMbWAfQWY85Wr9SrUb8R/3Q28yy1kYFg==@vger.kernel.org
X-Gm-Message-State: AFuF++mvmbZ/MEv3z9/qUPRMutAX8kWFsSkZk8vmfs+oVjbvWEcn14ID
	hHCz+kOVElGQZr2YSgCgxf9XfxFwEAjan0nWyU+RtJTrMSJi8XFtZCwn
X-Gm-Gg: AYBFou2HUHl/9nYzVaqYtvy6FoGgG0WUSccvZ+eiGZk8wbV7QbfF32SaIWmm71tqJ+p
	4RBhN5mzwXOTbfK4YOFB516PriSmPsUJoCEfF5fd1Y9jLOHDUJpe7bPW9lAJw11iVekcb05NOxr
	byIbuZiY8WJnHp45Ealf736oNkMGu1dqo73U8KWMCH4reQf1dc34WDAug/hZPQYIJ+Zn0Fb76bl
	j4Qk6HnC9USHgXKYETm/pmRP493WWdQs8rsqnCXpW6Qk9lfiziXWDJZs036+70feK5Qhp3IVbaq
	kbGcNR9IZiJXgz8GUowfV1EdoaIKoTBNsJgfoZpbMCx/35MQm8cQZlbSxLzf2ufPZvbyvx++t3P
	2KF3flyC8XCG/Efa5mT/tDqJ0PX40G/PhfcwmVnOyS0rK6p3FOV7NGiKyg7jqocoMo9JqfMPokd
	k4phrF2phGawB4F87Pm81dpR22n77CIMY5TBZqrjaeCpnrooASohO1rerkQkmFuyYg9FZQCJt2q
	0lr4/P9JkV9qPnrZX40a9qNjTnaoVDGNFh28FufAMce3waUBqd0W5LP2VTCUP60/bIlqig0Ue0Y
	OAf19qfOLqkmflY8UjuMutygJcq3Our7CiEq
X-Received: by 2002:a05:6000:288e:b0:485:8c16:a33f with SMTP id ffacd0b85a97d-486eb350ca0mr7180318f8f.52.1789167303720;
        Fri, 11 Sep 2026 15:55:03 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-114-033-154.95.114.pool.telefonica.de. [95.114.33.154])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35c071sm9075331f8f.33.2026.09.11.15.55.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Sep 2026 15:55:03 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	John Crispin <john@phrozen.org>,
	=?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: Fix beacon, TXQ and RX OMI kernel-doc references
Date: Sat, 12 Sep 2026 00:53:42 +0200
Message-Id: <20260911225342.11342-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several mac80211 kernel-doc comments misspell the functions they
describe. Refer to ieee80211_beacon_cntdwn_is_complete() for countdown
completion, ieee80211_next_txq() in the transmit queue scheduling
documentation, and ieee80211_prepare_rx_omi_bw() in the receive
bandwidth finalization documentation.

These corrections make the references match the existing APIs.

Fixes: 8552a434b6a0 ("mac80211: rename csa counters to countdown counters")
Fixes: da7f40c05c16 ("wifi: mac80211: add some support for RX OMI power saving")
Fixes: b4809e9484da ("mac80211: Add airtime accounting and scheduling to TXQs")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 include/net/mac80211.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9d1fac6e808298e068bd819897cc7cabee3fc2b8..e8d35f431a1bcb0779fac9aebd6a6f7f4ba9ac2d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4594,7 +4594,7 @@ struct ieee80211_prep_tx_info {
  *	decremented, and when they reach 1 the driver must call
  *	ieee80211_csa_finish(). Drivers which use ieee80211_beacon_get()
  *	get the csa counter decremented by mac80211, but must check if it is
- *	1 using ieee80211_beacon_counter_is_complete() after the beacon has been
+ *	1 using ieee80211_beacon_cntdwn_is_complete() after the beacon has been
  *	transmitted and then call ieee80211_csa_finish().
  *	If the CSA count starts as zero or 1, this function will not be called,
  *	since there won't be any time to beacon before the switch anyway.
@@ -7874,7 +7874,7 @@ ieee80211_return_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq,
  * This function is used to check whether given txq is allowed to transmit by
  * the airtime scheduler, and can be used by drivers to access the airtime
  * fairness accounting without using the scheduling order enforced by
- * next_txq().
+ * ieee80211_next_txq().
  *
  * Returns %true if the airtime scheduler thinks the TXQ should be allowed to
  * transmit, and %false if it should be throttled. This function can also have
@@ -8195,7 +8195,7 @@ bool ieee80211_prepare_rx_omi_bw(struct ieee80211_link_sta *link_sta,
  * ieee80211_finalize_rx_omi_bw - finalize BW RX OMI update
  * @link_sta: the link STA the OMI was sent to
  *
- * See ieee80211_client_prepare_rx_omi_bw(). Context is the same here
+ * See ieee80211_prepare_rx_omi_bw(). Context is the same here
  * as well.
  */
 void ieee80211_finalize_rx_omi_bw(struct ieee80211_link_sta *link_sta);
-- 
2.39.5 (Apple Git-154)

