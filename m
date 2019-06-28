Return-Path: <SRS0=Fjak=U3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84341C5B578
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 05:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58639206E0
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 05:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SVF2gO5O";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K+qxu1wm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfF1FII (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:08:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33600 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfF1FII (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jun 2019 01:08:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 226B260E75; Fri, 28 Jun 2019 05:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561698488;
        bh=rb7ZCFwECe0+1BB4kbofLdYTkobYyf8xm5XvPY+X28k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SVF2gO5ODahmk6AVVJHVAKLHp90dGLFfja/KRUOMS0Cu6RopHocM72xX8zIKITY6U
         bKV64ZtGM7NL8Pko2YzWgkeH9g1lWsJYeNei1ntUry702B72CJkooSP9favI7jcZX2
         KNJNq1GEM+AD4H1W1S8+A2zs5tUXtdthxDP3xaDw=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 979C1607C3;
        Fri, 28 Jun 2019 05:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561698487;
        bh=rb7ZCFwECe0+1BB4kbofLdYTkobYyf8xm5XvPY+X28k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=K+qxu1wmpEacp/1rtwuUS46ONjSuQSWqb76Wj/NjxihP4DQKdSLVRMrcQO89KZR0J
         taLLRWai3ZEc0sDY9UgAWS8kll+VU4FEDQ2xFt5izeC3TTxSZxDVZX8468CpLKUERh
         c4L7O51ZDD8MpBtaBvL2vJcifAdQfK/nSs/gfvEg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 979C1607C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: pci: remove unnecessary casts
References: <1561661250-30528-1-git-send-email-kvalo@codeaurora.org>
        <1561661250-30528-2-git-send-email-kvalo@codeaurora.org>
        <58e8952b87c8aa533c15fe5650f3f71288377f36.camel@sipsolutions.net>
        <a6c87741bc3e992bf61d2706834e069917018745.camel@sipsolutions.net>
Date:   Fri, 28 Jun 2019 08:08:04 +0300
In-Reply-To: <a6c87741bc3e992bf61d2706834e069917018745.camel@sipsolutions.net>
        (Johannes Berg's message of "Thu, 27 Jun 2019 21:15:48 +0200")
Message-ID: <87r27eqouj.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2019-06-27 at 21:12 +0200, Johannes Berg wrote:
>> On Thu, 2019-06-27 at 21:47 +0300, Kalle Valo wrote:
>> > Fixes checkpatch warnings:
>> > 
>> > drivers/net/wireless/ath/ath10k/pci.c:926: unnecessary cast may
>> > hide bugs, see http://c-faq.com/malloc/ma
>> > drivers/net/wireless/ath/ath10k/pci.c:1072: unnecessary cast may
>> > hide bugs, see http://c-faq.com/malloc/m
>> 
>> I think you cut off the link there, did you mean
>> http://c-faq.com/malloc/mallocnocast.html perhaps?

Yes, thanks. Fixed now in the pending branch.

> Which I should've read before replying ... WHAT? We consider calling
> undeclared functions an *error* in the kernel, this is quite pointless.

Yeah, the link checkpatch provides is pointless. TBH I didn't even read
it until you commented on it :) But the patch is still good to have as
there's no point of use casting on void pointers, it's just extra cruft.
Right?

-- 
Kalle Valo
