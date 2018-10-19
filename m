Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DA2ECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 07:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0BB62087A
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 07:02:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0BB62087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbeJSPHl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 11:07:41 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47350 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeJSPHl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 11:07:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gDOoA-00048N-MG; Fri, 19 Oct 2018 09:02:54 +0200
Message-ID: <492fb11bbe66cdea676e126a70a1ba9e1af3c97b.camel@sipsolutions.net>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Adham.Abozaeid@microchip.com, Ajay.Kathat@microchip.com,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Aditya.Shankar@microchip.com,
        Venkateswara.Kaja@microchip.com, Claudiu.Beznea@microchip.com
Date:   Fri, 19 Oct 2018 09:02:38 +0200
In-Reply-To: <5BC8D148.7050804@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81) <1539009076.3687.64.camel@sipsolutions.net>
         <5BBE5BCF.5020706@microchip.com>
         <1539241314.3687.190.camel@sipsolutions.net> <5BC11B3B.20901@microchip.com>
         <5c6c7a4d3471a2784d0b203beccd4de9c55b211e.camel@sipsolutions.net>
         <5BC8D148.7050804@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> > > Do you mean we should be doing the work from the cfg context?
> > > Note that this is called cfg80211_ops.set_wiphy_params(), and involves
> > > locking mutexes, packing the wids, bus operations, and waiting for the
> > > device to respond.
> > 
> > That *should* be fine - how long do you expect that to take?
> > 
> 
> It depends on the IO bus used (SPI/SDIO), clock speed.. etc
> It would also vary according to the data packets being transferred
> with the device.
> If there's heavy data transfer, configuration packets would take
> longer to be sent, and for their response to be received.

How much time do you think you're looking at?

I'd argue for trying it though as it makes the code MUCH simpler.

johannes

