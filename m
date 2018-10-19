Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C15ECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 07:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FBD52087A
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 07:05:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FBD52087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbeJSPJr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 11:09:47 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47366 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeJSPJq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 11:09:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gDOqB-0004AW-My; Fri, 19 Oct 2018 09:04:59 +0200
Message-ID: <cc30df441c843bf205ed8dff7b952ea22ff0dfe3.camel@sipsolutions.net>
Subject: Re: FTM support on ath10k
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arthur Watt <arthur.watt@virtuosys.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     "pradeepc@codeaurora.org" <pradeepc@codeaurora.org>
Date:   Fri, 19 Oct 2018 09:04:44 +0200
In-Reply-To: <DB7PR07MB4665D6F6B47475B1F7AFD1B4FFF80@DB7PR07MB4665.eurprd07.prod.outlook.com>
References: <DB7PR07MB4665D6F6B47475B1F7AFD1B4FFF80@DB7PR07MB4665.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> I am interested in contributing to the development and testing of FTM
> using ath10k devices.
> Currently I am running a standard 4.14 kernel

I guess you'd have to upgrade to something you compiled yourself :-)

>  and have QCA988X (WLE600VX) and QCA9984 (WLE1216V5) devices.
> My QCA9984 is running 10.4.3 firmware and the QCA988X is using
> 10.2.4.70.66.
> 
> Would it be possible for me to build/test some of the FTM changes, or
> is this very much a work in progress and not useable by other people.
> I can see that FTM spans a number of components:
>   Userpace (hostapd, wpa_supplicant)
>   cfg80211 (nl80211)
>   mac80211
>   ath10k driver.
> I would also be interested if it was possible to test FTM from a test
> harness around the ath10k?

I don't know. So far ath10k only has FTM responder code out, I think,
not FTM initiator.

No userspace tooling around it exists, as far as I know.

We're still working on both initiator and responder support for iwlwifi.

johannes

