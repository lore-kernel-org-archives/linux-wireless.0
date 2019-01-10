Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D237C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CDBB214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfAJLOX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:14:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41673 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727697AbfAJLOX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:14:23 -0500
Received: by mail-wr1-f65.google.com with SMTP id x10so10874341wrs.8
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2019 03:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0j41QadWa4w/LZUeVPoc0FviFxjhCpPGcAq3o3u/5bo=;
        b=OhSEV2xBD2wYRM21EEQnJa51yOWMp1FVncWOt9+xxl8zUaORc42nAAtTlm7NuwkTQa
         7nLazbU3d1ISYmHBOYszPAJqWsRa4K/mGoDmhdLdImEYmFVUnGkTEZjHLCV0WVm5RSw5
         AXSHF+VH4fKr4j4u+5ASWn8qNXaFJt1J682FwnMz4dq0y56AkMeCbH3xSv4XpkZOO32k
         nvlRXUwkVKuBENnu8pC94eCVX/nbb9orkJ/AB5HhznkdaLqwGAWLlWG0LXoKoiPH14F9
         eYbmYdFvgGqb17FeFjbmHvId9Q8rghFAuJ76AaCAUI+cllXe5N3tcpNr0+5RiVEF4yP8
         QG7w==
X-Gm-Message-State: AJcUukcT9dhxZ4+dQi9f+ZON+gxBWyCYpOjbjbubUzXq+N0u6x2Fc4c+
        oWF9J2Qz74KV7O2naTEK4CZWuQ==
X-Google-Smtp-Source: ALg8bN6KBnV3n1o5ppsl2ojdDEwtyJr1lOgRbHrko/p8Q9DeB44tolc2B0eaCxQlXVs708zk8PTyiA==
X-Received: by 2002:adf:9382:: with SMTP id 2mr8575238wrp.269.1547118861219;
        Thu, 10 Jan 2019 03:14:21 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id p5sm10911336wmh.16.2019.01.10.03.14.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jan 2019 03:14:20 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76: use proper name for __MT76x02_H macro
Date:   Thu, 10 Jan 2019 12:14:04 +0100
Message-Id: <500bfffcf550ed5835ccb93ad702d0ecafdaa0e3.1547118586.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1547118586.git.lorenzo.bianconi@redhat.com>
References: <cover.1547118586.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use proper name for __MT76x02_H macro in mt76x02.h

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index f594e8c82500..d8bd0509a790 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -15,8 +15,8 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef __MT76X02_UTIL_H
-#define __MT76X02_UTIL_H
+#ifndef __MT76x02_H
+#define __MT76x02_H
 
 #include <linux/kfifo.h>
 
@@ -238,4 +238,4 @@ mt76x02_rx_get_sta_wcid(struct mt76x02_sta *sta, bool unicast)
 		return &sta->vif->group_wcid;
 }
 
-#endif
+#endif /* __MT76x02_H */
-- 
2.20.1

