Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DABC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 08:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D21521919
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 08:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfAYI0B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:26:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfAYI0B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 03:26:01 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E9E5325B9;
        Fri, 25 Jan 2019 08:26:01 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1050BAA7;
        Fri, 25 Jan 2019 08:25:58 +0000 (UTC)
Date:   Fri, 25 Jan 2019 09:25:56 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mt76x02: use mask for vifs
Message-ID: <20190125082556.GA2180@redhat.com>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-2-git-send-email-sgruszka@redhat.com>
 <20190124161235.GA10806@localhost.localdomain>
 <20190124162040.GA5136@redhat.com>
 <20190124163541.GB10806@localhost.localdomain>
 <20190124222040.GA2873@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124222040.GA2873@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 25 Jan 2019 08:26:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 24, 2019 at 11:20:42PM +0100, Lorenzo Bianconi wrote:
> > > > 
> > > > I guess this does not work if you add 2 vifs and then you remove the first one
> > > > (you will end up with a wrong configuration in MT_MAC_ADDR_DW{0,1}). I guess
> > > > the hw will not work well if MT_MAC_ADDR_DW{0,1} is not properly configured
> > 
> > Maybe I am missing something, but let's assume you add the interface vif0 with address
> > 00:11:22:33:44:55 (MT_MAC_ADDR_DW{0,1} will be set to 00:11:22:33:44:55) and
> > then you add vif1 with address 00:aa:bb:cc:dd:ee. If at some point you remove
> > vif0 MT_MAC_ADDR_DW{0,1} will not be properly reconfigured. The problem will
> > be more complex if you have more interfaces

Ok, so in remove_interface extra code can be added to implement that.

> Moreover if you add 2 vif, vif0 with address 00:11:22:33:44:55 and vif1 with
> address 00:aa:bb:cc:dd:ee, have you double-checked you are able to get the same
> tpt on both interfaces? In the past IIRC there were issues if we use multibss
> with completely different mac addresses

I haven't check that. But what I can tell multi vif STA does not work, if
we do not enable PROMISC on rx filter. But this is not diffrent from MMIO
version, which mark multi vif support.

Regards
Stanislaw
