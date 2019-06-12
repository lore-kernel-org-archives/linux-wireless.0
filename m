Return-Path: <SRS0=e4fn=UL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122BAC31E46
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 14:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBB6220866
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 14:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409318AbfFLOVj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Jun 2019 10:21:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409256AbfFLOVj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jun 2019 10:21:39 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DED113097053;
        Wed, 12 Jun 2019 14:21:33 +0000 (UTC)
Received: from localhost (unknown [10.40.205.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 724EB1001B10;
        Wed, 12 Jun 2019 14:21:30 +0000 (UTC)
Date:   Wed, 12 Jun 2019 16:21:29 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mt76: usb: do not always copy the first part of
 received frames
Message-ID: <20190612142128.GA20760@redhat.com>
References: <cover.1559293385.git.lorenzo@kernel.org>
 <2ed0b595a12944a8cfea14e066bcc4fa24f0ba44.1559293385.git.lorenzo@kernel.org>
 <20190612091036.GB2965@redhat.com>
 <20190612095302.GD8107@localhost.localdomain>
 <20190612102502.GB4431@redhat.com>
 <20190612104921.GF8107@localhost.localdomain>
 <20190612115120.GA3496@redhat.com>
 <20190612122845.GH8107@localhost.localdomain>
 <20190612125905.GB2600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612125905.GB2600@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 12 Jun 2019 14:21:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jun 12, 2019 at 02:59:05PM +0200, Stanislaw Gruszka wrote:
> > > If max RX AMSDU size is 3839B I do not see reason why we allocate
> > > MT_SG_MAX_SIZE=8 of MT_RX_BUF_SIZE=2k buffers for sg_en case.
> > > I thought the reason is that max AMSDU size is 16kB so it fit into
> > > 8 sg buffers of 2k.
> > > 
> > > In other words, for me, looks like either
> > > - we can not handle AMSDU for non sg case because we do not
> > > allocate big enough buffer
> > 
> > I think AMSDU is mandatory and we currently support it even for non-sg case
> > (since max rx AMSDU is 3839B)
> > 
> > > or
> > > - we can just use one PAGE_SIZE buffer for rx and remove sg
> > > buffers for rx completely 
> > 
> > using sg buffers we can support bigger rx AMSDU size in the future without using
> > huge buffers (e.g. we can try to use IEEE80211_MAX_MPDU_LEN_HT_7935 with
> > mt76x2u)
> 
> I think it would be simpler just to allocate 2 pages for 7935B .

And if we could determine that there is no true need to use sg for rx,
I think best approach here would be revert f8f527b16db5 in v5.2 to fix
regression and remove rx sg in -next. That would make code simpler,
allocate 4k instead 16k per packet, allow to use build_skb (4096 - 3839
give enough space for shared info) and not use usb hcd bounce buffer.

Stanislaw
