Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C3FC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45FAA20825
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:24:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45FAA20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbeKIWFU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:05:20 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57508 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbeKIWFU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:05:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gL5qG-0004fC-7b; Fri, 09 Nov 2018 13:24:52 +0100
Message-ID: <dda0f03868f631ba9f76170e19dd28099a0e0add.camel@sipsolutions.net>
Subject: Re: [PATCH 1/4] New netlink command for TID specific configuration
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Date:   Fri, 09 Nov 2018 13:24:51 +0100
In-Reply-To: <20181109094017.j4vkhaprz4zmszch@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
         <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
         <20181107140552.zfuusbapgqjumoln@bars>
         <0b75171a7777bd25e203240a3a119cb5@codeaurora.org>
         <20181109094017.j4vkhaprz4zmszch@bars>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-11-09 at 09:40 +0000, Sergey Matyukevich wrote:
> 
> Ok. So if driver receives retry value (-1), it should reset to some
> default value known to driver or firmware. IMHO it worth making it
> more explicit: in its current form this convention will not be obvious
> for driver authors. Though I don't have a good idea how to do it.
> Maybe merge both aggregation and retry cfg80211 callbacks into one
> and use structure for params and bitmask for operations...

I think we want that anyway, I just suggested to also add the "noack" to
the same API, and indeed it's pointless to set retries and noack.

johannes

