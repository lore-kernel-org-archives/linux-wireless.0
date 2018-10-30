Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FAAC2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 09:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 806DC2080A
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 09:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 806DC2080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbeJ3S3j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 14:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbeJ3S3j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 14:29:39 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C1FD30832EA;
        Tue, 30 Oct 2018 09:36:58 +0000 (UTC)
Received: from localhost (unknown [10.40.205.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79F5D5B697;
        Tue, 30 Oct 2018 09:36:57 +0000 (UTC)
Date:   Tue, 30 Oct 2018 10:36:56 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: run calibration after scanning
Message-ID: <20181030093655.GA26345@redhat.com>
References: <1540808213-14442-1-git-send-email-sgruszka@redhat.com>
 <87zhuwbzj8.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zhuwbzj8.fsf@purkki.adurom.net>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 30 Oct 2018 09:36:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 29, 2018 at 04:25:31PM +0200, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > If we are associated and scanning is performed , sw_scan_complete callback
> > is done after we get back to operating channel, so we do not perform
> > phy calibration and queue cal work. Fix this by run calibration from
> > sw_scan_complete().
> >
> > Fixes: bbd10586f0df ("mt76x0: phy: do not run calibration during channel switch")
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> > This is for 4.20
> 
> So what are the symptoms from user's point of view? Is this a
> regression?

We do not perform gain calibration any longer if somebody will
request scan after association. This is formally a regression,
but calibration code changed a lot, so perhaps this can be dropped
for 4.20 and eventually go through -stable if I can confirm
it fixes performance problems.

Thanks
Stanislaw
