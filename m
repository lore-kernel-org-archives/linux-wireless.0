Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D5BC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 12:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B102192B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 12:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfBOMhz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 07:37:55 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40072 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfBOMhz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 07:37:55 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1guckZ-0007MC-3Q; Fri, 15 Feb 2019 13:37:51 +0100
Message-ID: <dd920f575478bee3cc071765c9e848e3d2dfffab.camel@sipsolutions.net>
Subject: Re: [RFC 2/2] ath10k: Add QCA vendor command/attr support to
 filterneighbor BSS frames
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Karthikeyan Periyasamy <periyasa@codeaurora.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Date:   Fri, 15 Feb 2019 13:37:49 +0100
In-Reply-To: <7212e3a5157ab61d10b8d7184e290593@codeaurora.org>
References: <1530791512-6915-3-git-send-email-periyasa@codeaurora.org>
         <20181005060031.BA1EB60BF4@smtp.codeaurora.org>
         <a28348956ba3fbfded80bc78ba1c0335df7edb75.camel@sipsolutions.net>
         <c9b16303e344b2dcd4d52cf9c0830846@codeaurora.org>
         <69a99a7f1b2b7434b70c5c6df1812952928547cc.camel@sipsolutions.net>
         <7212e3a5157ab61d10b8d7184e290593@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-01-28 at 10:19 +0530, Karthikeyan Periyasamy wrote:

> > At the same time, what happens today actually? Do all frames from non-
> > associated clients come up to the host? If so, is this not a problem 
> > for all APs, not just ath10k?
> 
> Today, without this patch. No frames from non-associated clients come up 
> to the host in AP mode.

So it's not just _filtering_ but also enabling to see them, right?

> > And if they don't come up, what feature requires this? Sorry for the
> > vague questions, but I'm not really sure what this is all about. If
> > there's a need for these frames, wouldn't we need a generic way of
> > enabling receiving them, and perhaps even signalling hostapd with them?
> 
> Steering application use this feature in their logical part of client 
> steering.

But there aren't even any steering applications that are open source or
anything like that, right?

I don't see why we should include this upstream. Clearly you can use
this for whatever you like to do with your driver in non-upstream
builds, and you can open-source this code, but if there are no
applications that could possibly use it upstream why bother?

johannes

