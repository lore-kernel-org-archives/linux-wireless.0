Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7774AC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 20:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0798120645
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 20:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="Ej5Elatr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0798120645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbeJDDFR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 23:05:17 -0400
Received: from mail.toke.dk ([52.28.52.200]:58669 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726941AbeJDDFR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 23:05:17 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538597722; bh=Tsr+JRZJC9GhrvaihO69jGHqTuMgrjpdIEPrtmw7cXM=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=Ej5ElatrvAUnKsTNDITkh6pP8G9DUxGqmxIS/BjqX13cR9iwP+VHMmy7j1ZhtfGEI
         fqd5RnXcMQisU0YhOxK7EqGFuHlSs8EKWiud76MkHvPqhOOlsZfAuw1BY3XVahl5bk
         bFaf4EIgVkNasQkPWwIZB/S024tJVyVbPzxZJAoaWcHMfI1Y50bNPglWhgwXtXVLWE
         jCnxy608HSrh18rW/tSs2l1WMC2+vnTVVlFpFbQ6Adkw03GMvexGtGViaA454QqDt+
         KXJ1ZNDvmUsaRv8ex00bt911iYfkR0UB/e8JBIC5MyddaP65J1fxMFzzm7giY10YcK
         rDT2RK4cPV32Q==
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tool to debug wifi pkt sniffs?
In-Reply-To: <a44e3947-29a9-d7ba-abec-59bc1b92b201@candelatech.com>
References: <a44e3947-29a9-d7ba-abec-59bc1b92b201@candelatech.com>
Date:   Wed, 03 Oct 2018 22:15:19 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pnwqaiso.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:

> Hello,
>
> I often find myself wanting to figure out what equipment is to blame (and why)
> in a wifi environment.
>
> I am thinking writing a tool that would parse a pcap file and look at frames
> in enough detail to flag block-ack bugs, rate-ctrl bugs, guess at the sniffer's
> capture ability, etc.
>
> Does anyone have anything already written that they would like to share, or know
> of projects that might already do some of this?

Not sure if this fits your criteria, but Sven's tool to create airtime
charts from packet sniffing data immediately came to mind:

https://github.com/cloudtrax/airtime-pie-chart

-Toke
