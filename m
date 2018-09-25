Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243B5C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 10:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5CEC2145D
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 10:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5CEC2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbeIYQIv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 12:08:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbeIYQIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 12:08:51 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 49CB02CE911;
        Tue, 25 Sep 2018 10:02:04 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6B7330A605E;
        Tue, 25 Sep 2018 10:02:00 +0000 (UTC)
Date:   Tue, 25 Sep 2018 12:01:58 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Sid Hayn <sidhayn@gmail.com>
Subject: Re: [PATCH] mt76x0: add quirk to disable 2.4GHz band for Archer T1U
Message-ID: <20180925100158.GA29828@redhat.com>
References: <1537858188-7815-1-git-send-email-sgruszka@redhat.com>
 <20180925075445.GA3872@localhost.localdomain>
 <f3c1e576-4756-7a3e-4bfe-3abaf3e1107d@nbd.name>
 <20180925090746.GC3872@localhost.localdomain>
 <20180925094837.GD2029@redhat.com>
 <8bcdd4fc-4dc6-f098-073e-83feb09a117f@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bcdd4fc-4dc6-f098-073e-83feb09a117f@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.26
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 25 Sep 2018 10:02:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Sep 25, 2018 at 11:55:48AM +0200, Arend van Spriel wrote:
> On 9/25/2018 11:48 AM, Stanislaw Gruszka wrote:
> >On Tue, Sep 25, 2018 at 11:07:47AM +0200, Lorenzo Bianconi wrote:
> >>On Sep 25, Felix Fietkau wrote:
> >>>On 2018-09-25 09:54, Lorenzo Bianconi wrote:
> >>>>>
> >>>>>diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> >>>>>index 76d607f73758..b7a1069ecd0e 100644
> >>>>>--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> >>>>>+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> >>>>>@@ -45,7 +45,8 @@
> >>>>> 	{ USB_DEVICE(0x20f4, 0x806b) },	/* TRENDnet TEW-806UBH  */
> >>>>> 	{ USB_DEVICE(0x7392, 0xc711) }, /* Devolo Wifi ac Stick */
> >>>>> 	{ USB_DEVICE(0x0df6, 0x0079) }, /* Sitecom Europe B.V. ac  Stick */
> >>>>>-	{ USB_DEVICE(0x2357, 0x0105) }, /* TP-LINK Archer T1U */
> >>>>>+	{ USB_DEVICE(0x2357, 0x0105),
> >>>>>+	  .driver_info = 1,	     }, /* TP-LINK Archer T1U */
> >>>>
> >>>>Hi Stanislaw,
> >>>>
> >>>>what about using 'ieee80211-freq-limit' OF property to limit available wireless
> >>>>band? In this way we can take into account even the opposite case (no 5GHz).
> >>>That doesn't make sense for USB devices, which can be plugged into any
> >>>machine.
> >>
> >>Ack, right.
> >>What about a more general solution like adding an enum { NO_5GHz = 1, NO_2GHz }?
> >>Does it worth to implement it now?
> >
> >I do not see reason for that. Basically band information should be
> >read from EEPROM, I do not expect need for more quirks like this.
> 
> Well. Never say never :-p And the phrase "quirks like this" does
> seem to leave the door open for other quirks. Or did you mean
> "quirks using driver_info"?

I mean quirks that mask out band. Anyway if the need for any other
quirk will show up then the things can be modified. Do not see point
for doing it now, when we don't know if new stuff will be used
at all.

Thanks
Stanislaw

