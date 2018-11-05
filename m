Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29680C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2B3C20827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:57:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2B3C20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbeKFBSG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 20:18:06 -0500
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:39055 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729600AbeKFBSG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 20:18:06 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 2C974182CF674;
        Mon,  5 Nov 2018 15:57:44 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: lift81_434fe191cb607
X-Filterd-Recvd-Size: 2307
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Mon,  5 Nov 2018 15:57:42 +0000 (UTC)
Message-ID: <0bbb80aef8f5d133335787c08c46a7a104072f81.camel@perches.com>
Subject: Re: [PATCH 4/8] staging: wilc1000: avoid line over 80 chars in
 wilc_parse_network_info()
From:   Joe Perches <joe@perches.com>
To:     Ajay.Kathat@microchip.com, linux-wireless@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Aditya.Shankar@microchip.com,
        Adham.Abozaeid@microchip.com, johannes@sipsolutions.net
Date:   Mon, 05 Nov 2018 07:57:41 -0800
In-Reply-To: <fcd1665b-4e75-54f0-ff77-08807fa311f6@microchip.com>
References: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
         <1541090691-31928-5-git-send-email-ajay.kathat@microchip.com>
         <0244e9225446db503360d9c024e0eb7e25c29944.camel@perches.com>
         <fcd1665b-4e75-54f0-ff77-08807fa311f6@microchip.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-11-05 at 12:18 +0000, Ajay.Kathat@microchip.com wrote:
> Hi Joe,
> 
> On 11/5/2018 4:27 PM, Joe Perches wrote:
> > On Thu, 2018-11-01 at 16:45 +0000, Ajay.Kathat@microchip.com wrote:
> > > From: Ajay Singh <ajay.kathat@microchip.com>
> > > 
> > > Use shorter name for 'network_info' variable to avoid line over 80 chars
> > > issue.
> > 
> > I suppose this is OK, though perhaps unnecessary.
> > 
> > As well, perhaps there are defects in the original code
> > in a couple places.
> > 
> > > diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> > []
> > > -		network_info->tsf_hi = le64_to_cpu(mgt->u.beacon.timestamp);
> > > -		network_info->tsf_lo = (u32)network_info->tsf_hi;
> > Perhaps there is a defect for both tsf_hi assignments
> > as it appears as if both are missing ">> 32"
> 
> Actually, 'tsf_hi' is used to store the complete tsf value as its data
> type is u64.  This value is pass to the cfg80211_inform_bss() as it is.
> So the conversion of 'tsf_hi' to 32 bit  is not required in this case.

Antipattern naming generally warrants a rename.


