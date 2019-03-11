Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B892C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 239CF20657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfCKNVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:21:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727701AbfCKNTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:19:44 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 62BB781F10;
        Mon, 11 Mar 2019 13:19:44 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 007105DAAF;
        Mon, 11 Mar 2019 13:19:43 +0000 (UTC)
Date:   Mon, 11 Mar 2019 14:19:40 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     yhchuang@realtek.com, johannes@sipsolutions.net,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        briannorris@chromium.org
Subject: Re: [PATCH v7 01/14] rtw88: main files
Message-ID: <20190311131939.GB6089@redhat.com>
References: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
 <1552139302-20476-2-git-send-email-yhchuang@realtek.com>
 <20190311131100.GA6482@redhat.com>
 <871s3da6yp.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871s3da6yp.fsf@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 11 Mar 2019 13:19:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 11, 2019 at 03:14:38PM +0200, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> >> +#define RA_MASK_VHT_RATES_1SS	(0x3ff000 << 0)
> >> +#define RA_MASK_VHT_RATES_2SS	(0x3ff000 << 10)
> >> +#define RA_MASK_VHT_RATES_3SS	(0x3ff000 << 20)
> >
> > Result will not fit in 32 bit, ULL marker should be added.
> 
> I haven't checked how these are used but IMHO using GENMASK() would be
> so much better.

GENMASK_ULL() in this case :-)

Stanislaw
