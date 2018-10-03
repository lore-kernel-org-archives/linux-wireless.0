Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2F7C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77B912089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77B912089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbeJCRHf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:07:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbeJCRHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:07:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E70707E9C0;
        Wed,  3 Oct 2018 10:19:50 +0000 (UTC)
Received: from localhost (ovpn-204-105.brq.redhat.com [10.40.204.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48BC25ED55;
        Wed,  3 Oct 2018 10:19:48 +0000 (UTC)
Date:   Wed, 3 Oct 2018 12:19:47 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: fix frag length allocation for usb
Message-ID: <20181003101946.GC2229@redhat.com>
References: <1538554631-5168-1-git-send-email-sgruszka@redhat.com>
 <20181003091206.GA27279@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003091206.GA27279@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 03 Oct 2018 10:19:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 11:12:07AM +0200, Lorenzo Bianconi wrote:
> > This is correct fix for c12128ce44b0 ("mt76: use a per rx queue page
> > fragment cache"). We use wrong length when we allocate segments for
> > MCU transmissions, which require bigger segment size than e->buf_size.
> > 
> > Commit 481bb0432414 ("mt76: usb: make rx page_frag_cache access atomic")
> > partially solved the problem or actually mask it by changing
> > mt76u_mcu_init_rx() and mt76u_alloc_queues() sequence, so e->buf_size
> > become non zero any longer, but still not big enough to handle MCU data.
> 
> Hi Stanislaw,
> 
> I agree that we should use len in page_frag_alloc() instead of q->buf_size, so
> 
> Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> 
> but reviewing the code I guess the real issue is not q->buf_size (since it should
> be bigger than MCU_RESP_URB_SIZE) but it is the sequence of calls in

I added printk and there are allocations where len is bigger then
q->buf_size even with correct mt76u_alloc_queues, mt76u_mcu_init_rx
sequence for mt76x0u:

[16426.606090] q->buf_size 2048 len 2048 nsgs 8sglen 1728
[16426.606131] q->buf_size 2048 len 2048 nsgs 8sglen 1728
[16426.606134] q->buf_size 2048 len 2048 nsgs 8sglen 1728
<snip>
[16426.606464] q->buf_size 2048 len 2048 nsgs 8sglen 1728
[16426.607517] q->buf_size 2048 len 1024 nsgs 1sglen 1024
[16426.939268] q->buf_size 2048 len 14584 nsgs 1sglen 14584
[16426.984955] q->buf_size 2048 len 14584 nsgs 1sglen 14584

Not sure where it come from, but it's after MCU init (which is 1024
third line from end).

> mt76x0u_register_device() since mt76u_alloc_queues need to be called before
> mt76u_mcu_init_rx()

Ok, so this was already fixed in 

commit 481bb0432414f790066205fe77226b7d1877385d
Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Wed Sep 26 13:07:39 2018 +0200

    mt76: usb: make rx page_frag_cache access atomic

but then the sequence was changed again in

commit faa605bdfaa1322ea8e85791abdb3382a8cb4e0c
Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri Sep 28 13:39:00 2018 +0200

    mt76x0: usb: move initialization code in usb.c

Thanks
Stanislaw
 
