Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4A8C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 14:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5877E2064E
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 14:15:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5877E2064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbeI1UjZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 16:39:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49158 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeI1UjY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 16:39:24 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1g5tYB-0002U5-Ss
        for linux-wireless@vger.kernel.org; Fri, 28 Sep 2018 14:15:23 +0000
Received: by mail-it1-f199.google.com with SMTP id w68-v6so2665996ith.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 07:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hX6amrLRVvY/emHXiOefZ9clw6veaAT8gz2hk85NfXU=;
        b=GF8CEr+HimcMdRMwMXSdQHY5T3B9I+9n9ueuFOML64mUD/CA/lVtxQJxCzwz0hZHMH
         pNjHnrJ/6oRgvaPbgrkrlEhQ3quAf7psC5DHHvHzWrUwzbBxIw6/usKfEP7646P5CJPx
         D+JMYnadQz1b6MQnYy/dscDQ2WRCXLpvxb7oLnkuO+/FesM+IJWmOKUQxtM4iwHxgmd/
         KjuH1bPJQCDH3xvlIust0LIpR4VykclsfaJKdsD08w/BaVY42Ys4IybxV0i2sCdxcsYL
         gWKokY6C9ihGhDkW08EtDitqfSMjUVry4YRfj08BNH2dqsHD6k6Hnt6AwdXAz005LkEX
         8F+A==
X-Gm-Message-State: ABuFfoijA2eUvFZThkGY50bDPkuwIv+tXpR395qzVxffeG3tO2HFIlhI
        alJLWqRzxh0X/5hkPU1Ntkq+UE4R0JMoUXQfpsuENkrOrD1JyhoTzy3UuSTcdH4L0D1AkczcAfF
        6q40BRP7yOkJ/FJJWWPeiWJFxQBkWC8MjrEdI9wt+YGdH
X-Received: by 2002:a02:308f:: with SMTP id q137-v6mr13221868jaq.18.1538144122756;
        Fri, 28 Sep 2018 07:15:22 -0700 (PDT)
X-Google-Smtp-Source: ACcGV61tyXpvZzMySRsekff1wb4MnfRonlk0H5qOFfMzWOoNiBy0/bpVsqoc1Y+Q6ZHQa0xSrhTzLQ==
X-Received: by 2002:a02:308f:: with SMTP id q137-v6mr13221837jaq.18.1538144122366;
        Fri, 28 Sep 2018 07:15:22 -0700 (PDT)
Received: from localhost ([2605:a601:ac7:2a20:7891:1d10:21bb:42d5])
        by smtp.gmail.com with ESMTPSA id w193-v6sm1102556ita.11.2018.09.28.07.15.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 07:15:21 -0700 (PDT)
Date:   Fri, 28 Sep 2018 09:15:20 -0500
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc:     linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
        Simon Wunderlich <simon.wunderlich@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>
Subject: Re: [PATCH 1/2] wireless-regdb: Sync FR with ETSI EN 301 893 V2.1.1
 (2017-05)
Message-ID: <20180928141520.GS16752@ubuntu-xps13>
References: <20180917074212.6739-1-sven.eckelmann@openmesh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917074212.6739-1-sven.eckelmann@openmesh.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Sep 17, 2018 at 09:42:11AM +0200, Sven Eckelmann wrote:
> The documents
> https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.01.01_60/en_301893v020101p.pdf
> and
> https://www.anfr.fr/fileadmin/mediatheque/documents/controle/20171127ANFR_-_ficheRLAN_5GHz.pdf
> show that the limits for the 5GHz bands are out of date:
> 
> * frequencies don't match the official limits
> * 5150 - 5350 MHz is not for outdoor usage
> * 5150 - 5250 MHz only usage is allowed to use up to 23 dBm (200 mW) even
>   without TPC
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>

Applied both patches, thanks!

Seth
