Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE4AC46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 12:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61AE120652
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 12:23:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s6BL1yVs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61AE120652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbeJWUqc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 16:46:32 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:37033 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbeJWUqc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 16:46:32 -0400
Received: by mail-wm1-f46.google.com with SMTP id x19-v6so1564802wmc.2
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2018 05:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0y2nR0Rd3KLGSZjMBFEyVUh3Eu8JlhuJx6HHaXttNUM=;
        b=s6BL1yVsWuHhLXVoqwsnwHidJxzQLjHomwoK4Q9KF1NHQdizJZTvloaknEHDf6Rnio
         3mT5Mbbu8Cu53qAwuKMpDJ21Sv6IL1ha6L9MS/SlfSUCknbXUFos0bAG3N8w9Imgjz6j
         MQXRmo9Jw5KXNW6/K/dlL+SiQ5VeMVEgCbEXKV+j5uA+sHkMTb2nXT5mNqSUb7lE5nRG
         A6xum3lbrkSnMojlauggkgHeYh34gcrp4e2AczpMaOibEh9ETOz/zrer+yeXeQl9FdqB
         YxYYv3Q8d/pW+dzeLLB+ARukfc52ruytaInCF8Sbn0N0Sf7/RAjnWsFQ1asLE/1e3hBc
         uDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0y2nR0Rd3KLGSZjMBFEyVUh3Eu8JlhuJx6HHaXttNUM=;
        b=tgF4oXv4+4o29t133vM84UtHzrPvDffpKuybquTcRFdQW4HaXodEj9Whi6K1BLhBFQ
         gtLNO5BRMIThgfEMxBzvXK4OVMOA6ERRxlwmPD3dc1wiYL3Bf1Q8ybI96kHwbRb/n9jw
         1zDnUMftosXJLY8WA9zlXe8bt7PWDjiNR1sRadqcMKjRqLokJrHUMwaSIWSAW7F3o82w
         GZPWMKj21e4jVPIiZJz4lpDfbw9GpFhsw6aXifp0C0cb5EGqCQl54yBVy7vZwXtk7EuV
         gzKZRALjzFa2sPd/PS9t9cqEZJJ6W5SPjpECMMrTA6TUIpcWKO/Eh6VIqr5Yah3wwsAq
         2osQ==
X-Gm-Message-State: ABuFfoh0UxIEyL/mpSVBsKjAIC3wHq7vC/puQkOmmF+zp3AsbFCCCZd+
        3P/vYGvfoZ1MhNbY3xHY0og=
X-Google-Smtp-Source: ACcGV63dRjtK08BBlBdbPTUWu43hjRz5QSWr+0qhrEzLf1dbcRDec1sOnktNZie/q1ynXEu7tUEZnA==
X-Received: by 2002:a1c:2904:: with SMTP id p4-v6mr2595203wmp.58.1540297395233;
        Tue, 23 Oct 2018 05:23:15 -0700 (PDT)
Received: from manjaro ([37.238.236.25])
        by smtp.gmail.com with ESMTPSA id b5-v6sm1442632wrr.94.2018.10.23.05.23.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Oct 2018 05:23:14 -0700 (PDT)
Date:   Tue, 23 Oct 2018 15:22:57 +0300
From:   Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <aspriel@gmail.com>
Subject: Re: mac80211 keeps trying to start ampdu session??
Message-ID: <20181023151312.65df98c4@manjaro>
In-Reply-To: <0ead002730ad2902d87c77cc3abeb9c21c4a0930.camel@sipsolutions.net>
References: <20181023104404.795619aa@manjaro>
        <0ead002730ad2902d87c77cc3abeb9c21c4a0930.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 23 Oct 2018 10:18:54 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2018-10-23 at 10:44 +0300, Ali MJ Al-Nasrawy wrote:
> > Hi,
> > 
> > I am trying to debug brcmsmac wireless driver for spamming the log
> > with the message:
> > [...] START: tid 2 is not agg'able
> > for it does not support AMPDU aggreggation for TID 2.
> > 
> > And after quick tracing, I found that mac80211 keeps trying to start
> > AMPDU session for the _same TID and STA_ despite that the driver
> > returns non-zero code via its ampdu_action callback and that
> > non-zero return codes are recognized as the "HW unavailable" for
> > such session (agg-tx.c:ieee80211_tx_ba_session_handle_start)
> > 
> > So, Is that an expected behaviour from mac80211 or not??  
> 
> This depends on the rate control algorithm, it triggers this.

In this case, it is minstrel_ht.

> 
> I think - perhaps depending on the return value - mac80211 *does* give
> up eventually, but not really sure.

The return value is handled only in
agg-tx.c:ieee80211_tx_ba_session_handle_start and it doesn't pass it
down or recognize difference between non-zero return values.

And I don't think that it gives up retrying: I already have 800MB of
compressed logs for the last four days only full of this message and
additionally I ran a simple test for the last hour and found that it
tries to start ampdu session for every frame to be sent with that TID!

> Perhaps just remove the message?

OK, I report this just in case of it being unintended behavior with
probably a negative performance impact.
