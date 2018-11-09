Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BA6C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5527820883
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5527820883
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbeKIVNw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:13:52 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52925 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727596AbeKIVNw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:13:52 -0500
Received: by mail-wm1-f68.google.com with SMTP id r11-v6so1697488wmb.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 03:33:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h79B7TeEU5yYrlUwEizS71Sb2NBurnyvSuOgqV8hsQc=;
        b=aIryFV1AOYnZiL6EOD3k/JRlCeQhNJ5lU1iSPw1vDEF0k4P/6w6xtunFp0JXTU2hBH
         gnBUUdjQq+IYFDiHFtop//nuYlkAotlwEk7CM3Klw6m+OjNbDqFiZClqsPfccaO3400y
         XLyb5p34isdrvcN3dCsElro6+91Vg4Z5DvAGuICs5umY3HWcx0Ivd5moW6vW3Acv3Yyy
         l6B1zZwAlocT8CUrKG65+P/1Kdf6QPeDwYCl3zMZNbowZjjBdUSDiM3fCRtrvUKxVX//
         tQ49Axu1mLOGxDV6C5JDMc+VqTHDYn/vXLuN2FBiH/gh7CENq/0enV45mn/ZIhlGmpMt
         +4sg==
X-Gm-Message-State: AGRZ1gK7rP56EcUCSByc+r06TzgO29jlLYGMvpIQ0vPlj2iHgfpfi+n9
        zgKIWK7YwxrUFpNCDKQeyQiGB3zupWg=
X-Google-Smtp-Source: AJdET5eJL8mtEdb8bZPQ6nhk1CbFoGMoodstnUyRSpr72UeAQ1ehc495F+KnYY+LEMuPOFS+G4blFw==
X-Received: by 2002:a1c:8414:: with SMTP id g20-v6mr4384160wmd.123.1541763217375;
        Fri, 09 Nov 2018 03:33:37 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id m9-v6sm7714383wrn.36.2018.11.09.03.33.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 03:33:36 -0800 (PST)
Date:   Fri, 9 Nov 2018 12:33:32 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] mt76x02: minor beaconing init changes
Message-ID: <20181109113331.GG4174@localhost.localdomain>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-5-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541758814-2046-5-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Disable BEACON timer during init and remove interrupt registers
> initalization form generic conde since they are PCIe specific.
> 

Since the timer is actually disabled (MT_INT_TIMER_EN set to 0) and
we just set the timer timeout here, does it worth to copy/paste
the same code?

Regards,
Lorenzo

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      |  7 +++++++
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c    | 11 ++++-------
>  drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c |  8 ++++++++
>  3 files changed, 19 insertions(+), 7 deletions(-)
> 
