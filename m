Return-Path: <SRS0=l5SL=WM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06AFC3A59E
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 19:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A1632133F
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 19:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ecQNDbzr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfHPT1P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Aug 2019 15:27:15 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38492 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbfHPT1O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Aug 2019 15:27:14 -0400
Received: by mail-ot1-f66.google.com with SMTP id r20so10624992ota.5
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2019 12:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=exNpvN0pQHXYSl/nDCeQwqAVMdLSgpwL7PY4nJgIlNo=;
        b=ecQNDbzr6Gu09g1Akx6yEsvqTztL4uzMMsZ7U7D6OmExRvUCrtJYMG1DgZLV5HYSBF
         M/puNL5KmOmKAqsVZvQJGVXedC5PIgRONKRabwVLwSwEv1s9G15votnDK9V6jRvCJT8R
         K+VF/M9v0ZihOvSgnqIT4cwqLL1yNQEZaY5Q6aepF6uWnsIEsM8ePGYst9bwn2D4La2p
         X6VlGa3dhCr/NZWJcEYWNzaLfjZ6hIaQ4Z8l1F4QqAgUA0NHgORlG8ImRIW8OA7KnF62
         ZQ/c5EDxl4RTIowCFNkDcDmzBy2t3MLoSZp6k7j0g5vOB+OXDKsi22LmMGmLcwtXPs0A
         Gb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=exNpvN0pQHXYSl/nDCeQwqAVMdLSgpwL7PY4nJgIlNo=;
        b=J2j1TiLBPXkFwxNXK1GuUf+4wrKiI7haqKAK0aUaP81v5EHLXfxYTsXcim4Alkb5ED
         hJtWc45mDHtJ8uQPWuBqG6s88K2BaAiuFDosmlxeyA5WH9HN4daBNxIbojZIIOJqPffs
         EM5YXd8M1REYGs6xBunbmFGetihUnPx9jwOuzz2GPgWjT+lrnqjVdCqZlOo2uWpVp0kV
         TbzIckP0aLLW/acnlTlvzKt78Szu0smsCazS+mtk8s0hI3uuk6lyPZiem4vYtAML+0RU
         r4f4ltRuXBMYfTiNRXOalyAb7YBOZdaq3SbNJFTB5k8NYA31HZBJlLO1i9P0Si3y1uY8
         JoWA==
X-Gm-Message-State: APjAAAVHVjrztQzskkd6udQ3uKdxVWnxko4/BqA9Yf5IkuLEm/SwpT1j
        +pFoF7rcsnHWYYzCzKe+y5E8nSlX
X-Google-Smtp-Source: APXvYqwmVix8cVbkG3xS2IG0Nq8QsExnuTlRtZjh+imFqtXE+P6XSitrqXQ4i2XmIBSE8xXxwX9cSA==
X-Received: by 2002:a05:6830:16:: with SMTP id c22mr8818596otp.116.1565983633125;
        Fri, 16 Aug 2019 12:27:13 -0700 (PDT)
Received: from localhost.localdomain (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.gmail.com with ESMTPSA id b10sm2452246oti.61.2019.08.16.12.27.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 12:27:12 -0700 (PDT)
From:   Denis Kenzior <denkenz@gmail.com>
To:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc:     Denis Kenzior <denkenz@gmail.com>
Subject: [RFCv2 3/4] nl80211: Don't split-dump for clients with large buffers
Date:   Fri, 16 Aug 2019 14:27:02 -0500
Message-Id: <20190816192703.12445-3-denkenz@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816192703.12445-1-denkenz@gmail.com>
References: <20190816192703.12445-1-denkenz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/nl80211.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 682a095415eb..24b67de99f3a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2498,6 +2498,22 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 			rtnl_unlock();
 			return ret;
 		}
+
+		/*
+		 * auto-detect support for large buffer sizes: af_netlink
+		 * will allocate skbufs larger than 4096 in cases where
+		 * it detects that the client receive buffer (given to
+		 * recvmsg) is bigger.  In such cases we can assume that
+		 * performing split dumps is wasteful since the client
+		 * can likely safely consume the entire un-split wiphy
+		 * message in one go without the extra message header
+		 * overhead.
+		 */
+		if (skb_tailroom(skb) > 4096) {
+			state->large_message = true;
+			state->split = false;
+		}
+
 		cb->args[0] = (long)state;
 	}
 
@@ -2531,6 +2547,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 				 * We can then retry with the larger buffer.
 				 */
 				if ((ret == -ENOBUFS || ret == -EMSGSIZE) &&
+				    !state->large_message &&
 				    !skb->len && !state->split &&
 				    cb->min_dump_alloc < 4096) {
 					cb->min_dump_alloc = 4096;
-- 
2.21.0

