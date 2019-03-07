Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C62C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 18:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38E5E20840
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 18:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfCGSkN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 13:40:13 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41268 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbfCGSkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 13:40:12 -0500
Received: by mail-ed1-f66.google.com with SMTP id x7so14333909eds.8
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2019 10:40:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nH3IbHzkEfQ+hjK2opupB8aSF8Da3hNlaO590Ec/k6A=;
        b=ZWiZ9HKZqEq/zahJy9geLXAi+OULV610sOO6ZTDmZq+5qOQsdIcH100noJtWmaKZVP
         l3XQjYaRacFZGKcJj9gFQdV0lue2QkmeU3oaS49lsxacGxEpPzeuBXvcSC42t+PeYkT2
         4DwM15+8gftfz02zogD7a7AoFq2gERkmw2aH3yhC0Qr5jzNC/VIFC9iiMAL75r0HTJ7m
         2hlmT044gvNo3SBZU4nTTcqlKIoliHzH397V+ptRd8f/rxYG284Zni8pkZgz533l82nJ
         /bKvqZLyW0SfveTfaS8DRq7zVb9EWiKDeOAhN81T+DAhy39jHwJC0LILQWmw4oRWb+Bk
         GqwQ==
X-Gm-Message-State: APjAAAUMKOi/wf1BqhWa939MjGZ6VjwiSxKBG82agHRRV0Owq9o8nI4z
        T6DnRQtCsijvLCIkTpUsUqq42Q==
X-Google-Smtp-Source: APXvYqw7+gcbpcmJnUCpUx6aAphCrsljUHwiqyohTOHSkrn6OLgwjIqQAuudQt/Hv8x4UDkRfir0HA==
X-Received: by 2002:a17:906:940d:: with SMTP id q13mr8771287ejx.160.1551984010813;
        Thu, 07 Mar 2019 10:40:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id ca14sm1018347ejb.70.2019.03.07.10.40.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Mar 2019 10:40:10 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C2532182F5B; Thu,  7 Mar 2019 19:40:08 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Miguel Catalan Cid <miguel.catalan@i2cat.net>
Subject: [PATCH] ath9k: Don't trust TX status TID number when reporting airtime
Date:   Thu,  7 Mar 2019 19:39:44 +0100
Message-Id: <20190307183944.11190-1-toke@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As already noted a comment in ath_tx_complete_aggr(), the hardware will
occasionally send a TX status with the wrong tid number. If we trust the
value, airtime usage will be reported to the wrong AC, which can cause the
deficit on that AC to become very low, blocking subsequent attempts to
transmit.

To fix this, account airtime usage to the TID number from the original skb,
instead of the one in the hardware TX status report.

Reported-by: Miguel Catalan Cid <miguel.catalan@i2cat.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
I haven't been able to confirm that this also affects the old in-driver
airtime scheduler, but I suspect it does, so I'll send a follow-up patch
to stable once this has been merged.

 drivers/net/wireless/ath/ath9k/xmit.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 773d428ff1b0..1c91eda0ba51 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -668,7 +668,8 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
 static void ath_tx_count_airtime(struct ath_softc *sc,
 				 struct ieee80211_sta *sta,
 				 struct ath_buf *bf,
-				 struct ath_tx_status *ts)
+				 struct ath_tx_status *ts,
+				 u8 tid)
 {
 	u32 airtime = 0;
 	int i;
@@ -679,7 +680,7 @@ static void ath_tx_count_airtime(struct ath_softc *sc,
 		airtime += rate_dur * bf->rates[i].count;
 	}
 
-	ieee80211_sta_register_airtime(sta, ts->tid, airtime, 0);
+	ieee80211_sta_register_airtime(sta, tid, airtime, 0);
 }
 
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
@@ -709,7 +710,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	if (sta) {
 		struct ath_node *an = (struct ath_node *)sta->drv_priv;
 		tid = ath_get_skb_tid(sc, an, bf->bf_mpdu);
-		ath_tx_count_airtime(sc, sta, bf, ts);
+		ath_tx_count_airtime(sc, sta, bf, ts, tid->tidno);
 		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 			tid->clear_ps_filter = true;
 	}
-- 
2.21.0

