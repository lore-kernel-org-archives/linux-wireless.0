Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC20C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 243F62086C
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:11:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cov/bpnF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cov/bpnF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 243F62086C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388265AbeKPAT6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 19:19:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732953AbeKPAT6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 19:19:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7FE06606DD; Thu, 15 Nov 2018 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542291117;
        bh=ggHeoVLGDqvw+pI3fMjl2nyghEnev3IhbzjE3lELRgY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Cov/bpnF+MRkWYHk/K1f0+Xb3JfjViI6Jg1PDkn75NPOQxurICk3HRGAQ0/nRAZus
         mWlqyomHRFQrnbcnfd0V8QQAiSBWyauX9sLIE2ehxVC4RO5Ut8jkoh6jn+3phxLAQ2
         9eeKEUfraJRbzHbJqkBpK9287SuilrzVoseQCnt8=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08753601D4;
        Thu, 15 Nov 2018 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542291117;
        bh=ggHeoVLGDqvw+pI3fMjl2nyghEnev3IhbzjE3lELRgY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Cov/bpnF+MRkWYHk/K1f0+Xb3JfjViI6Jg1PDkn75NPOQxurICk3HRGAQ0/nRAZus
         mWlqyomHRFQrnbcnfd0V8QQAiSBWyauX9sLIE2ehxVC4RO5Ut8jkoh6jn+3phxLAQ2
         9eeKEUfraJRbzHbJqkBpK9287SuilrzVoseQCnt8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08753601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <Adham.Abozaeid@microchip.com>
Cc:     <Ajay.Kathat@microchip.com>, <linux-wireless@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <Ganesh.Krishna@microchip.com>,
        <Aditya.Shankar@microchip.com>, <Venkateswara.Kaja@microchip.com>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [RFC 00/19] wilc: added driver for wilc module
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
        <87zhvrdz0q.fsf@kamboji.qca.qualcomm.com>
        <20181008104757.5e27eacb@ajaysk-VirtualBox>
        <87o9c4zy53.fsf@codeaurora.org> <5BBBA348.3070503@microchip.com>
Date:   Thu, 15 Nov 2018 16:11:52 +0200
In-Reply-To: <5BBBA348.3070503@microchip.com> (Adham Abozaeid's message of
        "Mon, 8 Oct 2018 18:34:51 +0000")
Message-ID: <87d0r6bfbr.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Adham.Abozaeid@microchip.com> writes:

> On 10/08/2018 12:38 AM, Kalle Valo wrote:
>> Ajay Singh <ajay.kathat@microchip.com> writes:
>> 
>>> On Sat, 6 Oct 2018 15:45:41 +0300
>>> Kalle Valo <kvalo@codeaurora.org> wrote:
>>>
>>>> Ajay Singh <ajay.kathat@microchip.com> writes:
>>>>
>>>>> This patch set contains the driver files from
>>>>> 'driver/staging/wilc1000'. Renamed the driver from 'wilc1000' to
>>>>> 'wilc' to have generic name, as the same driver will be used by
>>>>> other wilc family members.  
>>>>
>>>> I'm worried that the name 'wilc' is just too generic, I liked the
>>>> original name wilc1000 much more. Quite often when we have a new
>>>> generation of wireless devices there's also a new driver, so in the
>>>> long run I'm worried that a generic name like 'wilc' could be a
>>>> source of confusion. I think it's much smaller problem if
>>>> 'wilc1000' (the driver) also supports wilc3000 (the device), people
>>>> are already used to that. 
>
>> If I'm understanding correctly you are worried that 'wilc1000-spi.ko'
>> also supports wilc3000 devices, but I don't see that as a problem. I
>> think it's very common (not just in wireless) that the marketing names
>> don't always match with driver names.
>> 
>
> It's highly unlikely that microchip will have a new generation of wilc
> devices other than wilc1000 and wilc3000, since a new family is
> already in development.
> And in case a new generation was developed, it will be best to support
> it in the current driver because of the similarities between wilc
> devices.
>
> I'm afraid that it might be more confusing for users to use wilc1000
> naming while they are using wilc3000 hardware. It's not only that the
> name that is different from the marketing name, but it also refers to
> another existing product.

Well, I see it very differently. For example, if I google 'wilc1000' I
get directly to the product page but with 'wilc' I get nothing useful.
And I have been dealing with marketing for so long that "never say
never" about what they will decide ;)

So I'm still not convinced that renaming is a good idea. But actually my
opinion doesn't matter here, as the rename should happen in the staging
tree (when the driver is moved from staging to drivers/net/wireless it
should be a simple rename, no other changes). So I'll leave this for
Greg to decide if the rename is worthwhile or not. My vote would be a
clear "no" :)

-- 
Kalle Valo
