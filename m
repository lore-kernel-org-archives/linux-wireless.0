Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864EAC46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 16:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F01820665
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 16:13:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u8lNjEUJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F01820665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbeJXAhC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 20:37:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46274 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbeJXAhB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 20:37:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id i4-v6so2341880wrr.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2018 09:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+JScUQ78rFZbnKeeinU5VrseuSLSSJNADLkjx45RdqQ=;
        b=u8lNjEUJGPOo8RXEFj9OXw0uupkkXQUHKu4J7jr5JsFer9IsK/n36ynF814hr5fnhG
         UQnvAfUQNWuje9HOH8QYTpSjkcqHfncMuLcW5LVQeNC5vjl81xMDGpoGyXXeyMQZblVd
         Lozwt2hToIC2wYCSvrvf3NfpeNYf99X2mkGPu+KGc62HBV4QnQVgDRUJvZFRbEdpQ0DG
         PWcftUUq0Jji/2OGyBwbFajMqcX+j69JcIUtg38M4Y1IzYUs1yeKiE2ZlXb+Kp8p+TdB
         6Lr/rh5CKXM7ZCEBmb1EEemeCEHXTkPYlUzTIZUB2DGFSTuEai98HkxI/1C8rWCoQaYy
         DwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+JScUQ78rFZbnKeeinU5VrseuSLSSJNADLkjx45RdqQ=;
        b=jURMsjYmu7svGM606W/eF6YQoCWOd4SHsuBeIITARtnHnP7BfdiPgPMJHMlWl56oVQ
         cFPE0VnV400xyU7kM3ES5aEMlOItr5Z/4Kg8CuB7v1Rd2BsK8vQZMQUzTDjhxhpQDDl6
         pAeLiM3nzMW+0wLhRq/fhjqXdXX5qVOgMpznKWkFegL0NBxGWK61m1qsvNnv/D213gkq
         US7I9bpafzaw7rJ0U1qFgR8dHfTNZHmilR4b1K1iOjwQ1Jju6biWViztn5zJyvpIlcwl
         fwbFplv9nCv1y/jMk/Xup+olSjSolpPAIk5vr1K5DPM4/af/pqZGW4XcXf4Ac46JVA2o
         5JiA==
X-Gm-Message-State: ABuFfogJx4oRjzclTGkYNBZdGxEEu/lghLBc/qmZg8ZEfUaJOZClad7j
        xw00PKg6PRpAqnxYM44OqEVC2PDoOHE=
X-Google-Smtp-Source: ACcGV60SDuBKpSQxXz/K3pez4T73KtH4ziTYxK+1VQ5sShiFdV/TFAAuC9Iw0GTx2wwVPz0k+GEuFQ==
X-Received: by 2002:adf:9021:: with SMTP id h30-v6mr53403649wrh.248.1540311178471;
        Tue, 23 Oct 2018 09:12:58 -0700 (PDT)
Received: from localhost.localdomain ([37.238.236.62])
        by smtp.gmail.com with ESMTPSA id h18-v6sm1065505wro.0.2018.10.23.09.12.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Oct 2018 09:12:57 -0700 (PDT)
From:   Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Subject: [PATCH] brcmsmac: never log "tid x is not agg'able" by default
Date:   Tue, 23 Oct 2018 19:12:35 +0300
Message-Id: <20181023161235.18143-1-alimjalnasrawy@gmail.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This message greatly spams the log under heavy Tx of frames with BK access
class which is especially true when operating as AP. It is also not informative
as the "agg'ablity" of TIDs are set once and never change.
Fix this by logging only in debug mode.

Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index 912499f..c5de9a3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -846,8 +846,8 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		status = brcms_c_aggregatable(wl->wlc, tid);
 		spin_unlock_bh(&wl->lock);
 		if (!status) {
-			brcms_err(wl->wlc->hw->d11core,
-				  "START: tid %d is not agg\'able\n", tid);
+			brcms_dbg_ht(wl->wlc->hw->d11core,
+				     "START: tid %d is not agg\'able\n", tid);
 			return -EINVAL;
 		}
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-- 
2.19.0

