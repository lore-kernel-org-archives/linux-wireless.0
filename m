Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2338C282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 09:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B5B6217D7
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 09:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfAYJCm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 04:02:42 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34449 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfAYJCm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 04:02:42 -0500
Received: by mail-wr1-f68.google.com with SMTP id f7so9455960wrp.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2019 01:02:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PUZ2CyPepbn9J9N2Pcic0Ld2UQSxLEYYtQPdWiBepIQ=;
        b=f0tspQn2xnbNvT/ZPiZXhVV3QAF38dPfKoHYizwNO9Qwr/bNGNAKb5zJZoCw0tVEXw
         UdR1dpqtK/0vgrrhRpwUblAyUiVO9Pkeq1bh4mIX/SsKZopt2StL1gcEcSLUOxc8Bp11
         65zgFPx40aNZYSLOKfRuV0SJz85Wgr11DEc5SN0jpwiAJZZKbHgyxHLPbZrkujH+X2z3
         JJNRpi7uw0NGzMhlJFse4KXPmO7xSb0vyKgG9QNqJRW6LcXOJu+pFRejmQqcFcW0zPKl
         xNH7idTUtXLrPZVw7X+3dOsM1D8QButWNsi4LBtStFgZuvk6p3rJq7+mplk7Q33UVPNG
         xpFA==
X-Gm-Message-State: AJcUukdG2sp+j+PPTz7XQA0KOV5uL+qnhMAlAmEFij8aRn3KHkdWH9Nt
        BxPABnXn59QlEFIp83zFdNXQVWC7tRDqXA==
X-Google-Smtp-Source: ALg8bN5YFxWYACZD0ey7OFqARD9BDnTV38rOXUiNh/FS/EGngoHFn6iOcB2PspGEwbdm4JaodHSyIQ==
X-Received: by 2002:adf:c108:: with SMTP id r8mr10902903wre.233.1548406961010;
        Fri, 25 Jan 2019 01:02:41 -0800 (PST)
Received: from p1372.fit.wifi.vutbr.cz ([147.229.117.36])
        by smtp.gmail.com with ESMTPSA id c21sm82350882wre.71.2019.01.25.01.02.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jan 2019 01:02:40 -0800 (PST)
Date:   Fri, 25 Jan 2019 10:02:38 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mt76x02: use mask for vifs
Message-ID: <20190125090236.GA2761@p1372.fit.wifi.vutbr.cz>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-2-git-send-email-sgruszka@redhat.com>
 <20190124161235.GA10806@localhost.localdomain>
 <20190124162040.GA5136@redhat.com>
 <20190124163541.GB10806@localhost.localdomain>
 <20190124222040.GA2873@localhost.localdomain>
 <20190125082556.GA2180@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125082556.GA2180@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Thu, Jan 24, 2019 at 11:20:42PM +0100, Lorenzo Bianconi wrote:
> > > > > 
> > > > > I guess this does not work if you add 2 vifs and then you remove the first one
> > > > > (you will end up with a wrong configuration in MT_MAC_ADDR_DW{0,1}). I guess
> > > > > the hw will not work well if MT_MAC_ADDR_DW{0,1} is not properly configured
> > > 
> > > Maybe I am missing something, but let's assume you add the interface vif0 with address
> > > 00:11:22:33:44:55 (MT_MAC_ADDR_DW{0,1} will be set to 00:11:22:33:44:55) and
> > > then you add vif1 with address 00:aa:bb:cc:dd:ee. If at some point you remove
> > > vif0 MT_MAC_ADDR_DW{0,1} will not be properly reconfigured. The problem will
> > > be more complex if you have more interfaces
> 
> Ok, so in remove_interface extra code can be added to implement that.
> 
> > Moreover if you add 2 vif, vif0 with address 00:11:22:33:44:55 and vif1 with
> > address 00:aa:bb:cc:dd:ee, have you double-checked you are able to get the same
> > tpt on both interfaces? In the past IIRC there were issues if we use multibss
> > with completely different mac addresses
> 
> I haven't check that. But what I can tell multi vif STA does not work, if
> we do not enable PROMISC on rx filter. But this is not diffrent from MMIO
> version, which mark multi vif support.

Since this is not strictly related to AP/IBSS support I guess we can just use
mt76x02_add_interface for mt76x2u or modify mt76x2u_add_interface in order to
use ap_cli registers for sta mode and drop this patch. I think we can address it
later after more testing

Regards,
Lorenzo

> 
> Regards
> Stanislaw
