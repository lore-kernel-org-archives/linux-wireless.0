Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACCBC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F08BA20835
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:02:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F08BA20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbeJKO2F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 10:28:05 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53690 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeJKO2E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 10:28:04 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAUz2-0004Ra-MW; Thu, 11 Oct 2018 09:02:08 +0200
Message-ID: <1539241314.3687.190.camel@sipsolutions.net>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Adham.Abozaeid@microchip.com, Ajay.Kathat@microchip.com,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Aditya.Shankar@microchip.com,
        Venkateswara.Kaja@microchip.com, Claudiu.Beznea@microchip.com
Date:   Thu, 11 Oct 2018 09:01:54 +0200
In-Reply-To: <5BBE5BCF.5020706@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81) <1539009076.3687.64.camel@sipsolutions.net>
         <5BBE5BCF.5020706@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> Agree. parameter validation can be done before scheduling the work,
> and hence appropriate error can be returned to caller .


> If I got your point correctly, you are referring to the lines that
> stores the parameters into the hif_drv->cfg_values.

Well, I was actually thinking that I'm not even sure why you schedule
work at all!

> Instead of packing the parameters in host structures like struct
> add_sta_param, then repacking it in the device format, it can use
> struct station_parameters and pack them directly into the device
> format

Makes sense. Also note my other email on how there should be structs
involved, rather than open-coded WID entry lists.

johannes
