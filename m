Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7C4C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5DAC2082A
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IiJ0PdCA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ak+aoK7n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5DAC2082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbeJDQ5q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 12:57:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52350 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbeJDQ5p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 12:57:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7BA4960B26; Thu,  4 Oct 2018 10:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538647513;
        bh=YreLcI82fpjiE1hcoZzqzJwALxy5ORnOxNYV3swoyT8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IiJ0PdCADeK4acu+hx5Enry8eIsKWQANF7/Tfi6yQ8taUBK3KUTxzIGh4W6P/eqvN
         7VF5UCKW2fhL87MzJubu+3pQppRKGnufv1oHT4i8C18rkU625/HCC4v1zWQSE9ZH7g
         mRyv5lXAyjdXbHNY0pT+P2MdqDqa757CjJIDbEUQ=
Received: from x230.qca.qualcomm.com (85-76-114-39-nat.elisa-mobile.fi [85.76.114.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C80EB60B72;
        Thu,  4 Oct 2018 10:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538647512;
        bh=YreLcI82fpjiE1hcoZzqzJwALxy5ORnOxNYV3swoyT8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ak+aoK7nMUyYSxZTinQvFn6VRLWUnxlvOSNmDolvctgS4TBVOA3HinM4lAbqXIoXo
         rtn3daQ+13G4kzUmoVLJ9LtesuB9OsfUg7bvzzE46KWMR7GgrsqRXPljvQSHlsCuLQ
         81yKWVyGKnwoJBhe1BcGV79Ga1nnEptnm/tTwUq0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C80EB60B72
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lance Roy <ldr709@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/16] wireless: Replace spin_is_locked() with lockdep
References: <20181003053902.6910-1-ldr709@gmail.com>
        <20181003053902.6910-9-ldr709@gmail.com>
        <877eizjt5j.fsf@kamboji.qca.qualcomm.com>
        <20181004065720.GE896@E570.localdomain>
Date:   Thu, 04 Oct 2018 13:05:08 +0300
In-Reply-To: <20181004065720.GE896@E570.localdomain> (Lance Roy's message of
        "Wed, 3 Oct 2018 23:57:20 -0700")
Message-ID: <87in2i2fjf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lance Roy <ldr709@gmail.com> writes:

> On Wed, Oct 03, 2018 at 12:06:48PM +0300, Kalle Valo wrote:
>> Lance Roy <ldr709@gmail.com> writes:
>>
>> > lockdep_assert_held() is better suited to checking locking requirements,
>> > since it won't get confused when someone else holds the lock. This is
>> > also a step towards possibly removing spin_is_locked().
>> >
>> > Signed-off-by: Lance Roy <ldr709@gmail.com>
>> > Cc: Daniel Drake <dsd@gentoo.org>
>> > Cc: Ulrich Kunitz <kune@deine-taler.de>
>> > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Cc: <linux-wireless@vger.kernel.org>
>> > Cc: <netdev@vger.kernel.org>
>> > ---
>> >  drivers/net/wireless/zydas/zd1211rw/zd_mac.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Should I take this or is it going through some other tree?
>
> Sure you can take this if you like. If not, Paul McKenney will take it in his
> tree.

Ok, then I'll take this to wireless-drivers-next. And I'll change the
title prefix to "zd1211rw: ".

-- 
Kalle Valo
