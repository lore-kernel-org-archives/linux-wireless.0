Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3E7C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13BA5208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:23:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13BA5208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbeJRQXs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 12:23:48 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59860 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbeJRQXs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 12:23:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gD3az-0002dj-QZ; Thu, 18 Oct 2018 10:23:54 +0200
Message-ID: <5c6c7a4d3471a2784d0b203beccd4de9c55b211e.camel@sipsolutions.net>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Adham.Abozaeid@microchip.com, Ajay.Kathat@microchip.com,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Aditya.Shankar@microchip.com,
        Venkateswara.Kaja@microchip.com, Claudiu.Beznea@microchip.com
Date:   Thu, 18 Oct 2018 10:23:38 +0200
In-Reply-To: <5BC11B3B.20901@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81) <1539009076.3687.64.camel@sipsolutions.net>
                 <5BBE5BCF.5020706@microchip.com>
         <1539241314.3687.190.camel@sipsolutions.net> <5BC11B3B.20901@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-10-12 at 22:08 +0000, Adham.Abozaeid@microchip.com wrote:
> 
> On 10/11/2018 12:01 AM, Johannes Berg wrote:
> > 
> > > Agree. parameter validation can be done before scheduling the work,
> > > and hence appropriate error can be returned to caller .
> > 
> > 
> > > If I got your point correctly, you are referring to the lines that
> > > stores the parameters into the hif_drv->cfg_values.
> > 
> > Well, I was actually thinking that I'm not even sure why you schedule
> > work at all!
> 
> Do you mean we should be doing the work from the cfg context?
> Note that this is called cfg80211_ops.set_wiphy_params(), and involves
> locking mutexes, packing the wids, bus operations, and waiting for the
> device to respond.

That *should* be fine - how long do you expect that to take?

johannes


