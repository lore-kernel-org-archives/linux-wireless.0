Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C83C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71CBE2075C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71CBE2075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbeJHVp5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:45:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56562 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbeJHVp5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:45:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9Wbb-0008Ca-1H; Mon, 08 Oct 2018 16:33:55 +0200
Message-ID: <1539009224.3687.68.camel@sipsolutions.net>
Subject: Re: [PATCH 05/19] wilc: add wilc_wlan_if.h
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Mon, 08 Oct 2018 16:33:44 +0200
In-Reply-To: <1537957525-11467-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180926_122555_951472_AF2668E3)
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-6-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122555_951472_AF2668E3)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +#define WILC_TX_ERR_NO_BUF	(-2)

Hmm? what's wrong with just e.g. -ENOBUFS? If it doesn't go to userspace
it doesn't matter, and if it does you can't use this anyway? This would
be -ENOENT which is a bad idea.

> +
> +/********************************************
> + *
> + *      Wlan Configuration ID
> + *
> + ********************************************/
> +#define WILC_MULTICAST_TABLE_SIZE	8
> +#define MAX_SSID_LEN            33

Err, it's 32?

> +#define MAX_RATES_SUPPORTED     12
> +
> +enum bss_types {
> +	INFRASTRUCTURE		= 0,
> +	INDEPENDENT,
> +	AP,
> +};
> +
> +enum {
> +	B_ONLY_MODE		= 0,    /* 1, 2 M, otherwise 5, 11 M */
> +	G_ONLY_MODE,			/* 6,12,24 otherwise 9,18,36,48,54 */
> +	G_MIXED_11B_1_MODE,		/* 1,2,5.5,11 otherwise all on */
> +	G_MIXED_11B_2_MODE,		/* 1,2,5,11,6,12,24 otherwise all on */
> +};
> +
> +enum {
> +	G_SHORT_PREAMBLE	= 0,	/* Short Preamble */
> +	G_LONG_PREAMBLE		= 1,	/* Long Preamble */
> +	G_AUTO_PREAMBLE		= 2,	/* Auto Preamble Selection */
> +};

here we have a lot of those "constants should have some sort of prefix"
things ... it's not even clear if they're spec or not:

> +enum authtype {
> +	OPEN_SYSTEM		= 1,
> +	SHARED_KEY		= 2,
> +	ANY			= 3,
> +	IEEE8021		= 5
> +};

These look like they're spec but aren't ... not a good idea.

johannes
