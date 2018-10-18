Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889D6C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 575DC208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:23:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 575DC208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbeJRQX0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 12:23:26 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59828 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbeJRQX0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 12:23:26 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gD3ae-0002cf-Pd; Thu, 18 Oct 2018 10:23:32 +0200
Message-ID: <627fbc583ac6679cc9986959d84e15467eaea897.camel@sipsolutions.net>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Adham.Abozaeid@microchip.com, Ajay.Kathat@microchip.com,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Aditya.Shankar@microchip.com,
        Venkateswara.Kaja@microchip.com, Claudiu.Beznea@microchip.com
Date:   Thu, 18 Oct 2018 10:23:17 +0200
In-Reply-To: <5BC11842.1050700@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81) <1539202484.3687.188.camel@sipsolutions.net>
         <5BC11842.1050700@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-10-12 at 21:55 +0000, Adham.Abozaeid@microchip.com wrote:
> 
> Here the driver is configuring parameters in the device by sending a
> WID command for each parameters.
> The val pointer points to the value of the parameter to be set, and
> here all parameters being set to 0 were sharing the dummyval variable.

Ok.

> Looking again at this, these constant parameters can be omitted from
> the driver and done on the device instead.

I think it's fine, just the pointers look strange. Would probably be
different once you resolve the middle layer though.

> > > +	if (conn_attr->bssid)
> > > +		memcpy(cur_byte, conn_attr->bssid, 6);
> > > +	cur_byte += 6;
> > 
> > u8 bssid[ETH_ALEN];
> > 
> > > +	if (conn_attr->bssid)
> > > +		memcpy(cur_byte, conn_attr->bssid, 6);
> > > +	cur_byte += 6;
> > 
> > again?
> 
> Agree. Can be changed to avoid duplication. Requires a matching change on the device.

Again, like above, don't worry too much about changing the
device/firmware. I was just pointing out it's duplicate, if that's the
way it is then too bad, but it doesn't really matter.

The more interesting thing here is to change it to use a struct and not
pack it manually.

johannes

