Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E5DC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 05:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00BE620834
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 05:16:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nHp9G+j4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="arh9Fws+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00BE620834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbeJEMNN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 08:13:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57748 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbeJEMNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 08:13:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 38EC560B0D; Fri,  5 Oct 2018 05:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538716570;
        bh=aWI8AO6P4W94ILoJ04idpzIz1phdrB1+X/eHHvnSTAk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nHp9G+j4KHVnbBSJHz7X4yIzSIh1rvDQ0VOoqO+gfFx7XgBotudQ7HhEazlLHeTZB
         8Qyk/Ut7b984EhKSrQdznggjGgpv+JpucKV8gHgfrqZjY/bhQo4xn9OPBLPELMErjW
         wIeQf7eNHtHsyJxjqnyUzmgcP/nzpzvmnQfR9Lmg=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8FEB4607F4;
        Fri,  5 Oct 2018 05:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538716569;
        bh=aWI8AO6P4W94ILoJ04idpzIz1phdrB1+X/eHHvnSTAk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=arh9Fws+GTgZyNWBmvlfF+XEXUyAum+RDYVa39f6hMFGTfeNZrRrZoCsNY7/YuUGo
         zaepqXZg1UZ3gSZrWEEtAsmOKdQZ1YmEDp8LUe6jGQhSFp8QcZRA6uwRhpXNriuL5d
         bMb199Td8envymAbwxWqCpPOCMkS1S69ZKrrXIXU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8FEB4607F4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Nicolas Ferre - M43238" <Nicolas.Ferre@microchip.com>,
        Ganesh Krishna - C00112 <Ganesh.Krishna@microchip.com>,
        Adham Abozaeid - C43058 <Adham.Abozaeid@microchip.com>,
        Aditya Shankar - I16078 <Aditya.Shankar@microchip.com>
Subject: Re: feedback on mainlining wilc1000 staging driver
References: <20180816015243.545cd009@ajaysk-VirtualBox>
        <87sh3etwoj.fsf@purkki.adurom.net> <87o9e2twe9.fsf@purkki.adurom.net>
        <20180817100233.7f1c00d9@ajaysk-VirtualBox>
        <8736vdv3f5.fsf@kamboji.qca.qualcomm.com>
        <5B768574.6060009@broadcom.com>
        <87y3d5tmod.fsf@kamboji.qca.qualcomm.com>
        <20180817143911.5f0ee545@ajaysk-VirtualBox>
        <87r2ipnxxa.fsf@kamboji.qca.qualcomm.com>
        <20180926155743.032caa37@ajaysk-VirtualBox>
        <871s953nhu.fsf@codeaurora.org>
        <20181005080300.5030f616@ajaysk-VirtualBox>
Date:   Fri, 05 Oct 2018 08:16:04 +0300
In-Reply-To: <20181005080300.5030f616@ajaysk-VirtualBox> (Ajay Singh's message
        of "Fri, 5 Oct 2018 08:03:00 +0530")
Message-ID: <87woqxgei3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ajay Singh <ajay.kathat@microchip.com> writes:

>> > I have submitted a patch series for wilc1000 driver, single file
>> > per patch and its based on wireless-drivers-next. 
>> > I hope its done correctly, please provide inputs so we can
>> > address and make this driver ready for mainline.
>> 
>> Thanks, I see it in patchwork:
>> 
>> https://patchwork.kernel.org/project/linux-wireless/list/?series=23251&state=*&order=date
>> 
>> Do note that we have also another new driver (rtwlan/rtw88) under
>> review so review from the wireless folks might take some time.
>> 
>
> Thanks for the update.
> Btw I could see our driver was added to the pending branch. Just
> curious, could you please share details about how the pending branch is
> used ?

I use pending branch mainly for testing bigger patches with kbuild bot,
though I think the bot is offline this week. (Or was it next week? Can't
remember)

-- 
Kalle Valo
