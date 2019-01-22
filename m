Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D62CC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15E7920870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfAVOVd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:21:33 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36688 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfAVOVd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 09:21:33 -0500
Received: by mail-ed1-f68.google.com with SMTP id f23so19446741edb.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 06:21:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3IHpxwscK74GPH/OmYTacZuNvfvt+rhFlghjd4c8vPM=;
        b=I5p+kj8143q6KqITC/FadtqV05YMZnWTZKjKsYcgRfq5fdSRWkjb6mK4RGuxpv26VB
         cse4J2znLxeWuyvh0BL1RdgW7j/gmnmaKoV6egN2HzUn/eU1CQZUjPBi1xoC+Cn28AhI
         O1RO4EV6JXY279NuBsUXxaJrSOko9Uopz1HHYWYDC9kSRsNnZHVLNH0DQ56tuIBJuRfe
         5RZrPll3yNCQ08afFwsuFhRJpPALnZyUiIlcMeV4UCJ6eMna+IKCFExCGgu+80iSqxN4
         lRGD7dk+s4Y/btCRugcMKQMEB96clggb6gbUvJamz8ZA81kJlEBxueSKbou2KP90BDv+
         uWHw==
X-Gm-Message-State: AJcUukcCHQx/FD1gmUbB7oiFVIGjtddU8a6H8U+1fG+OG1wLecwqs8Gw
        1OWUOG4NfIfGp3szvokV0tiDBg==
X-Google-Smtp-Source: ALg8bN5nPdEKK/oeg5eB/dxboG3zFhcM4QpFSGhjxptEtLRC+3dfDDkXEJc2faOXxMp/gPj4rHnxFw==
X-Received: by 2002:a50:f5af:: with SMTP id u44mr32009323edm.172.1548166891402;
        Tue, 22 Jan 2019 06:21:31 -0800 (PST)
Received: from tohojo-x1-rh.localdomain (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id h8sm9462898edb.95.2019.01.22.06.21.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 06:21:30 -0800 (PST)
Received: by tohojo-x1-rh.localdomain (Postfix, from userid 1000)
        id 5E7621833C1; Tue, 22 Jan 2019 15:21:29 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net
Subject: [PATCH v7 1/4] mac80211: Expose ieee80211_schedule_txq() function
Date:   Tue, 22 Jan 2019 15:20:16 +0100
Message-Id: <20190122142019.21417-2-toke@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190122142019.21417-1-toke@redhat.com>
References: <20190122142019.21417-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since we reworked ieee80211_return_txq() so it assumes that the caller
takes care of logging, we need another function that can be called without
holding any locks. Introduce ieee80211_schedule_txq() which serves this
purpose.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/mac80211.h    | 13 +++++++++++++
 net/mac80211/driver-ops.h |  4 +---
 net/mac80211/tx.c         | 13 +++++++++++++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a285c2bfd14e..294a8a36012a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6209,6 +6209,19 @@ void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
 void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
 	__releases(txq_lock);
 
+/**
+ * ieee80211_schedule_txq - schedule a TXQ for transmission
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ * Schedules a TXQ for transmission if it is not already scheduled. Takes a
+ * lock, which means it must *not* be called between
+ * ieee80211_txq_schedule_start() and ieee80211_txq_schedule_end()
+ */
+void ieee80211_schedule_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+	__acquires(txq_lock) __releases(txq_lock);
+
 /**
  * ieee80211_txq_may_transmit - check whether TXQ is allowed to transmit
  *
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1aab1734b26f..ba3c07b10cd0 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1176,9 +1176,7 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 static inline void schedule_and_wake_txq(struct ieee80211_local *local,
 					 struct txq_info *txqi)
 {
-	spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
-	ieee80211_return_txq(&local->hw, &txqi->txq);
-	spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);
+	ieee80211_schedule_txq(&local->hw, &txqi->txq);
 	drv_wake_tx_queue(local, txqi);
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f46d8d822f86..17744be84b34 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3703,6 +3703,19 @@ void ieee80211_return_txq(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_return_txq);
 
+void ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			    struct ieee80211_txq *txq)
+	__acquires(txq_lock) __releases(txq_lock)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = to_txq_info(txq);
+
+	spin_lock_bh(&local->active_txq_lock[txq->ac]);
+	ieee80211_return_txq(hw, txq);
+	spin_unlock_bh(&local->active_txq_lock[ac]);
+}
+EXPORT_SYMBOL(ieee80211_schedule_txq);
+
 bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
 				struct ieee80211_txq *txq)
 {
-- 
2.20.1

