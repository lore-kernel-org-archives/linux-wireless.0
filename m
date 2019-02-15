Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9D5C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 16:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA32B2146E
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 16:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbfBOQtU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 11:49:20 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38007 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388334AbfBOQtU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 11:49:20 -0500
Received: by mail-ed1-f67.google.com with SMTP id h58so8486653edb.5
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2019 08:49:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1zSmmzsKU/67oSzxkP3nnUTXMLRwYqn+zk9jXOXk0W4=;
        b=FtWr5sW29+WKR/I87AtT/BuZYwhDyCk/h8ZU+5fU8BfVg2HWOWYmqTm/HYc4B1CkUI
         RoVv5KcFlIMzG0YNGucc5N5lg2wqvjX/xoL/EAvznITpwe4S7tToTZgrMfkEd5o67liV
         ZAf7cJx4VEVtbO9dvqp+EyXitkc6UkrFEj6d4D82I7ZG7io5peD0XYmQtC17HxeJ4lRI
         2u5V+PIE1gDPAVup9+B9SIJg34+9tmZthLisPFcxPlYvLIqwqJCGu5jk2i5nSSjdng9N
         S7sFmMrzc2uhWi1XthVFpVdMNxJca/DYqul3El3P5w3Lhbjn5YNJAL04OWid2rBC/YKK
         uVHA==
X-Gm-Message-State: AHQUAuak5tW35kRT3GntBONC+AVRvx1Su+qe73wfg4dFFKk/ZLnXbbDC
        e6+5ihNgfwARQIJhDKKQ1TtGkw==
X-Google-Smtp-Source: AHgI3IYLDn+bYGu683n6n8Dn+3n3w/cRp7DiCxBrsKIHNIzzleryALCsXPYuKV7ouu7ur+eDB+zfiw==
X-Received: by 2002:a17:906:28c9:: with SMTP id p9mr1786607ejd.43.1550249358831;
        Fri, 15 Feb 2019 08:49:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id s14sm1315992ejz.35.2019.02.15.08.49.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Feb 2019 08:49:17 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A55A1825DD; Fri, 15 Feb 2019 17:49:17 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH] ath9k: Make sure to zero status.tx_time before reporting TX status
Date:   Fri, 15 Feb 2019 17:48:55 +0100
Message-Id: <20190215164855.30666-1-toke@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since ath9k reports airtime usage directly using the
ieee80211_report_airtime() callback, it shouldn't also report it using the
tx_time in status. Make sure the field is zeroed before TX status is
reported to avoid spurious airtime being accounted by bits being left over
from earlier uses of the cb.

Fixes: 89cea7493a34 ("ath9k: Switch to mac80211 TXQ scheduling and airtime APIs")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 06e0c5a6fab6..773d428ff1b0 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2552,6 +2552,9 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	}
 
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
+
+	/* we report airtime in ath_tx_count_airtime(), don't report twice */
+	tx_info->status.tx_time = 0;
 }
 
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
-- 
2.20.1

