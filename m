Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F704C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 14:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F5621547
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 14:46:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33F5621547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbeI0VEm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:04:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37683 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeI0VEm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:04:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id y26-v6so5656653wma.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 07:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Pv6QNAIoqlqXwDADPSlGfB0rfoLmf/LXICZyzGXfI/w=;
        b=EjBY/ZZvFzzajpDNSAOhdqIRjDe2IQcaUXK9VQBA152NItO9h/eHr5kTkTsRViKA6W
         G0Repg1mAcMvNRRIwUQFjMC/tlU+oEIIhWF9T+Xp1Rl7XCo7Ds21IP8xpE97VTbcS7Nl
         EjDduziuPnbEy14qJ0n6cf1/Lgxq0hS5OOBU6+n9t20mJHabBVCUfQUy/aqzDIpaRPUx
         BFaf//qWpZcffTtO+eKZ693eoGEeE93kNaK1rfHNADLCMyGx7i2KhWdV4W3juszVipG7
         Ar7BfLYYfomEaH3hKFNOn5csgE2NBYk0CfHRYWdsmR2/mnm5ww+OBWVuuhf6/iFeZdzj
         2tKg==
X-Gm-Message-State: ABuFfojcTrerFyisnUiZ/b4FUou8Z1mSOQ4TKtlJicqel3oJA697rFyj
        kd9F6/weB8/F4MnU9IcnnZbqTeAhQVU=
X-Google-Smtp-Source: ACcGV635bc/y2U4aruSRHoFXuvMYzVEChQoCB1kMnK2naEqWCwKquz6i7oRciLSUnKLgqyE7Cu1QoQ==
X-Received: by 2002:a1c:ed1a:: with SMTP id l26-v6mr8358519wmh.61.1538059565086;
        Thu, 27 Sep 2018 07:46:05 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id p64-v6sm2897901wrc.97.2018.09.27.07.46.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 07:46:04 -0700 (PDT)
Date:   Thu, 27 Sep 2018 16:46:02 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 25/26] mt76: move eeprom_load routines in mt76x02_eeprom.c
Message-ID: <20180927144601.GA12949@localhost.localdomain>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <d2fdb4a39ed2b274c2661ce6f24c0e5851f30885.1538036134.git.lorenzo.bianconi@redhat.com>
 <6fa2f3a2-b6f7-be6c-48c9-133ac0b90117@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fa2f3a2-b6f7-be6c-48c9-133ac0b90117@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On 2018-09-27 11:01, Lorenzo Bianconi wrote:
> > Move mt76x02_eeprom_load, mt76x02_check_eeprom,
> > mt76x02_apply_cal_free_data and mt76x02_has_cal_free_data
> > in mt76x02-lib module since they will be used to load
> > mt76x0e eeprom data
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> This patch should be dropped. Almost all of the code is inherently 76x2
> specific and does not belong into common 76x02 code.

reviewing the code I think we can merge 25/26 and 26/26. Will do in v2

Regards,
Lorenzo

> 
> - Felix
