Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C7FC4360F
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 08:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 721DC2086C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 08:37:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dA9ckr4e";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MByCYwWX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732077AbfDAIhX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 04:37:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731882AbfDAIhX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 04:37:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6C7AC61948; Mon,  1 Apr 2019 08:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554107842;
        bh=HCoSLGOHQsdOAXi5QGC3Mvgeb5XnTqKS7PQScgEBI7E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dA9ckr4eeYKzqmCYMuowVdE6dZI/maL+g0z6UQidwY4B2zrmnZgRrdNrwXm62d9Yz
         85z36l2JOCeqD1sC1hpwGZmyCMq+pTUds1BjIe1idPXEJ0kvm8Q3ge+gPRgahnmvWz
         fsYYny04roBzk/xpWA56gzpCbDVEav9P3ty4QCL0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7E0EE61156;
        Mon,  1 Apr 2019 08:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554107841;
        bh=HCoSLGOHQsdOAXi5QGC3Mvgeb5XnTqKS7PQScgEBI7E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MByCYwWXa73/Lhh6Zy18JjgHTV/Hw+gGadZYv/XbZnFyYCybepiQPLSoa3ohUc/8o
         HQ95TXUurUS8YGzZcPAHljbgySRbd4G3gYtctooe/DMB3p8EeAWFbiKMRQt8ShZJQ7
         rauteAuf74lxN6coW+kpFSFpxQ/QiOMqvjrF3CjQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7E0EE61156
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Anthony Wong <anthony.wong@canonical.com>,
        Stephan Fabel <stephan.fabel@canonical.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: Ath10k on XPS 9380 regularly disconnects
References: <042C2903-585B-47BA-8657-8819D225EEA8@canonical.com>
        <87pnqknonc.fsf@codeaurora.org>
        <8ACA9157-127E-43B8-ADD0-28D9EBBCEEB0@canonical.com>
        <BD07B681-0083-4537-87D2-099F7152C51F@canonical.com>
Date:   Mon, 01 Apr 2019 11:37:17 +0300
In-Reply-To: <BD07B681-0083-4537-87D2-099F7152C51F@canonical.com> (Kai-Heng
        Feng's message of "Mon, 1 Apr 2019 16:03:21 +0800")
Message-ID: <877ece2kaq.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> at 23:43, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
>
>> at 01:05, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>>> + ath10k list
>>> - netdev & linux-kernel
>>>
>>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>>>
>>>> There=E2=80=99s an issue that ath10k disconnects at regular basis [1],=
 on
>>>> Linux kernel 4.18.
>>>>
>>>> Unfortunately I can=E2=80=99t reproduce the issue on XPS 9380 at my ha=
nd.
>>>>
>>>> Is there already a fix in upstream kernel?
>>>
>>> I'm not aware of any fixes related to this. Is this a regression? In
>>> other words, is there a known version of ath10k or firmware which didn't
>>> have this problem?
>>
>> We know this issue happen on kernel v4.15 and v4.18, but kernels
>> before v4.15 were not tested.
>>
>> The issue happens with Google Mesh, which has 802.11ac capability.
>>
>> I haven=E2=80=99t been able to reproduce the issue with an 802.11n route=
r (yet).
>
> Do I need a special WiFi router which support RX reorder to reproduce
> the issue?
>
> It's introduced by commit c545070e404b (=E2=80=9Cath10k: implement rx reo=
rder
> support=E2=80=9D).

I don't understand your question at all.

--=20
Kalle Valo
