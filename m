Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6B4C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17D75208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:17:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17D75208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbeJRQRs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 12:17:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45795 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbeJRQRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 12:17:48 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B96FB4E8BC;
        Thu, 18 Oct 2018 08:17:57 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B76944FAE;
        Thu, 18 Oct 2018 08:17:54 +0000 (UTC)
Date:   Thu, 18 Oct 2018 10:17:52 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: fix static tracepoints
Message-ID: <20181018081752.GB2190@redhat.com>
References: <cover.1539815635.git.lorenzo.bianconi@redhat.com>
 <d9c86c268b987115f4ce08a8594e9e4da6c5f9fb.1539815635.git.lorenzo.bianconi@redhat.com>
 <20181018064521.GA2199@redhat.com>
 <20181018081350.GA4938@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018081350.GA4938@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 18 Oct 2018 08:17:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 18, 2018 at 10:13:51AM +0200, Lorenzo Bianconi wrote:
> On Oct 18, Stanislaw Gruszka wrote:
> > On Thu, Oct 18, 2018 at 12:35:32AM +0200, Lorenzo Bianconi wrote:
> > > Add submit_urb and rx_urb static tracepoints in mt76-usb module.
> > > Move trace_mac_txstat_fetch in mt76x02_mac_load_tx_status routine
> > > in order to be available to usb drivers. Moreover remove
> > > no longer used mt76x0/trace.{c,h}
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > > ---
> > > @@ -54,7 +53,7 @@ mt76x0_rf_csr_wr(struct mt76x02_dev *dev, u32 offset, u8 value)
> > >  		FIELD_PREP(MT_RF_CSR_CFG_REG_ID, reg) |
> > >  		MT_RF_CSR_CFG_WR |
> > >  		MT_RF_CSR_CFG_KICK);
> > > -	trace_mt76x0_rf_write(&dev->mt76, bank, offset, value);
> > 
> > I think tracing RF registers writes/read can still be useful.
> 
> Hi Stanislaw,
> 
> I removed tracing for RF registers since these operations are already tracked in
> mt76_wr/mt76_rr so I thought they were redundant. Do you think deducing rf
> read/write operations from mt76_{rr,wr} tracing is too convoluted? If so I
> can reintroduce them in v2.

No, if we can trace RF access thats ok. ACK for patch.

Thanks
Stanislaw
