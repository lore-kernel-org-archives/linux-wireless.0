Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D88C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 09:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAF592081B
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 09:36:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YUL+ag2b";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TjPuS07M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfCHJgp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 04:36:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59594 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfCHJgp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 04:36:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 68D88604D4; Fri,  8 Mar 2019 09:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552037804;
        bh=l/64oNQTOmFAgdd0QuvzJGqoqlmoNeqREBju4/jvjjU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YUL+ag2b4ufOgVkTNYhfyyPRjGxCWE4JykjlbUT8kVqutQKv0qUyGJ0LwFWbMqg7E
         sD5ntsjFbnBv8aaAb1e7wMMxcTMbn3qa1tCzXUxLntvNix27ozC6KDDpVVVav/FBIE
         fxb49fNaRGZvYt1096W6oE1QNo6sHasJUKXBmQ/g=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4090A6030B;
        Fri,  8 Mar 2019 09:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552037803;
        bh=l/64oNQTOmFAgdd0QuvzJGqoqlmoNeqREBju4/jvjjU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TjPuS07M+wKgAY1DIP+OIT+xA8v4fWp1c3Qm3eaVLNLvCwi3BpRuvhq4M9fzcQ/fy
         YXrF8F0D+BPrYxMC8lg5r2GrI9vUvcDiuM8HgIWjZTytjJmQV8RuLfWqoUTFKBQqXg
         bGnBNUSAYvKGVdmm2q89L4zac77xHE8keZMdBPiw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4090A6030B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
References: <20190224140426.3267-1-marc.zyngier@arm.com>
        <87ef7hai0e.fsf@codeaurora.org>
        <15c00f9e-58df-e885-f3b0-2c57e9fadb11@arm.com>
Date:   Fri, 08 Mar 2019 11:36:37 +0200
In-Reply-To: <15c00f9e-58df-e885-f3b0-2c57e9fadb11@arm.com> (Marc Zyngier's
        message of "Fri, 8 Mar 2019 09:02:11 +0000")
Message-ID: <87o96l907u.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Marc Zyngier <marc.zyngier@arm.com> writes:

> On 08/03/2019 08:26, Kalle Valo wrote:
>> Marc Zyngier <marc.zyngier@arm.com> writes:
>> 
>>>   dt-bindings/marvell-8xxx: Allow wake-up interrupt to be placed in a
>>>     separate node
>>>   mwifiex: Fetch wake-up interrupt from 'wake-up' subnode when it exists
>>>   mwifiex: Flag wake-up interrupt as IRQ_NOAUTOEN rather than disabling
>>>     it too late
>>>   arm64: dts: rockchip: gru: Move wifi wake-up interrupt into its own
>>>     subnode
>>>
>>>  .../bindings/net/wireless/marvell-8xxx.txt    | 23 ++++++++++++++++++-
>>>  .../dts/rockchip/rk3399-gru-chromebook.dtsi   |  8 ++++---
>>>  drivers/net/wireless/marvell/mwifiex/main.c   | 13 +++++++++--
>>>  3 files changed, 38 insertions(+), 6 deletions(-)
>> 
>> I didn't read the discussion in detail, but I understanding is that I
>> should drop this series and wait for a new version. Please correct me if
>> I misunderstood.
>
> I indeed plan to resend the series with a slightly different approach,
> removing support for the wake-up interrupt on mwifiex PCI devices
> altogether.
>
> Note that patch #3 is a fairly independent fix, which could be applied
> right now.

Ok, I'll queue that for 5.2 then:

https://patchwork.kernel.org/patch/10827971/

-- 
Kalle Valo
