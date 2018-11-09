Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCE6C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 634FE20840
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 634FE20840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbeKIVIT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:08:19 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56552 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeKIVIT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:08:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gL4xH-0003Nr-CA; Fri, 09 Nov 2018 12:28:03 +0100
Message-ID: <218bac09a559cd0d1c6cdc5d9c4dbd4b33ffca1c.camel@sipsolutions.net>
Subject: Re: [PATCH 0/6] wireless: Per-sta NoAck and offload support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 09 Nov 2018 12:28:01 +0100
In-Reply-To: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org> (sfid-20181016_204254_690922_6A9D8E64)
References: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
         (sfid-20181016_204254_690922_6A9D8E64)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Adds infrastructure for driver to offload NoAck functionality,
> driver like ath10k could make use of it. Also extends the
> current ndev wide NoAck policy to per-station, with sta level
> NoAck policy configuration userspace could selectively turn off/on
> Noack based on various connection parameters of the station.

So ... we have this, but we also have

[PATCH 0/4] cfg80211/mac80211: Add support for TID specific configuration

which you were involved in.

Unless you can cite a good reason not to, I think it would make sense to
combine the two and make "noack" just another attribute in the TID
configuration.

johannes

