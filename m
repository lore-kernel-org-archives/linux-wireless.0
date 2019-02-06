Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C15C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 15:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B6C2175B
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 15:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfBFPG1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:06:27 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38994 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729826AbfBFPG1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 10:06:27 -0500
Received: by mail-wr1-f66.google.com with SMTP id t27so7923347wra.6
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2019 07:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o+LNNIfCUDk17VPGthJx3P5X++AW1YC6uXDb0Colq+g=;
        b=fAWcVrG/EGxTUX5HvNvNd1/bgEPAWYdwVD+VfRJnH9AvQBFTDwK7bc5B5pAtYRsgQM
         NyfDoqoF6EXKi8y+8uXI27O+zkgTIDD32Ohzi6H7GF6JgRm3RRul3Oh3nYHAqNCa2tLO
         5+GCUaU/+ctOse5ymnMH7t629xij/4FM1IfZvLtUi4ECc48iP9Mqd3dfZ18HNtDBpJ1P
         LoUvTTXEc1XNXlJKJ5vPKz1lCAzRqHF7bd3OoVhWuRe2GXTP5FTf4zhUDzkI+/LydAua
         krmMeFbGOIRtlBOc2MW4pozYhfdJf80h/0TN1/GIOTyfF71hHdw18+ZTDGO7ettwQCnB
         UgyA==
X-Gm-Message-State: AHQUAuY3aOGVzor+8jHmtf8QOYXlZ3m1f9OSCkfxJl2mWOswqrGDW/n/
        vLAOWRJSt1gLLslzUhbY+tHWfw==
X-Google-Smtp-Source: AHgI3IYiu13fAKaUbjhqbtbjF/7H9SrnmGd4l3DG0sdsTWmIrrb3Y2w6/D2t3SspKVOaLs3l43ET3w==
X-Received: by 2002:adf:e5c4:: with SMTP id a4mr7900608wrn.157.1549465585305;
        Wed, 06 Feb 2019 07:06:25 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x22sm6583683wmj.40.2019.02.06.07.06.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Feb 2019 07:06:24 -0800 (PST)
Date:   Wed, 6 Feb 2019 16:06:22 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 5.0 v2] mt76x0u: fix suspend/resume
Message-ID: <20190206150621.GB15380@localhost.localdomain>
References: <1549463656-22219-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549463656-22219-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> We need to reset MCU and do other initializations on resume otherwise
> MT7610U device will fail to initialize, what cause system hung due to
> USB requests timeouts.
> 
> Patch fixes 4.19 -> 4.20 regression.
> 
> Cc: stable@vger.kernel.org # 4.20+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> v2: minor coding style changes
> 

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
