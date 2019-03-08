Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132E3C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 09:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D70DF20684
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 09:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oQlGYxs6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W76Qqrf+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfCHJme (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 04:42:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfCHJmd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 04:42:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 66E0760312; Fri,  8 Mar 2019 09:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552038153;
        bh=xKrOoRyrG7f6MlcFsAJgycT+EzXHIgdgK+iJaZZ/1R8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oQlGYxs6dpuOpFiVAH1HCLfPIf3wiik+b8AYUjwbM2xME6WKR2MOhWc8gqv09BntT
         zTPAFbuOs2VFEoXom7K1BS9Rr1zLDCkslyoeuChM/GTOgH1m1M90+lglCtkHoRyaUd
         5BQFu+HwEFhwpje74NhwTy/vUuGmXkOFq9iPgSmI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 60D6860264;
        Fri,  8 Mar 2019 09:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552038152;
        bh=xKrOoRyrG7f6MlcFsAJgycT+EzXHIgdgK+iJaZZ/1R8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W76Qqrf+UlTJajCwQUyYZI095eSJJfsVf/gXYrF1ks4aMfMzNlGC+df7iJ08uyEjb
         WGHgDOZInJodAI2cZVN35NUR/4nkQC8GlIv2q3JSOzpJm2Mp7RP0zBt9TEoO7aUFya
         Mi7FY7TmNuCi4rA68JJMPW64ykP6FmaYsaUcTzdU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 60D6860264
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, Wen Gong <wgong@codeaurora.org>
Subject: Re: [PATCH] ath10k: support PCIe enter L1 state
References: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
        <20181115002836.GA71934@google.com>
        <c94346b26a6d4b11a045a176ca854051@aptaiexm02f.ap.qualcomm.com>
        <20181115184333.GA87504@google.com> <87va4x8q2c.fsf@codeaurora.org>
        <CABvG-CVAnwkiKVJik0PdsmRxF62kKv2N+aRKNq=nbopoExLvDA@mail.gmail.com>
        <87y36q75wr.fsf@kamboji.qca.qualcomm.com>
        <CA+ASDXO8NujrORVLZMPbDy916cnzOvx_Bp8Vr-VvkbBwJvB97A@mail.gmail.com>
Date:   Fri, 08 Mar 2019 11:42:29 +0200
In-Reply-To: <CA+ASDXO8NujrORVLZMPbDy916cnzOvx_Bp8Vr-VvkbBwJvB97A@mail.gmail.com>
        (Brian Norris's message of "Fri, 8 Feb 2019 09:05:11 -0800")
Message-ID: <87h8cd8zy2.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Fri, Feb 8, 2019 at 5:42 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>> No replies from anyone (including Wen) for 3 months about testing this
>> patch on anything else than QCA6174. So I'll drop this now, please
>> resubmit once test coverage is better.
>
> I know this isn't exactly what you're asking for, but FWIW we've been
> using this since late November on all our QCA6174 products. No issues
> seen as far as I know, and we have seen some power savings.

Thanks for the feedback, this is very good to know. I also would like to
apply this but not before we have some testing feedback from AP chipsets
like QCA988X or QCA9984. Wen, are you planning to test those and
resubmit?

-- 
Kalle Valo
