Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79180C677D4
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3799920841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:30:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3799920841
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbeJHUlp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 16:41:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51135 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbeJHUlo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 16:41:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id i8-v6so2066473wmg.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 06:29:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3Hclm4L2yfr8bYeTyyhLuiAF2f82PEGbrIFWfZ1Nre0=;
        b=TDewRZuhK24qYQExWnZq4IeIWi282kb8U5NE/vWUbBsoNsYSfZAN1SG3PAj8z/VhQu
         wb7XP5BATlhdUQCoPTkWphTZVoTngjOwr5gI3WXZk45B6wl8PVKF9X1b3xtFrX9pTVQK
         m/6KUWzagNTAy8ZMhWPSVHxovSsyihwtWUQcUwFZClrlhv1908gKNMLvIUapVTjAXJ7l
         hapyXOlP1LLRcEspY7jlXeKm8WAEDDG+jKMEE3paTa6vN1J3kwJBGQt6n+ODJWBYLKM1
         hfFcfPvCHc5AZvolP6v1xBUtUSNqZHI5Xe8xc9SV5uV8/TzxuqHpIu+fPmXVt7UXsloU
         2Dfg==
X-Gm-Message-State: ABuFfoih0GGWKWZ4N0MTmS/dwDPY6J+kt3aGO+m3mWytBNJ8o2yDT+jx
        5GESxE3IQMbRgsOxCTkDlz7rjQ==
X-Google-Smtp-Source: ACcGV6064NJFKhELNiBZ10qsdX8TjJhM4mERGWUjwesdw3iDPO3YG989tPWuc8GEm05xyHOrWp4qYQ==
X-Received: by 2002:a1c:e4c6:: with SMTP id b189-v6mr15379357wmh.114.1539005398577;
        Mon, 08 Oct 2018 06:29:58 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 82-v6sm12514277wms.17.2018.10.08.06.29.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 06:29:58 -0700 (PDT)
Date:   Mon, 8 Oct 2018 15:29:55 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mt76x0: pci: fix set external PA I/O current
Message-ID: <20181008132954.GB15297@localhost.localdomain>
References: <1539004909-195005-1-git-send-email-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539004909-195005-1-git-send-email-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/mediatek/mt76/mt76x0/pci.c: In function 'mt76x0e_register_device':
> drivers/net/wireless/mediatek/mt76/mt76x0/pci.c:107:8: warning:
>  variable 'data' set but not used [-Wunused-but-set-variable]
> 
> It seems correct value to write is 'data'
> 
> Fixes: 2b2cb40bcd7d ("mt76x0: pci: add hw initialization at bootstrap")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
