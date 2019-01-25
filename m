Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75303C282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4155C217D4
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfAYUtb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:49:31 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:39736 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbfAYUtb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:49:31 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn8Pn-0005LP-Fp; Fri, 25 Jan 2019 21:49:27 +0100
Message-ID: <69a99a7f1b2b7434b70c5c6df1812952928547cc.camel@sipsolutions.net>
Subject: Re: [RFC 2/2] ath10k: Add QCA vendor command/attr support to
 filterneighbor BSS frames
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Karthikeyan Periyasamy <periyasa@codeaurora.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Date:   Fri, 25 Jan 2019 21:49:26 +0100
In-Reply-To: <c9b16303e344b2dcd4d52cf9c0830846@codeaurora.org>
References: <1530791512-6915-3-git-send-email-periyasa@codeaurora.org>
         <20181005060031.BA1EB60BF4@smtp.codeaurora.org>
         <a28348956ba3fbfded80bc78ba1c0335df7edb75.camel@sipsolutions.net>
         <c9b16303e344b2dcd4d52cf9c0830846@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-11-20 at 08:10 +0530, Karthikeyan Periyasamy wrote:

> > This patch only talks about "allow an AP" etc. and so while important,
> > power isn't the _utmost_ concern like on mobile. Given an efficient
> > filtering solution in software, would that be sufficient?
> 
> Assume in a scenario where there are multiple APs (One Center AP and 
> Multiple repeater AP) in same operating channel.
> Clients present in Neighbor APs causing higher traffic.
> 
> when we try to filter desire client packets,
> In HW offload case, all Neighbor BSS packets are filtered by HW. so 
> there is no impact in CPU load. AP performance not get impacted.
> In bpf (enabling monitor mode) case, all Neighbor BSS packets get 
> filtered by software. It will consume CPU load which will impact AP 
> performance.
> 
> Irrespective of how many neighbor APs present in the topology, HW 
> offload take care of neighbor BSS filtering. Hence no impact in CPU 
> load.
> so we decided to use HW offload. To use our HW offload feature, we ended 
> up in vendor command approach.

Sure. I guess my question was intended more along the lines of "how much
CPU impact would you be able to live with?" :-)

At the same time, what happens today actually? Do all frames from non-
associated clients come up to the host? If so, is this not a problem for
all APs, not just ath10k?

And if they don't come up, what feature requires this? Sorry for the
vague questions, but I'm not really sure what this is all about. If
there's a need for these frames, wouldn't we need a generic way of
enabling receiving them, and perhaps even signalling hostapd with them?

Also, what are the statistics and what do you intend to use them for?

johannes

