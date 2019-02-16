Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079A8C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 11:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA362222DD
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 11:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dMI9MLVJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L+SU0voX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbfBPLVN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Feb 2019 06:21:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfBPLVN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Feb 2019 06:21:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 34F8060860; Sat, 16 Feb 2019 11:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550316072;
        bh=tHbnR+DR/1gceFnSr9DFfmcwp7teT/G4SBP1O+GUlas=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dMI9MLVJC8Re0z4KtFSW0uxJ3qNoxyNlzGBXImTLwW2ua8GxEmYW09vQSqrdhT1m1
         8VjhNB6t7UFzq/L2XvBlNwv5CLJpPok00+JoQkdg6MsOhN25RVoXqh65plMUV8LTzW
         sxBwW76J/RldEFFmriogm4rlT1557n4A831RstWU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DC948606FC;
        Sat, 16 Feb 2019 11:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550316071;
        bh=tHbnR+DR/1gceFnSr9DFfmcwp7teT/G4SBP1O+GUlas=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=L+SU0voX1zfteeq5E1ahCAG1e+eZ5TpSwLlDXo8ny7uZX+fYNblyuq31G4sdDKUYb
         2gPlNh5qT5GOOV/H3gMKxb/SaRsRj8A+v9zXIt9Wv8TNN2tqTJ99w47Z4Sj1Usuie8
         iJpryFJOnI3Q0kFnwN96oSFH3vha567GQo7tLlKA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DC948606FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kbuild@vger.kernel.org
Subject: -Wimplicit-fallthrough not working with ccache
References: <20180524225928.GA19570@embeddedor.com>
        <20180613114059.DAC95601D2@smtp.codeaurora.org>
Date:   Sat, 16 Feb 2019 13:21:06 +0200
In-Reply-To: <20180613114059.DAC95601D2@smtp.codeaurora.org> (Kalle Valo's
        message of "Wed, 13 Jun 2018 11:40:59 +0000 (UTC)")
Message-ID: <87zhqwuggt.fsf_-_@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(replying to an old thread but renaming it)

Kalle Valo <kvalo@codeaurora.org> writes:

> "Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:
>
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>> 
>> Notice that in this particular case, I replaced "pass through" with
>> a proper "fall through" comment, which is what GCC is expecting
>> to find.
>> 
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> Patch applied to ath-next branch of ath.git, thanks.
>
> f1d270ae10ff ath10k: htt_tx: mark expected switch fall-throughs

Gustavo, I enabled W=1 on my ath10k build checks and it took me a while
to figure out why GCC was warning about fall through annotations missing
even I knew you had fixed them. Finally I figured out that the reason
was ccache, which I need because I work with different branches and need
to recompile the kernel quite often.

If the plan is to enable -Wimplicit-fallthrough by default in the kernel
IMHO this might become an issue, as otherwise people using ccache start
seeing lots of invalid warnings. Apparently CCACHE_COMMENTS=1 will fix
that but my version of ccache doesn't support it, and how would everyone
learn that trick anyway? Or maybe CCACHE_COMMENTS can enabled through
kernel Makefile?

-- 
Kalle Valo
