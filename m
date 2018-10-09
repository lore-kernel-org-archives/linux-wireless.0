Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C26C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 11:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A94B213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 11:46:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A94B213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbeJITC5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 15:02:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52244 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbeJITC5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 15:02:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9qSy-000304-Po; Tue, 09 Oct 2018 13:46:21 +0200
Message-ID: <1539085569.3687.115.camel@sipsolutions.net>
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Tue, 09 Oct 2018 13:46:09 +0200
In-Reply-To: <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com>
         <1539008417.3687.57.camel@sipsolutions.net>
         <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
         <1539081379.3687.112.camel@sipsolutions.net>
         <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 17:14 +0530, Ajay Singh wrote:
> On 10/9/2018 4:06 PM, Johannes Berg wrote:
> > On Tue, 2018-10-09 at 16:04 +0530, Ajay Singh wrote:
> > 
> > > > > +typedef void (*wilc_remain_on_chan_expired)(void *, u32);
> > > > > +typedef void (*wilc_remain_on_chan_ready)(void *);
> > > 
> > > I think as per coding style the typedef for function pointer are allowed.
> > 
> > True, I guess, but why do you need them?
> 
> Actually these function pointer are used in multiple places i.e inside
> the struct and also for passing as the argument for the function. So i
> think its better to keep them as typedef to simplify and avoid any 'line
> over 80 chars' checkpatch issue. But anyway if you suggest we can modify
> to remove these typedefs .

I guess that must be part of the internal bounce buffer mechanism? I
guess leave them for now and see what falls out.

> > > > > +struct hidden_network {
> > > > > 
> Yes, its not related to hidden SSID. Suppose cfg80211 scan is called
> with SSID information(active scan) then SSID info will be maintained in
> this structure.

so maybe rename this?

johannes
