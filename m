Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBFEC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B02E20C0A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:48:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B02E20C0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbeIYPzZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 11:55:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbeIYPzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 11:55:25 -0400
Received: from smtp.corp.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5D763086266;
        Tue, 25 Sep 2018 09:48:41 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67FF389AE8;
        Tue, 25 Sep 2018 09:48:39 +0000 (UTC)
Date:   Tue, 25 Sep 2018 11:48:37 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Sid Hayn <sidhayn@gmail.com>
Subject: Re: [PATCH] mt76x0: add quirk to disable 2.4GHz band for Archer T1U
Message-ID: <20180925094837.GD2029@redhat.com>
References: <1537858188-7815-1-git-send-email-sgruszka@redhat.com>
 <20180925075445.GA3872@localhost.localdomain>
 <f3c1e576-4756-7a3e-4bfe-3abaf3e1107d@nbd.name>
 <20180925090746.GC3872@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180925090746.GC3872@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.27
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 25 Sep 2018 09:48:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Sep 25, 2018 at 11:07:47AM +0200, Lorenzo Bianconi wrote:
> On Sep 25, Felix Fietkau wrote:
> > On 2018-09-25 09:54, Lorenzo Bianconi wrote:
> > >>  
> > >> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > >> index 76d607f73758..b7a1069ecd0e 100644
> > >> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > >> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > >> @@ -45,7 +45,8 @@
> > >>  	{ USB_DEVICE(0x20f4, 0x806b) },	/* TRENDnet TEW-806UBH  */
> > >>  	{ USB_DEVICE(0x7392, 0xc711) }, /* Devolo Wifi ac Stick */
> > >>  	{ USB_DEVICE(0x0df6, 0x0079) }, /* Sitecom Europe B.V. ac  Stick */
> > >> -	{ USB_DEVICE(0x2357, 0x0105) }, /* TP-LINK Archer T1U */
> > >> +	{ USB_DEVICE(0x2357, 0x0105),
> > >> +	  .driver_info = 1,	     }, /* TP-LINK Archer T1U */
> > > 
> > > Hi Stanislaw,
> > > 
> > > what about using 'ieee80211-freq-limit' OF property to limit available wireless
> > > band? In this way we can take into account even the opposite case (no 5GHz).
> > That doesn't make sense for USB devices, which can be plugged into any
> > machine.
> 
> Ack, right.
> What about a more general solution like adding an enum { NO_5GHz = 1, NO_2GHz }?
> Does it worth to implement it now?

I do not see reason for that. Basically band information should be
read from EEPROM, I do not expect need for more quirks like this.

Thanks
Stanislaw 
