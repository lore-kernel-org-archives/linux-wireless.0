Return-Path: <SRS0=Otg8=OG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B89CC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B9502086B
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B9502086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbeK1JUv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 04:20:51 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52378 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeK1JUu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 04:20:50 -0500
Received: by mail-wm1-f66.google.com with SMTP id r11-v6so595374wmb.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2018 14:21:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5CUm4jo49q+OhNI4lrqwZgcdY8NIHMuZwO/W934glvY=;
        b=QDpRRuvfidfDKuUSitns4m+x143QWiuBguEW53XCu214Mi3KFdbd3vxb+OKDcU2gb8
         kJac78rR1QV8UOpIdUerQTeWL+9XBMN9BBGuwiSkmLdrSeClvk9TVKVNE3CG8WGXsgmt
         L10qGoTngYQhW2NzEL99jubW7a6pUX4PEPheEfB2gquoGwWewvXXOX/E/BYoqGUnGCve
         4oYcC4LadxqttzedRk+Za20LhhtvgKRov4QrAgEEQ6h9OKv0yZW61xoN6+PA8A31IdGl
         VmhbDmal/Q9ZuIrGcUrPQvUGGZNjtlwG9xS7HReH4snGHJNPt95CFPsZtE3z9lsyLVjm
         5s8g==
X-Gm-Message-State: AA+aEWaa4J3A1W2yZtHngsa0pRy0+bMsfn0CbF84/vp0ddsmPsTJ2st8
        hx25sFNwBuiBP1ds7K9KFiL6uaETH58=
X-Google-Smtp-Source: AFSGD/WG2YD08cWZFjxrSJFhaOrHRWLPpdcqw92ui2ErMauWHiFWD3zGY0syaQEm4FUk+MZF1FP4XQ==
X-Received: by 2002:a1c:414:: with SMTP id 20mr544585wme.67.1543357288096;
        Tue, 27 Nov 2018 14:21:28 -0800 (PST)
Received: from localhost.lan ([151.21.135.68])
        by smtp.gmail.com with ESMTPSA id 142sm866245wmw.27.2018.11.27.14.21.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 14:21:27 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name
Subject: [RFC 2/5] mac80211: introduce ieee80211_vif_to_netdev routine
Date:   Tue, 27 Nov 2018 23:21:09 +0100
Message-Id: <0db1977129e87685d66b2e9d6ddd821fe8d9fcf7.1543343124.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add ieee80211_vif_to_netdev utility routine to get the netdevice
pointer related to ieee80211_vif one even if the sdata has not been
inserted in the driver or running yet. ieee80211_vif_to_netdev
will be used by mt76 to properly configure xdp_rxq_info data
structure adding vif to the driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 include/net/mac80211.h |  2 ++
 net/mac80211/util.c    | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a91f1733ce43..f2784b36f2e2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1603,6 +1603,8 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  */
 struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif);
 
+struct net_device *ieee80211_vif_to_netdev(struct ieee80211_vif *vif);
+
 /**
  * enum ieee80211_key_flags - key flags
  *
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index bec424316ea4..a98293d71818 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -827,6 +827,18 @@ struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL_GPL(ieee80211_vif_to_wdev);
 
+struct net_device *ieee80211_vif_to_netdev(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!vif)
+		return NULL;
+
+	sdata = vif_to_sdata(vif);
+	return sdata->dev;
+}
+EXPORT_SYMBOL_GPL(ieee80211_vif_to_netdev);
+
 /*
  * Nothing should have been stuffed into the workqueue during
  * the suspend->resume cycle. Since we can't check each caller
-- 
2.19.1

