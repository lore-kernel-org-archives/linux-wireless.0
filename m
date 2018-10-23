Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2285C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 07:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B867D20671
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 07:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q94wnO+x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B867D20671
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbeJWQGZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 12:06:25 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:50395 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbeJWQGY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 12:06:24 -0400
Received: by mail-wm1-f47.google.com with SMTP id i8-v6so654148wmg.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2018 00:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=zHOBHPteq6+XEwEpHAl5Qs6oAl0R0W8j0Ilcjf71cfI=;
        b=Q94wnO+x6sAVq0V5r9t5Zc2huSeh18ZWxbgeLtLcGUP8OKKoe0ephn/cXXUQYy69E/
         7zRIc9Xol/vngstiP2ClSrM7UKigB9sZB+sxSi6LNv36lk1UZRuusLMUNqh1luwsQzmy
         jIXzHHQTuc4Tlm+rZHWA8tyR2XfCvRwC4HJrpARqEbgibWgvPKoxLgbVo9nx0MUUF8bu
         yBAQfetDc1biQEDGQ3CqyKZB2mvVr4NHEb2W155cuW4VcoeuHtt5YnoOFoVNVktJ+aeX
         x6nGUa3T6dREm4yXpgH8r7pnfHZx8ZhSwYoN5TEfkEEGuiNZPo1se++UUektoff1FrJx
         FWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=zHOBHPteq6+XEwEpHAl5Qs6oAl0R0W8j0Ilcjf71cfI=;
        b=e8FKxMm+SBEmOQe+DMXZ/mlJRANKtvUQfWEhJs9g3y6AXvSgv2SQRdRwJBHmy1nmy7
         TYwAAWwBHJTlISmbLOsUbTKLua5wbGNYPHsT4IwVfu3pEPiEAktvm1unpYHDrTcffSqR
         FC2YFv9N1VnzJWi5c9tORwWkqic9NQ6sYCVOmcABKhkoRdm55vkBt2MPPiM41KSebeG7
         BahLvBjANd19DqskezbFFcbtzlAM6yg6fuDuKu7TqzDV8CoDBdy8LU7ByZIDhW1MprDI
         U7+6UQ/sInm2VpIwlAhZ7voKY5P7EBpW3tXm5r/iA/sezI2nZGGikE4e6AUmLy+PC2CQ
         epBw==
X-Gm-Message-State: ABuFfohiOGVJXM2VBTjCN/NPuJC2Lbe3JjBkc05PZwdV0NtHOimPFZ2n
        fmaTP4AYHgUNFJoxvd0cfbDXPUmP
X-Google-Smtp-Source: ACcGV62u5l1j9YLc0iyHUjyiBAhKmfPgBsUMoMWYp+N4h7WHOCga8wGk2mGv+FF/EXY6+E4LaQTQ2Q==
X-Received: by 2002:a1c:1314:: with SMTP id 20-v6mr19908159wmt.132.1540280651532;
        Tue, 23 Oct 2018 00:44:11 -0700 (PDT)
Received: from manjaro ([37.238.236.76])
        by smtp.gmail.com with ESMTPSA id w4-v6sm760139wra.83.2018.10.23.00.44.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Oct 2018 00:44:11 -0700 (PDT)
Date:   Tue, 23 Oct 2018 10:44:04 +0300
From:   Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <aspriel@gmail.com>
Subject: mac80211 keeps trying to start ampdu session??
Message-ID: <20181023104404.795619aa@manjaro>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I am trying to debug brcmsmac wireless driver for spamming the log with
the message:
[...] START: tid 2 is not agg'able
for it does not support AMPDU aggreggation for TID 2.

And after quick tracing, I found that mac80211 keeps trying to start
AMPDU session for the _same TID and STA_ despite that the driver returns
non-zero code via its ampdu_action callback and that non-zero return
codes are recognized as the "HW unavailable" for such session
(agg-tx.c:ieee80211_tx_ba_session_handle_start)

So, Is that an expected behaviour from mac80211 or not??

Regards,
Ali MJ
