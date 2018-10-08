Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EB0C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 07:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 496BA20645
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 07:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YeXUEq8m";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YeXUEq8m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 496BA20645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbeJHOsp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 10:48:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36922 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbeJHOsp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 10:48:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CADE7607BD; Mon,  8 Oct 2018 07:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538984302;
        bh=XUgxxf+GYh695ff4+eF5pH285wFXQ8vKNTSp2qxdY9o=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YeXUEq8m2xgUna/PIbgMFtYv5wMNQ8kTC7FWmIyQQ8EYj9pU2Vj+uUM7e0/RcERvY
         bWgVb/dNZb8AzGoR30g8BYKHoVyihFhXo3MTGJrHMf6PbVTjW4ijYB4/hdWlSyt8m3
         pXQjlT8pL9YmlJ6MO1HyIMIAiF1MUazomugqsCyE=
Received: from x230.qca.qualcomm.com (188-67-121-187.bb.dnainternet.fi [188.67.121.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 157D560769;
        Mon,  8 Oct 2018 07:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538984302;
        bh=XUgxxf+GYh695ff4+eF5pH285wFXQ8vKNTSp2qxdY9o=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YeXUEq8m2xgUna/PIbgMFtYv5wMNQ8kTC7FWmIyQQ8EYj9pU2Vj+uUM7e0/RcERvY
         bWgVb/dNZb8AzGoR30g8BYKHoVyihFhXo3MTGJrHMf6PbVTjW4ijYB4/hdWlSyt8m3
         pXQjlT8pL9YmlJ6MO1HyIMIAiF1MUazomugqsCyE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 157D560769
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [RFC 00/19] wilc: added driver for wilc module
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
        <87zhvrdz0q.fsf@kamboji.qca.qualcomm.com>
        <20181008104757.5e27eacb@ajaysk-VirtualBox>
Date:   Mon, 08 Oct 2018 10:38:16 +0300
In-Reply-To: <20181008104757.5e27eacb@ajaysk-VirtualBox> (Ajay Singh's message
        of "Mon, 8 Oct 2018 10:47:57 +0530")
Message-ID: <87o9c4zy53.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ajay Singh <ajay.kathat@microchip.com> writes:

> On Sat, 6 Oct 2018 15:45:41 +0300
> Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Ajay Singh <ajay.kathat@microchip.com> writes:
>>=20
>> > This patch set contains the driver files from
>> > 'driver/staging/wilc1000'. Renamed the driver from 'wilc1000' to
>> > 'wilc' to have generic name, as the same driver will be used by
>> > other wilc family members.=20=20
>>=20
>> I'm worried that the name 'wilc' is just too generic, I liked the
>> original name wilc1000 much more. Quite often when we have a new
>> generation of wireless devices there's also a new driver, so in the
>> long run I'm worried that a generic name like 'wilc' could be a
>> source of confusion. I think it's much smaller problem if
>> 'wilc1000' (the driver) also supports wilc3000 (the device), people
>> are already used to that.=20
>
> I also thought about retaining the same wilc1000 name, which has be
> used for quite some time now. But as we are moving this driver
> to '/driver/net/wireless/' freshly so thought it=E2=80=99s better to chan=
ge in
> the first commit.
>
> As you know, 'wilc1000' name is used for folder name as well as module
> name (i.e wilc1000.ko and wilc1000-spi.ko/wilc1000-sdio.ko). WILC3000 is
> going to use the same modules(.ko).

So just to be clear, this sounds good to me.

> Do you think its good approach to have 'wilc1000' folder but only remove
> =E2=80=98wilc1000=E2=80=99 prefix from .ko modules names in Makefile (i.e=
 wilc.ko and
> wilc-spio.ko/wilc-sdio.ko). So these .ko becomes generic and give clear
> name to be used with both wilc1000 and wilc3000 modules.

But this I think is confusing. The driver should use the same name
everywhere, both in folder name ('wilc1000/') and in the module name
('wilc1000-*.ko').

If I'm understanding correctly you are worried that 'wilc1000-spi.ko'
also supports wilc3000 devices, but I don't see that as a problem. I
think it's very common (not just in wireless) that the marketing names
don't always match with driver names.

> Also should I submit the v2 version by retaining old name or wait for
> few more comments to include in that.

I haven't had a chance to review the driver and apparently nobody else
either. So I recommend waiting for review comments before submitting v2.

Also I suggest that you don't make any changes from the staging version,
like you did the rename. I think it's simplest to submit the code as it
is now in staging. And once you get review comments, first submit the
changes to staging and then send v2 for new review.

--=20
Kalle Valo
