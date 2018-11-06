Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0BEC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 07:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFFD02085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 07:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="oZNwzSMQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFFD02085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387578AbeKFQir (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:38:47 -0500
Received: from plaes.org ([188.166.43.21]:45836 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387428AbeKFQir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 11:38:47 -0500
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id 0183C403F3;
        Tue,  6 Nov 2018 07:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1541488497; bh=qfDdA4UHTUPJaAYoagSNH6due7eAUw8WMl7X64J+vz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oZNwzSMQiGz/dTL/hgPoeYVm0HYKku3jrNJgOuoDQngX4zM5djkSpqwVWok4POCtD
         mK8nTnKlNcczBdqPE7NwkZGK0nLAT89TnVn6lSLE8Lc3il959LXrkHua3kTGSu9t9F
         wXx07qmdZPSrBA12xzRI3emzY5zs6R0MZOjqafGFgTsYQD3N93x+UVCSwkud8A9e+t
         F4vjjFHwAGBUKg9Gs6SM7zMf0Yg1ESbADRY9pSPhyFj8i5WNaPGQ2tvz/uWeXiTsog
         wQPJE9+mww5piyB0Ts+VSTUFGuKifT2MUPqiWp6hpHeHwK9sf7kYV9us5qPq0Fe1bx
         6wZn2AZ2iaONg==
Date:   Tue, 6 Nov 2018 07:14:55 +0000
From:   Priit Laes <plaes@plaes.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] lib: cordic: Move cordic macros and defines to
 header file
Message-ID: <20181106071455.ch6wooqibm76tyjl@plaes.org>
References: <cover.9ec98292c595a111ae78f31383ff8618c9cb04da.1541446422.git-series.plaes@plaes.org>
 <3be396e01b33905e9ac5c80e7038b7aacf72eaf8.1541446422.git-series.plaes@plaes.org>
 <8eb0e232-d14b-60d9-e3c8-008c46659a30@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eb0e232-d14b-60d9-e3c8-008c46659a30@broadcom.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Nov 05, 2018 at 11:02:35PM +0100, Arend van Spriel wrote:
> On 11/5/2018 8:37 PM, Priit Laes wrote:
> > Also append CORDIC_ prefix to nonprefixed macros.
> 
> Bit annoying that you made me look at LKML for this patch. Can you just post
> the entire series to linux-wireless so Kalle can take it all through his
> tree. Also the commit message is a bit thin. Please explain why these are
> moved to the header file.

Sorry, I messed up again while trying to automate the send-email with
get_maintainers script (dry-run argument did not work .gitconfig :S)

> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > Signed-off-by: Priit Laes <plaes@plaes.org>
> > ---
> >  include/linux/cordic.h |  9 +++++++++
> >  lib/cordic.c           | 23 +++++++----------------
> >  2 files changed, 16 insertions(+), 16 deletions(-)
> 
