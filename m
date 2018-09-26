Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6411C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86459214C5
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:27:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86459214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbeIZQkI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:40:08 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57837 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbeIZQkI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:40:08 -0400
X-IronPort-AV: E=Sophos;i="5.54,306,1534834800"; 
   d="scan'208";a="18459152"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 26 Sep 2018 03:27:51 -0700
Received: from ajaysk-VirtualBox (10.10.76.4) by chn-sv-exch05.mchp-main.com
 (10.10.76.106) with Microsoft SMTP Server id 14.3.352.0; Wed, 26 Sep 2018
 03:27:50 -0700
Date:   Wed, 26 Sep 2018 15:57:43 +0530
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Nicolas Ferre - M43238" <Nicolas.Ferre@microchip.com>,
        Ganesh Krishna - C00112 <Ganesh.Krishna@microchip.com>,
        Adham Abozaeid - C43058 <Adham.Abozaeid@microchip.com>,
        Aditya Shankar - I16078 <Aditya.Shankar@microchip.com>
Subject: Re: feedback on mainlining wilc1000 staging driver
Message-ID: <20180926155743.032caa37@ajaysk-VirtualBox>
In-Reply-To: <87r2ipnxxa.fsf@kamboji.qca.qualcomm.com>
References: <20180816015243.545cd009@ajaysk-VirtualBox>
        <87sh3etwoj.fsf@purkki.adurom.net>
        <87o9e2twe9.fsf@purkki.adurom.net>
        <20180817100233.7f1c00d9@ajaysk-VirtualBox>
        <8736vdv3f5.fsf@kamboji.qca.qualcomm.com>
        <5B768574.6060009@broadcom.com>
        <87y3d5tmod.fsf@kamboji.qca.qualcomm.com>
        <20180817143911.5f0ee545@ajaysk-VirtualBox>
        <87r2ipnxxa.fsf@kamboji.qca.qualcomm.com>
Organization: Microchip Technology
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

On Thu, 23 Aug 2018 16:37:45 +0530
Kalle Valo <kvalo@codeaurora.org> wrote:

> Ajay Singh <ajay.kathat@microchip.com> writes:
> 
> >> >>> We need help to review and identify if there are any pending
> >> >>> items for wilc1000 driver, so we can address those issues and
> >> >>> make it ready to move to the wireless subsystem.    
> >> >>
> >> >> I think the best way to get that forward is to submit a patch
> >> >> (or patchset) to linux-wireless, that's the easiest for
> >> >> reviewers.    
> >> >
> >> > For brcm80211 drivers we used a single patch introducing it under
> >> > the wireless drivers folder. Because it was quite a sizable
> >> > patch we parked it on the wireless wiki page. Had a few
> >> > iterations doing it like that.    
> >> 
> >> Another option is to split it so that there's one patch per file,
> >> should be even pretty easy to automate that. It's just so much
> >> easier to comment on a patch submitted by email compared to the
> >> reviewer manually copying code and then commenting it, yuck.
> >>   
> >
> > Sure. I will prepare a patch per file send for review as its easy to
> > review.
> >
> > As Greg suggested, I will wait for the merge window to close and
> > after completing pending patches to staging, I will start the
> > review.
> >
> > For my understanding, the patches for review will be based on
> > wireless-testing branch.  
> 
> In this case I think wireless-drivers-next is the safest choise,
> wireless-testing also has other trees which might cause conflicts etc.

I have submitted a patch series for wilc1000 driver, single file
per patch and its based on wireless-drivers-next. 
I hope its done correctly, please provide inputs so we can
address and make this driver ready for mainline.

Regards,
Ajay

