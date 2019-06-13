Return-Path: <SRS0=exsR=UM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B77C31E45
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Jun 2019 16:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F87920449
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Jun 2019 16:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732658AbfFMQeB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:34:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730795AbfFMHzi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Jun 2019 03:55:38 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 42E6830860B8;
        Thu, 13 Jun 2019 07:55:38 +0000 (UTC)
Received: from localhost (ovpn-204-191.brq.redhat.com [10.40.204.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B10C01001E60;
        Thu, 13 Jun 2019 07:55:35 +0000 (UTC)
Date:   Thu, 13 Jun 2019 09:55:34 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mt76: usb: do not always copy the first part of
 received frames
Message-ID: <20190613075534.GB24561@redhat.com>
References: <cover.1559293385.git.lorenzo@kernel.org>
 <2ed0b595a12944a8cfea14e066bcc4fa24f0ba44.1559293385.git.lorenzo@kernel.org>
 <20190612091036.GB2965@redhat.com>
 <20190612095302.GD8107@localhost.localdomain>
 <20190612102502.GB4431@redhat.com>
 <20190612104921.GF8107@localhost.localdomain>
 <20190612115120.GA3496@redhat.com>
 <20190612122845.GH8107@localhost.localdomain>
 <20190612125905.GB2600@redhat.com>
 <20190612142741.GA7016@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612142741.GA7016@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 13 Jun 2019 07:55:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jun 12, 2019 at 04:27:42PM +0200, Lorenzo Bianconi wrote:
> > On Wed, Jun 12, 2019 at 02:28:48PM +0200, Lorenzo Bianconi wrote:
> 
> [...]
> 
> > > 
> > > using sg buffers we can support bigger rx AMSDU size in the future without using
> > > huge buffers (e.g. we can try to use IEEE80211_MAX_MPDU_LEN_HT_7935 with
> > > mt76x2u)
> > I think it would be simpler just to allocate 2 pages for 7935B .
> > 
> 
> We should avoid increasing buffer size to more than PAGE_SIZE for
> performance reasons.

Interesting, at what place and how this affect performance negatively ?

> As suggested by Felix what about of setting buf_size to
> PAGE_SIZE for both sg and non-sg cases and for sg setting usb data size to
> 
> SKB_WITH_OVERHEAD(q->buf_size) & (usb_endpoint_maxp() - 1);

Increasing to PAGE_SIZE for sg looks reasonable to me.

Not sure if understand data_size logic. If this mean 'PAGE_SIZE - usb_endpint_maxp()',
looks ok to me as well (for first segment), but would require one extra segment
to avoid coping (i.e. 2 pages for 3839 , 3 pages for 7935 ...) If we would 
like to stay with 128B copy fallback, we can have 1 page for 3839 , 2 for 7935 ...

It would be interesting how frequently AMSDU of max size is sent by
remote station. If this is rare situation I would be opting for
smaller allocation and 128B copy fallback. If this is frequent
for bigger allocation to assure we can always use build_skb().

Stanislaw 
