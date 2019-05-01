Return-Path: <SRS0=6eO7=TB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CCFC43219
	for <linux-wireless@archiver.kernel.org>; Wed,  1 May 2019 18:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF51F2081C
	for <linux-wireless@archiver.kernel.org>; Wed,  1 May 2019 18:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g2vF3436";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="joFE+6gO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfEASaR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 May 2019 14:30:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEASaR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 May 2019 14:30:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3202160A33; Wed,  1 May 2019 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556735416;
        bh=Qg7HihNrigN9dHoSgyLOdsgbume91IjE6/UZB5bmP2c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=g2vF3436O2PR/uNg5l+Xh66D0YxDCTehp27Y1AS8VQErRT6XfL7zKd4GKRihMiQKm
         RVuPjdSDKT9K1MxUOZmA1jdkKT7vJ0VG+RjLvCzj/ZlYqN11i1TQBHK7KE8PNwofBb
         NCfyBx4z9ZGQvTaX20kcz+TPPuCpdKknKFtPV+pI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2857E608FF;
        Wed,  1 May 2019 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556735415;
        bh=Qg7HihNrigN9dHoSgyLOdsgbume91IjE6/UZB5bmP2c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=joFE+6gOVGvmCSt0LONjWrYLVkj4jVBzISEtBdXSbcGgalx+MyJK768vwuNEWLF23
         YdBmw6L55YnMyIcDluC+GIHOMN1apb15wnNj4RC5nGDd+QBKKXhWM8VCdI5UoplBoV
         1JYJ+C/+OebiBrThKmSBQ2roVEYCSWi5jw1PVqWs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2857E608FF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     yhchuang@realtek.com, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, briannorris@chromium.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v9 04/14] rtw88: trx files
References: <1555653004-1795-1-git-send-email-yhchuang@realtek.com>
        <1555653004-1795-5-git-send-email-yhchuang@realtek.com>
        <87bm0npsp7.fsf@kamboji.qca.qualcomm.com>
        <04c534eb-af32-adfc-62bb-90d83526af1a@lwfinger.net>
Date:   Wed, 01 May 2019 21:30:10 +0300
In-Reply-To: <04c534eb-af32-adfc-62bb-90d83526af1a@lwfinger.net> (Larry
        Finger's message of "Wed, 1 May 2019 13:18:10 -0500")
Message-ID: <87a7g6ni31.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 4/30/19 7:45 AM, Kalle Valo wrote:
>> I'm not really fond of these "byte macros" or whatever they should be
>> called, you use these a lot in rtw88 but I have seen the same usage also
>> other drivers. The upstream way of doing this is to create a struct,
>> which also acts as a documentation, and you can pass it around different
>> functions. And the GENMASK()s are defined close the struct.
>>
>> Also you could change these defines to static inline functions, which
>> take the struct as a pointer, and that you get type checking from the
>> compiler. And that way you would get rid of that ugly casting as well.
>
> Kalle,
>
> I have never been a fan of those complicated macros dating back to the
> day that I had to make them endian correct. Without Sparse, I never
> would have made it.
>
> I understand your comment about making them be static inline
> functions, but I am intrigued be the struct method. Is there something
> other than bit field constructions that could accomplish this?

My comment was about handling firmware commands and events as a byte
array, not about bitfields. So that instead of accessing 'index + 1' and
'index + 4' you should create a proper struct for the command and access
it using 'cmd->foo' and 'cmd->bar'. Sure, bitfields you still need to
access using FIELD_GET() or similar but having a struct for commands is
a lot cleaner approach. And most upstream drivers do this: ath10k,
ath6kl, iwlwifi, p54 and whatnot.

Sorry, no time now to explain further now but, if needed, I can provide
a better example tomorrow.

> If not, then this method would be very difficult to implement. My
> basis is an E-mail by Linus that said it was almost impossible to get
> this type of construct to be endian correct. If he thinks it is
> difficult, then I know not to tackle it. :)

Could you please point Linus' email about this? I would like to
understand more, I didn't understand your comment.

-- 
Kalle Valo
