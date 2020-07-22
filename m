Return-Path: <SRS0=b555=BB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96263C433E5
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Jul 2020 16:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A07D2065F
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Jul 2020 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595434809;
	bh=xqB+ywDGvJFkgmF2+tJVX0IcLGW/r2TAe7nxQSJGg5A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=nFmW1RRjHji4aOUtQhpEJXxthtEAs015lmP/aJq0bVkWPIJA5rnQCeFvnSsxCSaJ0
	 WVqqt802MQ5ceVJoMy2G+vSIvHsKBAybaPEUakVTegWnaSTZK/VSGa6yNWrQXVsLXn
	 eeF4AVobPkOiWSwFXT9BsR9WygnlY70sPgasrXhg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgGVQUE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 22 Jul 2020 12:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726938AbgGVQUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Jul 2020 12:20:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2763520771;
        Wed, 22 Jul 2020 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595434803;
        bh=xqB+ywDGvJFkgmF2+tJVX0IcLGW/r2TAe7nxQSJGg5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S68k2PipvzaisQOZTk6U+DfQeK7zpG1ga4w8z1T7nPX6Aep/WFSXGWTMohZM2CzEC
         DN/tUimFK6xy8t/EEmdUbNxZDoqeqj5lKuj1PrRUrQdv4tJOq2mLfRMSfyQjO11pJH
         2gh5GwkuMB9uk+BgQ52tceHdrpFaneVEOPI1ycR4=
Date:   Wed, 22 Jul 2020 09:20:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        davem@davemloft.net, netdev@vger.kernel.org, dianders@chromium.org,
        evgreen@chromium.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC 0/7] Add support to process rx packets in thread
Message-ID: <20200722092001.62f3772c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721172514.GT1339445@lunn.ch>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
        <20200721172514.GT1339445@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 21 Jul 2020 19:25:14 +0200 Andrew Lunn wrote:
> On Tue, Jul 21, 2020 at 10:44:19PM +0530, Rakesh Pillai wrote:
> > NAPI gets scheduled on the CPU core which got the
> > interrupt. The linux scheduler cannot move it to a
> > different core, even if the CPU on which NAPI is running
> > is heavily loaded. This can lead to degraded wifi
> > performance when running traffic at peak data rates.
> > 
> > A thread on the other hand can be moved to different
> > CPU cores, if the one on which its running is heavily
> > loaded. During high incoming data traffic, this gives
> > better performance, since the thread can be moved to a
> > less loaded or sometimes even a more powerful CPU core
> > to account for the required CPU performance in order
> > to process the incoming packets.
> > 
> > This patch series adds the support to use a high priority
> > thread to process the incoming packets, as opposed to
> > everything being done in NAPI context.  
> 
> I don't see why this problem is limited to the ath10k driver. I expect
> it applies to all drivers using NAPI. So shouldn't you be solving this
> in the NAPI core? Allow a driver to request the NAPI core uses a
> thread?

Agreed, this is a problem we have with all drivers today.
We see seriously sub-optimal behavior in data center workloads, 
because kernel overloads the cores doing packet processing.

I think the fix may actually be in the scheduler. AFAIU the scheduler
counts the softIRQ time towards the interrupted process, and on top
of that tries to move processes to the cores handling their IO. In the
end the configuration which works somewhat okay is when each core has
its own IRQ and queues, which is seriously sub-optimal.
