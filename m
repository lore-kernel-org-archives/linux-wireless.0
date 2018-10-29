Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B7CC0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 20:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 185242082D
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 20:30:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dCZpso9x";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dCZpso9x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 185242082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbeJ3FUd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 01:20:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729553AbeJ3FUc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 01:20:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6E7846076A; Mon, 29 Oct 2018 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540845015;
        bh=HjXl8fZ3t5xjGGYcsUsAYNirLZrqBWMhD7HH7fMqGQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dCZpso9xeIuiAtqoxnMnoZm8HmrhuRxwOWdt/gYLmKSzsZZ5drgvwWbs5nKrJIdZV
         qpDONt7JANOpTx8k7oNK9dgGhjqM8Vbg0VQGc3gRhUPhoMRNiiydDKfkvdWfRb/NZ4
         Q16n4Fh1DffgP8xXAF34nGg6uOrw3JqEzjkBi938=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 131CB602BC;
        Mon, 29 Oct 2018 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540845015;
        bh=HjXl8fZ3t5xjGGYcsUsAYNirLZrqBWMhD7HH7fMqGQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dCZpso9xeIuiAtqoxnMnoZm8HmrhuRxwOWdt/gYLmKSzsZZ5drgvwWbs5nKrJIdZV
         qpDONt7JANOpTx8k7oNK9dgGhjqM8Vbg0VQGc3gRhUPhoMRNiiydDKfkvdWfRb/NZ4
         Q16n4Fh1DffgP8xXAF34nGg6uOrw3JqEzjkBi938=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Oct 2018 13:30:15 -0700
From:   Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Subject: Re: [PATCH] mac80211: support FTM responder configuration/statistics
In-Reply-To: <3025909cb6950d7b8b30b4b659b3676df164e3d0.camel@sipsolutions.net>
References: <1538623160-25886-1-git-send-email-pradeepc@codeaurora.org>
 (sfid-20181004_051935_494006_E9A4C858)
 <c832f9007e0a844d3335a0cd9996818f49df2311.camel@sipsolutions.net>
 <765cbdd596e96b7cf73239a4e04b06a7@codeaurora.org>
 <389c2e4819c83330a3b652f2a45ff024ec94cd2c.camel@sipsolutions.net>
 <03f51a115f6d71923c3212af25c470d3@codeaurora.org>
 <3025909cb6950d7b8b30b4b659b3676df164e3d0.camel@sipsolutions.net>
Message-ID: <64d9763ad7226a2a08c93b8001b38185@codeaurora.org>
X-Sender: pradeepc@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> Yes, but we may not get there?
> 
>         if (!need_new_beacon)
>                 goto skip_beacons;
ah!..yes...Thanks..


