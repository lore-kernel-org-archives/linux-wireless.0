Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71220C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DE332084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:22:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DE332084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbeJAO7C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 10:59:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50623 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728806AbeJAO7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 10:59:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id s12-v6so7793235wmc.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 01:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z7ovNgCsfV+Y7NCHCiBb5/l701c1iDuz9tpl9J6XDac=;
        b=YNQoWtyjFVN+jmic1FSzBrdNyoaxkT7/KO1pcqAV4hAxbZb0CPTUtFgR6eNO2cekN7
         GK5xm+Ryg66NZv0NO9PVwh5GN1D0FAJyeeZ6gbETg0hqVSorcaGBInA1hAgrQ/C9pD0P
         x3tOisRlI6b/i63yFF+veLNvBvr1LgVft3Y6KcRDES5c3a+O3sgAtrf5AtgLM9Ghw99g
         tNfGkgfoCalhCQfoxR7sZpHNex3cXuZOacZzvUupNn2ejHLZzEVEA4lfuhJxR8ecOAoM
         er8R+RhLk+ZOOzsTNTcf35RGuUfqm167K47hLlBw3169KBjMTg4GzaLxfP48T0j17h6i
         Dqmw==
X-Gm-Message-State: ABuFfohPZ/RMyhx6GXQyiDtkRW1AgkFYuSlrQDK3kH6FVpHFk/5TCFRK
        9ba8XKOEiyU0D0OWeSEY7wvLwHVSZ6o=
X-Google-Smtp-Source: ACcGV605R6yVPqX3o1QGdP9y1h6EobUXpdL+dCh/WslQ3xVMPxgYUgpeSHglOFxkkTN8i1b+nIu1kA==
X-Received: by 2002:a1c:6308:: with SMTP id x8-v6mr7484444wmb.99.1538382147257;
        Mon, 01 Oct 2018 01:22:27 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c13-v6sm1160623wrm.50.2018.10.01.01.22.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 01:22:27 -0700 (PDT)
Date:   Mon, 1 Oct 2018 10:22:24 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: pci: add mt76x0e_cleanup routine
Message-ID: <20181001082224.GA3055@localhost.localdomain>
References: <20180929172641.32440-1-lorenzo.bianconi@redhat.com>
 <20181001054239.GA22206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001054239.GA22206@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Oct 01, Stanislaw Gruszka wrote:
> Hi
> 
> On Sat, Sep 29, 2018 at 07:26:41PM +0200, Lorenzo Bianconi wrote:
> > Add mt76x0e_cleanup routine to tidy up the device
> > during netdevice removal
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > +	mt76_wr(dev, MT_H2M_MAILBOX_CID, ~0);
> > +	mt76_wr(dev, MT_H2M_MAILBOX_STATUS, ~0);
> 
> I don't think this is needed. Those are legacy communication registers,
> most likely not used in new chips and stay in vendor driver, because
> it wasn't cleaned up.

Ack, I will remove them in v2.
Regards,

Lorenzo

> 
> Regards
> Stanislaw
> 
