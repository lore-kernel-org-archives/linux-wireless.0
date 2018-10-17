Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A2EECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E392098A
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:47:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9E392098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbeJQTmc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 15:42:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33036 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbeJQTmc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 15:42:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id y140-v6so1294656wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2018 04:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GmHEFRJjj+4JJDC5mA+XlnM+XnURdfz6hoDVEef5oi0=;
        b=iHB8x6iKKI3nqw3axRzhV37p0c0fATHuoedk2kTq78lmwWH9KucpmVqMYuoesmExmy
         IkgaeLu6PoneB77d4j6T/4rD5CHs5egQoj1gTMhnTo7DVNmZupYLnuRTni2pfjQq3NqH
         h9yXK8DTxX9g/7BlwBIplib3ab4dQwj9BGaPfjYNkkFMPmF4m1/CzSIHsMvJxgVJeGgD
         mDFZKCLWTr9QGphTDPTPnZFjJQN6DUnY+PuyR2mIXsZ6uI1nwOUTeELtlLGhB8ocoBYx
         c1qEV4yotygMsombpg3QYWNf6su6UJvLJywSBqN3BdmcwbNLyrzPQn6yDFPj6J4nAXc0
         QVfw==
X-Gm-Message-State: ABuFfohzp15kaKjGTZ7fs0cjkDGAYYBVtSV+KO0o4D3yWyCNBaeoBFp9
        7+QSvThGYwcM4qH5T/sNVYls8A==
X-Google-Smtp-Source: ACcGV62Kf6tCCfDAlS9f7kC7N04u8Drmmjoy0VUpqVq2eM4BgRzWM2CSAJgEF8qByTUdUkdYZ79S1A==
X-Received: by 2002:a1c:13c4:: with SMTP id 187-v6mr2548611wmt.66.1539776830500;
        Wed, 17 Oct 2018 04:47:10 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v76-v6sm2091485wmd.32.2018.10.17.04.47.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Oct 2018 04:47:09 -0700 (PDT)
Date:   Wed, 17 Oct 2018 13:47:07 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: Re: [PATCH] mt76: clean up unused leftover EXPORT_SYMBOLs
Message-ID: <20181017114706.GB13977@localhost.localdomain>
References: <20181017111101.19685-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017111101.19685-1-nbd@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Make previously exported functions static where possible
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h         | 2 --
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 8 +-------
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  | 2 --
>  drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 1 -
>  drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 2 --
>  drivers/net/wireless/mediatek/mt76/usb.c          | 6 ++----
>  6 files changed, 3 insertions(+), 18 deletions(-)

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
