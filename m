Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63809C352AA
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 07:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EB9F21783
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 07:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732905AbfJAHcr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 03:32:47 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55946 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbfJAHcr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 03:32:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFCeL-0000u5-27; Tue, 01 Oct 2019 09:32:45 +0200
Message-ID: <7b920db4e91a7e68f9eeacd95339b5f509e3273b.camel@sipsolutions.net>
Subject: Re: bug: nl80211 / brcmfmac broken for bcm4329/bcm4330 sdio in
 linux-next
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Peter Geis <pgwipeout@gmail.com>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 01 Oct 2019 09:32:43 +0200
In-Reply-To: <CAMdYzYpqYbgb-9s1VPSreoosQ=BPnhzC_gKOzbGipKikk5+4zA@mail.gmail.com> (sfid-20190930_194259_322677_22853590)
References: <CAMdYzYpqYbgb-9s1VPSreoosQ=BPnhzC_gKOzbGipKikk5+4zA@mail.gmail.com>
         (sfid-20190930_194259_322677_22853590)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Since 5.3 landed, brcmfmac has been broken both on bcm4329 and bcm4330
> sdio devices.

Yep, thanks for the report. I don't think you mean 5.3, as that doesn't
contain the problematic commit as far as I can tell? That was commit
2a38075cd0be ("nl80211: Add support for EDMG channels").

I have a fix for this already pending I believe:
https://patchwork.kernel.org/patch/11156631/

johannes

