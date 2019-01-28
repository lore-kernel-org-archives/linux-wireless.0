Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144FAC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 04:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D28482148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 04:49:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="APHAvwJF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="APHAvwJF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfA1Etj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 23:49:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfA1Etj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 23:49:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B0370602CB; Mon, 28 Jan 2019 04:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548650978;
        bh=9ADLyjPg/eTugLlOqMObgt2nc2TRFExz3VMex+1uGeo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=APHAvwJFfwsDCreY+g3K42tMfQn/MdlFEocIHo/FFIvKqHmivK0vTiR/eRgp6R6d5
         UBJrqex74FjXwFab1Y+1ktiL7gY5anVSnBkgqmfVtfOr/qXHaVQgREaNNajJC2l5M2
         M3HBvw8NuAoYWXp+sY5Bb6Do9CAylledYC7O34uc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 0F5E96055A;
        Mon, 28 Jan 2019 04:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548650978;
        bh=9ADLyjPg/eTugLlOqMObgt2nc2TRFExz3VMex+1uGeo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=APHAvwJFfwsDCreY+g3K42tMfQn/MdlFEocIHo/FFIvKqHmivK0vTiR/eRgp6R6d5
         UBJrqex74FjXwFab1Y+1ktiL7gY5anVSnBkgqmfVtfOr/qXHaVQgREaNNajJC2l5M2
         M3HBvw8NuAoYWXp+sY5Bb6Do9CAylledYC7O34uc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 28 Jan 2019 10:19:37 +0530
From:   Karthikeyan Periyasamy <periyasa@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] ath10k: Add QCA vendor command/attr support to
 filterneighbor BSS frames
In-Reply-To: <69a99a7f1b2b7434b70c5c6df1812952928547cc.camel@sipsolutions.net>
References: <1530791512-6915-3-git-send-email-periyasa@codeaurora.org>
 <20181005060031.BA1EB60BF4@smtp.codeaurora.org>
 <a28348956ba3fbfded80bc78ba1c0335df7edb75.camel@sipsolutions.net>
 <c9b16303e344b2dcd4d52cf9c0830846@codeaurora.org>
 <69a99a7f1b2b7434b70c5c6df1812952928547cc.camel@sipsolutions.net>
Message-ID: <7212e3a5157ab61d10b8d7184e290593@codeaurora.org>
X-Sender: periyasa@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-01-26 02:19, Johannes Berg wrote:
> 
> Sure. I guess my question was intended more along the lines of "how 
> much
> CPU impact would you be able to live with?" :-)

As much as no CPU impact.

> At the same time, what happens today actually? Do all frames from non-
> associated clients come up to the host? If so, is this not a problem 
> for
> all APs, not just ath10k?
> 

Today, without this patch. No frames from non-associated clients come up 
to the host in AP mode.

> And if they don't come up, what feature requires this? Sorry for the
> vague questions, but I'm not really sure what this is all about. If
> there's a need for these frames, wouldn't we need a generic way of
> enabling receiving them, and perhaps even signalling hostapd with them?

Steering application use this feature in their logical part of client 
steering.

This feature allow an application to configure filtering rules to 
capture from
stations that are active on the operating channel but not associated to 
this AP.
It also allow to get the statistics information of the configured non 
associated stations.

Ath10k driver use HW filter to capture other BSS frames and drop these 
packets
after collecting statistics information of configured non associated 
stations.

QCA vendor command/attr details:
https://w1.fi/cgit/hostap/commit/?id=6b21df0bb7a261ef890a02d1fef95ffa5ff54cfc


> Also, what are the statistics and what do you intend to use them for?

In this patch, we are providing the below information as a statistics of 
non associated stations.

- MAC address
- Last received signal strength
- Time stamp of the last received signal strength

Thanks,
Karthikeyan
