Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B278CC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C1A521480
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C1A521480
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbeIYPOZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 11:14:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36934 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbeIYPOZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 11:14:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id n11-v6so12740689wmc.2
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2018 02:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y1UuhVtWwho4/sXuk477KWMNNBMaLENEdctUiyacrSI=;
        b=DWf0gnL9SFcfPOTfW+0dqsD5OZ4NV5qwSCHas4wRGV/BFMFph1kRf6NIwfR/4w9cBk
         UawQ3Bg2ap+WwpAoz1Ts1PUGOTNcl8SUUH2XkjYWFkePraCmYQHtlSWJ7Yr3LQAnPyAo
         YRxAOPOYUi3Q2MeP1CJ/rSDdlsJ0JdRWQjWHtqwO5iQauDK5krP+lNocRBF5HtpFtzSQ
         zjyQOKtqR8W+7R117yH+VGcvh35lpVRYGyGWq6uQS5/I9YRhniG6hHt/5S+4vgdTq1MX
         IKaA03nxV5GIGYjN9aYJHoaCtfTtua5EdgSbxzo8mZSKbYTZjIveeVjRVTHxdtZsM6yg
         MT9g==
X-Gm-Message-State: ABuFfohwzIHJFvweqWB4fWdWIjKEvSnhMwyuCxF8dQ0eTBfBjbxUJjx+
        +FyxMNh1BKbKuXgU38OP0dYKaQ==
X-Google-Smtp-Source: ACcGV61SIBLZpbvlAunE6R4Jnz01HUGTxZtWaCzStgWpaaAjd4fdmCPk/XrxBYoPkZfqaurAHZvAig==
X-Received: by 2002:a1c:a685:: with SMTP id p127-v6mr85583wme.68.1537866470333;
        Tue, 25 Sep 2018 02:07:50 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q135-v6sm2199630wmd.4.2018.09.25.02.07.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Sep 2018 02:07:49 -0700 (PDT)
Date:   Tue, 25 Sep 2018 11:07:47 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, Sid Hayn <sidhayn@gmail.com>
Subject: Re: [PATCH] mt76x0: add quirk to disable 2.4GHz band for Archer T1U
Message-ID: <20180925090746.GC3872@localhost.localdomain>
References: <1537858188-7815-1-git-send-email-sgruszka@redhat.com>
 <20180925075445.GA3872@localhost.localdomain>
 <f3c1e576-4756-7a3e-4bfe-3abaf3e1107d@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3c1e576-4756-7a3e-4bfe-3abaf3e1107d@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sep 25, Felix Fietkau wrote:
> On 2018-09-25 09:54, Lorenzo Bianconi wrote:
> >>  
> >> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> >> index 76d607f73758..b7a1069ecd0e 100644
> >> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> >> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> >> @@ -45,7 +45,8 @@
> >>  	{ USB_DEVICE(0x20f4, 0x806b) },	/* TRENDnet TEW-806UBH  */
> >>  	{ USB_DEVICE(0x7392, 0xc711) }, /* Devolo Wifi ac Stick */
> >>  	{ USB_DEVICE(0x0df6, 0x0079) }, /* Sitecom Europe B.V. ac  Stick */
> >> -	{ USB_DEVICE(0x2357, 0x0105) }, /* TP-LINK Archer T1U */
> >> +	{ USB_DEVICE(0x2357, 0x0105),
> >> +	  .driver_info = 1,	     }, /* TP-LINK Archer T1U */
> > 
> > Hi Stanislaw,
> > 
> > what about using 'ieee80211-freq-limit' OF property to limit available wireless
> > band? In this way we can take into account even the opposite case (no 5GHz).
> That doesn't make sense for USB devices, which can be plugged into any
> machine.

Ack, right.
What about a more general solution like adding an enum { NO_5GHz = 1, NO_2GHz }?
Does it worth to implement it now?

Regards,
Lorenzo

> 
> - Felix
