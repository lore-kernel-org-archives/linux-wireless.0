Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91491C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 17:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C8932080D
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 17:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfBURaW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 12:30:22 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41864 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfBURaW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 12:30:22 -0500
Received: by mail-ed1-f65.google.com with SMTP id x7so23833876eds.8
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 09:30:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KQS74oJ+S455vNozkBMijYenWjVSejJHEX8dpzVy3n0=;
        b=IfQUlftkUQUyomqZkSecTer6T39EzBv7u+vR+qizP7eRPK+KPXg7B8cTjygnmN1rqi
         5UgfIz0in/qgzIRUe2WlJofw/cWNh26p6H6JXkV46SuCgRQbz/0WdGvODdGcYhtOZUYm
         SLrHR/I5iUzso4PllaidkLrFjEesEdpAUtne1oIU8BQBubtoGLUXisw5rQ8uDhcduXFx
         xy6ThrXA314yeRvRwQ+qvAJ0r0e7G6JfnPWviQuwVG15f81Hcyco3QXm3TOYWljsvRXZ
         XmXcBino8Gu9u3eD/nigUpgo0WI6PIec8I20qOd0KAWBNSe3D5PqJN0uwXvgwW5aKz7V
         2Nrg==
X-Gm-Message-State: AHQUAuaGlnqWh3qscjpfDdsX0/8hhGN6xqjFNTe1FaN56BRAmDzoyf8G
        U0KXC235vnJOJA0yxc6Sd1ozoQ==
X-Google-Smtp-Source: AHgI3Iby8nV7qPfhZJpa6ZfGC9KB70vdWejUcyXS2QF/B9AiYvl7xoZrph7QXVs08jDfQXpLSCaoHg==
X-Received: by 2002:a50:d55a:: with SMTP id f26mr16507907edj.292.1550770220646;
        Thu, 21 Feb 2019 09:30:20 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id ay21sm3413366ejb.0.2019.02.21.09.30.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Feb 2019 09:30:19 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7E49B1803B8; Thu, 21 Feb 2019 18:30:19 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>,
        Grant Grundler <grundler@google.com>,
        Kalle Valo <kvalo@codeaurora.org>, wgong@qti.qualcomm.com,
        ath10k@lists.infradead.org, wgong@codeaurora.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Kan Yan <kyan@google.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH] mac80211: Change default tx_sk_pacing_shift to 7
Date:   Thu, 21 Feb 2019 18:29:36 +0100
Message-Id: <20190221172936.21816-1-toke@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87d0nlhxl9.fsf@toke.dk>
References: <87d0nlhxl9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When we did the original tests for the optimal value of sk_pacing_shift, we
came up with 6 ms of buffering as the default. Sadly, 6 is not a power of
two, so when picking the shift value I erred on the size of less buffering
and picked 4 ms instead of 8. This was probably wrong; those 2 ms of extra
buffering makes a larger difference than I thought.

So, change the default pacing shift to 7, which corresponds to 8 ms of
buffering. The point of diminishing returns really kicks in after 8 ms, and
so having this as a default should cut down on the need for extensive
per-device testing and overrides needed in the drivers.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/mac80211/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5055aeba5c5a..800e67615e2a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -617,13 +617,13 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	 * We need a bit of data queued to build aggregates properly, so
 	 * instruct the TCP stack to allow more than a single ms of data
 	 * to be queued in the stack. The value is a bit-shift of 1
-	 * second, so 8 is ~4ms of queued data. Only affects local TCP
+	 * second, so 7 is ~8ms of queued data. Only affects local TCP
 	 * sockets.
 	 * This is the default, anyhow - drivers may need to override it
 	 * for local reasons (longer buffers, longer completion time, or
 	 * similar).
 	 */
-	local->hw.tx_sk_pacing_shift = 8;
+	local->hw.tx_sk_pacing_shift = 7;
 
 	/* set up some defaults */
 	local->hw.queues = 1;
-- 
2.20.1

