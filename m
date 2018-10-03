Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FB2C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 16:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 542402082A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 16:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c/NAjTsR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 542402082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbeJCXNx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 19:13:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37630 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbeJCXNx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 19:13:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id u12-v6so6809862wrr.4
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 09:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zPzzVPC/fkempvCD0lfC9gKlVcfugyjtQ6oUh52pSIM=;
        b=c/NAjTsRiNxrlJYoBHab8IIQ10uqOQKB6zU3JAKfgiUjwAfgeaN/yedHNPwQ1cFXp6
         FGaFvCvXjPCBUA5OOgMnxEop1Y2dTWBUzmywvH1mJQyFSHHfJBYcYz+EEyI6PXF0uEOn
         S/i1kxrBigfqE/hCtLwJQ0qKDO58rT3i+Aa1/yisAcAsPBxtA6KACqn/oUXDCgoIV36y
         /GRuQjlqE6Q7uJAiVmkKHj1voTPj5nbhtrRLBCyKfF8/WLIMaOLQ4531kpQhNI5lAc4l
         OKrWquJO/HwQUYPJM5iJzjH2BHvE5On+x5ugjj86/O57BU/DEZ/DzBh0Qk9sBHxbmYp2
         CYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zPzzVPC/fkempvCD0lfC9gKlVcfugyjtQ6oUh52pSIM=;
        b=Uh7eJfRjgsMvKXBadFunEmNUsZZjVHe8GuRT+gZQmuTanStzRSs+kBr2BMjI8SH+4u
         RMOdLa5APTzp3CT+g4wVunxfEp7E01DbWN1qRCUygn3i3Jg4vwV9IK3uwKWppRJj66LO
         0fgEIjDOVJbXZoETRN9DxG9YSDAMbgLUlpJkapTdbTy7IQxDenyzPu+1gw4JvBhjk6/k
         xn0iXbUl6LT08RserZ6sS6MvorEVDg8SIgzpvzTIhopFByVyoLm3mHRDqpwTyW28j2uA
         doyiA+LWDlOVr7rG1SZAxu8jU9HJbu1VcT4Hxtm6PRTzvdoZZLeFTVHvlDbLOlD3N4pd
         gxOA==
X-Gm-Message-State: ABuFfoiLWhz6sv5muuyAM2e+E6+rlOeySC5fysno+3ILO1PaTfEipCAo
        Zmor/mi8Uj0hcAr+6zw14WvdrpD4
X-Google-Smtp-Source: ACcGV62zsI/aH0UtJjS3PuIghzWjUjLvSctIQpawN4iYrxy0rngHTUYD78q6KczjkmB9gWnUy2Oj1w==
X-Received: by 2002:adf:b30f:: with SMTP id j15-v6mr1942593wrd.207.1538583886189;
        Wed, 03 Oct 2018 09:24:46 -0700 (PDT)
Received: from localhost.localdomain ([37.238.236.10])
        by smtp.gmail.com with ESMTPSA id 185-v6sm2609392wmy.38.2018.10.03.09.24.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 09:24:45 -0700 (PDT)
From:   Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Subject: [PATCH v4] brcmsmac: AP mode: update beacon when TIM changes
Date:   Wed,  3 Oct 2018 19:21:39 +0300
Message-Id: <20181003162139.17014-1-alimjalnasrawy@gmail.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
References: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Beacons are not updated to reflect TIM changes. This is not compliant with
power-saving client stations as the beacons do not have valid TIM and can
cause the network to stall at random occasions and to have highly variable
latencies.
Fix it by updating beacon templates on mac80211 set_tim callback.

Addresses an issue described in:
https://marc.info/?i=20180911163534.21312d08%20()%20manjaro

Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
---

v3 -> v4:
	-set vif to NULL on remove_interface callback to prevent dangling
pointers.
	-access vif from within &wl->lock context only.
	-perform null pointer check before passing vif to
ieee80211_beacon_get_tim.

v2 -> v3:
	- remove tabs from blank lines
	- extend the commit message to answer "Why"

v1 -> v2:
	-remove FIXME comment
	-remove blank line before 'vif' member declaration

 .../broadcom/brcm80211/brcmsmac/mac80211_if.c | 26 +++++++++++++++++++
 .../broadcom/brcm80211/brcmsmac/main.h        |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ddfdfe1..257968f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -502,6 +502,7 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_bh(&wl->lock);
+	wl->wlc->vif = vif;
 	wl->mute_tx = false;
 	brcms_c_mute(wl->wlc, false);
 	if (vif->type == NL80211_IFTYPE_STATION)
@@ -519,6 +520,11 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 static void
 brcms_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
+	struct brcms_info *wl = hw->priv;
+
+	spin_lock_bh(&wl->lock);
+	wl->wlc->vif = NULL;
+	spin_unlock_bh(&wl->lock);
 }
 
 static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
@@ -937,6 +943,25 @@ static void brcms_ops_set_tsf(struct ieee80211_hw *hw,
 	spin_unlock_bh(&wl->lock);
 }
 
+static int brcms_ops_beacon_set_tim(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta, bool set)
+{
+	struct brcms_info *wl = hw->priv;
+	struct sk_buff *beacon = NULL;
+	u16 tim_offset = 0;
+
+	spin_lock_bh(&wl->lock);
+	if (wl->wlc->vif)
+		beacon = ieee80211_beacon_get_tim(hw, wl->wlc->vif,
+						  &tim_offset, NULL);
+	if (beacon)
+		brcms_c_set_new_beacon(wl->wlc, beacon, tim_offset,
+				       wl->wlc->vif->bss_conf.dtim_period);
+	spin_unlock_bh(&wl->lock);
+
+	return 0;
+}
+
 static const struct ieee80211_ops brcms_ops = {
 	.tx = brcms_ops_tx,
 	.start = brcms_ops_start,
@@ -955,6 +980,7 @@ static const struct ieee80211_ops brcms_ops = {
 	.flush = brcms_ops_flush,
 	.get_tsf = brcms_ops_get_tsf,
 	.set_tsf = brcms_ops_set_tsf,
+	.set_tim = brcms_ops_beacon_set_tim,
 };
 
 void brcms_dpc(unsigned long data)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
index c4d135c..9f76b88 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
@@ -563,6 +563,7 @@ struct brcms_c_info {
 
 	struct wiphy *wiphy;
 	struct scb pri_scb;
+	struct ieee80211_vif *vif;
 
 	struct sk_buff *beacon;
 	u16 beacon_tim_offset;
-- 
2.18.0

