Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBD3C04EB8
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 07:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2437421479
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 07:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I9xpVB3C";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eDbXLBVX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2437421479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbeK3Svx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 13:51:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37500 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbeK3Svw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 13:51:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ED90E6086B; Fri, 30 Nov 2018 07:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543563808;
        bh=lUYxAyPJKN6otDJni0Jgz2GwrYBtsTxO8zMiqyXdTF8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=I9xpVB3CgZCW5xBxr+eDtUprDHspPuTuKf7m96ucW224Bxe0lB9WY4sJcJa9vnd7a
         OdbaM0bJje8z3uXa4gEIG/tUYftE7rf1RdRlXXEGCDP2UUwXtNgawzpsWBR2Fb5UzJ
         1/xRTlmyaUJdbPixvrvTde7uF6hF5MJTqEmkUoN0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0DFD160351;
        Fri, 30 Nov 2018 07:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543563806;
        bh=lUYxAyPJKN6otDJni0Jgz2GwrYBtsTxO8zMiqyXdTF8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eDbXLBVXL2KUVJ6yjg2ZUmML1KoRaC65kLKgGidRuhVdK6CUydV79EdT3NMnRlchW
         mZUXC6RydjORT7YL6GO3aUVVyobsfA2bt58VyWxp2lJfsa2XL3emobJPAhIspWYB+U
         GQs+IHuZ2TouRsVgokRzMNDFvRgDGuLOXMKXmmn4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0DFD160351
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kees Cook <keescook@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: linux-next: build warnings after merge of the wireless-drivers-next tree
References: <20181130120555.1d35eb6b@canb.auug.org.au>
        <87lg5b5glw.fsf@kamboji.qca.qualcomm.com>
        <20181130165006.60b2545f@canb.auug.org.au>
Date:   Fri, 30 Nov 2018 09:43:21 +0200
In-Reply-To: <20181130165006.60b2545f@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 30 Nov 2018 16:50:06 +1100")
Message-ID: <87h8fz57ty.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Kalle,
>
> On Fri, 30 Nov 2018 06:33:47 +0200 Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> I take it that -Wimplict-fallthrough is not enabled by default yet? So
>> Dave and Linus won't see these warnings?
>
> Correct.
>
>> What I'm planning is to send a pull request to Dave today and fix these
>> warnings in the next pull request. Does that sound good?
>
> That sounds fine.

Great, thanks for the confirmation. I'll then send the pull request
today.

-- 
Kalle Valo
