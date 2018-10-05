Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B92C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 07:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A5B32064D
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 07:54:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A5B32064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbeJEOvi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 10:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbeJEOvi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 10:51:38 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C96FE30B8F97;
        Fri,  5 Oct 2018 07:54:06 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F8BF3002615;
        Fri,  5 Oct 2018 07:54:04 +0000 (UTC)
Date:   Fri, 5 Oct 2018 09:54:04 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: iwlegacy: Fix possible data races in
 il4965_send_rxon_assoc()
Message-ID: <20181005075403.GC1931@redhat.com>
References: <20181003140745.7650-1-baijiaju1990@gmail.com>
 <20181004075914.GB20523@redhat.com>
 <988494cb-c121-697e-b502-ea4e7c601f47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <988494cb-c121-697e-b502-ea4e7c601f47@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.24
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 05 Oct 2018 07:54:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 04, 2018 at 04:52:19PM +0800, Jia-Ju Bai wrote:
> On 2018/10/4 15:59, Stanislaw Gruszka wrote:
> >On Wed, Oct 03, 2018 at 10:07:45PM +0800, Jia-Ju Bai wrote:
> >>These possible races are detected by a runtime testing.
> >>To fix these races, the mutex lock is used in il4965_send_rxon_assoc()
> >>to protect the data.
> >Really ? I'm surprised by that, see below.
> 
> My runtime testing shows that il4965_send_rxon_assoc() and
> il4965_configure_filter() are concurrently executed.
> But after seeing your reply, I need to carefully check whether my
> runtime testing is right, because I think you are right.
> In fact, I only monitored the iwl4965 driver, but did not monitor
> the iwlegacy driver, so I will do the testing again with monitoring
> the lwlegacy driver.
<snip>
> >So I wonder how this patch did not cause the deadlock ?
> 
> Oh, sorry, anyway, my patch will cause double locks...

So how those runtime test were performend such you didn't
notice this ?

> >Anyway what can be done is adding:
> >
> >lockdep_assert_held(&il->mutex);
> >
> >il4965_commit_rxon() to check if we hold the mutex.
> 
> I agree.

Care to post a patch ?

Thanks
Stanislaw
