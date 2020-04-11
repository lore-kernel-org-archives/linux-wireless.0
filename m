Return-Path: <SRS0=JTkr=53=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC48C2BBC7
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 00:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54AEE21744
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 00:20:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y4P580LG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgDKAUT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 10 Apr 2020 20:20:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37800 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgDKAUR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Apr 2020 20:20:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id z6so4385296wml.2;
        Fri, 10 Apr 2020 17:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bnsdQ5U1vczReUdSDEyFDyP+NZXKnWhzI4gNW+WqNi8=;
        b=Y4P580LG8AOE73qKmST1Ddlv62Xh2B/xEmvDDI7TnWMBIYAgb0We1EJiiTitFQ7XuJ
         iOnsUBn0VCt4JcfU84GiB7eSPyTdXOLNYo+DEZvom+0aRjTkhl4ofekKMOk6b8/e8LOU
         3Syu2KELG0PNf5gGTqPoRmqaMYTka12nijp+jwg8oRyGxnrgxSRE7pngHjzfDUUzLao7
         nDTj73suFFI+YSHA2HOd5SItkBr9miR3s9NIaItMOPBwJAPjmuC8E/cpKiyxDLqev7JT
         45yoPK7F8KLtMGSUNDDppOSOEKe7raEHcq2ZG//QO7VpmCudSZUXqouMkH5QCr3fB0hB
         sZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bnsdQ5U1vczReUdSDEyFDyP+NZXKnWhzI4gNW+WqNi8=;
        b=POtOzAC8EXLPD+ihwvx1uMl9J6muC1AIMnpzrOjkI/LNMZD/jqWnZ37ketDkif7bdP
         rGrhs9SokNkFWikIfZrTP0RcD681Iko2cUG6x4erQe19tGm0LGH+SFnpF+gAEBmIgRXw
         ynbAiNiJ99ERtAO19wcKl0yLky9+VlHzQAnXKDY+iLqYy6ANIvzXuLaWxsybVWV5Pnxy
         UbIoCwhMYmtOUCBiYhk4bXnBamfOYp6/R5cbdBLLa+UbCO57IOjgSAnDsr1M9oiFi7Ft
         egoxNHSVbqXrZcDTQC6GQTMbKevaVNRftkB5NYGyY+YdgDSPYvlZpHRF+nYBLs0d+57H
         wCjA==
X-Gm-Message-State: AGi0PuZ1AgcE+jgQ7UEMt8hGNcrqBrvr1wFXBETDrDFuNS92krDPuC/K
        KZZQv/TnqgC4VcMtW8gyQUHiCCPOu5g9
X-Google-Smtp-Source: APiQypIGyDnDKW2FoYn138vCPA/Jpjjbp+1H5MENkWO7oxvo7KZDFCmi+fR4jGleSf1o3W6FbciRlg==
X-Received: by 2002:a1c:f409:: with SMTP id z9mr7850215wma.51.1586564414006;
        Fri, 10 Apr 2020 17:20:14 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-153.as13285.net. [2.102.14.153])
        by smtp.gmail.com with ESMTPSA id b191sm5091594wmd.39.2020.04.10.17.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 17:20:13 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list@cypress.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH 4/9] mac80211: Add missing annotation for brcms_rfkill_set_hw_state()
Date:   Sat, 11 Apr 2020 01:19:28 +0100
Message-Id: <20200411001933.10072-5-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200411001933.10072-1-jbi.octave@gmail.com>
References: <0/9>
 <20200411001933.10072-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sparse reports a warning at brcms_rfkill_set_hw_state()

warning: context imbalance in brcms_rfkill_set_hw_state()
	- unexpected unlock
The root cause is the missing annotation at brcms_rfkill_set_hw_state()
Add the missing __must_hold(&wl->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index 8e8b685cfe09..c3dbeacea6ca 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1717,6 +1717,7 @@ int brcms_check_firmwares(struct brcms_info *wl)
  * precondition: perimeter lock has been acquired
  */
 bool brcms_rfkill_set_hw_state(struct brcms_info *wl)
+	__must_hold(&wl->lock)
 {
 	bool blocked = brcms_c_check_radio_disabled(wl->wlc);
 
-- 
2.24.1

