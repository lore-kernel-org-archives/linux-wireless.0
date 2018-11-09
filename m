Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74B0C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 20:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5565A20827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 20:27:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5565A20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=milecki.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbeKJGJP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Nov 2018 01:09:15 -0500
Received: from 9.mo5.mail-out.ovh.net ([178.32.96.204]:41598 "EHLO
        9.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725752AbeKJGJP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Nov 2018 01:09:15 -0500
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2018 01:09:15 EST
Received: from player792.ha.ovh.net (unknown [10.109.159.248])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 062BF2036EB
        for <linux-wireless@vger.kernel.org>; Fri,  9 Nov 2018 21:11:08 +0100 (CET)
Received: from RCM-web4.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player792.ha.ovh.net (Postfix) with ESMTPSA id 7582FA00A3;
        Fri,  9 Nov 2018 21:10:56 +0100 (CET)
Received: from ip-194-187-74-233.konfederacka.maverick.com.pl
 ([194.187.74.233])
 via ip-194-187-74-233.konfederacka.maverick.com.pl
 ([194.187.74.233])
 by mail.ovh.net
 with HTTP (HTTP/1.1 POST); Fri, 09 Nov 2018 21:10:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 09 Nov 2018 21:10:56 +0100
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, stable@vger.kernel.org
Subject: Re: [PATCH FIX] brcmfmac: fix reporting support for 160 MHz channels
In-Reply-To: <87lg62cpno.fsf@codeaurora.org>
References: <20181108150829.24842-1-zajec5@gmail.com>
 <87lg62cpno.fsf@codeaurora.org>
Message-ID: <f1e1160ba35a42e12a0162629be23304@milecki.pl>
X-Sender: rafal@milecki.pl
User-Agent: Roundcube Webmail/1.3.8
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
X-Ovh-Tracer-Id: 16851343908361113112
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrkeefgddufeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-09 15:05, Kalle Valo wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
> 
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> Driver can report IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ so it's
>> important to provide valid & complete info about supported bands for
>> each channel. By default no support for 160 MHz should be assumed 
>> unless
>> firmware reports it for a given channel later.
>> 
>> This fixes info passed to the userspace. Without that change userspace
>> could try to use invalid channel and fail to start an interface.
>> 
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> Cc: stable@vger.kernel.org
> 
> Should this be queued to 4.20?

That's my suggestion.

I try to mark fixes (patches for currently developed release) with an
extra FIX tag in a subject. Do you see those when using your patchwork
tool? Do you have any other method in mind that would be preferred by
you?
