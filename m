Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF85C282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 22:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40EE6218D0
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 22:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfAXWUr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 17:20:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41315 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfAXWUr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 17:20:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so8210867wrs.8
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 14:20:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hMIew2CYu0kbCk252mccCf1EcTdaXKR9HP057nEhVw8=;
        b=HLaykLzKSXSYPcf1iZUU/pDlK7Z/LKNjOiLev+MJMTacL7fPPvwzFTujTu+KrF0Hwr
         2sa6WQmt1/okfzD37fdUPPbF4Y559xt//v36A5sKgh35kbzS+ZoY3p9rMew8/RqIE/wB
         A8IMmU8jy9Iqsjr9sY0p0Tl/KlG1GerMSWQUgmcHVSb4AzlD0tlKffi3pWcn0mDSC4yN
         UdmjX8CTIpSDD6EWpDYv6HYa3hv92uecASvSmIEPd15eISHUDUYAHNOcH8Rg2/0MkFzS
         4L+hTBCDzmVW6hEWVIevVgKmD5XgsOTZ4YZ+di9QGk9Dtu8tz8DcR6TTpualOfi5nAPs
         MwsA==
X-Gm-Message-State: AJcUukcgpChWXx3pF4Ybh0hBtWY5rXeOZiF6fxLw/atCkNB87Ua7dIOD
        nnXpnOE6NQKeF7AclOXOVJZAC+a4j35SUg==
X-Google-Smtp-Source: ALg8bN4ul7lgv9E7i7pruHwH8brgN/bLTbsI4UJdsVj3wtGsVZohfiHRvY40ll7hrFSmCKiPnb1e7w==
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr9271816wrm.223.1548368445463;
        Thu, 24 Jan 2019 14:20:45 -0800 (PST)
Received: from localhost.localdomain ([85.93.125.228])
        by smtp.gmail.com with ESMTPSA id c13sm117696483wrb.38.2019.01.24.14.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 14:20:44 -0800 (PST)
Date:   Thu, 24 Jan 2019 23:20:42 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mt76x02: use mask for vifs
Message-ID: <20190124222040.GA2873@localhost.localdomain>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-2-git-send-email-sgruszka@redhat.com>
 <20190124161235.GA10806@localhost.localdomain>
 <20190124162040.GA5136@redhat.com>
 <20190124163541.GB10806@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124163541.GB10806@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > > 
> > > I guess this does not work if you add 2 vifs and then you remove the first one
> > > (you will end up with a wrong configuration in MT_MAC_ADDR_DW{0,1}). I guess
> > > the hw will not work well if MT_MAC_ADDR_DW{0,1} is not properly configured
> 
> Maybe I am missing something, but let's assume you add the interface vif0 with address
> 00:11:22:33:44:55 (MT_MAC_ADDR_DW{0,1} will be set to 00:11:22:33:44:55) and
> then you add vif1 with address 00:aa:bb:cc:dd:ee. If at some point you remove
> vif0 MT_MAC_ADDR_DW{0,1} will not be properly reconfigured. The problem will
> be more complex if you have more interfaces

Moreover if you add 2 vif, vif0 with address 00:11:22:33:44:55 and vif1 with
address 00:aa:bb:cc:dd:ee, have you double-checked you are able to get the same
tpt on both interfaces? In the past IIRC there were issues if we use multibss
with completely different mac addresses

Regards,
Lorenzo

> 
> > 
> > This is only done when when vif_mask is 0 i.e. no interfaces. When
> > some interface is already created, changing MAC address will now work
> > anyway.
> > 
> > Thanks
> > Stanislaw
