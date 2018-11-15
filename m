Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23368C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 16:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3384223CB
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 16:08:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="foTJFcdX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="A7jTBTaS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3384223CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388088AbeKPCQ4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 21:16:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48638 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbeKPCQ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 21:16:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 992DD60764; Thu, 15 Nov 2018 16:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542298109;
        bh=H9ZA1xq1b47tPDc+S343cl7YTk2uJyyDO0qQPTxi8oM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=foTJFcdXlt/FZBXme6u3LdF/qPezGaE/tcUs2pw2aP7utNIIw81EU/Z45G3Ux8tAN
         2L1WXg/gQDzjcqc7GnzqDOxza08RRmxnBN3Ai5Z7zAg/a3KaZqFTEipuVvwa+3eShS
         Emh/mq8sdgWQNO7FzjGu2CyG1BCnbyBQnLaYoyis=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8B25D6020B;
        Thu, 15 Nov 2018 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542298108;
        bh=H9ZA1xq1b47tPDc+S343cl7YTk2uJyyDO0qQPTxi8oM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=A7jTBTaS+xh5NOIcXhbzbjp4DaU3+Fr2tBP1apLwr8Fm/dVOSheJB6HV44HLv9Dn4
         2n2dTM0F+zoQi+peBOYV3q4EMv30XALVbA9YbchGIL1HI6FNpU4EnL1GlmCcwuMbG3
         Vt2SpAkXnEIiBi0wRgAglYm+znq/Dtq8gXvoZ7JY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8B25D6020B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Joe Perches <joe@perches.com>
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com, sgruszka@redhat.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC v4 08/13] rtw88: debug files
References: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
        <1539421245-11847-9-git-send-email-yhchuang@realtek.com>
        <a731948bf875867be4246b72a661ce71833620b8.camel@perches.com>
        <87y3b1vpjk.fsf@codeaurora.org>
        <0a41d14b9a964b6b7825bf5c55c32f35166354cd.camel@perches.com>
        <e85b7fa45cefc0bc3df15785f34792abe33f41c6.camel@perches.com>
        <878t1ubf6i.fsf@codeaurora.org>
        <3946d05c0c026f3bdffaa35a686e5f12b8f3c59e.camel@perches.com>
Date:   Thu, 15 Nov 2018 18:08:23 +0200
In-Reply-To: <3946d05c0c026f3bdffaa35a686e5f12b8f3c59e.camel@perches.com> (Joe
        Perches's message of "Thu, 15 Nov 2018 07:19:56 -0800")
Message-ID: <87zhua8gso.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Thu, 2018-11-15 at 16:15 +0200, Kalle Valo wrote:
>> Joe Perches <joe@perches.com> writes:
>> 
>> > On Sat, 2018-10-13 at 13:28 -0700, Joe Perches wrote:
>> > > On Sat, 2018-10-13 at 18:23 +0300, Kalle Valo wrote:
>> > > > Joe Perches <joe@perches.com> writes:
>> > []
>> > > > > It's very unusual to have _all_ the logging under a CONFIG_<FOO>_DEBUG
>> > > > > config guard flag.
>> > > > 
>> > > > For wireless drivers that is actually quite typical.
>> > > 
>> > > No, it isn't.
>> > > 
>> > > > IIRC at least ath6kl, ath9k and ath10k do that, most likely also others.
>> > > 
>> > > No, they don't.  Check again.
> []
>> > Kalle, did I miss a reply here?
>> 
>> I didn't bother to waste my time after reading comments like "check
>> again" and "look harder".
>
> You are the maintainer here and you give advice that others are
> likely to follow.
>
> I was a bit frustrated after your fairly assertive, but wrong
> statement that the other drivers you maintain do the same thing.

Yeah, I can understand that. But do note that I'm a non-native english
speaker with an always full inbox, I don't have time nor skills to write
in a way expected by a native speaker. So please don't assume that I'm
assertive or other meanings from my style of text, just consider that my
writings as "simple english".

Also I do a lot of mistakes, and when I do please just clearly explain
it to me. I'm always grateful about that, all constructive help is very
welcome.

-- 
Kalle Valo
