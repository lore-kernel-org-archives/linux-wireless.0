Return-Path: <SRS0=5LI1=BA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391DCC433E6
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 17:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 214B42068F
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 17:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgGURZ3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Jul 2020 13:25:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47740 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729107AbgGURZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Jul 2020 13:25:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxw0w-006CkE-OX; Tue, 21 Jul 2020 19:25:14 +0200
Date:   Tue, 21 Jul 2020 19:25:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dianders@chromium.org, evgreen@chromium.org
Subject: Re: [RFC 0/7] Add support to process rx packets in thread
Message-ID: <20200721172514.GT1339445@lunn.ch>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jul 21, 2020 at 10:44:19PM +0530, Rakesh Pillai wrote:
> NAPI gets scheduled on the CPU core which got the
> interrupt. The linux scheduler cannot move it to a
> different core, even if the CPU on which NAPI is running
> is heavily loaded. This can lead to degraded wifi
> performance when running traffic at peak data rates.
> 
> A thread on the other hand can be moved to different
> CPU cores, if the one on which its running is heavily
> loaded. During high incoming data traffic, this gives
> better performance, since the thread can be moved to a
> less loaded or sometimes even a more powerful CPU core
> to account for the required CPU performance in order
> to process the incoming packets.
> 
> This patch series adds the support to use a high priority
> thread to process the incoming packets, as opposed to
> everything being done in NAPI context.

I don't see why this problem is limited to the ath10k driver. I expect
it applies to all drivers using NAPI. So shouldn't you be solving this
in the NAPI core? Allow a driver to request the NAPI core uses a
thread?

	Andrew
