Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4BAC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C70C22082F
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbfAPLTy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 06:19:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728612AbfAPLTx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 06:19:53 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C056341AE2;
        Wed, 16 Jan 2019 11:19:53 +0000 (UTC)
Received: from localhost (unknown [10.40.205.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B3C61019633;
        Wed, 16 Jan 2019 11:19:47 +0000 (UTC)
Date:   Wed, 16 Jan 2019 12:19:46 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org, rosenp@gmail.com
Subject: Re: [RFC 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190116111946.GB5234@redhat.com>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
 <20190115153546.GA8387@redhat.com>
 <20190115154746.GA30564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115154746.GA30564@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 16 Jan 2019 11:19:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 15, 2019 at 04:47:47PM +0100, Lorenzo Bianconi wrote:
> Hi Stanislaw,

Hi :-)

> > Not sure what is the problem , but this patch set look like a workaround
> > not fix. If this an issue with IOMMU and sg, seems there is something wrong
> > in sg page mappings eigher on mt76 dirver or IOMMU driver.
> 
> The main point here I guess is we do not need sg if fragment number is one (e.g
> usb2.0). Moreover this can fix IOMMU reported issues.

So there if diffrence for USB host driver when we have one usb->sg
sengment and if we just pass the buffer via urb->transfer_buf . I think
most USB host drivers behave the same in such cases. For what USB
hardware/driver this is needed ? Perhaps simpler fix could be done
in USB host driver?

Also I'm not sure for what this new module parameter is needed ?
 
> @Rosen: could you please try this series enabling IOMMU?
> 
> > 
> > If things need to be fixed in mt76 I whould check if page mappings for
> > sg are correct. Or remove sg usage from mt76_usb completly, mt76 MMIO
> > version do not use sg for framgments, so most likely USB don't need it
> > as well.
> 
> usb scatter-gather is used to properly support non-linear skbs (A-MSDU,
> with usb3.0) since the hw (unlike pci counterpart) does not support it,
> so we need it.

Ok, having separe URB for each fragment make no sense since we have
embedded sg structure in URB.

Regards
Stanislaw
