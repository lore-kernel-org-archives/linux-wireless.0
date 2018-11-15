Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52891C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 17:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0710C2086C
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 17:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="ZhYaXlE2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0710C2086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbeKPDT2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 22:19:28 -0500
Received: from mail.toke.dk ([52.28.52.200]:33629 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387833AbeKPDT2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 22:19:28 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1542301848; bh=p4hi3F4fwvoR6vcBhUdhPgag7NYfP3wiuvkpDT3lN9c=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ZhYaXlE281+lxHmVoYe8DD6Inv7TNTgsTnJ91mUyTvbLwPtHH9h4wHxuN5C1EmRrQ
         scNvxLpx/8c97qS36Vt612ucqhFus/DPbNG8y3TF5vtRfhwd7+lMyfwsfhi+5HG9Ep
         RnZNhvtxFwSaymbvenODkg+0fxZDWK9jtpNWdJPDIPEBbQoej9bFFGmqKJD7A7Dez1
         HBwYT77qIW952cTP3ZvfCqSvh+Sbe63iBtq7rVKkhb/ZYZmxygNZFRIJWqDwmX3OqI
         kig2u2M4ZbfWntQ+6spDAH6I+5YCRRSrktL5QtM3k8M7bP+XfJQZ71g7P3/os3fkjg
         4mHwXoa6eDoZQ==
To:     Louie Lu <me@louie.lu>, rmanohar@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        make-wifi-fast@lists.bufferbloat.net
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <CADMDV=zX4NuyDS+C==c8iq7FagGLFOoQ-Fjf=x-zmehJAz8=zQ@mail.gmail.com>
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org> <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org> <CADMDV=zX4NuyDS+C==c8iq7FagGLFOoQ-Fjf=x-zmehJAz8=zQ@mail.gmail.com>
Date:   Thu, 15 Nov 2018 09:10:44 -0800
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87va4ytgff.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Louie Lu <me@louie.lu> writes:

> Hi Rajkumar, Toke,
>
> I found the series (v3,4/6) remove the debugfs remove reset station's
> airtime method, and didn't added at here.
>
> Not sure how to help this kind of situation, do I need a separate
> patch to fix this, or posting the patch here is fine?

This is fine; we can fold it into the next version. Thanks :)

-Toke
