Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7D2C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A04392082F
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:30:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ed/0awq+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SbLB+NBv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A04392082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbeJXP5I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 11:57:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbeJXP5I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 11:57:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F19F9602BA; Wed, 24 Oct 2018 07:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540366216;
        bh=0avqvEeKjtz1HlqLyOfj44JWgtubTkFpq7YvG9Rp/oo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ed/0awq+ZiqZTI8PugrfLJaHU1HWHH0WKod96lFtAxsMy3ag74FNl8AbSwBcPRnWV
         rlwrFp7EBe7Jme4hjqgG8yFLLEG+BxUc2JcCBRATK7AMGb9YNvsUuNVLgqvgIXL5Hy
         8L1wrERwk0VLGZfcpJCYcx5w7s+nTLevEXKZjIDg=
Received: from x230.qca.qualcomm.com (87-93-79-96.bb.dnainternet.fi [87.93.79.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8F0CD602BA;
        Wed, 24 Oct 2018 07:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540366215;
        bh=0avqvEeKjtz1HlqLyOfj44JWgtubTkFpq7YvG9Rp/oo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SbLB+NBvkku+qbdc6NiSqdslyULdvFVSDAe3lB847NPfKrG+kS8h8Mo17nLGj6bgM
         GSDfUZ5M4ffkFZjkroX/KgAkmBx5Kjv+5/4WwLjcZ257Ct5DS9X2HHCiVI27HlkjYO
         yK00LDB9bK0EgrwfSypPsq2Iwujt+3jPxVDPaWk0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8F0CD602BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>
Subject: Re: [GIT] Networking
References: <20181023.202921.1185045750138652543.davem@davemloft.net>
        <CAHk-=whuhCGujWKO8JObGQaSdWOpJBXdkM-B-vD80QZifveScw@mail.gmail.com>
Date:   Wed, 24 Oct 2018 10:30:09 +0300
In-Reply-To: <CAHk-=whuhCGujWKO8JObGQaSdWOpJBXdkM-B-vD80QZifveScw@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 24 Oct 2018 07:01:31 +0100")
Message-ID: <87pnvzu7i6.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless, ath10k, niklas, jeff, andy, david

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Oct 24, 2018 at 4:30 AM David Miller <davem@davemloft.net> wrote:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>
> Hmm. Tentatively pulled, but there's something wrong with the Kconfig rules.
>
> Doing "make allmodconfig" (not even the build itself, just the config
> phase), I get
>
>   WARNING: unmet direct dependencies detected for QCOM_QMI_HELPERS
>     Depends on [n]: ARCH_QCOM && NET [=y]
>     Selected by [m]:
>     - ATH10K_SNOC [=m] && NETDEVICES [=y] && WLAN [=y] &&
> WLAN_VENDOR_ATH [=y] && ATH10K [=m] && (ARCH_QCOM || COMPILE_TEST
> [=y])
>
> because I'm obviously not building on ARCH_QCOM.
>
> I suspect that QCOM_QMI_HELPERS needs to have
>
>         depends on (ARCH_QCOM || COMPILE_TEST) && NET
>
> or similar. I'll see if this builds for me at all despite the Kconfig warning.

I had missed this warning, sorry about that. Jeff reported the same
problem while I was on vacation and according to Niklas[1] it should be
fixed by this commit in linux-next:

ccfb464cd106 ("soc: qcom: Allow COMPILE_TEST of qcom SoC Kconfigs")

I'm hoping you will get the commit during this merge window but not sure
about that and via which tree it would come. Adding Andy and David who
hopefully know more.

[1] http://lists.infradead.org/pipermail/ath10k/2018-October/012330.html

-- 
Kalle Valo
