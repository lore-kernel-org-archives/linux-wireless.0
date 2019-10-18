Return-Path: <SRS0=fVU0=YL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DFCCA9ED0
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 05:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 833E8222C5
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 05:10:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="SSAw+mF6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391172AbfJRFKW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Oct 2019 01:10:22 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:59966 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbfJRFKV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Oct 2019 01:10:21 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Oct 2019 01:10:21 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 64E6AC94
        for <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2019 04:53:12 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7IXD6O1x1n09 for <linux-wireless@vger.kernel.org>;
        Thu, 17 Oct 2019 23:53:12 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 3C502B0B
        for <linux-wireless@vger.kernel.org>; Thu, 17 Oct 2019 23:53:12 -0500 (CDT)
Received: by mail-io1-f69.google.com with SMTP id f9so7054315ioh.6
        for <linux-wireless@vger.kernel.org>; Thu, 17 Oct 2019 21:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PiAvGPBAd5r/3XyVj4aUHP7AUeXoHl9s9vGj/rL2vBE=;
        b=SSAw+mF6f+5B+nirGSGu/AIgxkBVez4C2mLwuOn2tdvSW6D2qgygO+CJhg/4C5A4UY
         xWLJlB3gN5EseI5nGlOxXzBh17l243fYEsLjpBwMlbcyftv/av5pE+ARJqX4V6h3fEVb
         apUsF/OH+V+/oXLedtF3gnfl3I+r5VDk4FJpUI4VC2joMHaMKxpbl+T4BOTeZ1qvYq3J
         9sgaWLiyFSDyQPKt8y46jMtH/uo8saK+v/LqHHNuPDs3YPlY8kVkUpk3MQfwTOR5HcIa
         Tx4igdKciSEATWOcEVUnHHCFtyOgsKlDcT64tagQdJdLbSr4LvX88ddY8tEER3peRXg/
         7pGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PiAvGPBAd5r/3XyVj4aUHP7AUeXoHl9s9vGj/rL2vBE=;
        b=smeGd23ZdXNLR3oinNDHQIQ/Om1N0JJ7i1kwXdeK8tVBBg/RxuAHrDqTg1upDoQaKa
         ca8vf/DMRjWUWV1iLQPhS5c4iGPCkAfs4xtbpTpWHbXmktoA0YQU5uIUiJ3hbCoWVl9g
         lzE5rgyX7xyD2oOi7s8JyLP9k/6jeleIUnortr9m02JFuSiVbCGvBcykXq1KGcLA3WeH
         GSiPpN3kKERf4mvS/MbFgHzf3J2xtnhYT4la/rzlwUxu4Lf5Nc1klfNiuRHcuaqNjzvS
         psUNpH3WoeBxzNmX4heEx/+zeLs2+LXXATjCiq28Sf2aOPp0hmm0QAJ2T8FkDt7cr6+b
         WpDQ==
X-Gm-Message-State: APjAAAXovpZHuxlCnbJxYvQfdJsHU++FsK3SywzLD0gu9RsUuyN9c8zR
        YCiDM5GWaIn9bKm+7sqWVM94iG872h2My1RlorsMHyxaiP14l14jexeu0O41jAJAqi0Z5+Dmsji
        meDzhSsKE/0lDwtbP01tbcZNqiWt/3q8=
X-Received: by 2002:a92:48cf:: with SMTP id j76mr7837585ilg.246.1571374391564;
        Thu, 17 Oct 2019 21:53:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyC/JNn6/bb1kk/U+cLwblGbXmpbY/tAAsujMTaZdpNNs4/lNdEfWgzh72OP1sSvTEK7SUrdw==
X-Received: by 2002:a92:48cf:: with SMTP id j76mr7837569ilg.246.1571374391314;
        Thu, 17 Oct 2019 21:53:11 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id 197sm1639719ioc.78.2019.10.17.21.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:53:10 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/lib80211: scrubbing the buffer for key
Date:   Thu, 17 Oct 2019 23:53:05 -0500
Message-Id: <20191018045305.8108-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The "key" is not scrubbed. As what peer modules do, the fixes zeros
out the key buffer.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 net/wireless/lib80211_crypt_wep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index dafc6f3571db..08e511aaa1ff 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -202,6 +202,7 @@ static int lib80211_wep_set_key(void *key, int len, u8 * seq, void *priv)
 	if (len < 0 || len > WEP_KEY_LEN)
 		return -1;
 
+	memset(wep, 0, sizeof(*wep));
 	memcpy(wep->key, key, len);
 	wep->key_len = len;
 
-- 
2.17.1

