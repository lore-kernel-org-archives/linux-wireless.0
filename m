Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF830C10F00
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE37320842
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:03:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cgz7V8vu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CcY8IdeU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfBYKDW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 05:03:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51402 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfBYKDV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 05:03:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 451D4609EF; Mon, 25 Feb 2019 10:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551089001;
        bh=e0d2RElkNZ97RRyJaTfd5Iq6tQyVUapUNPsg51PNFGo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Cgz7V8vuUhYxD08ErkS5oQhEdKHAg6an7XHB8M7zWSMBQ+KaxdtuEPQEPmkDwFyxl
         0wCz6HN6DTdr367SqCfdQHgDCKS14U/7PPYk7C3VBnsSCbCAXZ7j+g45eo67h1Dh05
         BuSlxcY8PiQ0xQ2a6Kw0sAB95FrL1WvfX7ND8fes=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30E416074F;
        Mon, 25 Feb 2019 10:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551089000;
        bh=e0d2RElkNZ97RRyJaTfd5Iq6tQyVUapUNPsg51PNFGo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CcY8IdeUM0/HNSBTBM+TrCdwc3BVBoJS2Ed9T5BfxFDhLqYe/zOQ9f/hFfXZy+xN0
         Ai5+Fa3Z/dataSJ96+NhLkp3691VSsKP37ZGJpvB7Nikx3IxMsNBS8HKLPV/ateDhK
         d/QodsOviX0BTco9PR+AYSSqDwLX9o3f7LLVx6O4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 30E416074F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath9k: remove set but not used variable 'acq'
References: <20190225033246.127410-1-yuehaibing@huawei.com>
        <87lg24urgq.fsf@toke.dk>
Date:   Mon, 25 Feb 2019 12:03:16 +0200
In-Reply-To: <87lg24urgq.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Mon, 25 Feb 2019 10:50:45 +0100")
Message-ID: <87ftscmbh7.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:

> YueHaibing <yuehaibing@huawei.com> writes:
>
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_rx_count_airtime=
':
>> drivers/net/wireless/ath/ath9k/recv.c:1010:18: warning:
>>  variable 'acq' set but not used [-Wunused-but-set-variable]
>>
>> It's not used after 89cea7493a34 ("ath9k: Switch to mac80211 TXQ schedul=
ing
>> and airtime APIs"). Also remove related variables.
>
> Ah, right, seems I forgot to clean that up. I wonder why I didn't get a
> compiler warning for it.

I think the warning is not enabled by default and you need to use W=3D1
Makefile variable to enable it.

--=20
Kalle Valo
