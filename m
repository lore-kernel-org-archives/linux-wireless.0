Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58F2C0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89E982082D
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89E982082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbeJ3GYj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 02:24:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47938 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbeJ3GYj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 02:24:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gHFAl-0004RY-Hh; Mon, 29 Oct 2018 22:34:07 +0100
Message-ID: <2ffd6546914f4e68e9c4549ae2cbf30b73d2aee8.camel@sipsolutions.net>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Adham.Abozaeid@microchip.com, Ajay.Kathat@microchip.com,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Aditya.Shankar@microchip.com,
        Venkateswara.Kaja@microchip.com, Claudiu.Beznea@microchip.com
Date:   Mon, 29 Oct 2018 22:33:44 +0100
In-Reply-To: <3fa12173-6459-fa3d-54a6-3c73fb05d39a@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         <1539009076.3687.64.camel@sipsolutions.net>
         <5BBE5BCF.5020706@microchip.com>
         <1539241314.3687.190.camel@sipsolutions.net> <5BC11B3B.20901@microchip.com>
         <5c6c7a4d3471a2784d0b203beccd4de9c55b211e.camel@sipsolutions.net>
         <5BC8D148.7050804@microchip.com>
         <492fb11bbe66cdea676e126a70a1ba9e1af3c97b.camel@sipsolutions.net>
         <5BCA4455.1020307@microchip.com>
         <7f6ec3536d71bf62e64f2592f5e1eabe05256563.camel@sipsolutions.net>
         <3fa12173-6459-fa3d-54a6-3c73fb05d39a@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-29 at 21:32 +0000, Adham.Abozaeid@microchip.com wrote:
> 
> Correct. The speed of executing the work will be the same in both
> cases (maybe a little slower in case of deferring the work)
> The intuition here was to do minimum work in the cfg's context, but
> since this isn't a concern, I can skip deferring the work.

It sort of depends. Practically all of this is done with the RTNL held,
so you might be blocking _other_ things that need the RTNL. I'm not sure
if that matters that much, but still ...

Regardless, I'd try this first. Perhaps you can even see later that only
some commands take a long time, and others are quicker. Having
wpa_supplicant/hostapd not know when an operation is really completed is
unlikely to be a good idea, IMHO.

johannes

