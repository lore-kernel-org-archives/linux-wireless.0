Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23F5C65C30
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5E5A2087D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:01:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UZwFBewN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UZwFBewN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5E5A2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbeJFTEt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 15:04:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44582 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbeJFTEs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 15:04:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F05AE60C4E; Sat,  6 Oct 2018 12:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538827309;
        bh=/oYYc+aHC+9vLCB4xc2sXp80HTrn4dxs30lmh2KPspQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UZwFBewNbyQ37HlQEMhliuRJE7w2vKy0LtMToAvoAvgo+sMRGGxYfuyAx/+5k7oqu
         LZ5YEwkzcy0lKvQKE/fKbMbTP8fsYkRx6rFKhKQ9ccU02jxPbVD4yzxHqkovSYi92h
         bchQvNbRO7S/VdVd/7fqxc1PMwsNRQ1IwrcqvuiE=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 44039602F1;
        Sat,  6 Oct 2018 12:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538827309;
        bh=/oYYc+aHC+9vLCB4xc2sXp80HTrn4dxs30lmh2KPspQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UZwFBewNbyQ37HlQEMhliuRJE7w2vKy0LtMToAvoAvgo+sMRGGxYfuyAx/+5k7oqu
         LZ5YEwkzcy0lKvQKE/fKbMbTP8fsYkRx6rFKhKQ9ccU02jxPbVD4yzxHqkovSYi92h
         bchQvNbRO7S/VdVd/7fqxc1PMwsNRQ1IwrcqvuiE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 44039602F1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Cody Schuffelen <schuffelen@google.com>
Cc:     joelaf@google.com, sergey.matyukevich.os@quantenna.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation device
References: <20181004195906.201895-1-schuffelen@google.com>
        <20181005143323.ezyd2x6x5ymlb7rg@bars>
        <CAJWu+ooTRUxj2PAiUkgjTLb+VC9OoBpkj9-_ZoC-oCS3owc5Hg@mail.gmail.com>
        <CAJWu+oqoSsj=50vk-jUTKUVgZ_oj5Vng0bBF605Aw_iWD=W24A@mail.gmail.com>
        <CAAELVAGAZ-UM77P=JqzHjUGja9oJcN5y9+YvxZWKBmOXAu=zNQ@mail.gmail.com>
Date:   Sat, 06 Oct 2018 15:01:44 +0300
In-Reply-To: <CAAELVAGAZ-UM77P=JqzHjUGja9oJcN5y9+YvxZWKBmOXAu=zNQ@mail.gmail.com>
        (Cody Schuffelen's message of "Fri, 5 Oct 2018 14:59:27 -0700")
Message-ID: <87tvlzffmf.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Cody Schuffelen <schuffelen@google.com> writes:

> Thanks for the comments! I will work on incorporating the suggested
> changes.

Few important remarks:

1. Do not EVER submit HTML mails, mailing lists will automatically
   reject them. So your mail didn't reach the lists and I only got it
   because I was in the Cc field.

2. Do not top post, it's really annoying:

   https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#do_not_top_post_and_edit_your_quotes

3. Reply to the review comments you get, even if you agree with them. By
   not replying you give an impression that you are ignoring the review
   comments.

-- 
Kalle Valo
