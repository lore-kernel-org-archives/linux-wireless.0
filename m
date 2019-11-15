Return-Path: <SRS0=1RAM=ZH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA1CCC432C3
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 11:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B47BA20732
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 11:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FdX9WGMj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W6PoPLTz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfKOL46 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Nov 2019 06:56:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfKOL46 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Nov 2019 06:56:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 000D9601A3; Fri, 15 Nov 2019 11:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573819017;
        bh=NJKjstIkPCIdcN/uk64cj3+wALwzkGLn4GdQPc9agfc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FdX9WGMj0/X8EwLGlM7hr5PVhb17CFXuFyMAS3+j7CYjXH88WlZ9kJnrkuUn6KMPD
         tWJXKGZNJcOjbE0JnWqmoFhRi9Uc8noDIzXxXOY+E818CD9IXpENWxlUeBlvOSqxMz
         WoVW4azVgaEsIlPHU+5c/1/ppcD9eZfhWqe/KpFs=
Received: from x230.qca.qualcomm.com (unknown [83.145.195.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D6C93601A3;
        Fri, 15 Nov 2019 11:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573819016;
        bh=NJKjstIkPCIdcN/uk64cj3+wALwzkGLn4GdQPc9agfc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W6PoPLTzo2kC0KM/iJoqcgeu4MqfpfoSLJhOB+4qFcmp2T3nOnl5VOdG86LpvSyyW
         sf0KUvhDr9zJYWfjQJwpumcr4ZkvXYdr+o8/V6N14mk1hcpAMGcJ34jtfAmLJ+bV1l
         7fIluLiJH2a9Eu6xuRoXk+5mtI5PB0hzd5K+nH7w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D6C93601A3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     ath10k@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus =?utf-8?Q?L=C3=BCssing?= <ll@simonwunderlich.de>
Subject: Re: [PATCH net-next v2] ath10k: fix RX of frames with broken FCS in monitor mode
References: <20191115105612.8531-1-linus.luessing@c0d3.blue>
Date:   Fri, 15 Nov 2019 13:56:45 +0200
In-Reply-To: <20191115105612.8531-1-linus.luessing@c0d3.blue> ("Linus
        \=\?utf-8\?Q\?L\=C3\=BCssing\=22's\?\= message of "Fri, 15 Nov 2019 11:56:12 +0100")
Message-ID: <87a78xwdxe.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Linus L=C3=BCssing <linus.luessing@c0d3.blue> writes:

> From: Linus L=C3=BCssing <ll@simonwunderlich.de>
>
> So far, frames were forwarded regardless of the FCS correctness leading
> to userspace applications listening on the monitor mode interface to
> receive potentially broken frames, even with the "fcsfail" flag unset.
>
> By default, with the "fcsfail" flag of a monitor mode interface
> unset, frames with FCS errors should be dropped. With this patch, the
> fcsfail flag is taken into account correctly.
>
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Linus L=C3=BCssing <ll@simonwunderlich.de>

ath10k patches go ath-next branch, not net-next. So to avoid confusion
please don't mark ath10k patches as "net-next", please.

> ---
> This was tested on an Open Mesh A41 device, featuring a QCA4019. And
> with this firmware:
>
> https://www.candelatech.com/downloads/ath10k-4019-10-4b/firmware-5-ct-ful=
l-community-12.bin-lede.011

I'll add this testing information to the commit log. (No need to resend
just because of commit log changes)

> But from looking at the code it seems that the vanilla ath10k has the
> same issue, therefore submitting it here.

So this should work with the Qualcomm firmware as well, right?

--=20
Kalle Valo
