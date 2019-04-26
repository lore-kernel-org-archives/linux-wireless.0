Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093EFC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4DD5206C1
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:57:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j469153I";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eZO35kWh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfDZL5t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:57:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfDZL5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 07:57:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BFF856074F; Fri, 26 Apr 2019 11:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279868;
        bh=OMDU9ZIUYqvpQDEoJOo221IcbJpxyWHZFmCcq5fhZsU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=j469153IyPaYGvEjA378I7K934E1JjApfp2ojmPAND+g2vvewuU0jVIx3DOLM6JEn
         TNTfcx9FegH+OwsxUNdXFsqQpqI90IWzNQaWFMojLLRRzIAS+sFvAamXz0A/YIbWb0
         geSc0UUwKvxmAVDcSCrcLpYjIaGbIqMytZuLRfoM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B540C60275;
        Fri, 26 Apr 2019 11:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279868;
        bh=OMDU9ZIUYqvpQDEoJOo221IcbJpxyWHZFmCcq5fhZsU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=eZO35kWhQmpgma34/cMrJQ58GEi8GH8LL0ATtYY62U2VNDvB50K3oTdsf3uV7hBlv
         XYxCN3uSuZ5YZqeFcTLQtBXOQSrCPbylDBVNlMom+c3LVa42Nk6GlJTqN/95A9BTn6
         /ILBkxGpUa+3Gmn7Ncdu4LlvBvx+6JgFfbDaC+xg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B540C60275
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwl8k: move spin_lock_bh to spin_lock in tasklet
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1553012645-28989-1-git-send-email-chongguiguzi@gmail.com>
References: <1553012645-28989-1-git-send-email-chongguiguzi@gmail.com>
To:     Jeff Xie <chongguiguzi@gmail.com>
Cc:     buytenh@wantstofly.org, davem@davemloft.net,
        chongguiguzi@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190426115748.BFF856074F@smtp.codeaurora.org>
Date:   Fri, 26 Apr 2019 11:57:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jeff Xie <chongguiguzi@gmail.com> wrote:

> It is unnecessary to call spin_lock_bh in a tasklet.
> 
> Signed-off-by: Jeff Xie <chongguiguzi@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

0b2ff1ff64c8 mwl8k: move spin_lock_bh to spin_lock in tasklet

-- 
https://patchwork.kernel.org/patch/10859991/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

