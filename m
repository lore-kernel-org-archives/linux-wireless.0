Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E58ECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 09:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 871D22151D
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 09:06:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 871D22151D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbeJQRBZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 13:01:25 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:55677 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbeJQRBY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 13:01:24 -0400
Received: by mail-wm1-f41.google.com with SMTP id 206-v6so1183761wmb.5
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2018 02:06:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RngQGA6pMAemF0gyvyncxUp8iXp1JWLRDsA2jdWcyIU=;
        b=UV0u04f3d68ZJVqjdepDcX8b05MTo3Fs4R6RpRld5bQFVEz5DPKpv04WFf6/2i3uzB
         ZGQfaILQhaBZF/rFo8qOJYgHrfHWqxQ3+AEtgfv7Mk3j5ugvXqHxDTiCNz+PLGA8X46D
         UXq+I/G3CfrkgLP8FjMTLGoCabPCAh8P9KGVweLS2L063MZ6KMkhoO85aegWOk9/lZqq
         vB5vO5dwRWFokxjm5Ym1w/lN1nC4GYTupP8vPzoYu1LPG0DeXWYVER/KDXiAqFjNgekp
         +6QZ+w8VO78Mq9/hi9ARhVbUw73gpPIENaLeRVmKp+mKDBVX91xRfBbqdXCTx9r0gzMD
         uJ1Q==
X-Gm-Message-State: ABuFfohclHYJj9bW0pu9jdzA1UNgCMVm08Bd+9OiRhQBy0wIzHjIGSCz
        aZYCTXleRoRhWjVDkBis2rm9Cg==
X-Google-Smtp-Source: ACcGV60cWjXvX3I0G2XuEpf6kEF8q6pbKAxtx5EjsWGhRl7vY/7yM7NUSPhF/y/VUa0SVOrBfLh9Eg==
X-Received: by 2002:a1c:adce:: with SMTP id w197-v6mr1992286wme.11.1539767199071;
        Wed, 17 Oct 2018 02:06:39 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id z185-v6sm2135523wmz.47.2018.10.17.02.06.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Oct 2018 02:06:38 -0700 (PDT)
Date:   Wed, 17 Oct 2018 11:06:36 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/9] mt76x0: pci: add pre_tbtt_tasklet support
Message-ID: <20181017090634.GA13977@localhost.localdomain>
References: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
 <a9a57f93166d917d7682b4a201351f526155cd1e.1539723134.git.lorenzo.bianconi@redhat.com>
 <20181017081131.GB2256@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017081131.GB2256@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Tue, Oct 16, 2018 at 11:23:26PM +0200, Lorenzo Bianconi wrote:
> > Enable/disable pre_tbtt_tasklet in mt76x0 driver in order
> > to add AP support
> 
> Is there some USB limitation that disallow tho do this for USB
> as well? Or perhaps this is easer for now do this for PCI devices
> and add AP support for USB later? But perhaps, since you adding
> support for AP you could do this for both buses.

AFAIK usb devices do not have TBTT interrupts so I think we can
use a timer to load beacon frames into the device. Anyway I guess
pre_tbtt_tasklet tasklet is something mmio specific.

Regards,
Lorenzo

> 
> Thanks
> Stanislaw 
