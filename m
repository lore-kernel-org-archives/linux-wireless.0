Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A26C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19E5F20827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:16:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19E5F20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbeKIW4z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:56:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbeKIW4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:56:55 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ADBE8307DAB4;
        Fri,  9 Nov 2018 13:16:20 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E5065D736;
        Fri,  9 Nov 2018 13:16:16 +0000 (UTC)
Date:   Fri, 9 Nov 2018 14:16:10 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] mt76x02: minor beaconing init changes
Message-ID: <20181109131608.GB8054@redhat.com>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-5-git-send-email-sgruszka@redhat.com>
 <20181109113331.GG4174@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109113331.GG4174@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 09 Nov 2018 13:16:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 09, 2018 at 12:33:32PM +0100, Lorenzo Bianconi wrote:
> > Disable BEACON timer during init and remove interrupt registers
> > initalization form generic conde since they are PCIe specific.
> > 
> 
> Since the timer is actually disabled (MT_INT_TIMER_EN set to 0) and
> we just set the timer timeout here, does it worth to copy/paste
> the same code?

As I pointed somwhere else I have some random, not easy to reproduce
performance drops on MT7610U sta mode, starting when AP mode support
was added. I'm can not be sure if this is by this setting this
timer, but I would rather accept slight code duplication, than 
do something that (even with very low probability) can cause
troubles and for sure is not necessary.

Thanks
Stanislaw
