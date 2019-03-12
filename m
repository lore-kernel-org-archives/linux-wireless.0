Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E600EC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 08:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2CAE214AE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 08:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="C2CU5N2i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfCLIFL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:05:11 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:52246 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfCLIFK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 04:05:10 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 926F3A9E
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 08:05:09 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TKhjEzhkMJt2 for <linux-wireless@vger.kernel.org>;
        Tue, 12 Mar 2019 03:05:09 -0500 (CDT)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 60C82A8E
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 03:05:09 -0500 (CDT)
Received: by mail-io1-f72.google.com with SMTP id d7so1191073ios.17
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 01:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/UfKkWpYjlT8HaU1Ko3WZBjaI52PEMRkC5DbnaB1afM=;
        b=C2CU5N2ilF6/MC7VS18KzFDgWfc8qUkgQW75R93Fmi0mcK20vJz+l4pSQ/yjezdMu4
         ErC+JVyr1f9K+eRzhrHvLysmkvAdYmygBD6BMYTsmvQvAm9THOYJI6+s8b+EJ3/FzBKB
         1tv8o8yNmEN1FuexN7Cvv0a7ntfZfy/1POskTMQ09zp8HBIBFnxUJkmMGFnEMlZvliiI
         ChtMvwI7TkqvCZISby5YNpTnVEQMs7k0kT51CBBYSz9YowePaA4I5aWndtPgTZQjeXM5
         9iD1FhovsHd6QvZlnHnNqVi8Kre/dbxcPpdfpvM3oCS4lW2n6u7I+qBTia8m2lvi3LnQ
         Qn2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/UfKkWpYjlT8HaU1Ko3WZBjaI52PEMRkC5DbnaB1afM=;
        b=oBJlxCOS5OBUC9N07APw6LzIJ7nVGEScW6jGeUogIxukEG1OJ6HdXq1OwTNNm7uxd4
         CY4oNlFWeqjovgSGSWOHTs/7SRejTpsOrb9zEQdtpKJ/o0cEq9+Yoaua0eEF8rTLXUM6
         /SQIOQYBIuduU/sAnkEx/3qh3+eNfk0aDOpv8K1tLnVfqVLl+nnTXqOJWfqPHIzkwYZc
         zHTeHoT09BVhtb9cSN1yd45imz0CNZQVA1QzL4izVcUM4jVrpRRPAFwzt0jtf3ts+geQ
         OB+1KKyuQNR+aQXVnJh7sBS0tRcaDnBcAh/cjBGwKJRv1aISQCQEhnvoqdCoasSkNpQt
         wU6w==
X-Gm-Message-State: APjAAAWfZoAUwv/30oalumClylbHVlwee7URfuz6eiIk41rtdbuOd2Hw
        zNebDKJQDCv4Dt6gqtXnESdeHpmmePibq4LFKknRBoLniAUx381UF+t7I2jQxFVV0D+d29WmKHP
        C7hHe8KDaehLOQTxVgkEeNDB+fgsj2J0=
X-Received: by 2002:a02:3e8b:: with SMTP id s133mr4972937jas.16.1552377908993;
        Tue, 12 Mar 2019 01:05:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy3ZuyqFz2fQwVVgNZphNFG7Y9j9mWyIanz3U+djB/ZPVQsf6s9oS+mL1mA87L3fhG4aZWNSw==
X-Received: by 2002:a02:3e8b:: with SMTP id s133mr4972929jas.16.1552377908755;
        Tue, 12 Mar 2019 01:05:08 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id u24sm3327451ior.59.2019.03.12.01.05.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 01:05:07 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: cw1200: fix a NULL pointer dereference
Date:   Tue, 12 Mar 2019 03:05:02 -0500
Message-Id: <20190312080502.2953-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case create_singlethread_workqueue fails, the fix free the
hardware and returns NULL to avoid NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/st/cw1200/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/main.c
index 90dc979f260b..c1608f0bf6d0 100644
--- a/drivers/net/wireless/st/cw1200/main.c
+++ b/drivers/net/wireless/st/cw1200/main.c
@@ -345,6 +345,11 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 	mutex_init(&priv->wsm_cmd_mux);
 	mutex_init(&priv->conf_mutex);
 	priv->workqueue = create_singlethread_workqueue("cw1200_wq");
+	if (!priv->workqueue) {
+		ieee80211_free_hw(hw);
+		return NULL;
+	}
+
 	sema_init(&priv->scan.lock, 1);
 	INIT_WORK(&priv->scan.work, cw1200_scan_work);
 	INIT_DELAYED_WORK(&priv->scan.probe_work, cw1200_probe_work);
-- 
2.17.1

