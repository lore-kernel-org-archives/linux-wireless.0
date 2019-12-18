Return-Path: <SRS0=gBLi=2I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B982C43603
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 09:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C64D218AC
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 09:00:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="gVyAi23P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfLRJA2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Dec 2019 04:00:28 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:57815 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbfLRJA2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Dec 2019 04:00:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576659628; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=C6xg5DcjA3hSmJzJichK0Av56FlXQEQ8x34hW9f9Do4=; b=gVyAi23PEo3vOxw33uPn0rH5kOJcubC0uHq716m/RcdZsBSTe8LQDsw51snrm6vjgAkDXMnw
 P28offlX9lE2EfG93jQr+iP65FPh1MqjCx5w0XvccOe6NjvGg2V8ZhDOnCAMkTDn6Fho4YsO
 Wpv+J3YNqqV6DI/rzVK8VdFWRPo=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df9eaa2.7fb499dc52d0-smtp-out-n03;
 Wed, 18 Dec 2019 09:00:18 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 736DFC447A0; Wed, 18 Dec 2019 09:00:17 +0000 (UTC)
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 31459C43383;
        Wed, 18 Dec 2019 09:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 31459C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        lorenzo.bianconi@redhat.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com
Subject: Re: [PATCH] mt76: fix compilation warning in mt76_eeprom_override()
References: <a64aaf778d3d144a46678f2833db2ec0afa3c58a.1576521036.git.lorenzo@kernel.org>
        <87bls63ujm.fsf@tynnyri.adurom.net>
        <20191218085825.GB11823@localhost.localdomain>
Date:   Wed, 18 Dec 2019 11:00:11 +0200
In-Reply-To: <20191218085825.GB11823@localhost.localdomain> (Lorenzo
        Bianconi's message of "Wed, 18 Dec 2019 09:58:25 +0100")
Message-ID: <871rt2uhyc.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>>=20
>> > Fix the following compilation warning in mt76_eeprom_override routine
>> > when CONFIG_OF is not set and label 'out' is not actually used
>> >
>> > drivers/net/wireless/mediatek/mt76/eeprom.c: In function =E2=80=98mt76=
_eeprom_override=E2=80=99:
>> > drivers/net/wireless/mediatek/mt76/eeprom.c:100:1: warning: label
>> > =E2=80=98out=E2=80=99 defined but not used [-Wunused-label]
>> >
>> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>=20
>> What commit introduced this? Or is this an old issue?
>
> Hi Kalle,
>
> I did not added the Fixed tag since this commit is currently just on Feli=
x's tree:
>
> commit c203e25590b472eb561e1c53898a7f7b5c734563
> mt76: fix possible undetected invalid MAC address

Ok, so no need to push to wireless-drivers then.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
